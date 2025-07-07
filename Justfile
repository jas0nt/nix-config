set shell := ["bash", "-uc"]

default:
  @just --choose

flake-update:
  sudo nix flake update

# [ minimal | minimal | nixos ]
build target = 'nixos':
  sudo nixos-rebuild switch --flake path:.#{{target}}

debug target = 'nixos':
  sudo nixos-rebuild switch --flake path:.#{{target}} --show-trace --verbose

# no substitute
build-nosub target = 'nixos':
  sudo nixos-rebuild switch --flake path:.#{{target}} --option substitute false

up input = '':
  nix flake update {{input}}

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
  Environment=\"http_proxy=http://127.0.0.1:7890\"\n\
  Environment=\"https_proxy=http://127.0.0.1:7890\"\n\
  Environment=\"all_proxy=socks5h://127.0.0.1:7890\"\n"\
  > /run/systemd/system/nix-daemon.service.d/override.conf'
  sudo systemctl daemon-reload
  sudo systemctl restart nix-daemon

proxyoff:
  sudo rm -f /run/systemd/system/nix-daemon.service.d/override.conf
  sudo systemctl daemon-reload
  sudo systemctl restart nix-daemon
