(require 'dashboard)

(dashboard-setup-startup-hook)
(setq dashboard-center-content t)
(setq dashboard-image-banner-max-height 400)
(setq dashboard-items '((recents . 15)
			            (projects . 7)
			            (bookmarks . 7)))