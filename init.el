;; Initialize package sources
(require 'package)
(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; Load theme early
(load-theme 'cyberpunk t)

;; Neotree
(use-package neotree
  :bind ("C-3" . neotree-toggle))

;; Centaur Tabs
(use-package centaur-tabs
  :init
  (setq centaur-tabs-style "bar"
        centaur-tabs-set-icons t)
  :config
  (centaur-tabs-mode t)
  :bind
  (("C-1" . centaur-tabs-backward)
   ("C-2" . centaur-tabs-forward)))

;; Aggressive Indent
(use-package aggressive-indent
  :hook (prog-mode . global-aggressive-indent-mode)
  :config
  (add-to-list 'aggressive-indent-excluded-modes 'html-mode))

;; Line Numbers
(add-hook 'prog-mode-hook 'linum-mode)

;; Smartparens for structural editing
(use-package smartparens
  :hook ((elixir-mode emacs-lisp-mode ruby-mode python-mode) . smartparens-mode))

;; Company-mode (auto-completion)
(use-package company
  :hook (after-init . global-company-mode))

;; Projectile
(use-package projectile
  :init (setq projectile-keymap-prefix (kbd "C-0"))
  :config (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("C-0" . projectile-command-map)))

;; Magit
(use-package magit :defer t)

;; === Elixir ===
(use-package elixir-mode :defer t)
(use-package alchemist :defer t)
(add-hook 'elixir-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'elixir-format nil t)))

;; === Python ===
(use-package elpy
  :init (elpy-enable)
  :hook (elpy-mode . (lambda ()
                       (setq python-shell-interpreter "python3")
                       (add-hook 'before-save-hook #'elpy-black-fix-code nil t)))
  :config
  (setq elpy-rpc-python-command "python3"))

(defun elpy-black-fix-code ()
  "Format current buffer with black."
  (interactive)
  (when (executable-find "black")
    (shell-command-to-string (format "black %s" (shell-quote-argument buffer-file-name)))
    (revert-buffer t t t)))

;; === Ruby ===
(use-package enh-ruby-mode
  :mode "\\.rb\\'"
  :interpreter "ruby"
  :hook ((enh-ruby-mode . robe-mode)
         (enh-ruby-mode . (lambda ()
                            (add-hook 'before-save-hook #'rubocop-autocorrect-current-file nil t)))))

(use-package robe :defer t)

(defun rubocop-autocorrect-current-file ()
  "Autocorrect current file with RuboCop."
  (interactive)
  (when (executable-find "rubocop")
    (shell-command-to-string
     (format "rubocop -A %s" (shell-quote-argument buffer-file-name)))
    (revert-buffer t t t)))

;; === Emacs Lisp ===
(defun elisp-autoformat-buffer ()
  "Auto-indent and clean up Emacs Lisp code."
  (when (derived-mode-p 'emacs-lisp-mode)
    (indent-region (point-min) (point-max))
    (whitespace-cleanup)))

(add-hook 'emacs-lisp-mode-hook
          (lambda ()
            (smartparens-mode 1)
            (aggressive-indent-mode 1)
            (company-mode 1)
            (add-hook 'before-save-hook 'elisp-autoformat-buffer nil t)))
