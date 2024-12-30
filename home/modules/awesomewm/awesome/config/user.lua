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
  monitor      = "bash -c 'pkill btop || kitty --class myfloatingl btop'",
  launcher     = "rofi -show drun",
  switcher     = "rofi -show window",
  terminal     = "kitty",
  web_browser  = "firefox",
  text_editor  = "vim",
  file_manager = "kitty --class fm -e ranger",
  screnshoot   = "shutter --select",
  screnshootf   = "shutter --full",
  image_viewer = "qview"
}

M.exit = {
  lock     = "bash -c 'sleep 1 && i3lock-fancy-rapid 5 3'",
  suspend  = "bash -c 'systemctl hibernate'",
  reboot   = "systemctl reboot",
  shutdown = "shutdown -h now",
}

return M
