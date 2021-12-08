;;; Advent Of Code 2021 - Day 8 - Anthony Green <green@moxielogic.com>

(ql:quickload :fset)

(print (let ((counts (make-array 8)))
         (mapc (lambda (line)
                 (dolist (digit (subseq (uiop:split-string line :separator " ") 11))
                   (incf (aref counts (length digit)))))
               (uiop:read-file-lines "08.input"))
         (+ (aref counts 2) (aref counts 4) (aref counts 3) (aref counts 7))))

(print
 (reduce
  '+
  (mapcar (lambda (number-line)
            (let ((digits (make-array 10))
                  (segment-counts (make-array 8 :initial-element (list)))
                  (line (uiop:split-string number-line :separator " "))
                  (bag)
                  (e))
              (dolist (digit (subseq line 0 10))
                (push digit (aref segment-counts (length digit))))
              (setf (aref digits 1) (find t line :test (lambda (d x) (eq (length x) 2))))
              (setf (aref digits 4) (find t line :test (lambda (d x) (eq (length x) 4))))
              (setf (aref digits 7) (find t line :test (lambda (d x) (eq (length x) 3))))
              (setf (aref digits 8) (find t line :test (lambda (d x) (eq (length x) 7))))
              (setf bag (fset:convert 'fset:bag (remove #\Space (coerce (subseq number-line 0 58) 'list))))

              ;; Figure out which segment is 'e'
              (fset:filter (lambda (v) (when (eq 4 (fset:multiplicity bag v))
                                         (setf e v))) bag)

              ;; 9 is the 6 segment string without 'e'
              (setf (aref digits 9) (find e (aref segment-counts 6) :test (lambda (c s) (not (find c s)))))
              (setf (aref segment-counts 6) (remove (aref digits 9) (aref segment-counts 6) :test #'equal))

              ;; 0 is one of the 6 segment strings that intersects with 1
              (let ((one-segment-set (fset:convert 'fset:set (coerce (aref digits 1) 'list))))
                (setf (aref digits 0) (find t (aref segment-counts 6)
                                            :test (lambda (_ s) (eq (fset:size (fset:intersection one-segment-set
                                                                                                  (fset:convert 'fset:set (coerce s 'list))))
                                                                    2)))))
              ;; 6 is the remaining 6 segment digit
              (setf (aref digits 6) (car (remove (aref digits 0) (aref segment-counts 6) :test #'equal)))

              ;; 3 is one of the 5 segment that intersects with 1
              (let ((one-segment-set (fset:convert 'fset:set (coerce (aref digits 1) 'list))))
                (setf (aref digits 3) (find t (aref segment-counts 5)
                                            :test (lambda (_ s) (eq (fset:size (fset:intersection one-segment-set
                                                                                                  (fset:convert 'fset:set (coerce s 'list))))
                                                                    2)))))
              (setf (aref segment-counts 5) (remove (aref digits 3) (aref segment-counts 5) :test #'equal))


              ;; 5 has 5 segments in common with 6, and 2 is the other one.
              (let ((six-segment-set (fset:convert 'fset:set (coerce (aref digits 6) 'list))))
                (if (eq (fset:size (fset:intersection six-segment-set
                                                      (fset:convert 'fset:set (coerce (car (aref segment-counts 5)) 'list))))
                        5)
                    (progn
                      (setf (aref digits 5) (car (aref segment-counts 5)))
                      (setf (aref digits 2) (cadr (aref segment-counts 5))))
                    (progn
                      (setf (aref digits 2) (car (aref segment-counts 5)))
                      (setf (aref digits 5) (cadr (aref segment-counts 5))))))

              (let ((numbers (make-hash-table :test #'equal)))
                (loop for i from 0 to 9 do (progn (setf (gethash (sort (aref digits i) #'char-lessp) numbers) i)))
                (+ (* 1000 (gethash  (sort (nth 11 line) #'char-lessp) numbers))
                   (* 100 (gethash (sort (nth 12 line) #'char-lessp) numbers))
                   (* 10 (gethash (sort (nth 13 line) #'char-lessp) numbers))
                   (* 1 (gethash (sort (nth 14 line) #'char-lessp) numbers))))))

          (uiop:read-file-lines "08.input"))))
