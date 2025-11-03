let
  username = "jason";
in
{
  username = username;
  home = "/home/${username}";
  terminal = "kitty";
  font = "FiraCode Nerd Font";
  font-cn = "Source Han Sans";
  font-code = "Recursive Mono Casual Static";
  editor = "vim";
  browser = "firefox";
  http-proxy = "http://127.0.0.1:7890";
  socks-proxy = "socks5://127.0.0.1:7890";
}
