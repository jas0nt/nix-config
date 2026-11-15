{
  const,
  lib,
  ...
}:

{
  imports = [
    ./randopen.nix
  ]
  ++ lib.optionals const.is-linux [
    ./windows.nix
    ./xunlei.nix
  ];

  programs.fish = {
    functions = {
      fish_greeting.body = "krabby random --no-title";

      va.body = ''
        set venv_dir "$HOME/.venv"
        set selected (ls -1 "$venv_dir" | fzf --height=20% --layout=reverse --border --prompt="Activate venv > ")
        if test -n "$selected"
            set activate_script "$venv_dir/$selected/bin/activate.fish"
            if test -f "$activate_script"
                source "$activate_script"
                echo "Activated $selected"
            else
                echo "Error: Not a valid venv (missing activate.fish)"
            end
        end
      '';

      rgc.body = "rg --json $argv | delta";

    }
    // lib.optionalAttrs const.is-linux {
      gpu_fan.body = "bash ~/scripts/gpu_fan.sh $argv";
    };
  };

}
