;;; Advent Of Code 2021 - Day 3 - Anthony Green <green@moxielogic.com>

(ql:quickload :fset)

(let ((bags (make-array 12 :initial-element (fset:empty-bag))))
  (dolist (line (uiop:read-file-lines "03.input"))
    (loop for i from 0 to 11
          do (setf (aref bags i)
                   (fset:with (aref bags i) (aref line i)))))
  (loop with n = 0 for bag across bags
        do (setf n
                 (+ (* n 2)
                    (if (> (fset:multiplicity bag #\1)
                           (fset:multiplicity bag #\0)) 1 0)))
        finally (print (* n (logxor 4095 n)))))

(flet ((find-value (a b)
         (loop for i from 0 to 11
               with set = (fset:convert 'fset:set (uiop:read-file-lines "03.input"))
               do (let ((bag (fset:empty-bag)))
                    (fset:do-set (line set)
                      (setf bag (fset:with bag (aref line i))))
                    (let ((most-freq
                            (if (> (fset:multiplicity bag #\0)
                                   (fset:multiplicity bag #\1)) a b)))
                      (setf set
                            (fset:filter (lambda (x) (equal (aref x i) most-freq))
                                         set))))
               until (equal (fset:size set) 1)
               finally (return (parse-integer (fset:arb set) :radix 2)))))
  (print (* (find-value #\0 #\1) (find-value #\1 #\0))))
