;;; Advent Of Code 2021 - Day 8 - Anthony Green <green@moxielogic.com>

(let ((lows nil)
      (low-points nil)
      (prev-line (format nil "~v@{~A~:*~}" 102 "9"))
      (prev-lows nil)
      (y -1))
  (dolist (line (append (uiop:read-file-lines "09.input")
                        (list (subseq prev-line 2))))
    (let* ((line (concatenate 'string "9" line "9")))
      (loop for p in prev-lows
            when (char< (aref prev-line p) (aref line p))
              do (progn
                   (push (cons (- p 1) y) low-points)
                   (push (+ (digit-char-p (aref prev-line p)) 1) lows)))
      (setf prev-lows (loop for i from 1 to (- (length line) 1)
                            when (and (char< (aref line i) (aref line (- i 1)))
                                      (char< (aref line i) (aref line (+ i 1)))
                                      (char< (aref line i) (aref prev-line i)))
                              collect i))
      (setf prev-line line)
      (incf y 1)))

  ; Part 1
  (print (reduce '+ lows))

  ; Part 2
  (let ((map ""))
    (dolist (line (uiop:read-file-lines "09.input"))
      (setf map (concatenate 'string map line)))
    (labels ((basin-search (x y)
               (let ((c (aref map (+ (* y 100) x))))
                 (setf (aref map (+ (* y 100) x)) #\9)
                 (if (eq c #\9)
                     0
                     (+ (if (< 0 x) (basin-search (- x 1) y) 0)
                        (if (< x 99) (basin-search (+ x 1) y) 0)
                        (if (< 0 y) (basin-search x (- y 1)) 0)
                        (if (< y 99) (basin-search x (+ y 1)) 0) 1)))))
      (print (reduce '* (subseq (sort (loop for point in low-points
                                            collect (basin-search (car point) (cdr point)))
                                      #'>)
                                0 3))))))
