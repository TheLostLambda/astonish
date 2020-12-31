(defsystem "astonish"
  :version "0.1.0"
  :author ""
  :license ""
  :depends-on ("uiop" "alexandria")
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description ""
  :in-order-to ((test-op (test-op "astonish/tests"))))

(defsystem "astonish/tests"
  :author ""
  :license ""
  :depends-on ("astonish"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for astonish"
  :perform (test-op (op c) (symbol-call :rove :run c)))
