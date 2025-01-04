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
        extraConfig = "set -g @plugin 'dracula/tmux'";
      }
      {
        plugin = tmuxPlugins.tmux-fzf;
        extraConfig = "set -g @plugin 'sainnhe/tmux-fzf'";
      }
    ];
    extraConfig = ''
      set-option -g pane-border-style fg=default
      set-option -g pane-active-border-style fg=green
      set-option -g pane-border-lines double

      bind-key -n M-q kill-pane
      bind-key -n M-j select-pane -D
      bind-key -n M-k select-pane -U
      bind-key -n M-h select-pane -L
      bind-key -n M-l select-pane -R
      bind-key -n M-K select-window -p
      bind-key -n M-J select-window -n
      bind-key -n M-H switch-client -p
      bind-key -n M-L switch-client -n
    '';
  };

  programs.fzf.tmux.enableShellIntegration = true;
}
