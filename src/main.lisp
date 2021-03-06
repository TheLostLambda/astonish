(defpackage astonish
  (:use :cl :alexandria)
  (:export :load-forms-from-file :select-conses :macroexpand-select))
(in-package :astonish)

;;; Public Functions -----------------------------------------------------------

;; FIXME: Read things like defpackage and load first, run them, switch package,
;; then read the rest of the file. This way symbols can always be found by the
;; reader and are read into the correct packages
(defun load-forms-from-file (file &optional package)
  "Read forms from a lisp file without any evaluation"
  (let ((current-package (or package *package*)))
    (uiop:with-safe-io-syntax (:package current-package)
      (uiop:read-file-forms (lisp-file file)))))

(defun select-conses (path forms)
  "Given a path (a list of car's) and list of forms, return all matching conses.
   The second return value is the same selection, but inverted"
  (destructuring-bind (x &rest xs) path
    (let ((selected (filter-conses-by-car x forms)))
      (if (null xs)
          (values selected (cons-difference forms selected))
          (select-conses xs (apply #'append selected))))))

(defun macroexpand-select (macros form)
  "Recursively expand all occurrences of select macros"
  (map-inodes (lambda (n) (if (find (car n) macros) (macroexpand n) n)) form))

;;; Private Helper Functions ---------------------------------------------------

(defun filter-conses-by-car (car forms)
  "Filter forms so that only ones with the specified car remain"
  (remove-if-not (lambda (x) (and (listp x) (string= car (car x)))) forms))

(defun map-inodes (function form)
  "Maps the given function over all the inner nodes of a tree"
  (if (proper-list-p form)
      (funcall function (mapcar (lambda (n) (map-inodes function n)) form))
      form))

(defun cons-difference (a b)
  "Like set-difference, but filters for conses and preserves order"
  (remove-if (lambda (x) (or (find x b) (atom x))) a))

(defun lisp-file (file)
  "Adds a .lisp extension to pathnames without an extension"
  (if (pathname-type file)
      file
      (make-pathname :type "lisp" :defaults file)))
