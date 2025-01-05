{pkgs, ...}:

{
  imports = [
    ./bash
    ./fish
    ./nushell
  ];

  programs.tmux = {
    enable = true;
    tmuxinator.enable = true;
    keyMode = "emacs";
    newSession = false;
    prefix = "';'";
    plugins = with pkgs; [
      {
        plugin = tmuxPlugins.dracula;
        extraConfig = ''
          set -g @plugin 'dracula/tmux'
          set -g @dracula-plugins "time"
          set -g @dracula-show-powerline true
          set -g @dracula-show-left-icon "[#S] - #W"
        '';
      }
    ];
    extraConfig = ''
      set-option -g pane-border-lines double

      bind-key -n M-Enter split-window -h -c "#{pane_current_path}"
      bind-key -n M-"'" split-window -v -c "#{pane_current_path}"
      bind-key -n M-o new-window -c "#{pane_current_path}"
      bind-key -n M-O command-prompt -p "New session name:" "new-session -s '%%'"
      bind-key -n M-u previous-window
      bind-key -n M-i next-window
      bind-key -n M-U switch-client -p
      bind-key -n M-I switch-client -n

      bind-key -n M-q kill-pane
      bind-key -n M-Q kill-window
      bind-key -n M-j select-pane -D
      bind-key -n M-k select-pane -U
      bind-key -n M-h select-pane -L
      bind-key -n M-l select-pane -R
      bind-key -n M-J swap-pane -D
      bind-key -n M-K swap-pane -U
    '';
  };

  programs.fzf.tmux.enableShellIntegration = true;
}
