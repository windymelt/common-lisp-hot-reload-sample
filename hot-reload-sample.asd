(in-package :cl-user)
(defpackage hot-reload-sample-asd
  (:use :cl :asdf))
(in-package :hot-reload-sample-asd)

(defsystem hot-reload-sample
  :version "0.1"
  :author "Windymelt"
  :depends-on (:clack :cffi)
  :components ((:file "main"))
  :description "This is a sample for hot reload.")
