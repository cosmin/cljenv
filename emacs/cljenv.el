(eval-and-compile
  (defvar cljenv-emacs-path
    (let ((path (file-truename (or (locate-library "cljenv")
                                   load-file-name))))
      (and path (file-name-directory path)))))


(defun cljenv-init ()
  (add-to-list 'load-path (concat cljenv-emacs-path "swank-clojure/src/emacs/"))
  (add-to-list 'load-path (concat cljenv-emacs-path "clojure-mode/"))

  (if (getenv "CLJENV_HOME")
      (progn
        (add-to-list 'load-path (concat shared-profile-elisp "swank-clojure/"))
        (add-to-list 'load-path (concat shared-profile-elisp "clojure-mode/"))
        
        (setq swank-clojure-binary "clj")
        
        (require 'clojure-mode)
        (require 'swank-clojure-autoload)        
        )))
  
(provide 'cljenv)
