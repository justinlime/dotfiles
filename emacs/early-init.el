;; Speeds up startup times, changes reverted after startup is complete
(setq gc-cons-threshold most-positive-fixnum)
;; IDK what this does tbh, but seems to help startup times a bit
(setq file-name-handler-alist-original file-name-handler-alist)
(setq file-name-handler-alist nil)
;; disable package.el at early init
;; even though it will be loaded later
;; shaves off some startup time
(setq package-enable-at-startup nil)
