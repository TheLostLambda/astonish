(defpackage astonish/tests/main
  (:use :cl
        :astonish
        :rove))
(in-package :astonish/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :astonish)' in your Lisp.

(deftest test-target-1
  (testing "should (= 1 1) to be true"
    (ok (= 1 1))))
