(defsystem "nmunro-project"
  :version "0.0.1"
  :author "NMunro"
  :license "BSD-3-Clause"
  :depends-on ("djula"
               "prove")
  :components ((:module "src"
                :components
                ((:file "nmunro-project"))))
  :description "Generate a skeleton for modern project"
  :in-order-to ((test-op (test-op "nmunro-project-test"))))
