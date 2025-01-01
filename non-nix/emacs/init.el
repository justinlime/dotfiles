;; Allow tangling if the file is a symlink
(setq vc-follow-symlinks nil) 
;; org-babel-load-file in this case creates generates a .el file from a .org file.
;; If the .org file is a symlink, it won't regenerate it if changes are made to it,
;; so I delete it beforehand so it forces the .el to regenerate
(delete-file
  (expand-file-name
    "config.el"
    user-emacs-directory))
;; Tangle the .org and load it
(org-babel-load-file
  (expand-file-name
    "config.org"
    user-emacs-directory))
