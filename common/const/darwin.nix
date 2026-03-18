let
  username = "jasontao";
in
{
  system = "x86_64-darwin";
  is-linux = false;
  is-darwin = true;
  username = username;
  home = "/Users/${username}";
  terminal = "kitty";
  font = "Maple Mono NF";
  font-cn = "Maple Mono CN";
  font-code = "Maple Mono NF";
  editor = "vim";
  browser = "firefox";
}
