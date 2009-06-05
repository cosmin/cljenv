(autoload 'cljenv-init "cljenv" "Initialize CLJENV")

(cljenv-init)
(require 'slime)
(slime-setup '(slime-repl))

(provide 'cljenv-autoload)
