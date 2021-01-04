(defpackage astonish/tests/main
  (:use :cl
        :astonish
        :rove))
(in-package :astonish/tests/main)

;; NOTE: To run this test file, execute `(asdf:test-system :astonish)' in your Lisp.

(deftest load-forms-from-file-test
  (testing "should be 10 top-level forms"
    (ok (= 10 (length (load-forms-from-file #P"tests/data/pal-picker-test"))))))

(deftest select-conses-test
  (let ((all-forms (load-forms-from-file #P"tests/data/pal-picker-test" #.*package*)))
    (testing "should work for nested forms"
      (ok (equal '((PLAY-FETCH "Cat") (PLAY-FETCH "Fish")
                   (PLAY-FETCH "Rabbit")(PLAY-FETCH "Bird"))
                 (select-conses '(test is-true play-fetch) all-forms)))
      (ok (equal '((PET "Fish"))
                 (nth-value 1 (select-conses '(test is-true play-fetch) all-forms)))))))

(deftest macroexpand-select-test
  (defmacro three (x) `(,x ,x ,x))
  (defmacro rev (&body body) (reverse body))
  (let ((test-form     '(defun wacky-stuff (maybe?)
                          (if maybe? (loop :repeat 10 :collect '(three "cats"))
                                     (rev '(1 2 3) cadr))))
        (expected-form '(defun wacky-stuff (maybe?)
                          (if maybe? (loop :repeat 10 :collect '("cats" "cats" "cats"))
                                     (cadr '(1 2 3))))))
    (testing "expands some, not all, macros"
      (ok (equal expected-form (macroexpand-select '(three rev) test-form))))))
