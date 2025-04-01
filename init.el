;; Initialize package sources
(require 'package)
(setq package-enable-at-startup nil) ; Prevent double package loading
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; Bootstrap use-package
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(require 'use-package)
(setq use-package-always-ensure t)

;; Load theme early for UI performance
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

;; Smartparens for Elixir
(use-package smartparens
  :hook (elixir-mode . smartparens-mode))

;; Auto-format on save for Elixir
(add-hook 'elixir-mode-hook
          (lambda ()
            (add-hook 'before-save-hook 'elixir-format nil t)))

;; Company-mode (auto-completion)
(use-package company
  :hook (after-init . global-company-mode))

;; Projectile
(use-package projectile
  :init (setq projectile-keymap-prefix (kbd "C-0"))
  :config (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("C-0" . projectile-command-map)))

;; Optional: Magit
(use-package magit :defer t)

;; Elixir mode and Alchemist
(use-package elixir-mode :defer t)
(use-package alchemist :defer t)

;; Save selected packages
(setq package-selected-packages
      '(projectile alchemist aggressive-indent smartparens
                   neotree magit centaur-tabs elixir-mode use-package))

