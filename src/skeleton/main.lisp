(defpackage {{project-name}}
  (:use :cl)
  (:export #:main))

(in-package {{project-name}})

(defun main ()
  (format t "Hello world!~%"))