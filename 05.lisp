(ql:quickload :parseq)

(defvar *diagonal*)
(parseq:defrule num () (rep (1 3) digit) (:string) (:function #'parse-integer))
(parseq:defrule line () (and num "," num " -> " num "," num)
  (:lambda (x1 i1 y1 i2 x2 i3 y2)
    (if (or *diagonal* (equal x1 x2) (equal y1 y2)) (cons (cons x1 y1) (cons x2 y2)) nil)))

(flet ((danger-count (diagonal)
         (setf *diagonal* diagonal)
         (let ((board (make-array '(1000 1000))))
           (dolist (line (remove nil (mapcar (lambda (input) (parseq:parseq 'line input))
                                             (uiop:read-file-lines "05.input"))))
             (destructuring-bind ((x1 . y1) x2 . y2) line
               (let* ((length (max (abs (- x1 x2)) (abs (- y1 y2))))
                      (x (floor (- x2 x1) length))
                      (y (floor (- y2 y1) length)))
                 (loop for p from 0 upto length
                       do (incf (aref board (+ x1 (* p x)) (+ y1 (* p y))))))))
           (count t (make-array 1000000 :displaced-to board)
                  :test (lambda (x v) (< 1 v))))))
  (print (danger-count nil))
  (print (danger-count t)))
