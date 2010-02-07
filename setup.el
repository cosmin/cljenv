(set-language-environment "UTF-8")

(setq home-directory (getenv "HOME"))
(setq cljenv-home (getenv "CLJENV_HOME"))
(setq cljenv-emacs (concat cljenv-home "/emacs/"))

(add-to-list 'load-path cljenv-emacs)
(add-to-list 'load-path (concat cljenv-emacs "slime/"))

(require 'cljenv-autoload)
(setq slime-net-coding-system 'utf-8-unix)
