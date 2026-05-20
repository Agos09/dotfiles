;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Avoid GdkPixbuf "xpm not supported" warning (if system has no XPM loader)
(setq image-types (delq 'xpm image-types))

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!

;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
;; (setq user-full-name "John Doe"
;;       user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; =============================================================================
;; ORG-MODE CONFIGURATION
;; =============================================================================

;; Set org directory before org loads
(setq org-directory "~/kDrive/2_Areas/org/")

;; =============================================================================
;; ORG-ROAM CONFIGURATION
;; =============================================================================

;; Set org-roam directory
(setq org-roam-directory (expand-file-name "~/kDrive/2_Areas/org/roam_notes/"))

;; Enable automatic database sync
(org-roam-db-autosync-mode)

;; Configure org-roam capture templates
(setq org-roam-capture-templates
      '(("d" "default" plain "%?"
         :target (file+head "%<%Y%m%d%H%M%S>-${slug}.org"
                            "#+title: ${title}\n")
         :unnarrowed t)
        
        ("p" "Public/Publish" plain "%?"
         :target (file+head
                  ;; File naming convention
                  "%(concat (format-time-string \"%Y%m%d%H%M%S-\") (org-hugo-slug ${title}) \".org\")"
                  
                  ;; File header for ox-hugo
                  "%(concat
                   \"#+TITLE: ${title}\\n\"
                   \"#+HUGO_SECTION: notes\\n\"  
                   \"#+HUGO_TAGS: public\\n\"
                   \"#+HUGO_PUBLISH_DATE: %U\\n\"
                   \"#+HUGO_LASTMOD: %u\\n\"
                   \"#+ROAM_KEY: ${id}\\n\"
                   )"
                  )
         :unnarrowed t)

          ("w" "Weekly Review" plain "%?"
          :target (file+head "~/kDrive/2_Areas/org/reviews.org" "Weekly Reviews") ; Adjust file path and headline as needed
  " Weekly Review: %<%Y-%m-%d %a>\n Energy Audit\n What gave me energy this week?\n - \n What drained my energy this
  week?\n - \n Actionable Insights\n What is the one change I can make to do more of what gave me energy and less of
  what drained it?\n - \n Metrics & Trends\n* Weekly Energy Score (1-5): \n \"Change\" Implementation Rate (Last Week's
  Change): [ ] Yes / [ ] No\n Focus Ratio (from Time Tracking, e.g., RescueTime): \n Key Result Progress (from
  OKRs/Project Management): \n Qualitative Reflection (Monthly - review last 4 weeks)\n Recurring themes in
  energy-giving activities:\n - \n* Recurring themes in energy-draining activities:\n - \n")
          ))


; =============================================================================
;; ORG-ROAM-UI CONFIGURATION
;; =============================================================================

(after! org-roam-ui
  (org-roam-ui-mode +1) 
  (setq org-roam-ui-follow t)
  (setq org-roam-ui-update-on-save t))

;; =============================================================================
;; OX-HUGO CONFIGURATION
;; =============================================================================

