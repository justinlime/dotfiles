;; Needed because org-babel-load-file refuses to
;; regenerate config.el when config.org is a symlink
(delete-file
(expand-file-name
 "config.el"
 user-emacs-directory))
(let ((file-name-handler-alist nil)) 
  (org-babel-load-file
   (expand-file-name
    "config.org"
    user-emacs-directory)))
