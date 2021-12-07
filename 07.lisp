;;; Advent Of Code 2021 - Day 7 - Anthony Green <green@moxielogic.com>

(let* ((input (sort (mapcar #'parse-integer (uiop:split-string (car (uiop:read-file-lines "07.input")) :separator ",")) #'<))
       (median (nth (floor (length input) 2) input)))
  (reduce #'+ (mapcar (lambda (p) (abs (- median p))) input)))

(let* ((input (mapcar #'parse-integer (uiop:split-string (car (uiop:read-file-lines "07.input")) :separator ",")))
       (avg (floor (reduce #'+ input) (length input))))
  (reduce #'+ (mapcar (lambda (p)
                        (let ((dist (abs (- avg p))))
                          (ceiling (+ (* dist dist) dist) 2)))
                      input)))
