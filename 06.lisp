;;; Advent Of Code 2021 - Day 6 - Anthony Green <green@moxielogic.com>

(flet ((model-fish-population (days)
         (let ((ages (make-array 9)))
           (dolist (age-string (uiop:split-string (car (uiop:read-file-lines "06.input")) :separator ","))
             (incf (aref ages (parse-integer age-string))))
           (dotimes (day days)
             (incf (aref ages 7) (aref ages 0))
             (rotatef (aref ages 0) (aref ages 1) (aref ages 2) (aref ages 3) (aref ages 4) (aref ages 5) (aref ages 6) (aref ages 7) (aref ages 8)))
           (reduce #'+ ages))))
  (print (model-fish-population 80))
  (print (model-fish-population 256)))
