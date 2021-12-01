;;; Advent Of Code 2021 - Day 1 - Anthony Green <green@moxielogic.com>

(defparameter +numbers+ (mapcar #'parse-integer (uiop:read-file-lines "01.input")))

;; Part 1

(defun up-count (nlist)
  (if (cdr nlist)
      (+ (if (< (car nlist) (cadr nlist)) 1 0)
         (up-count (cdr nlist)))
      0))

(print (up-count +numbers+))

;; Part 2

(defun up-count-window (nlist)
  (flet ((window-sum (nlist)
           (if (caddr nlist)
               (+ (car nlist) (cadr nlist) (caddr nlist))
               nil)))
    (let ((a (window-sum nlist))
          (b (window-sum (cdr nlist))))
      (if (and a b)
          (+ (if (< a b) 1 0)
             (up-count-window (cdr nlist)))
          0))))

(print (up-count-window +numbers+))
