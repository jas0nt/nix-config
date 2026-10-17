--- @since 25.5.31

-- dired-satchel: queue copy/move/delete operations in memory, then run them
-- later as ONE rsync/mv/rm shell script.
--
-- Two modes, toggled with `toggle` (indicator shown in the status bar):
--   SCRIPT (default)  y / x / p build a satchel that is queued in memory;
--                     `run` executes everything later as one script.
--   LIVE              y / x / p / Y are Yazi's native yank / cut / paste /
--                     unyank, and delete is the native `remove`.
--
-- Commands (`plugin dired-satchel <cmd>`):
--   pack     (y) SCRIPT: add the selected files (or the hovered file) to the
--            satchel, to be COPIED. The satchel accumulates across
--            directories; packing a file again just switches its kind.
--            LIVE: native `yank`.
--   cut      (x) SCRIPT: same, but the files will be MOVED.
--            LIVE: native `yank --cut`.
--   paste    (p) SCRIPT: queue the satchel into the current directory (a
--            copy of the packed files, a move of the cut ones), then empty
--            it. Files already in the current directory are skipped.
--            LIVE: native `paste` (`--force` is passed through).
--   unpack   (Y) SCRIPT: empty the satchel.
--            LIVE: native `unyank` (and empty the satchel).
--   delete   SCRIPT: queue the selected (or hovered) files for deletion.
--            LIVE:   native `remove` (`--permanently` is passed through).
--   insert   queue the yanked files as copy/move into the current
--            directory (works in both modes; uses Yazi's yank buffer
--            instead of the satchel).
--   unqueue  remove the selected (or hovered) files from every queued
--            operation and from the satchel; operations that become
--            empty are dropped.
--   undo     drop the most recently queued operation
--   run      run the queue; with an empty queue, run the leftover script
--            (works in both modes)
--   preview  view the script the queue would produce (or the leftover one)
--   status   show queue size, or live progress while a script is running
--   clear    drop the queue and delete the script file
--   toggle   switch between SCRIPT and LIVE mode
--
-- Visual marks (needs `require("dired-satchel"):setup()` in init.lua):
--   a letter at the right edge: y = copy, x = move (packed or queued),
--   D = delete.
--   Marks stay while the script runs, are cleared when it succeeds, and are
--   kept if it fails (the script is still on disk). They are removed by
--   `unqueue` / `undo` / `clear`. Shown when the linemode is not "none".
--   setup() also adds a SCRIPT / LIVE indicator to the status bar.
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
--     partial data, mv is guarded by an existence check, and rm -rf ignores
--     missing paths, so re-running is safe.
--
-- Script contents:
--   Moves within one filesystem use `mv` (instant rename); moves across
--   filesystems use rsync (progress + resumable).

local function env(name)
	local v = os.getenv(name)
	if v and v ~= "" then
		return v
	end
end

local HOME = env("HOME") or env("USERPROFILE") or ""
local STATE_DIR = (env("XDG_STATE_HOME") or (HOME .. "/.local/state")) .. "/yazi"
local SCRIPT = STATE_DIR .. "/dired-satchel.sh"
local LOG = STATE_DIR .. "/dired-satchel.log"
local PREVIEW = STATE_DIR .. "/dired-satchel.preview.sh"

-- ---------------------------------------------------------------------
-- Sync helpers: the only code that touches `cx` and the plugin state.
-- State layout:
--   st.ops         list of { type, files, dest }   (queued, not yet run)
--   st.inflight    list of ops written to the script that is running / failed
--   st.stash       list of file names packed into the satchel
--   st.stash_cut   set of those names that are packed to be MOVED (the rest copy)
--   st.running     bool
--   st.script_mode nil/true = SCRIPT, false = LIVE
--   st.marks       file name -> mark, rebuilt after every state change
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

