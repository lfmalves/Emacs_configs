;; Disable package auto-loading at startup (we manage it manually)
(setq package-enable-at-startup nil)

;; Initialize package system
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Ensure package archive contents are up-to-date
(unless package-archive-contents
  (package-refresh-contents))

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; Load theme after it's installed
(use-package cyberpunk-theme
  :config
  (load-theme 'cyberpunk t))

;; Neotree for file tree
(use-package neotree
  :bind ("C-3" . neotree-toggle))

;; Centaur Tabs for tab-style navigation
(use-package centaur-tabs
  :init
  (setq centaur-tabs-style "bar"
        centaur-tabs-set-icons t)
  :config
  (centaur-tabs-mode t)
  :bind
  (("C-1" . centaur-tabs-backward)
   ("C-2" . centaur-tabs-forward)))

;; Smartparens for structural editing
(use-package smartparens
  :hook ((elixir-mode emacs-lisp-mode ruby-mode python-mode) . smartparens-mode))

;; Aggressive indent for clean code
(use-package aggressive-indent
  :hook (prog-mode . global-aggressive-indent-mode)
  :config
  (add-to-list 'aggressive-indent-excluded-modes 'html-mode))

;; Show line numbers (modern alternative to linum-mode)
(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; Company-mode for autocompletion
(use-package company
  :hook (after-init . global-company-mode))

;; Projectile for project navigation
(use-package projectile
  :init (setq projectile-keymap-prefix (kbd "C-0"))
  :config (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("C-0" . projectile-command-map)))

;; Magit for Git integration
(use-package magit :defer t)

;; === Elixir ===
(use-package elixir-mode :defer t)
(use-package alchemist :defer t)

(add-hook 'elixir-mode-hook
          (lambda ()
            (when (executable-find "mix")
              (add-hook 'before-save-hook #'elixir-format nil t))))

;; === Python ===
(defun elpy-black-fix-code ()
  "Format current buffer with black."
  (interactive)
  (when (and buffer-file-name (executable-find "black"))
    (shell-command-to-string
     (format "black %s" (shell-quote-argument buffer-file-name)))
    (revert-buffer t t t)))

(use-package elpy
  :init
  (setq elpy-rpc-python-command "python3"
        python-shell-interpreter "python3")
  :config
  (elpy-enable)
  (add-hook 'elpy-mode-hook
            (lambda ()
              (add-hook 'before-save-hook #'elpy-black-fix-code nil t))))

;; === Ruby ===
(defun rubocop-autocorrect-current-file ()
  "Autocorrect current file with RuboCop."
  (interactive)
  (when (and buffer-file-name (executable-find "rubocop"))
    (shell-command-to-string
     (format "rubocop -A %s" (shell-quote-argument buffer-file-name)))
    (revert-buffer t t t)))

(use-package enh-ruby-mode
  :mode "\\.rb\\'"
  :interpreter "ruby"
  :hook ((enh-ruby-mode . robe-mode)
         (enh-ruby-mode . (lambda ()
                            (add-hook 'before-save-hook #'rubocop-autocorrect-current-file nil t)))))

(use-package robe :defer t)

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
