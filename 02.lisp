;;; Advent Of Code 2021 - Day 2 - Anthony Green <green@moxielogic.com>

(ql:quickload :parseq)

(parseq:defrule up () "up" (:constant '(0 -1)))
(parseq:defrule down () "down" (:constant '(0 1)))
(parseq:defrule forward () "forward" (:constant '(1 0)))
(parseq:defrule value () (rep (0 10) digit) (:string) (:function #'parse-integer))
(parseq:defrule move () (and (or up down forward) " " value) (:lambda (m i s) (mapcar (lambda (v) (* v s)) m)))

(print (reduce #'* (reduce (lambda (x y) (mapcar #'+ x y))
                           (mapcar (lambda (line) (parseq:parseq 'move line))
                                   (uiop:read-file-lines "02.input")))))

(print (let ((x 0) (y 0) (aim 0))
         (mapc (lambda (line)
                 (let ((movement (parseq:parseq 'move line)))
                   (setf aim (+ aim (cadr movement)))
                   (setf x (+ x (car movement)))
                   (setf y (+ y (* aim (car movement))))))
               (uiop:read-file-lines "02.input"))
         (* x y)))
