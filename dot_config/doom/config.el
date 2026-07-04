;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Avoid GdkPixbuf "xpm not supported" warning (if system has no XPM loader)
(setq image-types (delq 'xpm image-types))

;; =============================================================================
;; PERSONAL INFORMATION & THEME
;; =============================================================================
(setq doom-theme 'doom-one)

;; Enable line numbers (t = normal, relative = relative)
(setq display-line-numbers-type t)

;; Set org directory globally (Required before Org loads)
(setq org-directory "~/kDrive/2_Areas/org/")

;; =============================================================================
;; ORG-MODE CONFIGURATION
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
          :stepskip0 t :fileskip0 t :link t))

  ;; --- Refile Targets (Consolidated & Protected) ---
  (setq org-refile-targets '((org-agenda-files :maxlevel . 3)))
  (setq org-refile-use-outline-path 'file)

  ;; --- Standard Org-Capture Templates (SPC X) ---
  ;; Preserves Doom default templates and appends your custom ones
  (setq org-capture-templates
        (append org-capture-templates
                '(;; 1. Aneddoto Biografico
                  ("a" "Aneddoto Biografico" entry
                   (file "/home/ago/kDrive/2_Areas/org/roam_notes/20241225T070044--aneddoti.org")
                   "* %^{Titolo Aneddoto} :aneddoto:status-inbox:\n:PROPERTIES:\n:CREATED:  %U\n:END:\n\n%?\n"
                   :jump-to-captured t
                   :after-finalize (lambda () (org-id-get-create)))

                  ;; 2. Weekly Review (Inserts under 'Weekly Reviews' headline in reviews.org)
                  ("w" "Weekly Review" entry
                   (file+headline "~/kDrive/2_Areas/org/reviews.org" "Weekly Reviews")
                   "* Weekly Review: %<%Y-%m-%d %a>\n** Energy Audit\nWhat gave me energy this week?\n- %?\n\nWhat drained my energy this week?\n- \n\n** Actionable Insights\nWhat is the one change I can make to do more of what gave me energy and less of what drained it?\n- \n\n** Metrics & Trends\n- Weekly Energy Score (1-5): \n- \"Change\" Implementation Rate (Last Week's Change): [ ] Yes / [ ] No\n- Focus Ratio (from Time Tracking): \n- Key Result Progress (from OKRs/Project Management): \n\n** Qualitative Reflection (Monthly - review last 4 weeks)\nRecurring themes in energy-giving activities:\n- \n\n** Recurring themes in energy-draining activities:\n- "
                   :jump-to-captured t))))

  ;; --- Enable org-babel languages ---
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t)
     (python . t)))

  ;; --- General Enhancements ---
  (setq org-table-auto-recalculate t)
  (setq auto-save-interval 60)
  (add-hook 'org-mode-hook (lambda () (display-line-numbers-mode 1)))
  (add-hook 'org-mode-hook 'visual-line-mode))

;; =============================================================================
;; ORG-ROAM CONFIGURATION
;; =============================================================================
(after! org-roam
  ;; Set org-roam directory
  (setq org-roam-directory (expand-file-name "~/kDrive/2_Areas/org/roam_notes/"))

  ;; Enable automatic database sync (Safe deferred load)
  (org-roam-db-autosync-mode)

  ;; Configure org-roam capture templates (Dynamic notes only)
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
                     )")
           :unnarrowed t))))

;; =============================================================================
;; ORG-ROAM-UI CONFIGURATION
;; =============================================================================
(after! org-roam-ui
  (org-roam-ui-mode +1) 
  (setq org-roam-ui-follow t)
  (setq org-roam-ui-update-on-save t))

;; =============================================================================
;; ORG-AGENDA CONFIGURATION
;; =============================================================================
(after! org
  ;; Add timetrack.org to agenda files
  (add-to-list 'org-agenda-files (expand-file-name "timetrack.org" org-directory))

  ;; Custom Agenda Views
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
             ((org-agenda-overriding-header "Waiting For..."))))
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
              (org-agenda-sorting-strategy '(effort-up priority-down)))))
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
                   (org-agenda-sorting-strategy '(scheduled-up)))))))))

;; =============================================================================
;; OX-HUGO CONFIGURATION
;; =============================================================================
(after! ox-hugo
  ;; Set the Hugo site directory
  (setq org-hugo-base-dir (expand-file-name "~/kDrive/1_Projects/notes_agostinodeangelis_da15e11b/"))
  (setq org-hugo-section "posts")
  (setq org-hugo-use-code-for-kbd t)
  (setq org-hugo-prefer-hugo-bindings t)
  (setq org-hugo-export-with-toc nil)
  (setq org-hugo-export-with-section-numbers nil)
  (setq org-hugo-front-matter-format 'yaml))

;; =============================================================================
;; OX-REVEAL CONFIGURATION
;; =============================================================================
(after! ox-reveal
  (setq org-reveal-root "file:///.config/doom/reveal.js"))

;; =============================================================================
;; CLOCK QUICK KEYBINDINGS
;; =============================================================================
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
;; ANKI-EDITOR CONFIGURATION
;; =============================================================================
(after! anki-editor
  (setq anki-editor-create-decks t)
  (setq anki-editor-default-deck "My Default Deck")
  (setq anki-editor-default-note-type "Basic")
  
  (map! :map org-mode-map
        "C-c a n" #'anki-editor-insert-note
        "C-c a p" #'anki-editor-push-notes
        "C-c a c" #'anki-editor-cloze-dwim
        "C-c a d" #'anki-editor-delete-notes))

;; =============================================================================
;; PROTOCOL NUMBER GENERATION
;; =============================================================================
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
;; (Optional - default SPC n r f is built-in, but preserved here)
(map! :leader
      :desc "Org-roam node find" "n r f" #'org-roam-node-find)

;; =============================================================================
;; PATENT WORKFLOW HELPERS
;; =============================================================================
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

;; =============================================================================
;; ADDITIONAL PACKAGES & TOOLS
;; =============================================================================

;; PDF Tools - Optimized Doom standard
(use-package! pdf-tools
  :magic ("%PDF" . pdf-view-mode)
  :config
  (pdf-tools-install)
  (setq-default pdf-view-display-size 'fit-width)
  (setq pdf-annot-activate-created-annotations t)
  :bind (:map pdf-view-mode-map
              ("C-s" . isearch-forward)))

;; Python Environment Integration
(after! lsp-python-ms
  (setq lsp-python-ms-executable "pyright"))

;; Chezmoi Configuration
(use-package! chezmoi
  :bind ("C-c c z" . chezmoi-find))

;; Security Settings (auth-source)
(setq auth-sources '("~/.authinfo.gpg"))

;; Readwise to Org-Roam Sync (Safe Deferred Key Fetching)
(use-package! org-roam-readwise
  :config
  (setq org-roam-readwise-directory "readwise")
  ;; Deferred API key search so it doesn't freeze or prompt on start
  (setq org-roam-readwise-api-token
        (let ((source (auth-source-search :host "readwise.io" :user "apikey")))
          (if source
              (let ((secret (plist-get (car source) :secret)))
                (if (functionp secret)
                    (funcall secret)
                  secret))
            (message "Errore: credenziali Readwise non trovate in auth-source!")))))

;; =============================================================================
;; DOOM DASHBOARD WARNING MITIGATION
;; =============================================================================
;; Suppress org-element warnings in the Doom dashboard buffer to prevent
;; warnings when saving org-roam files or triggering hooks from the dashboard.
(add-hook '+doom-dashboard-mode-hook
          (lambda ()
            (setq-local warning-suppress-types '(org-element))))

