--- @since 25.5.31

-- 任务队列插件
-- 生成rsync命令脚本，用于批量复制/移动文件
local function expand_home(path)
    if path:sub(1,1) == "~" then
        local home = os.getenv("HOME") or os.getenv("USERPROFILE")
        if home then
            return home .. path:sub(2)
        end
    end
    return path
end

local script_path = expand_home("~/.config/yazi/task_q.sh")

-- 生成rsync命令
local generate_rsync = ya.sync(function()
    -- 检查是否有被标记的文件
    if not cx or not cx.yanked or #cx.yanked == 0 then
        ya.notify {
            title = "Task Queue",
            content = "No files marked",
            timeout = 1,
        }
        return
    end

    -- 检查是否有活动目录
    if not cx.active or not cx.active.current or not cx.active.current.cwd then
        ya.notify {
            title = "Task Queue",
            content = "No active directory",
            timeout = 1,
        }
        return
    end

    local count = 0
    local target_dir = tostring(cx.active.current.cwd)
    local f = io.open(script_path, "a")

    if f then
        local operation = cx.yanked.is_cut and "move" or "copy"

        for _, url in pairs(cx.yanked) do
            local cmd
            local quoted_src = ya.quote(tostring(url))
            local quoted_dst = ya.quote(target_dir)
            if operation == "copy" then
                cmd = "rsync -avh --progress --no-compress --inplace " .. quoted_src .. " " .. quoted_dst .. "\n"
            else
                cmd = "rsync -avh --progress --no-compress --inplace --remove-source-files " .. quoted_src .. " " .. quoted_dst .. "\n"
            end
            f:write(cmd)
            count = count + 1
        end

        f:close()

        ya.notify {
            title = "Task Queue",
            content = operation .. ": " .. count .. " files",
            timeout = 1,
        }
    else
        ya.notify {
            title = "Task Queue",
            content = "Error: Cannot write to task_q.sh",
            timeout = 1,
        }
    end
end)

return {
    setup = function() end,
    entry = function(_, job)
        local args = job and job.args and job.args[1]
        if args == "insert" then
            generate_rsync()
        end
    end
}
