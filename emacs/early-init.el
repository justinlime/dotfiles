;; Speeds up startup times, changes reverted after startup is complete
(setq gc-cons-threshold most-positive-fixnum)
;; IDK what this does tbh, but seems to help startup times a bit
(setq file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)
(setq frame-inhibit-implied-resize t)
;; disable package.el at early init
;; even though it will be loaded later
;; shaves off some startup time
(setq package-enable-at-startup nil ; don't auto-initialize!
      ;; don't add that `custom-set-variables' block to my init.el!
      package--init-file-ensured t)
