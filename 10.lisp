;;; Advent Of Code 2021 - Day 10 - Anthony Green <green@moxielogic.com>

(let ((score 0))
  (labels ((parse-chunk (line close-list)
             (when (> (length line) 0)
               (let ((next-char (position (aref line 0) "{[<(")))
                 (if next-char
                     (parse-chunk (subseq line 1) (cons (aref "}]>)" next-char) close-list))
                     (if (equal (aref line 0) (car close-list))
                         (parse-chunk (subseq line 1) (cdr close-list))
                         (incf score (nth (position (aref line 0) ")]}>") '(3 57 1197 25137)))))))))
    (dolist (line (uiop:read-file-lines "10.input"))
      (parse-chunk line (list)))
    (print score)))

(labels ((parse-chunk (line close-list)
           (if (equal (length line) 0)
               (loop for x in close-list
                     with score = 0
                     do (setf score (+ (* score 5) (nth (position x ")]}>") '(1 2 3 4))))
                     finally (return score))
               (let ((next-char (position (aref line 0) "{[<(")))
                 (if next-char
                     (parse-chunk (subseq line 1) (cons (aref "}]>)" next-char) close-list))
                     (when (equal (aref line 0) (car close-list))
                       (parse-chunk (subseq line 1) (cdr close-list))))))))
  (let ((scores (sort (remove nil (mapcar (lambda (line) (parse-chunk line (list)))
                                          (uiop:read-file-lines "10.input"))) '>)))
    (print (nth (floor (length scores) 2) scores))))
