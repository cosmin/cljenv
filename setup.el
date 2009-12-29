(set-language-environment "UTF-8")

(setq home-directory (getenv "HOME"))
(setq cljenv-root (getenv "CLJENV_ROOT"))
(setq cljenv-emacs (concat cljenv-emacs "/emacs/"))

(add-to-list 'load-path cljenv-emacs)
(add-to-list 'load-path (concat cljenv-emacs "slime/"))

(require 'cljenv-autoload)
(setq slime-net-coding-system 'utf-8-unix)
