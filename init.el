;(require 'psvn) 

(add-to-list 'load-path "~/.emacs.d/color-theme-6.6.0")
(add-to-list 'load-path "~/.emacs.d")

;python-mode
(add-to-list 'load-path "~/.emacs.d/python-mode.el-6.0.4")
(setq py-install-directory "~/.emacs.d/python-mode.el-6.0.4")
(require 'python-mode)

(require 'idutils)
(require 'color-theme)

(eval-after-load "color-theme"
  '(progn
     (color-theme-initialize)
     (color-theme-hober)))

(defun my-c-mode-hook ()
  (setq-default c-basic-offset 4)
  (setq c-basic-offset 4)
  (setq indent-tabs-mode nil)
  (setq tab-width 4)
  (c-set-offset 'substatement-open 0)
  (c-set-offset 'brace-list-open 0))
(add-hook 'c-mode-common-hook 'my-c-mode-hook)
(add-hook 'c++-mode-common-hook 'my-c-mode-hook) 
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(safe-local-variable-values (quote ((c-file-offsets (comment-intro . 0))))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 )

;;id-tools
(autoload 'gid "gid" nil t)
