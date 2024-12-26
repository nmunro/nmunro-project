(defsystem "nmunro-project"
  :version "1.0.0"
  :author "NMunro"
  :license "BSD-3-Clause"
  :depends-on (:djula
               :rove)
  :components ((:module "src"
                :components
                ((:file "nmunro-project"))))
  :description "Generate a skeleton for modern project"
  :in-order-to ((test-op (test-op "nmunro-project-test"))))
