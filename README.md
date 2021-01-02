# Astonish

A Common Lisp library for querying and manipulating Lisp ASTs

## Tasks

select-conses should take a fancy query string that supports OR operations,
filtering on cadr, caddr, etc, and should also work on atoms. Maybe something
like this: "test . code-of-conduct > is-true, is-false", run on this:

(TEST CODE-OF-CONDUCT "Is the given action unsuitable for the given pet?"
  (IS-FALSE (PET "Cat")) (IS-FALSE (PET "Dog")) (IS-TRUE (PET "Fish"))
  (IS-FALSE (PET "Rabbit")) (IS-FALSE (PET "Bird"))
  (IS-TRUE (PLAY-FETCH "Cat")) (IS-FALSE (PLAY-FETCH "Dog"))
  (IS-TRUE (PLAY-FETCH "Fish")) (IS-TRUE (PLAY-FETCH "Rabbit"))
  (IS-TRUE (PLAY-FETCH "Bird"))))

Should give:

(IS-FALSE (PET "Cat")) (IS-FALSE (PET "Dog")) (IS-TRUE (PET "Fish"))
(IS-FALSE (PET "Rabbit")) (IS-FALSE (PET "Bird"))
(IS-TRUE (PLAY-FETCH "Cat")) (IS-FALSE (PLAY-FETCH "Dog"))
(IS-TRUE (PLAY-FETCH "Fish")) (IS-TRUE (PLAY-FETCH "Rabbit"))
(IS-TRUE (PLAY-FETCH "Bird"))))

## Usage

TODO

## Installation

TODO
