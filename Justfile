set shell := ["bash", "-uc"]

default:
  just --list --unsorted

build:
  sudo nixos-rebuild switch --flake path:.#nixos

debug:
  sudo nixos-rebuild switch --flake path:.#nixos --show-trace --verbose

up:
  nix flake update

upp input:
  nix flake lock --update-input {{input}}

history:
  nix profile history --profile /nix/var/nix/profiles/system

list:
  # list all generations
  sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

clean:
  # remove all generations older than 7 days
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d

gc:
  # garbage collect all unused nix store entries
  sudo nix store gc --debug
  sudo nix-collect-garbage --delete-old

repl:
  nix repl -f flake:nixpkgs


proxy:
  sudo mkdir -p /run/systemd/system/nix-daemon.service.d/
  sudo sh -c 'echo -e "[Service]\n\
  Environment=\"http_proxy=socks5h://localhost:7891\"\n\
  Environment=\"https_proxy=socks5h://localhost:7891\"\n\
  Environment=\"all_proxy=socks5h://localhost:7891\"\n"\
  > /run/systemd/system/nix-daemon.service.d/override.conf'
  sudo systemctl daemon-reload
  sudo systemctl restart nix-daemon
  systemctl cat nix-daemon

proxyoff:
  sudo rm -f /run/systemd/system/nix-daemon.service.d/override.conf
  sudo systemctl daemon-reload
  sudo systemctl restart nix-daemon
  systemctl cat nix-daemon

