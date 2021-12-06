;;; Advent Of Code 2021 - Day 6 - Anthony Green <green@moxielogic.com>

(flet ((model-fish-population (days)
         (let ((ages (make-array 9)))
           (dolist (age-string (uiop:split-string (car (uiop:read-file-lines "06.input")) :separator ","))
             (incf (aref ages (parse-integer age-string))))
           (dotimes (day days)
             (incf (aref ages (mod (+ day 7) 9)) (aref ages (mod day 9))))
           (reduce #'+ ages))))
  (print (model-fish-population 80))
  (print (model-fish-population 256)))
