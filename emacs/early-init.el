;; Speeds up startup times, changes reverted after startup is complete
(setq gc-cons-threshold (* 1024 1024 256)) ;256 MB GC
(setq file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)

(setq vc-follow-symlinks nil) ;; Allow tangleing if the file is a symlink
(setq package-enable-at-startup nil) ;disable package.el
