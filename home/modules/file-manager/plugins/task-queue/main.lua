--- @since 25.5.31

-- task-queue: queue copy/move/delete operations in memory, then run them
-- later as ONE rsync/rm shell script.
--
-- Commands (`plugin task-queue <cmd>`):
--   insert   queue the yanked files as copy/move into the current directory
--   delete   queue the selected (or hovered) files for deletion
--   run      run the queue; with an empty queue, run the leftover script
--   preview  view the script the queue would produce (or the leftover one)
--   status   show queue size, or live progress while a script is running
--   undo     drop the most recently queued operation
--   clear    drop the queue and delete the script file
--
-- Visual marks (needs `require("task-queue"):setup()` in init.lua):
--   queued files show a letter at the right edge: C = copy, M = move,
--   D = delete. Marks stay while the script runs, are cleared when it
--   succeeds, and are kept if it fails (the script is still on disk).
--   They are removed by `undo` / `clear`. Shown when the linemode is not "none".
--
-- Script file lifecycle:
--   * The queue lives in memory only (per Yazi instance).
--   * The script file is written ONLY by `run`, right before it runs.
--   * So if the script file exists on disk, it is a LEFTOVER from an
--     interrupted or failed run (reboot, crash, rsync error). It is never
--     overwritten.
--   * It is removed only when it runs successfully (automatic), or by
--     `clear` (manual).
--   * `run` with an empty queue runs the leftover script as-is. With a
--     non-empty queue and a leftover script it refuses.
--   * The script is idempotent: rsync skips finished files, --inplace keeps
--     partial data, and rm -rf ignores missing paths, so re-running is safe.

local function env(name)
	local v = os.getenv(name)
	if v and v ~= "" then
		return v
	end
end

local HOME = env("HOME") or env("USERPROFILE") or ""
local STATE_DIR = (env("XDG_STATE_HOME") or (HOME .. "/.local/state")) .. "/yazi"
local SCRIPT = STATE_DIR .. "/task-queue.sh"
local LOG = STATE_DIR .. "/task-queue.log"
local PREVIEW = STATE_DIR .. "/task-queue.preview.sh"

-- ---------------------------------------------------------------------
-- Sync helpers: the only code that touches `cx` and the plugin state.
-- State layout: st.ops = list of { type, files, dest }, st.running = bool
-- ---------------------------------------------------------------------

