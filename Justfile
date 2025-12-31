set shell := ["bash", "-uc"]

proxy_env := 'env "http_proxy=http://127.0.0.1:7890" "https_proxy=http://127.0.0.1:7890"'

default:
  @just --choose

flake-update:
  sudo nix flake update

build:
  sudo {{proxy_env}} nixos-rebuild switch --flake path:.

debug:
  sudo {{proxy_env}} nixos-rebuild switch --flake path:. --show-trace --verbose

# no substitute
build-nosub:
  sudo {{proxy_env}} nixos-rebuild switch --flake path:. --option substitute false

up input = '':
  sudo {{proxy_env}} nix flake update {{input}}
  just build

history:
  nix profile history --profile /nix/var/nix/profiles/system

list:
  # list all generations
  sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

clean:
  # remove all generations older than 7 days
  nix profile wipe-history --profile ~/.local/state/nix/profiles/home-manager --older-than 7d
  nix-collect-garbage --delete-older-than 7d

gc:
  # garbage collect all unused nix store entries
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system  --older-than 7d
  sudo nix-collect-garbage --delete-older-than 7d

val path:
    printf ":lf .\nnixosConfigurations.$(hostname).config.{{path}}\n" | nix repl --quiet

repl:
  nix repl -f flake:nixpkgs
