(setq gc-cons-threshold most-positive-fixnum)

(defvar better-gc-cons-threshold 134217728 ; 128mb
  "The default value to use for `gc-cons-threshold'.

If you experience freezing, decrease this.  If you experience stuttering, increase this.")

(add-hook 'emacs-startup-hook
      (lambda ()
        (if (boundp 'after-focus-change-function)
        (add-function :after after-focus-change-function
              (lambda ()
                (unless (frame-focus-state)
                  (garbage-collect))))
      (add-hook 'after-focus-change-function 'garbage-collect))
        (defun gc-minibuffer-setup-hook ()
      (setq gc-cons-threshold (* better-gc-cons-threshold 2)))

        (defun gc-minibuffer-exit-hook ()
      (garbage-collect)
      (setq gc-cons-threshold better-gc-cons-threshold))

        (add-hook 'minibuffer-setup-hook #'gc-minibuffer-setup-hook)
        (add-hook 'minibuffer-exit-hook #'gc-minibuffer-exit-hook)))


(prefer-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)

(set-language-environment 'utf-8)
(set-default-coding-systems 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(set-clipboard-coding-system 'utf-8)
(set-file-name-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(modify-coding-system-alist 'process "*" 'utf-8)

;; no welcome page
(setq inhibit-splash-screen t)
;; Disable the startup message
(setq inhibit-startup-message t)
;; Disable the initial scratch message
(setq initial-scratch-message nil)
;; Disable the startup screen
(setq inhibit-startup-screen t)
;; Disable the startup buffer menu
(setq inhibit-startup-buffer-menu t)
;; Disable the startup echo area message
(setq inhibit-startup-echo-area-message user-login-name)

;; fullscreen
(setq initial-frame-alist (quote ((fullscreen . maximized))))
;; (set-frame-parameter nil 'fullscreen 'fullboth)

;;custom file
(setq custom-file (expand-file-name "~/.emacs.d/custom.el" user-emacs-directory))

;;diable error tone
(setq ring-bell-function 'ignore)

;;no backup file
(setq make-backup-files nil)
(setq auto-save-default nil)

;;show recent file
(recentf-mode 1)
(setq recentf-max-menu-items 15)

;;delete selection
(delete-selection-mode 1)

;;paste from clipboard
(setq x-select-enable-clipboard t)

;;replace Yes/No with y/n
(fset 'yes-or-no-p 'y-or-n-p)

;;tab-width
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)


(require 'try)