(after! ox-hugo
  ;; Set the Hugo site directory
  (setq org-hugo-base-dir (expand-file-name "~/kDrive/1_Projects/notes_agostinodeangelis_da15e11b/"))
  
  ;; Configure ox-hugo to work with org-roam
  (setq org-hugo-section "posts")
  (setq org-hugo-use-code-for-kbd t)
  (setq org-hugo-prefer-hugo-bindings t)
  
  ;; Custom export settings for org-roam integration
  (setq org-hugo-export-with-toc nil)
  (setq org-hugo-export-with-section-numbers nil)
  
  ;; Configure front matter to include org-roam metadata
  (setq org-hugo-front-matter-format 'yaml))

;; =============================================================================
;; OX-REVEAL CONFIGURATION
;; =============================================================================

(after! ox-reveal
  (setq org-reveal-root "file:///.config/doom/reveal.js"))

;; =============================================================================
;; ORG TIME TRACKING CONFIGURATION
;; =============================================================================

(after! org
  ;; --- Clock Settings ---
  (setq org-clock-persist 'history)              ;; Save clock history across sessions
  (org-clock-persistence-insinuate)              ;; Enable persistence
  (setq org-clock-in-resume t)                   ;; Resume clock if clocking into task with open clock
  (setq org-clock-out-remove-zero-time-clocks t) ;; Remove 0-minute clocks
  (setq org-clock-report-include-clocking-task t);; Include current task in reports
  (setq org-clock-idle-time 15)                  ;; Auto clock-out after 15m idle
  (setq org-clock-into-drawer t)                 ;; Clock into LOGBOOK drawer
  (setq org-clock-modeline-total 'current)       ;; Show time in modeline

  ;; --- Effort Estimates (Budget) ---
  (setq org-global-properties
        '(("Effort_ALL" . "0:15 0:30 1:00 2:00 4:00 8:00")))

  ;; Show effort in column view
  (setq org-columns-default-format
        "%50ITEM(Task) %10Effort(Budget){:} %10CLOCKSUM(Actual){:} %TODO %TAGS")

  ;; --- Clock Table Defaults ---
  (setq org-clocktable-defaults
        '(:maxlevel 3 :scope file :properties ("Effort") :block nil
          :stepskip0 t :fileskip0 t :link t)))

;; --- Quick Keybindings for Clocking (Doom-style) ---
(map! :leader
      (:prefix ("c" . "clock")
       :desc "Clock in"           "i" #'org-clock-in
       :desc "Clock out"          "o" #'org-clock-out
       :desc "Clock cancel"       "x" #'org-clock-cancel
       :desc "Clock goto"         "g" #'org-clock-goto
       :desc "Set effort"         "e" #'org-set-effort
       :desc "Clock report"       "r" #'org-clock-report
       :desc "Manually set range" "m" #'org-clock-in-last
       :desc "Display clocks"     "d" #'org-clock-display))

;; Clock into recent task from anywhere
(defun my/org-clock-in-recent ()
  "Clock into a recently clocked task."
  (interactive)
  (org-clock-in '(4)))

(map! :leader :desc "Clock in recent" "c c" #'my/org-clock-in-recent)

;; =============================================================================
;; ORG-AGENDA CONFIGURATION
;; =============================================================================

(setq org-refile-targets '((org-agenda-files :maxlevel . 3)))
(setq org-refile-use-outline-path 'file)

;; Add timetrack.org to agenda files
(after! org
  (add-to-list 'org-agenda-files (expand-file-name "timetrack.org" org-directory)))

(setq org-agenda-custom-commands
      '(("d" "My Daily Review" 
         ;; Block 1: Immediate Tasks (High Priority or Overdue)
         ((tags-todo "+PRIORITY=\"A\"|DEADLINE<\"<+1d>\"" 
           ((org-agenda-overriding-header "PRIORITY A & DEADLINE Tasks")))

          ;; Block 2: Today's Schedule and Habits
          (agenda "" 
           ((org-agenda-span 'day)
            (org-agenda-overriding-header "Today's Schedule")))

          ;; Block 3: Next Actions (TODOs tagged with next)
          (tags-todo "+NEXT-WAITING" 
           ((org-agenda-overriding-header "Next Actions (Not Waiting)")))

          ;; Block 4: All Waiting Items
          (todo "WAITING" 
           ((org-agenda-overriding-header "Waiting For...")))
          )
         ((org-agenda-compact-blocks t)))

        ;; TIME TRACKING VIEW
        ("t" "Time Tracking"
         ((agenda "" 
           ((org-agenda-span 'day)
            (org-agenda-start-with-clockreport-mode t)
            (org-agenda-overriding-header "Today's Clocked Time")))
          (tags-todo "Effort>\"0\""
           ((org-agenda-overriding-header "Tasks with Time Budget")
            (org-agenda-columns-add-appointments-to-effort-sum t)
            (org-agenda-sorting-strategy '(effort-up priority-down))))
          )
         ((org-agenda-compact-blocks t)
          (org-agenda-clockreport-parameter-plist
           '(:link t :maxlevel 2 :fileskip0 t :properties ("Effort")))))

         ("s" "Abbonamenti Table" tags "ABBONAMENTO"
          ((org-agenda-overriding-header "Subscriptions Overview")
           (org-agenda-start-with-columns-view t)
           (org-columns-format "%40ITEM %15DEADLINE %20COSTO")))

         ("l" "Loop Events with Dates"
           ((todo ""
                  ((org-agenda-overriding-header "Scheduled Loop Items")
                   (org-agenda-filter-preset '("ABBONAMENTO"))
                   (org-agenda-prefix-format '((todo . " %-12:c %11(org-entry-get nil \"SCHEDULED\") ")))
                   (org-agenda-todo-ignore-with-date nil)
                   (org-agenda-sorting-strategy '(scheduled-up))))))))

;; =============================================================================
;; ANKI-EDITOR CONFIGURATION
;; =============================================================================

(after! anki-editor
  ;; Create decks in Anki automatically if they don't exist
  (setq anki-editor-create-decks t)
  
  ;; Default deck and note type
  (setq anki-editor-default-deck "My Default Deck")
  (setq anki-editor-default-note-type "Basic")
  
  ;; Set up keybindings
  (map! :map org-mode-map
        "C-c a n" #'anki-editor-insert-note
        "C-c a p" #'anki-editor-push-notes
        "C-c a c" #'anki-editor-cloze-dwim
        "C-c a d" #'anki-editor-delete-notes))

;; =============================================================================
;; PROTOCOL NUMBER GENERATION
;; =============================================================================

;; Global variable for protocol numbers
(defvar protocol-last-number 0 "The last protocol number used.")

(defun my-protocol-get-timestamp ()
  "Get the current timestamp in a specific format."
  (format-time-string "%Y%m%d-%H%M%S"))

(defun generate-protocol-number-with-timestamp (prefix)
  "Generates a protocol number with the given prefix and timestamp."
  (let* ((timestamp (my-protocol-get-timestamp))
         (new-number (1+ protocol-last-number))
         (formatted-number (format "%05d" new-number))
         (protocol-number (concat prefix timestamp "-" formatted-number)))
    (setq protocol-last-number new-number)
    protocol-number))

(defun insert-protocol-number-with-prefix-and-timestamp (prefix)
  "Inserts a protocol number with the given prefix and timestamp at the cursor."
  (interactive "sEnter prefix: ")
  (let ((protocol-number (generate-protocol-number-with-timestamp prefix)))
    (insert protocol-number)))

;; Key binding for protocol number generation
(map! "C-c a p n" #'insert-protocol-number-with-prefix-and-timestamp)

;; =============================================================================
;; KEYBINDINGS
;; =============================================================================

;; Org-roam keybindings
(map! :leader
      :desc "Org-roam node find" "n r f" #'org-roam-node-find)

;; =============================================================================
;; RSS FEED CONFIGURATION (Optional - uncomment if needed)
;; =============================================================================

;; (after! elfeed
;;   (setq elfeed-feeds
;;         '(
;;           "https://theregister.com/headlines.atom"
;;           "https://www.iptechblog.com/category/europe/feed/"
;;           "https://www.techcentral.ie/feed/"
;;           "ipwatchdog.com/feed" :title "Ip watchdog"
;;           "patentlyo.com/feed"
;;           "https://feeds.feedburner.com/theipkat"
;;           "https://www.managingip.com/rssfeeds/ip-strategy"
;;           "https://www.managingip.com/rssfeeds/patents"
;;           "https://www.managingip.com/rssfeeds/copyright"
;;           "https://www.managingip.com/rssfeeds/trademarks"
;;           "https://www.iprights.it/feed/"
;;           "https://pluralistic.net/feed/"
;;           "https://www.wipo.int/pct/en/newslett/rss.xml"
;;           "https://www.wipo.int/econ_stat/en/economics/rss.xml"
;;           "https://www.wipo.int/patentscope/en/news/pctdb/rss.xml"
;;           "https://www.wipo.int/wipo_magazine/en/rss"
;;           "https://www.wipo.int/news/en/wipolex/rss.xml"
;;           "https://wipo.taleo.net/careersection/feed/joblist.rss?lang=en&portal=101430233&searchtype=3&f=null&s=2|A&a=null&multiline=true")
;;         )
;;   
;;   ;; Update interval (in seconds)
;;   (setq elfeed-update-interval 3600)
;;   
;;   ;; Directory where elfeed stores its data
;;   (setq elfeed-db-directory "~/.elfeed.db")
;;   
;;   ;; Automatically update feeds on startup
;;   (add-hook 'after-init-hook 'elfeed-update)
;;   
;;   ;; Keybinding to open the elfeed dashboard
;;   (map! "C-x g" #'elfeed))

;; =============================================================================
;; COPILOT CONFIGURATION (Optional - uncomment if needed)
;; =============================================================================

;; (after! copilot
;;   :hook (prog-mode . copilot-mode)
;;   :bind (("C-c c a" . copilot-accept-completion)
;;          ("C-c c p" . copilot-previous-completion)
;;          ("C-c c n" . copilot-next-completion)
;;          ("C-c c c" . copilot-chat)
;;          ("C-c c s" . copilot-accept-completion-by-word)
;;          ("C-c c d" . copilot-accept-completion-by-line)))


;; =============================================================================
;; PATENT WORKFLOW HELPERS
;; =============================================================================

;; Load patent elisp helpers (supports multiple patent projects)
(defvar patent-helpers-paths
  '("~/kDrive/1_Projects/Geoloom_e703c540/Agro-fiscal-oracle-llm/patent-application/patent_elisp_helpers.el"
    "~/kDrive/1_Projects/MLR_patent_a234aa45/3_Scripts/patent_elisp_helpers.el")
  "List of patent helper files to try loading.")

(dolist (path patent-helpers-paths)
  (when (file-exists-p (expand-file-name path))
    (load-file (expand-file-name path))))

;; Key bindings for patent workflow (C-c p prefix)
(map! :map org-mode-map
      "C-c p r" #'my/patent-check-refs
      "C-c p m" #'my/insert-ref-macro
      "C-c p n" #'my/insert-refnum-macro
      "C-c p e" #'my/export-to-quarto-markdown
      "C-c p l" #'my/list-all-refs
      "C-c p v" #'my/patent-check-missing-refs)

;; Enable org-babel for elisp and python
(after! org
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t))))

;; =============================================================================
;; ORG-MODE ENHANCEMENTS
;; =============================================================================

;; Better table editing
(setq org-table-auto-recalculate t)

;; Auto-save frequently
(setq auto-save-interval 60)

;; Show line numbers in org files
(add-hook 'org-mode-hook (lambda () (display-line-numbers-mode 1)))

;; Word wrap for long lines
(add-hook 'org-mode-hook 'visual-line-mode)

(use-package pdf-tools
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-tools-install)
  (setq-default pdf-view-display-size 'fit-width)
  (setq pdf-annot-activate-created-annotations t)
  :bind (:map pdf-view-mode-map
              ("C-s" . isearch-forward)))

(setq org-refile-targets '((org-agenda-files :maxlevel . 3)))

(setq org-refile-use-outline-path 'file)

;; Configurazione per far trovare a LSP l'ambiente creato da uv
(after! lsp-python-ms
  (setq lsp-python-ms-executable "pyright"))

;; Se usi Emacs 29+ e preferisci Eglot invece di lsp-mode
;; (setq lsp-executor-python-interpreter "python3")

(use-package! easy-chezmoi
  :bind ("C-c c z" . easy-chezmoi))
