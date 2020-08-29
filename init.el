(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(require 'neotree)
(global-set-key (kbd "C-3") 'neotree-toggle)

(require 'centaur-tabs)
(centaur-tabs-mode t)
(global-set-key (kbd "C-1")  'centaur-tabs-backward)
(global-set-key (kbd "C-2") 'centaur-tabs-forward)

(global-aggressive-indent-mode 1)
(add-to-list 'aggressive-indent-excluded-modes 'html-mode)

(load-theme 'cyberpunk t)

(add-hook 'elixir-mode-hook #'smartparens-mode)

(add-hook 'elixir-mode-hook
          (lambda () (add-hook 'before-save-hook 'elixir-format nil t)))

(require 'projectile)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(projectile-mode +1)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   '(projectile alchemist aggressive-indent smartparens neotree magit centaur-tabs elixir-mode)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
