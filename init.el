;(require 'psvn) 
(tool-bar-mode -1)
(menu-bar-mode -1)

(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line


;; Add in your own as you wish:
(defvar my-packages '(ag
		      jedi
		      flymake
                      flymake-cursor
                      flymake-puppet
                      flymake-python-pyflakes
                      projectile
                      puppet-mode
                      puppetfile-mode
                      pylint
                      virtualenv
                      whitespace-cleanup-mode)
  "A list of packages to ensure are installed at launch.")
 
(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))


(add-to-list 'load-path "~/.emacs.d")

(add-to-list 'custom-theme-load-path "~/.emacs.d/emacs-color-theme-solarized")
(load-theme 'solarized t)
(set-frame-parameter nil 'background-mode 'dark)
(when (not (display-graphic-p (selected-frame)))
  (set-terminal-parameter (frame-terminal frame) 'background-mode 'dark))
(enable-theme 'solarized)

;python-mode
(add-to-list 'load-path "~/.emacs.d/python-mode.el-6.0.4")
(setq py-install-directory "~/.emacs.d/python-mode.el-6.0.4")
(require 'flymake-python-pyflakes)
(require 'flymake-cursor)
(setq flymake-python-pyflakes-executable "/usr/local/bin/flake8")


(require 'python-mode)
;;; Python stuff
(add-hook 'python-mode-hook
            (lambda ()
              (require 'virtualenv)
              (flymake-python-pyflakes-load)))

;; don't use default keybindings from jedi.el; keep C-. free
(setq jedi:setup-keys nil)
(setq jedi:tooltip-method nil)
(autoload 'jedi:setup "jedi" nil t)
(add-hook 'python-mode-hook 'jedi:setup)

(defvar jedi:goto-stack '())
(defun jedi:jump-to-definition ()
  (interactive)
  (add-to-list 'jedi:goto-stack
               (list (buffer-name) (point)))
  (jedi:goto-definition))
(defun jedi:jump-back ()
  (interactive)
  (let ((p (pop jedi:goto-stack)))
    (if p (progn
            (switch-to-buffer (nth 0 p))
            (goto-char (nth 1 p))))))

(add-hook 'python-mode-hook
          '(lambda ()
             (local-set-key (kbd "C-.") 'jedi:jump-to-definition)
             (local-set-key (kbd "C-,") 'jedi:jump-back)
             (local-set-key (kbd "C-c d") 'jedi:show-doc)
             (local-set-key (kbd "C-<tab>") 'jedi:complete)))

(require 'thrift-mode)
(require 'idutils)

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
 '(custom-safe-themes
   (quote
    ("3c83b3676d796422704082049fc38b6966bcad960f896669dfc21a7a37a748fa" default)))
 '(safe-local-variable-values (quote ((c-file-offsets (comment-intro . 0))))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;;id-tools
(autoload 'gid "gid" nil t)

;;Projectile
(projectile-global-mode)
(define-key projectile-mode-map [?\s-d] 'projectile-find-dir)
(define-key projectile-mode-map [?\s-p] 'projectile-switch-project)
(define-key projectile-mode-map [?\s-o] 'projectile-find-file)


;; full screen
(defun switch-fullscreen nil
  (interactive)
  (let* ((modes '(nil fullboth fullwidth fullheight))
         (cm (cdr (assoc 'fullscreen (frame-parameters) ) ) )
         (next (cadr (member cm modes) ) ) )
    (modify-frame-parameters
     (selected-frame)
     (list (cons 'fullscreen next)))))
;; Set the number to the number of columns to use.
(setq flymake-python-pyflakes-extra-arguments '("--max-line-length=100"))

;; globally refresh file buffers if changed
(global-auto-revert-mode t)

;;helm

(add-to-list 'load-path "~/.emacs.d/async")
(add-to-list 'load-path "~/.emacs.d/helm")
(require 'helm-config)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

;;(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
;;(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
;;(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)

(helm-mode 1)

;;help-projectile
(projectile-global-mode)
(setq projectile-completion-system 'helm)
(helm-projectile-on)

(define-key projectile-mode-map [?\s-f] 'helm-projectile-ag)


;;powerline
(require 'powerline)
(powerline-center-theme)
(sml/setup)

