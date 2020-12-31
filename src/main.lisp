(defpackage astonish
  (:use :cl)
  (:export :load-forms-from-file :select-conses :macroexpand-select))
(in-package :astonish)

;;; Public Functions -----------------------------------------------------------

(defun load-forms-from-file (file &optional package)
  "Read forms from a lisp file without any evaluation"
  (let ((current-package (or package *package*)))
    (uiop:with-safe-io-syntax (:package current-package)
      (uiop:read-file-forms file))))

;; FIXME: This should take a fancy query string that supports OR operations,
;; filtering on cadr, caddr, etc, and should also work on atoms. Maybe something
;; like this: "test . code-of-conduct > is-true, is-false", run on this:
;;
;; (TEST CODE-OF-CONDUCT "Is the given action unsuitable for the given pet?"
;;   (IS-FALSE (PET "Cat")) (IS-FALSE (PET "Dog")) (IS-TRUE (PET "Fish"))
;;   (IS-FALSE (PET "Rabbit")) (IS-FALSE (PET "Bird"))
;;   (IS-TRUE (PLAY-FETCH "Cat")) (IS-FALSE (PLAY-FETCH "Dog"))
;;   (IS-TRUE (PLAY-FETCH "Fish")) (IS-TRUE (PLAY-FETCH "Rabbit"))
;;   (IS-TRUE (PLAY-FETCH "Bird"))))
;;
;; Should give:
;;
;; (IS-FALSE (PET "Cat")) (IS-FALSE (PET "Dog")) (IS-TRUE (PET "Fish"))
;; (IS-FALSE (PET "Rabbit")) (IS-FALSE (PET "Bird"))
;; (IS-TRUE (PLAY-FETCH "Cat")) (IS-FALSE (PLAY-FETCH "Dog"))
;; (IS-TRUE (PLAY-FETCH "Fish")) (IS-TRUE (PLAY-FETCH "Rabbit"))
;; (IS-TRUE (PLAY-FETCH "Bird"))))
(defun select-conses (path forms)
  "Given a path (a list of car's) and list of forms, return all matching conses"
  (destructuring-bind (x &rest xs) path
    (let ((selected (filter-conses-by-car x forms)))
      (if (null xs)
          selected
          (select-conses xs (apply #'append selected))))))

(defun macroexpand-select (macros form)
  "Recursively expand all occurrences of select macros"
  (map-inodes (lambda (n) (if (find (car n) macros) (macroexpand n) n)) form))

;;; Private Helper Functions ---------------------------------------------------

(defun filter-conses-by-car (car forms)
  "Filter forms so that only ones with the specified car remain"
  (remove-if-not (lambda (x) (and (listp x) (eq car (car x)))) forms))

(defun map-inodes (function form)
  "Maps the given function over all the inner nodes of a tree"
  (if (listp form)
      (funcall function (mapcar (lambda (n) (map-inodes function n)) form))
      form))
