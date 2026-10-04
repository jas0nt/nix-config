set shell := ["bash", "-uc"]

hostname := `hostname -s`
keep := "7d"

# 只在设置了代理变量时生成 `env http_proxy=... https_proxy=...` 前缀
proxy_env := `p="${PROXY:-${HTTP_PROXY:-${http_proxy:-}}}"; if [ -n "$p" ]; then printf 'env "http_proxy=%s" "https_proxy=%s"' "$p" "$p"; fi`

rebuild := if os() == "macos" {
  "nix run nix-darwin/master#darwin-rebuild -- switch"
} else {
  "nixos-rebuild switch"
}

config_attr := if os() == "macos" { "darwinConfigurations" } else { "nixosConfigurations" }

default:
  @just --choose

build *args:
  sudo {{proxy_env}} {{rebuild}} --flake path:. {{args}}

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
