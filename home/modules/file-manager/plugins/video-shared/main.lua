local M = {}

local SHARED_DIR = os.getenv("HOME") .. "/.emacs.d/cache/ready-player/"
local SUFFIX = ".png"
local PERCENT = 10 -- 与 Emacs 的 my-ready-player--thumbnail-percent-for 默认值一致

local function md5(s)
	local out = Command("sh")
		:arg({ "-c", 'printf %s "$1" | md5sum | cut -d" " -f1', "sh", s })
		:stdout(Command.PIPED)
		:output()
	if out and out.status.success then
		return (out.stdout:gsub("%s+", ""))
	end
end

-- skip == 0 用共享缓存；手动 seek（skip ≠ 0）回退到 Yazi 自己的缓存，
-- 避免覆盖你在 Emacs 里挑好的缩略图
local function cache_of(job)
	if job.skip ~= 0 then
		return ya.file_cache(job)
	end
	local sum = md5(tostring(job.file.url))
	return sum and Url(SHARED_DIR .. sum .. SUFFIX)
end

function M:preload(job)
	local cache = cache_of(job)
	if not cache or fs.cha(cache) then
		return true
	end

	fs.create("dir_all", Url(SHARED_DIR)) -- 目录不存在时创建（尽力而为）

	local tmp = tostring(cache) .. ".yazi.tmp"
	local status = Command("ffmpegthumbnailer")
		:arg({ "-i", tostring(job.file.url), "-s", "0", "-c", "png",
		       "-t", (PERCENT + job.skip) .. "%", "-o", tmp })
		:stdout(Command.NULL):stderr(Command.NULL)
		:status()

	if status and status.success then
		os.rename(tmp, tostring(cache)) -- 原子替换，Emacs 不会读到半成品
		return true
	end
	os.remove(tmp)
	return false
end

function M:peek(job)
	local start = os.clock()
	local cache = cache_of(job)
	if not cache then return end

	local ok, err = self:preload(job)
	if not ok or err then return end

	ya.sleep(math.max(0, rt.preview.image_delay / 1000 + start - os.clock()))
	local _, err = ya.image_show(cache, job.area)
	ya.preview_widget(job, err and ui.Text(err):area(job.area):wrap(ui.Text.WRAP))
end

function M:seek(job)
	local h = cx.active.current.hovered
	if h and h.url == job.file.url then
		local step = ya.clamp(-1, job.units, 1)
		ya.emit("peek", { math.max(0, cx.active.preview.skip + step), only_if = job.file.url })
	end
end

return M
