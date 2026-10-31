local M = {}

local HOME = os.getenv("HOME")
-- No $HOME -> no shared dir; everything falls back to Yazi's own cache.
local SHARED_DIR = (HOME and HOME ~= "") and (HOME .. "/.emacs.d/cache/ready-player/") or nil
local SUFFIX = ".png"
local PERCENT = 10 -- 与 Emacs 的 my-ready-player--thumbnail-percent-for 默认值一致
local MAX_PERCENT = 95 -- 与 Yazi 内置 video 预览的上界一致
local THUMB_SIZE = "0" -- 0 = 原始分辨率；若 Emacs 端不要求原尺寸，可改成例如 "1280"

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
	if job.skip ~= 0 or not SHARED_DIR then
		return ya.file_cache(job)
	end
	local sum = md5(tostring(job.file.url))
	return sum and Url(SHARED_DIR .. sum .. SUFFIX)
end

-- 生成缩略图（已存在且非空则直接返回 true）。
-- from_peek: 仅 peek 可以在越界时发 peek 事件把 skip 拉回上界。
local function generate(job, cache, from_peek)
	local cha = fs.cha(cache)
	if cha and cha.len > 0 then
		return true
	end

	local percent = PERCENT + job.skip
	if percent > MAX_PERCENT then
		if from_peek then
			ya.emit("peek", { MAX_PERCENT - PERCENT, only_if = job.file.url, upper_bound = true })
		end
		return false
	end

	if SHARED_DIR then
		fs.create("dir_all", Url(SHARED_DIR)) -- 目录不存在时创建（尽力而为）
	end

	-- 唯一 tmp 名：预加载器与 peek 可能同时生成同一个文件，
	-- 共用 tmp 会让一方 rename 之后另一方还在往最终文件里写
	local tmp = string.format(
		"%s.%d.%d.tmp",
		tostring(cache),
		math.floor(ya.time() * 1000000),
		math.random(0x7fffffff)
	)
	local status = Command("ffmpegthumbnailer")
		:arg({ "-i", tostring(job.file.url), "-s", THUMB_SIZE, "-c", "png", "-t", percent .. "%", "-o", tmp })
		:stdout(Command.NULL)
		:stderr(Command.NULL)
		:status()

	if status and status.success and os.rename(tmp, tostring(cache)) then -- 原子替换，Emacs 不会读到半成品
		return true
	end
	os.remove(tmp)
	return false
end

function M:preload(job)
	local cache = cache_of(job)
	return cache ~= nil and generate(job, cache, false)
end

function M:peek(job)
	local start = os.clock()
	local cache = cache_of(job)
	if not cache or not generate(job, cache, true) then
		return
	end

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
