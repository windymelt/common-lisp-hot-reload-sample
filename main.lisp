(in-package :cl-user)
(defpackage hot-reload-sample
  (:use :cl)
  (:export :main))
(in-package :hot-reload-sample)

(defun main (&rest argv)
  (declare (ignorable argv))
  (clack:clackup
   (lambda (env)
     (declare (ignorable env))
     '(200 (:content-type "text/plain") ("Hello, Clack!"))))
  (format t "Press enter key to exit...~%")
  (read-line nil nil))
