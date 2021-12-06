;;; Advent Of Code 2021 - Day 6 - Anthony Green <green@moxielogic.com>

(flet ((model-fish-population (days)
         (let* ((fish-ages (mapcar #'parse-integer (uiop:split-string (car (uiop:read-file-lines "06.input")) :separator ","))))
           (loop for day from 1 upto days
                 do (let ((new-fish (list)))
                      (setf fish-ages
                            (append (mapcar
                                     (lambda (fish-age)
                                       (if (eq fish-age 0)
                                           (progn
                                             (push 8 new-fish)
                                             6)
                                         (- fish-age 1)))
                                     fish-ages)
                                    new-fish)))
                 finally (return (length fish-ages))))))
  (print (model-fish-population 80)))

(let* ((fish-ages (make-array 9)))
  (mapcar (lambda (age-string)
            (incf (aref fish-ages (parse-integer age-string))))
          (uiop:split-string (car (uiop:read-file-lines "06.input")) :separator ","))
  (loop for day from 1 upto 256
        do (let ((a8 (aref fish-ages 0))
                 (a0 (aref fish-ages 1))
                 (a1 (aref fish-ages 2))
                 (a2 (aref fish-ages 3))
                 (a3 (aref fish-ages 4))
                 (a4 (aref fish-ages 5))
                 (a5 (aref fish-ages 6))
                 (a6 (+ (aref fish-ages 0) (aref fish-ages 7)))
                 (a7 (aref fish-ages 8)))
             (setf (aref fish-ages 0) a0)
             (setf (aref fish-ages 1) a1)
             (setf (aref fish-ages 2) a2)
             (setf (aref fish-ages 3) a3)
             (setf (aref fish-ages 4) a4)
             (setf (aref fish-ages 5) a5)
             (setf (aref fish-ages 6) a6)
             (setf (aref fish-ages 7) a7)
             (setf (aref fish-ages 8) a8))
        finally (print (loop for i from 0 to 8 sum (aref fish-ages i)))))
