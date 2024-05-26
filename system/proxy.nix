{ pkgs, lib, ... }:

{
  networking = {
    proxy.default = "http://127.0.0.1:7890";
    proxy.allProxy = "socks5://127.0.0.1:7890";
    proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  };

}
