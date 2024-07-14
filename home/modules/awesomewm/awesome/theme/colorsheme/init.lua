local user = require("config.user")
local colorscheme

local colorschemes = {
  dracula = require("theme.colorsheme.dracula")
}

if user.config.theme == "dracula" then
  colorscheme = colorschemes.dracula
end

return colorscheme