local snapshot_yanked = ya.sync(function()
	local files = {}
	for _, url in pairs(cx.yanked) do
		files[#files + 1] = tostring(url)
	end
	return {
		files = files,
		cut = cx.yanked.is_cut,
		cwd = tostring(cx.active.current.cwd),
	}
end)

local snapshot_targets = ya.sync(function()
	local files = {}
	for _, url in pairs(cx.active.selected) do
		files[#files + 1] = tostring(url)
	end
	if #files == 0 then
		local hovered = cx.active.current.hovered
		if hovered then
			files[1] = tostring(hovered.url)
		end
	end
	return files
end)

-- Visual marks: a small letter at the right edge of every file that is
-- queued (st.ops) or part of a script that is running / failed
-- (st.inflight). Rebuilt from the ops after every state change.
local MARKS = {
	copy = { char = "C", color = "green" },
	move = { char = "M", color = "yellow" },
	delete = { char = "D", color = "red" },
}

local function redraw()
	if ui.render then
		ui.render()
	elseif ya.render then
		ya.render()
	end
end

local function rebuild_marks(st)
	local marks = {}
	local function add(op)
		for _, f in ipairs(op.files) do
			marks[f] = MARKS[op.type]
		end
	end
	for _, op in ipairs(st.inflight or {}) do
		add(op)
	end
	for _, op in ipairs(st.ops or {}) do
		add(op)
	end
	st.marks = marks
	redraw()
end

local get_state = ya.sync(function(st)
	return { ops = st.ops or {}, running = st.running or false }
end)

local push_op = ya.sync(function(st, op)
	st.ops = st.ops or {}
	st.ops[#st.ops + 1] = op
	rebuild_marks(st)
end)

local pop_op = ya.sync(function(st)
	local op = table.remove(st.ops or {})
	rebuild_marks(st)
	return op
end)

-- Drop the queue and all in-flight marks.
local reset = ya.sync(function(st)
	st.ops, st.inflight = {}, {}
	rebuild_marks(st)
end)

-- Everything queued goes into the script file: move it to "in-flight" so
-- the marks stay until the script succeeds (a failed run keeps them).
local begin_run = ya.sync(function(st)
	st.inflight = st.inflight or {}
	for _, op in ipairs(st.ops or {}) do
		st.inflight[#st.inflight + 1] = op
	end
	st.ops = {}
	st.running = true
	rebuild_marks(st)
end)

local end_run = ya.sync(function(st, success)
	st.running = false
	if success then
		st.inflight = {}
	end
	rebuild_marks(st)
end)

-- ---------------------------------------------------------------------
-- Small utilities
-- ---------------------------------------------------------------------

local function notify(content, level, timeout)
	ya.notify {
		title = "Task Queue",
		content = content,
		level = level or "info",
		timeout = timeout or 3,
	}
end

local function exists(path)
	local f = io.open(path, "r")
	if f then
		f:close()
		return true
	end
	return false
end

local function ensure_state_dir()
	Command("mkdir"):arg("-p"):arg(STATE_DIR):status()
end

-- Write via a temp file + rename, so a crash can never leave a truncated
-- script behind (a truncated leftover would later be run as-is).
local function write_atomic(path, text)
	local tmp = path .. ".tmp"
	local f, err = io.open(tmp, "w")
	if not f then
		return nil, err
	end
	f:write(text)
	f:close()
	return os.rename(tmp, path)
end

local function format_duration(seconds)
	if seconds >= 60 then
		return string.format("%dm %ds", seconds // 60, seconds % 60)
	end
	return string.format("%ds", seconds)
end

local function count_files(ops)
	local n = 0
	for _, op in ipairs(ops) do
		n = n + #op.files
	end
	return n
end

local function confirm(title, body)
	local height = 4
	for _ in body:gmatch("\n") do
		height = height + 1
	end
	return ya.confirm {
		pos = { "center", w = 70, h = math.min(height + 1, 24) },
		title = ui.Line(title),
		body = ui.Text(body):wrap(ui.Wrap.YES),
	}
end

-- ---------------------------------------------------------------------
-- Script rendering
-- ---------------------------------------------------------------------

local function quote_all(files)
	local quoted = {}
	for i, f in ipairs(files) do
		quoted[i] = ya.quote(f)
	end
	return table.concat(quoted, " ")
end

-- One-line description; control characters are replaced so a hostile file
-- name can never break out of a shell comment or a notification.
local function describe(op)
	local n = #op.files
	local text
	if op.type == "delete" then
		text = string.format("delete %d file(s): %s%s", n, op.files[1], n > 1 and " ..." or "")
	else
		text = string.format("%s %d file(s) -> %s", op.type, n, op.dest)
	end
	return (text:gsub("%c", "?"))
end

local function command(op)
	if op.type == "delete" then
		return "rm -rf -- " .. quote_all(op.files)
	end

	local dest = ya.quote((op.dest:gsub("/*$", "/")))
	local sources = quote_all(op.files)
	if op.type == "copy" then
		return string.format("rsync -avh --progress --no-compress --inplace -- %s %s", sources, dest)
	end

	-- move: --remove-source-files only removes files, so also prune the
	-- directories it leaves behind (only empty ones; failures are ignored).
	return table.concat({
		string.format(
			"rsync -avh --progress --no-compress --inplace --remove-source-files --ignore-missing-args -- %s %s",
			sources,
			dest
		),
		string.format("find %s -depth -type d -empty -delete || true", sources),
	}, "\n")
end

local function render(ops)
	local out = { "#!/usr/bin/env bash", "set -xeuo pipefail", "" }
	for _, op in ipairs(ops) do
		out[#out + 1] = "# " .. describe(op)
		out[#out + 1] = command(op)
		out[#out + 1] = ""
	end
	return table.concat(out, "\n")
end

-- ---------------------------------------------------------------------
-- Commands
-- ---------------------------------------------------------------------

local function queue_transfer()
	local snap = snapshot_yanked()
	if not snap or #snap.files == 0 then
		return notify("No yanked files", "warn")
	end

	local op = { type = snap.cut and "move" or "copy", files = snap.files, dest = snap.cwd }
	push_op(op)
	ya.emit("unyank", {})
	notify("Queued " .. describe(op))
end

local function queue_delete()
	local files = snapshot_targets()
	if not files or #files == 0 then
		return notify("No file selected or hovered", "warn")
	end

	local op = { type = "delete", files = files }
	push_op(op)
	ya.emit("escape", { select = true })
	notify("Queued " .. describe(op))
end

local function undo()
	local op = pop_op()
	if op then
		notify("Removed from queue: " .. describe(op))
	else
		notify("Queue is empty", "warn")
	end
end

local function clear()
	local s = get_state()
	if s.running then
		return notify("A script is running; wait for it to finish", "warn")
	end

	local leftover = exists(SCRIPT)
	if #s.ops == 0 and not leftover then
		return notify("Nothing to clear")
	end

	local body = string.format("%d queued operation(s)", #s.ops)
	if leftover then
		body = body .. "\nLeftover script: " .. SCRIPT
	end
	if not confirm("Clear queue and script file?", body) then
		return notify("Cancelled")
	end

	reset()
	os.remove(SCRIPT)
	os.remove(LOG)
	notify("Cleared queue and script file")
end

local function preview()
	local s = get_state()
	local path
	if #s.ops > 0 then
		-- Rendered from the queue into a scratch file; never touches SCRIPT.
		ensure_state_dir()
		local ok, err = write_atomic(PREVIEW, render(s.ops))
		if not ok then
			return notify("Cannot write preview: " .. tostring(err), "error", 6)
		end
		path = PREVIEW
	elseif exists(SCRIPT) then
		path = SCRIPT
	else
		return notify("Queue is empty and there is no leftover script", "warn")
	end

	ya.emit("shell", { "${PAGER:-less} " .. ya.quote(path), block = true })
end

local function tail_of_log()
	local f = io.open(LOG, "rb")
	if not f then
		return nil
	end
	local size = f:seek("end")
	f:seek("set", math.max(0, size - 512))
	local chunk = f:read("a") or ""
	f:close()

	-- rsync redraws its progress line with \r, so split on both.
	local last
	for piece in chunk:gmatch("[^\r\n]+") do
		last = piece
	end
	return last
end

local function status()
	local s = get_state()
	if s.running then
		local last = tail_of_log() or "(no output yet)"
		return notify("Script running. Latest output:\n" .. last, "info", 5)
	end
	if #s.ops > 0 then
		return notify(
			string.format("%d operation(s), %d file(s) queued (run to execute)", #s.ops, count_files(s.ops))
		)
	end
	if exists(SCRIPT) then
		return notify("Queue is empty, but a leftover script exists: run to resume it, clear to delete it", "warn", 5)
	end
	notify("Queue is empty")
end

local function run()
	local s = get_state()
	if s.running then
		return notify("A script is already running", "warn")
	end

	local leftover = exists(SCRIPT)
	if #s.ops == 0 and not leftover then
		return notify("Queue is empty and there is no leftover script", "warn")
	end
	if #s.ops > 0 and leftover then
		return notify(
			"Leftover script exists: " .. SCRIPT .. "\nRun it with an empty queue, or delete it with clear",
			"error",
			8
		)
	end

	-- Confirm BEFORE writing anything, so cancelling never leaves a stray
	-- script on disk.
	local title, body
	if leftover then
		title = "Run LEFTOVER script?"
		body = SCRIPT
	else
		local lines = {}
		for i, op in ipairs(s.ops) do
			if i > 12 then
				lines[#lines + 1] = string.format("... and %d more", #s.ops - 12)
				break
			end
			lines[#lines + 1] = describe(op)
		end
		title = "Run queued operations?"
		body = table.concat(lines, "\n")
	end
	if not confirm(title, body) then
		return notify("Cancelled")
	end

	if #s.ops > 0 then
		ensure_state_dir()
		local ok, err = write_atomic(SCRIPT, render(s.ops))
		if not ok then
			return notify("Cannot write script: " .. tostring(err), "error", 8)
		end
	end

	begin_run() -- queue -> in-flight (marks stay), running = true
	local started = os.time()

	-- Output goes to a log file (instead of the TUI) so `status` can tail it.
	local result, err = Command("bash")
		:arg("-c")
		:arg('exec bash "$1" >"$2" 2>&1')
		:arg("_")
		:arg(SCRIPT)
		:arg(LOG)
		:stdin(Command.NULL)
		:stdout(Command.NULL)
		:stderr(Command.NULL)
		:status()

	local success = result and result.success or false
	end_run(success) -- success clears the marks, failure keeps them
	local elapsed = format_duration(os.time() - started)

	if success then
		os.remove(SCRIPT)
		os.remove(LOG)
		notify("Script finished successfully (" .. elapsed .. ")", "info", 8)
	else
		local why = result and ("exit code " .. tostring(result.code)) or tostring(err)
		notify(
			string.format("Script FAILED after %s (%s)\nKept for retry: %s\nLog: %s", elapsed, why, SCRIPT, LOG),
			"error",
			15
		)
	end
	ya.emit("refresh", {})
end

local actions = {
	insert = queue_transfer,
	delete = queue_delete,
	run = run,
	preview = preview,
	status = status,
	undo = undo,
	clear = clear,
}

return {
	-- Call from init.lua: require("task-queue"):setup()
	setup = function(st, _)
		Linemode:children_add(function(self)
			local mark = st.marks and st.marks[tostring(self._file.url)]
			if not mark then
				return ui.Span("  ") -- reserve the width so rows stay aligned
			end
			return ui.Line {
				ui.Span(" "),
				ui.Span(mark.char):style(ui.Style():fg(mark.color):bold()),
			}
		end, 1500)
	end,

	entry = function(_, job)
		local name = job.args[1]
		local action = name and actions[name]
		if not action then
			return notify("Unknown command: " .. tostring(name), "error")
		end
		action()
	end,
}
