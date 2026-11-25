set shell := ["bash", "-uc"]

hostname := `hostname -s`
keep := "7d"

# Current user's nix config (contains access-tokens). root can't read it under sudo, so inject it via NIX_CONFIG
nix_conf := home_directory() / ".config/nix/nix.conf"

# Proxy URL, empty if unset
proxy := `printf '%s' "${PROXY:-${HTTP_PROXY:-${http_proxy:-}}}"`

# Proxy args for `env`, only generated when a proxy is set
proxy_args := if proxy == "" { "" } else { ' "http_proxy=' + proxy + '" "https_proxy=' + proxy + '"' }

# For normal-user commands: proxy only
proxy_env := if proxy == "" { "" } else { "env" + proxy_args }

# For sudo commands: user's nix.conf + proxy
sudo_env := 'env "NIX_CONFIG=$(cat "' + nix_conf + '" 2>/dev/null)"' + proxy_args

rebuild := if os() == "macos" {
  "nix run nix-darwin/master#darwin-rebuild -- switch"
} else {
  "nixos-rebuild switch"
}

config_attr := if os() == "macos" { "darwinConfigurations" } else { "nixosConfigurations" }

default:
  @just --choose

build *args:
  sudo {{sudo_env}} {{rebuild}} --flake path:. {{args}}

debug: (build "--show-trace --verbose")

# no substitute
build-nosub: (build "--option substitute false")

# update inputs (as normal user), then build
up input='': && build
  sudo -v
  {{proxy_env}} nix flake update {{input}}

# list all system generations
list:
  sudo nix-env --list-generations --profile /nix/var/nix/profiles/system

# remove old user generations, then GC
clean:
  nix profile wipe-history --profile ~/.local/state/nix/profiles/home-manager --older-than {{keep}}
  nix-collect-garbage --delete-older-than {{keep}}

# also remove old system generations
gc:
  sudo nix profile wipe-history --profile /nix/var/nix/profiles/system --older-than {{keep}}
  sudo nix-collect-garbage --delete-older-than {{keep}}
  just clean

# evaluate a config option, e.g. `just val networking.hostName`
val path:
  printf ':lf .\n{{config_attr}}.{{hostname}}.config.{{path}}\n' | nix repl --quiet

repl:
  nix repl -f flake:nixpkgs

fmt:
  nix fmt

check:
  nix flake check path:.

lint:
  deadnix --fail .
  statix check . --ignore "**/hardware-configuration.nix"
  nixfmt --check $(find . -name "*.nix" -not -path "./.git/*")
