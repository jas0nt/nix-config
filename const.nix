let
  username = "jason";
in
{
  username = username;
  home = "/home/${username}";
  terminal = "kitty";
  font = "Maple Mono NF";
  font-cn = "Maple Mono CN";
  font-code = "Maple Mono NF";
  editor = "vim";
  browser = "firefox";
  http-proxy = "http://127.0.0.1:7890";
  socks-proxy = "socks5://127.0.0.1:7890";
}
