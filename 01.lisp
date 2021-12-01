;;; Advent Of Code 2021 - Day 1 - Anthony Green <green@moxielogic.com>

(let ((input (mapcar #'parse-integer (uiop:read-file-lines "01.input"))))
  (print (loop for (a b) on input while b count (> b a)))
  (print (loop for (a b c d) on input while d count (> d a))))
