(defpackage astonish
  (:use :cl)
  (:export :load-forms-from-file :select-conses :macroexpand-select))
(in-package :astonish)

;;; Public Functions -----------------------------------------------------------

(defun load-forms-from-file (file)
  "Read forms from a lisp file without any evaluation"
  (let ((current-package *package*))
    (uiop:with-safe-io-syntax (:package current-package)
      (uiop:read-file-forms file))))

(defun select-conses (path forms)
  "Given a path (a list of car's) and list of forms, return all matching conses"
  (destructuring-bind (x &rest xs) path
    (let ((selected (filter-conses-by-car x forms)))
      (if (null xs)
          selected
          (select-forms xs (apply #'append selected))))))

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
