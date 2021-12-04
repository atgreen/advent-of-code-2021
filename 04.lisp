;;; Advent Of Code 2021 - Day 4 - Anthony Green <green@moxielogic.com>

(ql:quickload :split-sequence)
(ql:quickload :str)

(let* ((scores (list))
       (input (uiop:read-file-lines "04.input"))
       (boards (mapcar #'parse-integer
                       (remove "" (split-sequence:split-sequence
                                   #\Space
                                   (reduce (lambda (a b) (str:concat a " " b))
                                           (cdr input)))
                               :test #'string=)))
       (num-boards (floor (length boards) 25)))
  (block star
    (labels ((winning-row? (i) (equal -5 (reduce #'+ (subseq boards i (+ i 5)))))
             (winning-column? (i) (equal -5 (loop for x from i upto (+ i 20) by 5 sum (nth x boards))))
             (winning-board? (i)
               (or (loop for x from i upto (+ i 15) by 5 until (winning-row? x) finally (return (winning-row? x)))
                   (loop for x from 0 upto 4 by 1 until (winning-column? x) finally (return (winning-column? x))))))
      (dolist (num (mapcar #'parse-integer (split-sequence:split-sequence #\, (car input))))
        (loop for i from 0 to (- (length boards) 1)
              when (equal (nth i boards) num)
                do (progn
                     (setf (nth i boards) -1)
                     (let ((b (* (floor i 25) 25)))
                       (when (winning-board? b)
                         (push (* num (loop for i from b upto (+ b 24)
                                            sum (if (< (nth i boards) 0) 0 (nth i boards))))
                               scores)
                         (loop for i from b upto (+ b 24) do (setf (nth i boards) -1))
                         (decf num-boards)
                         (when (equal 0 num-boards)
                           (return-from star)))))))))
  (format t "star 1: ~A~%star 2: ~A~%" (first scores) (car (last scores))))
