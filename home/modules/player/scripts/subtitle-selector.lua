local mp = require 'mp'
local msg = require 'mp.msg'

-- debug: mpv --msg-level=all=info --log-file=mpv.log video.mp4

-- 配置：你希望匹配的字幕标题关键词（支持Lua正则表达式）
local preferred_sub_titles = {
    "Chinese %(Simplified%)",   -- 优先匹配简体中文标题
    "简体中文",                  -- 匹配中文标题
    "简中",                     -- 匹配中文标题缩写
    "zh%-Hans",                 -- 匹配简体中文语言代码
    "chs",                      -- 常见的简体中文缩写
    "sc",                       -- 常见的简体中文缩写
    "Chinese %(Traditional%)",  -- 匹配繁体中文标题（优先级应低于简体）
    "繁体中文",                  -- 匹配繁体中文标题
    "繁中",                     -- 匹配繁体中文标题缩写
    "zh%-Hant",                 -- 匹配繁体中文语言代码
    "cht",                      -- 常见的繁体中文缩写
    "Chinese",                  -- 通用的"Chinese"匹配（放在最后）
    "中文",                     -- 通用的"中文"匹配
    "zh",                       -- 通用的中文语言代码
}

function select_subtitle_by_title()
    local track_list = mp.get_property_native("track-list")
    local best_sub_id = nil
    local best_score = nil

    -- 遍历所有轨道
    for _, track in ipairs(track_list) do
        -- 只处理字幕轨道
        if track.type == "sub" then
            local title = track.title or ""
            msg.info("发现字幕轨道 ID: " .. track.id .. ", 标题: " .. title .. ", 语言: " .. (track.lang or "未知"))

            -- 遍历优先级列表进行匹配评分
            for score, pattern in ipairs(preferred_sub_titles) do
                if title:match(pattern) then
                    -- 找到匹配，评分越高（数字越小）优先级越高
                    if best_score == nil or score < best_score then
                        best_score = score
                        best_sub_id = track.id
                        msg.info("匹配成功！当前最佳 ID: " .. best_sub_id .. ", 模式: " .. pattern .. ", 评分: " .. score)
                    end
                end
            end
        end
    end

    -- 如果找到了匹配的字幕轨道，就选择它
    if best_sub_id then
        mp.set_property("sid", best_sub_id)
        msg.info("已根据标题自动选择字幕轨道 ID: " .. best_sub_id)
    else
        msg.info("未找到与预设标题模式匹配的字幕轨道。")
    end
end

-- 在文件加载完成后尝试选择字幕
mp.register_event("file-loaded", select_subtitle_by_title)
