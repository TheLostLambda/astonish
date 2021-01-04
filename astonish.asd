(defsystem "astonish"
  :version "0.1.0"
  :author "Brooks J Rady <b.j.rady@gmail.com>"
  :license "GPLv3"
  :depends-on ("uiop" "alexandria")
  :components ((:module "src"
                :components
                ((:file "main"))))
  :description "A small library for querying and manipulating Lisp ASTs"
  :in-order-to ((test-op (test-op "astonish/tests"))))

(defsystem "astonish/tests"
  :author "Brooks J Rady <b.j.rady@gmail.com>"
  :license "GPLv3"
  :depends-on ("astonish"
               "rove")
  :components ((:module "tests"
                :components
                ((:file "main"))))
  :description "Test system for astonish"
  :perform (test-op (op c) (symbol-call :rove :run c)))
