let
  username = "jason";
in
{
  system = "x86_64-linux";
  is-linux = true;
  is-darwin = false;
  username = username;
  home = "/home/${username}";
  terminal = "kitty";
  font = "Maple Mono NF";
  font-cn = "Maple Mono CN";
  font-code = "Maple Mono NF";
  editor = "vim";
  browser = "firefox";
}
