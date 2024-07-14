local M = {}

M.config = {
  -- My profile config
  user  = "jason",
  home  = os.getenv("HOME"),
  host  = "nixos",
  theme = "dracula",
  font  = "FiraCode Nerd Font Bold 10",
}

M.apps = {
  -- My profile apps
  launcher     = "rofi -show drun",
  switcher     = "rofi -show window",
  terminal     = "kitty",
  web_browser  = "firefox",
  text_editor  = "lvim",
  file_manager = "kitty --class fm -e ranger",
  screnshoot   = "shutter -s",
  image_viewer = "qview"
}

M.exit = {
  lock     = "i3lock-fancy-rapid 5 3",
  suspend  = "systemctl hibernate",
  reboot   = "systemctl reboot",
  shutdown = "shutdown -h now",
}

return M
