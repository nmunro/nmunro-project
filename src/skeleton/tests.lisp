(defpackage {{project-name}}/tests/main
  (:use :cl
        :{{project-name}}
        :rove))
(in-package :{{project-name}}/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :{{project-name}})' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
  (format t "Testing~%")
    (ok (= 1 1))))