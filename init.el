;;this is my new init.el
;;the old one was getting way to big and slow so I decided to actually make a minimal one
;;my objective is to have 150 lines max, including packages
;;written on 27-09-2025

;;melpa setup
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;;set custom file
(setq custom-file "~/.emacs.d/emacs-custom.el")
(load custom-file)

;;compilation command keybind
(global-set-key (kbd "C-;") #'compile)

;;set directory for auto save files
(setq backup-by-copying t
      backup-directory-alist '(("." . "~/.emacs-saves/"))
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t)
(setq auto-save-file-name-transforms
      `((".*" "~/.emacs-saves/" t)))

;;visual changes
(setq inhibit-startup-screen t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(global-visual-line-mode t)
(global-display-line-numbers-mode 1)
(load-theme 'modus-operandi)
(global-hl-line-mode 1)
(show-paren-mode 1)
(column-number-mode 1)
(display-time-mode 1)
;;set font and size
(add-to-list 'default-frame-alist
             '(font . "DejaVu Sans Mono-12"))

;;dired changes

(setq dired-open-extensions '(("mkv" . "mpv")))

;;electric parenthesis mode
(electric-pair-mode 0)

;;change buffer menu for ibuffer
(global-set-key (kbd "C-x C-b") #'ibuffer)

;;cc mode changes (indentation in later section)

(defun my-make-CR-do-indent ()
    (define-key c-mode-base-map "\C-m" 'c-context-line-break))
(add-hook 'c-initialization-hook 'my-make-CR-do-indent)

;;indentation changes
(setq-default indent-tabs-mode nil)
(electric-indent-mode 1)
(setq c-basic-offset 4)
(setq lisp-body-indent 4)
(setq tab-width 4)
;;column changes
(setq-default set-fill-column 80)

;;dict mode changes
(setq dictionary-server "dict.org")

;;ido and fido mode
;;(ido-mode 1)
;;(setq ido-auto-merge-delay-time 999999999)
;;(fido-mode 1) 
;;fido mode is really slow so I am using vertico and marginalia instead until they fix this shit and make it less slow
(use-package vertico
    :ensure t
    :config
    (vertico-mode 1))
(use-package marginalia
    :ensure t
    :config
    (marginalia-mode 1))

;;org mode changes
(setq org-directory "~/programming/org")
(add-hook 'org-mode-hook 'visual-line-mode)
(add-hook 'org-mode-hook 'flyspell-mode)
(setq org-image-actual-width 600)
;;some keybind changes, tab was being weird, there was no heading with control
;;enter and the buffer movements were being overwritten by org mode keybinds
;;even though they were global
(with-eval-after-load "org"
    (define-key org-mode-map (kbd "<tab>") #'org-cycle)
    (define-key org-mode-map (kbd "C-<return>") #'org-insert-heading)
    (define-key org-mode-map (kbd "<C-S-up>")     'buf-move-up)    
    (define-key org-mode-map (kbd "<C-S-down>")   'buf-move-down)  
    (define-key org-mode-map (kbd "<C-S-left>")   'buf-move-left)  
    (define-key org-mode-map (kbd "<C-S-right>")  'buf-move-right))

(setq org-todo-keywords
      '((sequence "TODO(t)" "PROJECT(p)" "READING(r)" "|" "DONE(d)" "CANCELLED(c)")))
;;changes for org agenda
(setq org-log-done t)
(setq org-agenda-files '("~/programming/org/agendas"))
(global-set-key (kbd "C-c a") 'org-agenda)
;;org babel changes
(org-babel-do-load-languages 'org-babel-load-languages
			     '(
			       (python     . t)
			       (C       . t)
                               ))

;;org capture templates
(global-set-key (kbd "C-c c") 'org-capture)
(setq org-capture-templates
      '(("i" "Inbox" entry
         (file "~/programming/org/inbox.org")
         "* TODO %?")))

;;shell changes
(with-eval-after-load "shell"
    (define-key shell-mode-map (kbd "<tab>") #'completion-at-point))

;;arduino mode packages
(use-package arduino-mode
    :ensure t
    :config)
(use-package arduino-cli-mode
    :ensure t
    ;; :hook arduino-mode
    ;; :mode "\\.ino\\'"
    :custom
    (arduino-cli-warnings 'all)
    (arduino-cli-verify t))

;;markdown mode
(use-package markdown-mode
    :ensure t
    :config)

;;adding multiple cursors
(use-package multiple-cursors
    :ensure t
    :config
    (global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
    (global-set-key (kbd "C->") 'mc/mark-next-like-this)
    (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
    (global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this))

;; latex changes
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
    :config)

;;yasnippet
(use-package yasnippet
    :ensure t
    :config
    (add-to-list 'load-path
              "~/.emacs.d/plugins/yasnippet")
    (require 'yasnippet)
    (yas-global-mode 1))

;;magit
(use-package magit
    :ensure t
    :bind
    ("C-x g" . magit-status)
    :config)

;;erc
(setq erc-server "irc.libera.chat"
      erc-nick "psdp658"
      erc-track-shorten-start 8
      erc-kill-buffer-on-part t
      erc-auto-query 'bury)

;;pdf tools
(use-package pdf-tools
    :ensure t
    :config)

;;elfeed
(use-package elfeed
    :ensure t
    :config
    (setq elfeed-feeds
          '("https://inv.nadeko.net/feed/channel/UCD6VugMZKRhSyzWEWA9W2fg" ;;sseth
            "https://inv.nadeko.net/feed/channel/UCyEJzdViuBHCo4Cokj4-BgQ" ;;picothespicywarlord
            "https://inv.nadeko.net/feed/channel/UCP399QC1HNG2CtpzvmelWEg" ;;pacaranaabelcirilo
            "https://inv.nadeko.net/feed/channel/UC2eYFnH61tmytImy1mTYvhA" ;;luke smith
            "https://inv.nadeko.net/feed/channel/UCfwJBTwTgdCj5IHmBcOD8Vg" ;;shreddednerd
            "https://inv.nadeko.net/feed/channel/UCb_sF2m3-2azOqeNEdMwQPw" ;;matthewmatosis
            "https://yewtu.be/feed/channel/UCYSDUtXMbJ-kLe0s5XpxUng"       ;;more hawka
            "https://yewtu.be/feed/channel/UCEq0icugzGTAw_q0LaDFmZw"       ;;noob2dev
            "https://battlepenguin.com/feed.xml"
            "https://joshblais.com/index.xml"
            "https://www.eff.org/rss/updates.xml"
            "https://act.eff.org/action.atom"
            "https://sadgrl.online/posts/rss.xml"
            "https://corbettreport.com/feed/"
            "https://stonetoss.com/comic/feed/"
            "https://analognowhere.com/feed/rss.xml"
            "https://archlinux.org/feeds/news/"
            )))

;;fzf
(use-package fzf
    :ensure t
    :bind
    ("C-x C-'" . fzf)
    ("C-x C-." . fzf-directory)
    ("C-x C-/" . fzf-git)
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

;;go mode
(use-package go-mode
    :ensure t
    :config
    )

;;buffer move
(use-package buffer-move
    :ensure t
    :config
    (global-set-key (kbd "<C-S-up>")     'buf-move-up)
    (global-set-key (kbd "<C-S-down>")   'buf-move-down)
    (global-set-key (kbd "<C-S-left>")   'buf-move-left)
    (global-set-key (kbd "<C-S-right>")  'buf-move-right))

;;corfu (completion framework)
(use-package corfu
    :ensure t
    :custom
    (corfu-cycle t)
    (corfu-auto t)
    (corfu-auto-prefix 2)
    (corfu-auto-delay 0.0)
    :bind (:map corfu-map
                ("M-SPC" . corfu-insert-separator)
                ("RET" . nil)
                ("TAB" . corfu-next)
                ("S-TAB" . corfu-previous)
                ("S-RET" . corfu-insert))
    :init
    (global-corfu-mode)
)