-- Selected files and the hovered file, separately: `pack` needs to tell
-- "something is selected" from "only hovering".
local snapshot_selection = ya.sync(function()
	local selected = {}
	for _, url in pairs(cx.active.selected) do
		selected[#selected + 1] = tostring(url)
	end
	local hovered = cx.active.current.hovered
	return {
		selected = selected,
		hovered = hovered and tostring(hovered.url) or nil,
	}
end)

local snapshot_cwd = ya.sync(function()
	return tostring(cx.active.current.cwd)
end)

-- Visual marks: a small letter at the right edge of every file that is
-- packed, queued (st.ops) or part of a script that is running / failed
-- (st.inflight). Rebuilt from the state after every change. Packed files
-- show what will happen to them (y copy, x move), like a queued op.
local MARKS = {
	copy = { char = "y", color = "green" },
	move = { char = "x", color = "yellow" },
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
	for _, f in ipairs(st.stash or {}) do
		marks[f] = (st.stash_cut and st.stash_cut[f]) and MARKS.move or MARKS.copy
	end
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
	return {
		ops = st.ops or {},
		stash = st.stash or {},
		cut = st.stash_cut or {},
		running = st.running or false,
		script_mode = st.script_mode ~= false,
	}
end)

local toggle_mode = ya.sync(function(st)
	st.script_mode = not (st.script_mode ~= false)
	redraw()
	return st.script_mode
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

-- Add FILES to the satchel as `kind` ("copy" or "cut"). It accumulates; a
-- file that is already in it just switches kind. Returns { total, changed }.
local set_stash = ya.sync(function(st, files, kind)
	st.stash = st.stash or {}
	st.stash_cut = st.stash_cut or {}
	local present = {}
	for _, f in ipairs(st.stash) do
		present[f] = true
	end

	local is_cut = kind == "cut"
	local changed = 0
	for _, f in ipairs(files) do
		if not present[f] then
			present[f] = true
			st.stash[#st.stash + 1] = f
			st.stash_cut[f] = is_cut or nil
			changed = changed + 1
		elseif (st.stash_cut[f] or false) ~= is_cut then
			st.stash_cut[f] = is_cut or nil
			changed = changed + 1
		end
	end
	rebuild_marks(st)
	return { total = #st.stash, changed = changed }
end)

local clear_stash = ya.sync(function(st)
	local n = #(st.stash or {})
	st.stash, st.stash_cut = {}, {}
	rebuild_marks(st)
	return n
end)

-- Remove FILES from every queued op and from the satchel. An op that loses
-- its last file is dropped. In-flight ops are never touched: they are
-- already part of the script that is running (or failed).
-- Returns the number of distinct files that were found.
local unqueue_files = ya.sync(function(st, files)
	local wanted, hit = {}, {}
	for _, f in ipairs(files) do
		wanted[f] = true
	end

	local function strip(list)
		local out = {}
		for _, f in ipairs(list) do
			if wanted[f] then
				hit[f] = true
			else
				out[#out + 1] = f
			end
		end
		return out
	end

	local new_ops = {}
	for _, op in ipairs(st.ops or {}) do
		op.files = strip(op.files)
		if #op.files > 0 then
			new_ops[#new_ops + 1] = op
		end
	end
	st.ops = new_ops
	st.stash = strip(st.stash or {})
	local cut = {}
	for _, f in ipairs(st.stash) do
		if st.stash_cut and st.stash_cut[f] then
			cut[f] = true
		end
	end
	st.stash_cut = cut
	rebuild_marks(st)

	local n = 0
	for _ in pairs(hit) do
		n = n + 1
	end
	return n
end)

-- Drop the queue and all in-flight marks. The satchel is left alone.
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
		title = "Dired Satchel",
		content = content,
		level = level or "info",
		timeout = timeout or 3,
	}
end

-- Replace control characters so a hostile file name can never break out
-- of a shell comment or a notification.
local function clean(text)
	return (text:gsub("%c", "?"))
end

local function basename(path)
	return path:match("[^/]+$") or path
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

-- One-line description; control characters are replaced.
local function describe(op)
	local n = #op.files
	local text
	if op.type == "delete" then
		text = string.format("delete %d file(s): %s%s", n, op.files[1], n > 1 and " ..." or "")
	else
		text = string.format("%s %d file(s) -> %s", op.type, n, op.dest)
	end
	return clean(text)
end

-- Device number, or nil when it cannot be determined (file missing, not
-- Unix, or a Yazi version without the `dev` field). Callers then fall back
-- to the rsync path, which has --ignore-missing-args.
-- follow = false: sources are lstat'ed (mv moves the symlink itself);
-- follow = true : the destination directory follows symlinks.
local function dev_of(path, follow)
	local cha = fs.cha(Url(path), follow)
	return cha and cha.dev or nil
end

-- Idempotent mv: skip sources that no longer exist, so re-running a
-- leftover script after a partial run is safe under `set -e`.
local function mv_cmd(files, dest)
	local lines = {}
	for i, f in ipairs(files) do
		local q = ya.quote(f)
		lines[i] = string.format("if [ -e %s ] || [ -L %s ]; then mv -- %s %s; fi", q, q, q, dest)
	end
	return table.concat(lines, "\n")
end

local function rsync_move_cmd(files, dest)
	local sources = quote_all(files)
	-- --remove-source-files only removes files, so also prune the
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

local function command(op)
	if op.type == "delete" then
		return "rm -rf -- " .. quote_all(op.files)
	end

	local dest = ya.quote((op.dest:gsub("/*$", "/")))
	if op.type == "copy" then
		return string.format("rsync -avh --progress --no-compress --inplace -- %s %s", quote_all(op.files), dest)
	end

	-- move: same filesystem -> mv (a plain rename, instant at any size);
	-- different filesystem -> rsync (progress output and resumable).
	local dest_dev = dev_of(op.dest, true)
	local fast, slow = {}, {}
	for _, f in ipairs(op.files) do
		local d = dest_dev and dev_of(f, false)
		if d and d == dest_dev then
			fast[#fast + 1] = f
		else
			slow[#slow + 1] = f
		end
	end

	local cmds = {}
	if #fast > 0 then
		cmds[#cmds + 1] = mv_cmd(fast, dest)
	end
	if #slow > 0 then
		cmds[#cmds + 1] = rsync_move_cmd(slow, dest)
	end
	return table.concat(cmds, "\n")
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

-- Every command receives `args` (job.args): named flags such as
-- `--permanently` arrive as args.permanently (most commands ignore them).

-- SCRIPT mode: add the selected files (or the hovered one) to the satchel
-- as `kind` ("copy" or "cut"). LIVE mode: native yank / yank --cut.
local function add_to_satchel(kind)
	if not get_state().script_mode then
		return ya.emit("yank", { cut = kind == "cut" or nil })
	end

	local sel = snapshot_selection()
	local files = sel.selected
	if #files == 0 and sel.hovered then
		files = { sel.hovered }
	end
	if #files == 0 then
		return notify("No file selected or hovered", "warn")
	end

	local r = set_stash(files, kind)
	if #sel.selected > 0 then
		ya.emit("escape", { select = true })
	end
	if r.changed == 0 then
		return notify("Already in the satchel")
	end

	local verb = kind == "cut" and "Cut" or "Copied"
	if #files == 1 then
		return notify(
			string.format("%s %s (satchel now has %d file(s))", verb, clean(basename(files[1])), r.total)
		)
	end
	notify(string.format("%s %d file(s) (satchel now has %d)", verb, #files, r.total))
end

local function pack()
	add_to_satchel("copy")
end

local function cut()
	add_to_satchel("cut")
end

local function unpack_stash()
	local script_mode = get_state().script_mode
	local n = clear_stash()
	if not script_mode then
		return ya.emit("unyank", {})
	end
	notify(n > 0 and "Satchel emptied" or "Satchel is already empty")
end

-- Run a script file with bash; output goes to a log file (instead of the
-- TUI) so `status` can tail it. Returns Command:status()'s results.
local function launch(path)
	return Command("bash")
		:arg("-c")
		:arg('exec bash "$1" >"$2" 2>&1')
		:arg("_")
		:arg(path)
		:arg(LOG)
		:stdin(Command.NULL)
		:stdout(Command.NULL)
		:stderr(Command.NULL)
		:status()
end

local function parent_dir(path)
	return (path:match("^(.*)/[^/]+/*$") or "") .. "/"
end

-- Split the satchel for delivery into DEST_DIR: files to copy and files
-- to move. Files that already live in DEST_DIR are left out.
local function split_satchel(s, dest_dir)
	local copies, cuts = {}, {}
	for _, f in ipairs(s.stash) do
		if parent_dir(f) ~= dest_dir then
			local list = s.cut[f] and cuts or copies
			list[#list + 1] = f
		end
	end
	return copies, cuts
end

local function ops_for(copies, cuts, dest)
	local ops = {}
	if #copies > 0 then
		ops[#ops + 1] = { type = "copy", files = copies, dest = dest }
	end
	if #cuts > 0 then
		ops[#ops + 1] = { type = "move", files = cuts, dest = dest }
	end
	return ops
end

local function describe_all(ops)
	local parts = {}
	for _, op in ipairs(ops) do
		parts[#parts + 1] = describe(op)
	end
	return table.concat(parts, "; ")
end

-- SCRIPT mode: queue the whole satchel into the cwd (a copy of the files
-- packed with `pack`, a move of those packed with `cut`) and empty it; the
-- queued files keep their C / M marks. LIVE mode: native paste.
local function paste(args)
	local s = get_state()
	if not s.script_mode then
		return ya.emit("paste", { force = args.force })
	end
	if #s.stash == 0 then
		return notify("Satchel is empty", "warn")
	end

	local dest = snapshot_cwd()
	local dest_dir = (dest:gsub("/*$", "/"))
	local copies, cuts = split_satchel(s, dest_dir)
	if #copies == 0 and #cuts == 0 then
		return notify("Everything in the satchel is already in this directory", "warn")
	end

	local ops = ops_for(copies, cuts, dest)
	for _, op in ipairs(ops) do
		push_op(op)
	end
	clear_stash()
	notify("Queued " .. describe_all(ops))
end

-- Queue Yazi's yank buffer as copy/move (independent of the satchel).
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

local function queue_delete(args)
	if not get_state().script_mode then
		return ya.emit("remove", { permanently = args.permanently })
	end

	local sel = snapshot_selection()
	local files = sel.selected
	if #files == 0 and sel.hovered then
		files = { sel.hovered }
	end
	if #files == 0 then
		return notify("No file selected or hovered", "warn")
	end

	local op = { type = "delete", files = files }
	push_op(op)
	ya.emit("escape", { select = true })
	notify("Queued " .. describe(op))
end

-- Remove the selected (or hovered) files from the queue and the satchel.
local function unqueue()
	local sel = snapshot_selection()
	local files = sel.selected
	if #files == 0 and sel.hovered then
		files = { sel.hovered }
	end
	if #files == 0 then
		return notify("No file selected or hovered", "warn")
	end

	local n = unqueue_files(files)
	if #sel.selected > 0 then
		ya.emit("escape", { select = true })
	end
	if n > 0 then
		notify(string.format("Removed %d file(s) from the queue/satchel", n))
	else
		notify("Not in the queue or satchel", "warn")
	end
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
	local packed = #s.stash > 0 and string.format("; %d file(s) packed", #s.stash) or ""
	if s.running then
		local last = tail_of_log() or "(no output yet)"
		return notify("Script running. Latest output:\n" .. last, "info", 5)
	end
	if #s.ops > 0 then
		return notify(
			string.format(
				"%d operation(s), %d file(s) queued (run to execute)%s",
				#s.ops,
				count_files(s.ops),
				packed
			)
		)
	end
	if exists(SCRIPT) then
		return notify("Queue is empty, but a leftover script exists: run to resume it, clear to delete it", "warn", 5)
	end
	notify("Queue is empty" .. packed)
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
	local result, err = launch(SCRIPT)

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

local function toggle()
	local script_mode = toggle_mode()
	notify("Satchel queue mode: " .. (script_mode and "SCRIPT (queued)" or "LIVE (immediate)"))
end

local actions = {
	pack = pack,
	cut = cut,
	paste = paste,
	unpack = unpack_stash,
	insert = queue_transfer,
	delete = queue_delete,
	unqueue = unqueue,
	undo = undo,
	run = run,
	preview = preview,
	status = status,
	clear = clear,
	toggle = toggle,
}

return {
	-- Call from init.lua: require("dired-satchel"):setup()
	setup = function(st, _)
		if st.script_mode == nil then
			st.script_mode = true
		end

		-- Per-file marks at the right edge of the file list.
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

		-- Mode indicator in the status bar.
		Status:children_add(function()
			if st.script_mode == false then
				return ui.Line { ui.Span(" LIVE "):style(ui.Style():fg("green"):bold()) }
			end
			return ui.Line { ui.Span(" SCRIPT "):style(ui.Style():fg("yellow"):bold()) }
		end, 500, Status.RIGHT)
	end,

	entry = function(_, job)
		local name = job.args[1]
		local action = name and actions[name]
		if not action then
			return notify("Unknown command: " .. tostring(name), "error")
		end
		action(job.args)
	end,
}
