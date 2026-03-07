set shell := ["bash", "-uc"]

proxy_env := 'env "http_proxy=http://127.0.0.1:7890" "https_proxy=http://127.0.0.1:7890"'

# Detect OS
os := `if [ -f /usr/bin/sw_vers ]; then echo "darwin"; else echo "linux"; fi`
hostname := `hostname -s`


default:
  @just --choose

flake-update:
  sudo nix flake update

build:
  #!/usr/bin/env bash
  if [[ "{{os}}" == "darwin" ]]; then
    sudo {{proxy_env}} nix run nix-darwin/master#darwin-rebuild -- switch --flake path:.
  else
    sudo {{proxy_env}} nixos-rebuild switch --flake path:.
  fi

debug:
  #!/usr/bin/env bash
  if [[ "{{os}}" == "darwin" ]]; then
    sudo {{proxy_env}} nix run nix-darwin/master#darwin-rebuild -- switch --flake path:. --show-trace --verbose
  else
    sudo {{proxy_env}} nixos-rebuild switch --flake path:. --show-trace --verbose
  fi

# no substitute
build-nosub:
  #!/usr/bin/env bash
  if [[ "{{os}}" == "darwin" ]]; then
    sudo {{proxy_env}} nix run nix-darwin/master#darwin-rebuild -- switch --flake path:. --option substitute false
  else
    sudo {{proxy_env}} nixos-rebuild switch --flake path:. --option substitute false
  fi

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
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than 7d
  sudo nix-collect-garbage --delete-older-than 7d

val path:
  #!/usr/bin/env bash
  if [[ "{{os}}" == "darwin" ]]; then
    printf ":lf .\ndarwinConfigurations.{{hostname}}.config.{{path}}\n" | nix repl --quiet
  else
    printf ":lf .\nnixosConfigurations.{{hostname}}.config.{{path}}\n" | nix repl --quiet
  fi

repl:
  nix repl -f flake:nixpkgs
