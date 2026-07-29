;;new emacs config as of 27-12-2025
;;old one had a lot of problems specially with keybinds

(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;;set custom file and autosave into directory
(setq custom-file "~/.emacs.d/emacs-custom.el")
(load custom-file)

(setq backup-by-copying t
      backup-directory-alist '(("." . "~/.emacs-saves/"))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)
(setq auto-save-file-name-transforms
      `((".*" "~/.emacs-saves/" t)))

;;visual changes
(setq inhibit-startup-screen t
      ring-bell-function #'ignore) ;;annoying fucking noise aaaaaaaaaa
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(global-visual-line-mode t)
(global-display-line-numbers-mode 1)
;;(load-theme 'modus-vivendi)
(global-hl-line-mode 1)
(show-paren-mode 1)
(column-number-mode 1)
(display-time-mode 1)
(set-frame-parameter nil 'alpha-background 100)
(add-to-list 'default-frame-alist '(alpha-background . 100))

;;custom theme (gruvbox)
(use-package gruvbox-theme
    :ensure t
    :config
    (load-theme 'gruvbox-dark-hard))

;;small functional changes
(setq use-short-answers t
      set-fill-column 80)
(electric-pair-mode 0)

;;dired changes
(setq dired-open-extensions '(("mkv" . "mpv")))
(setq dired-listing-switches "-alFh")
(setq read-file-name-completion-ignore-case t
      read-buffer-completion-ignore-case t
      completion-ignore-case t)

;;setting registers
(set-register ?w (cons 'file "~/programming/org/wiki.org"))

;;fido and ido mode
(ido-mode 1)
(setq ido-auto-merge-delay-time 999999999)
(fido-mode 1)

;;fzf
(use-package fzf
    :ensure t
    :config
    (setq fzf/args "-x --color bw --print-query --margin=1,0 --no-hscroll"
          fzf/executable "fzf"
          fzf/git-grep-args "-i --line-number %s"
          ;; command used for `fzf-grep-*` functions
          ;; example usage for ripgrep:
          ;; fzf/grep-command "rg --no-heading -nH"
          fzf/grep-command "grep -nrH"
          ;; If nil, the fzf buffer will appear at the top of the window
          fzf/position-bottom t
          fzf/window-height 15))

;;cc mode changes
(defun my-make-CR-do-indent ()
    (define-key c-mode-base-map "\C-m" 'c-context-line-break))
(add-hook 'c-initialization-hook 'my-make-CR-do-indent)

;;cmake mode
(use-package cmake-mode
    :ensure t)

;;arduino mode packages
(use-package arduino-mode
    :ensure t
    :config)
(use-package arduino-cli-mode
    :ensure t
    :hook arduino-mode
    :mode "\\.ino\\'"
    :custom
    (arduino-cli-warnings 'all)
    (arduino-cli-verify t))

;;scheme
(use-package geiser
    :ensure t
    :config)

(use-package geiser-guile
    :ensure t
    :config)

;;go mode changes
(use-package go-mode
    :ensure t
    :config
    (add-hook 'go-mode-hook
              (lambda ()
                  (setq-default)
                  (setq tab-width 4)
                  (setq standard-indent 4)
                  (setq indent-tabs-mode nil)))
    
    (defun project-find-go-module (dir)
        (when-let ((root (locate-dominating-file dir "go.mod")))
            (cons 'go-module root)))
    (cl-defmethod project-root ((project (head go-module)))
        (cdr project))
    (add-hook 'project-find-functions #'project-find-go-module)

    (add-hook 'go-mode-hook 'eglot-ensure)
    (defun eglot-format-buffer-before-save ()
        (add-hook 'before-save-hook #'eglot-format-buffer -10 t))
    (add-hook 'go-mode-hook #'eglot-format-buffer-before-save))

;;cobol mode
(use-package cobol-mode
    :ensure t)

;;rust lang configuration
(use-package rust-mode
    :ensure t
    :config
    (add-to-list 'exec-path (expand-file-name "~/.cargo/bin"))
    (setenv "PATH" (concat (expand-file-name "~/.cargo/bin") ":" (getenv "PATH")))
    (add-hook 'rust-mode-hook #'eglot-ensure)
    (add-hook 'rust-mode-hook #'font-lock-mode))

;;python configuration
(add-hook 'python-mode-hook #'eglot-ensure) 
(add-hook 'python-mode-hook #'font-lock-mode)


;;octave mode
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))

;;java mode (TO BE CONFIGURED) (personal note: elgot-java is possibly the worst piece of software I have ever seen)

;;indentation changes (i fucking hate this and it should be changed to FORCE on all modes a tab)
(setq-default indent-tabs-mode nil
	          c-basic-offset 4
	          lisp-body-indent 4
	          tab-width 4)
(electric-indent-mode 1)

;;dict mode changes
(setq dictionary-server "dict.org")

;;yasnippet
(use-package yasnippet
    :ensure t
    :config
    (setq yas-snippet-dirs '("~/.emacs.d/snippets"))
    (yas-global-mode 1)
    )

;;org mode changes
(setq org-directory "~/programming/org")
(add-hook 'org-mode-hook 'visual-line-mode)
(add-hook 'org-mode-hook 'flyspell-mode)
(setq org-image-actual-width 600)
(setq org-todo-keywords
      '((sequence "TODO" "|" "DONE")))
(setq org-cite-global-bibliography '("~/documents/bibliography.bib"))

;;org latex preview
;;(setq org-format-latex-options (plist-put org-format-latex-options :scale 1.5))

;;changes for org agenda
(setq org-log-done t
      org-agenda-files '("~/programming/org/agendas"))


;;org capture templates
(setq org-capture-templates
      '(("i" "Inbox" entry
         (file "~/programming/org/inbox.org")
         "* TODO %?")))

;;org babel changes
(use-package ob-go
    :ensure t)
(org-babel-do-load-languages 'org-babel-load-languages
			                 '((python  . t)
			                   (C       . t)
                               (go      . t)
                               (latex   . t)
                               (scheme  . t)))
(setq org-src-tab-acts-natively t)

;;latex
(use-package auctex
    :ensure t
    :config
    (setq TeX-auto-save t)
    (setq TeX-parse-self t)
    (add-hook 'LaTeX-mode-hook 'visual-line-mode)
    (add-hook 'LaTeX-mode-hook 'flyspell-mode)
    (add-hook 'LaTeX-mode-hook 'LaTeX-math-mode)
    (add-hook 'LaTeX-mode-hook 'turn-on-reftex)
    (setq reftex-plug-into-AUCTeX t))

(use-package cdlatex
    :ensure t
    :config
    (define-key cdlatex-mode-map (kbd "<tab>") #'cdlatex-tab)
    (add-hook 'LaTeX-mode-hook #'turn-on-cdlatex)
    (add-hook 'LaTeX-mode-hook #'turn-on-reftex))

(setq reftex-default-bibliography '("~/documents/bibliography.bib")
      reftex-plug-into-AUCTeX t)

;;mardown mode
(use-package markdown-mode
                :ensure t)

;;adding muliple cursors
(use-package multiple-cursors
    :ensure t
    :config)

;;treemacs
(use-package treemacs
    :ensure t)

;;expandregion
(use-package expand-region
    :ensure t)

;;erc
;; (setq erc-server "irc.libera.chat"
;;       erc-nick "azel658"
;;       erc-track-shorten-start 8
;;       erc-kill-buffer-on-part t
;;       erc-auto-query 'bury)

;;pdf tools
(use-package pdf-tools
    :ensure t
    :config
    (add-hook 'pdf-view-mode-hook (lambda ()(display-line-numbers-mode -1)))
    (add-to-list 'auto-mode-alist '("\\.pdf\\'" . pdf-view-mode)))

(use-package company
    :ensure t
    :hook (c-mode emacs-lisp-mode go-mode cobol-mode arduino-mode cmake-mode scheme-mode rust-mode css-mode mhtml-mode)
    :config
    )

;;epub compatibility
(use-package nov
    :ensure t
    :config
    (add-to-list 'auto-mode-alist '("\\.epub\\'" . nov-mode))
    )

;;elfeed
 (use-package elfeed
     :ensure t
     :config
     (setq elfeed-feeds
           '("https://battlepenguin.com/feed.xml"
             "https://pantsuprophet.xyz/index/pantsuprophet.xml"
             "https://joshblais.com/index.xml"
             "https://www.eff.org/rss/updates.xml"
             "https://act.eff.org/action.atom"
             "https://sadgrl.online/posts/rss.xml"
             "https://corbettreport.com/feed/"
             "https://analognowhere.com/feed/rss.xml"
             "https://archlinux.org/feeds/news/"
             "https://esquizo.net/blog/index.rss"
             "https://lukesmith.xyz/index.xml"
             "https://hnrss.org/newest?points=25"
             "https://karthinks.com/index.xml"
             )))

;;buffer and window packages
(use-package buffer-move
    :ensure t
    :config)

(use-package winum
    :ensure t
    :config
    (require 'winum)
    (winum-mode))

;;magit and git changes
(use-package magit
    :ensure t)

;;mu4e
;;(use-package mu4e
;;    :ensure t)

;;gptel
(use-package gptel
    :ensure t
    :config
    (setq gptel-model 'gpt-5.4-mini
          gptel-default-mode 'org-mode))

;;iterm
(use-package eat
    :ensure t)

;;keybinds
(global-set-key (kbd "C-;") #'compile)
(global-set-key (kbd "C-x C-b") #'ibuffer)
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)
(global-set-key (kbd "<C-S-up>")     'buf-move-up)
(global-set-key (kbd "<C-S-down>")   'buf-move-down)
(global-set-key (kbd "<C-S-left>")   'buf-move-left)
(global-set-key (kbd "<C-S-right>")  'buf-move-right)
(global-set-key (kbd "C-=") 'er/expand-region)
(global-set-key (kbd "C-x C-'") 'fzf)
(global-set-key (kbd "C-x C-.") 'fzf-directory)
(global-set-key (kbd "C-x C-/") 'fzf-git)
(global-set-key (kbd "C-x g") 'magit-status)
(global-set-key (kbd "C-c =") 'reftex-toc)
(global-set-key (kbd "C-c g") 'gptel)
(global-set-key (kbd "C-c C-<return>") 'gptel-menu)
(global-set-key (kbd "<f5>") 'recompile)
(global-set-key (kbd "<f6>") 'eglot-format-buffer-before-save)

(setq winum-keymap
      (let ((map (make-sparse-keymap)))
          (global-set-key (kbd "C-`") 'treemacs-select-window)
          (global-set-key (kbd "C-1") 'winum-select-window-1)
          (global-set-key (kbd "C-2") 'winum-select-window-2)
          (global-set-key (kbd "C-3") 'winum-select-window-3)
          (global-set-key (kbd "C-4") 'winum-select-window-4)
          (global-set-key (kbd "C-5") 'winum-select-window-5)
          (global-set-key (kbd "C-6") 'winum-select-window-6)
          (global-set-key (kbd "C-7") 'winum-select-window-7)
          (global-set-key (kbd "C-8") 'winum-select-window-8)
          map))
(put 'upcase-region 'disabled nil)
