;;; Advent Of Code 2021 - Day 17 - Anthony Green <green@moxielogic.com>

(ql:quickload :cl-ppcre)

(let ((target-text (car (uiop:read-file-lines "17.input"))))
  (flet ((launch-probe (vx vy min-x max-x min-y max-y)
           (loop
             with x = 0 with y = 0
             until (or (and (<= min-x x max-x) (<= min-y y max-y))
                       (or (> x max-x) (< y min-y)))
             do (progn
                  (incf x vx)
                  (incf y vy)
                  (when (> vx 0) (decf vx))
                  (decf vy))
             finally (return (if (and (<= min-x x max-x) (<= min-y y max-y)) 1 0)))))
    (cl-ppcre:register-groups-bind ((#'parse-integer min-x max-x min-y max-y))
        ("target area: x=(.+)\\\.\\\.(.+), y=(.+)\\\.\\\.(.+)$" target-text)
      (print (floor (* min-y (+ 1 min-y)) 2))
      (print (loop for vx from 0 upto 1000
                   sum (loop for vy from -1000 upto 1000
                             sum (launch-probe vx vy min-x max-x min-y max-y)))))))
