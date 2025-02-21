{pkgs, ...}:

{
  imports = [
    ./bash
    ./fish
    ./nushell
  ];

  home.packages = with pkgs; [
    sesh
  ];

  programs.zellij = {
    enable = true;
    settings = {
      theme = "dracula";
    };
  };

  programs.tmux = {
    enable = true;
    tmuxinator.enable = true;
    keyMode = "emacs";
    newSession = false;
    prefix = "';'";
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.resurrect;
      }
      {
        plugin = tmuxPlugins.dracula;
        extraConfig = ''
          set -g @dracula-plugins "time"
          set -g @dracula-show-powerline true
          set -g @dracula-show-left-icon "[#S] - #W"
        '';
      }
    ];
    extraConfig = ''
      set -sg escape-time 0
      set -g detach-on-destroy off  # don't exit from tmux when closing a session
      set-option -g pane-border-lines double

      bind-key -n M-Enter split-window -h -c "#{pane_current_path}"
      bind-key -n M-"'" split-window -v -c "#{pane_current_path}"
      bind-key -n M-o new-window -c "#{pane_current_path}"
      bind-key -n M-O command-prompt -p "New session name:" "new-session -s '%%'"
      bind-key -n M-u previous-window
      bind-key -n M-i next-window
      bind-key -n M-U switch-client -p
      bind-key -n M-I switch-client -n
      bind-key -n M-Tab if-shell '[ "$(tmux list-windows | wc -l)" -gt 1 ]' \
        'last-window' \
        'switch-client -l'

      bind-key -n M-q kill-pane
      bind-key -n M-Q kill-window
      bind-key -n M-j select-pane -D
      bind-key -n M-k select-pane -U
      bind-key -n M-h select-pane -L
      bind-key -n M-l select-pane -R
      bind-key -n M-J swap-pane -D
      bind-key -n M-K swap-pane -U

      bind-key "S" run-shell "sesh connect \"$(
        sesh list --icons | fzf-tmux -p 55%,60% \
          --no-sort --ansi --border-label ' sesh ' --prompt '⚡  ' \
          --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
          --bind 'tab:down,btab:up' \
          --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
          --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
          --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
          --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
          --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
          --bind 'ctrl-d:execute(tmux kill-session -t {2..})+change-prompt(⚡  )+reload(sesh list --icons)' \
      )\""

    '';
  };

  programs.fzf.tmux.enableShellIntegration = true;
}
