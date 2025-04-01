;; === Pacotes e Inicialização ===
(setq package-enable-at-startup nil)
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(unless package-archive-contents
  (package-refresh-contents))

(unless (package-installed-p 'use-package)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; === Tema ===
(use-package cyberpunk-theme
  :config
  (load-theme 'cyberpunk t))

;; === Interface ===
(use-package neotree
  :bind ("C-3" . neotree-toggle))

(use-package centaur-tabs
  :init
  (setq centaur-tabs-style "bar"
        centaur-tabs-set-icons t)
  :config
  (centaur-tabs-mode t)
  :bind (("C-1" . centaur-tabs-backward)
         ("C-2" . centaur-tabs-forward)))

;; === Navegação e edição ===
(use-package smartparens
  :hook ((elixir-ts-mode emacs-lisp-mode ruby-mode python-mode) . smartparens-mode))

(use-package aggressive-indent
  :hook (prog-mode . aggressive-indent-mode)
  :config
  (add-to-list 'aggressive-indent-excluded-modes 'html-mode))

(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; === Autocompletar ===
(use-package company
  :hook (after-init . global-company-mode))

;; === Projectile ===
(use-package projectile
  :init (setq projectile-keymap-prefix (kbd "C-0"))
  :config (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("C-0" . projectile-command-map)))

;; === Git ===
(use-package magit :defer t)

;; === Elixir ===
(use-package elixir-ts-mode
  :mode "\\.exs?\\'")

(use-package elixir-tools
  :hook (elixir-ts-mode . elixir-tools-mode))

(use-package eglot
  :hook (elixir-ts-mode . eglot-ensure))

(add-hook 'elixir-ts-mode-hook
          (lambda ()
            (when (executable-find "mix")
              (add-hook 'before-save-hook #'elixir-format nil t))))

;; === Python ===
(use-package python
  :ensure nil
  :hook (python-mode . eglot-ensure))

(use-package blacken
  :hook (python-mode . blacken-mode)
  :custom (blacken-line-length 88))

;; === Ruby ===
(use-package enh-ruby-mode
  :mode "\\.rb\\'"
  :interpreter "ruby"
  :hook ((enh-ruby-mode . (lambda ()
                            (add-hook 'before-save-hook #'rubocop-autocorrect-current-file nil t)))))

(defun rubocop-autocorrect-current-file ()
  "Autocorrect current file with RuboCop."
  (interactive)
  (when (and buffer-file-name (executable-find "rubocop"))
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
