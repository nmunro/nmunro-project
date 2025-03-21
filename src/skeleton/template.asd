(defsystem "{{project-name}}"
  :version "{{project-version}}"
  :author "{{project-author}}"
  :license "{{project-license}}"
  :description "{{project-description}}"
  :depends-on ()
  :components ((:module "src"
                :components
                ((:file "main"))))
  :in-order-to ((test-op (test-op "{{project-name}}/tests"))))

(defsystem "{{project-name}}/tests"
  :author "{{project-author}}"
  :license "{{project-license}}"
  :depends-on ("{{project-name}}"
               :rove)
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for {{project-name}}"
  :perform (test-op (op c) (symbol-call :rove :run c)))
