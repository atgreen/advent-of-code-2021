;;; Advent Of Code 2021 - Day 4 - Anthony Green <green@moxielogic.com>

(ql:quickload :split-sequence)
(ql:quickload :str)

;;; These are not pretty, but they work

(let* ((input (uiop:read-file-lines "~/git/advent-of-code-2021/04.input"))
       (boards (mapcar #'parse-integer
                       (remove "" (split-sequence:split-sequence
                                   #\Space
                                   (reduce (lambda (a b) (str:concat a " " b))
                                           (cdr input)))
                               :test #'string=))))
  (block star-1
    (labels ((winning-row? (i)
               (format t "winning-row? ~A~%" i)
               (equal -5 (reduce #'+ (subseq boards i (+ i 5)))))
             (winning-column? (i)
               (equal -5 (loop for x from i upto (+ i 20) by 5 sum (nth x boards))))
             (winning-board? (i)
               (format t "Checking board ~A~%" i)
               (or (loop for x from i upto (+ i 15) by 5 until (winning-row? x) finally (return (winning-row? x)))
                   (loop for x from 0 upto 4 by 1 until (winning-column? x) finally (return (winning-column? x))))))
      (dolist (num (mapcar #'parse-integer (split-sequence:split-sequence #\, (car input))))
        (format t "~A~%" num)
        (loop for i from 0 to (- (length boards) 1)
              when (equal (nth i boards) num)
                do (progn
                     (setf (nth i boards) -1)
                     (format t "i = ~A~%" i)
                     (let ((b (* (floor i 25) 25)))
                       (when (winning-board? b)
                         (format t "WINNER ~A ~A" b
                                 (* num
                                    (loop for i from b upto (+ b 24)
                                          sum (if (< (nth i boards) 0) 0 (nth i boards)))))
                         (pprint boards)
                         (return-from star-1)))))))))


(let* ((input (uiop:read-file-lines "~/git/advent-of-code-2021/04.input"))
       (boards (mapcar #'parse-integer
                       (remove "" (split-sequence:split-sequence
                                   #\Space
                                   (reduce (lambda (a b) (str:concat a " " b))
                                           (cdr input)))
                               :test #'string=)))
       (num-boards (floor (length boards) 25)))
  (block star-1
    (labels ((winning-row? (i)
               (> (+ (nth i boards) (nth (+ i 1) boards) (nth (+ i 2) boards) (nth (+ i 3) boards) (nth (+ i 4) boards)) 15000))
             (winning-column? (i)
               (> (+ (nth i boards) (nth (+ i 5) boards) (nth (+ i 10) boards) (nth (+ i 15) boards) (nth (+ i 20) boards)) 15000))
             (winning-board? (i)
               (or (winning-row? i) (winning-row? (+ i 5)) (winning-row? (+ i 10)) (winning-row? (+ i 15)) (winning-row? (+ i 20))
                   (winning-column? i) (winning-column? (+ i 1)) (winning-column? (+ i 2)) (winning-column? (+ i 3)) (winning-column? (+ i 4)))))
      (dolist (num (mapcar #'parse-integer (split-sequence:split-sequence #\, (car input))))
        (format t "~A~%" num)
        (loop for i from 0 to (- (length boards) 1)
              when (equal (nth i boards) num)
                do (setf (nth i boards) (+ (nth i boards) 3000))
              until (let ((b (* (floor i 25) 25)))
                      (when (winning-board? b)
                        (format t "WINNER ~A~%"
                                (* (- (nth i boards) 3000)
                                   (loop for i from b upto (+ b 24)
                                         sum (if (>= (nth i boards) 3000) 0 (nth i boards)))))
                        (loop for i from b upto (+ b 24)
                              do (setf (nth i boards) -3000))
                        (decf num-boards)
                        (when (equal 0 num-boards)
                          (return-from star-1)))))))))
