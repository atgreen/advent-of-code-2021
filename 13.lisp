;;; Advent Of Code 2021 - Day 13 - Anthony Green <green@moxielogic.com>

(let ((map (make-hash-table :test #'equal))
      (last-x)
      (last-y))
  (let* ((steps
           (cdr (remove t
                        (loop for l in (uiop:read-file-lines "13.input")
                             collect (let ((d (uiop:split-string l :separator ",")))
                                       (if (equal (length d) 2)
                                           (setf (gethash (list (parse-integer (car d)) (parse-integer (cadr d))) map) t)
                                           (if (> (length l) 10)
                                               (list (aref l 11) (parse-integer (subseq l 13))))))))))
         (final-map (loop for insn in steps
                          for new-map = (make-hash-table :test #'equal)
                          with first = t
                          do (let ((n (cadr insn)))
                               (if (char= (car insn) #\x)
                                   (progn
                                     (setf last-x n)
                                     (loop for p being the hash-keys of map
                                           do (if (< (car p) n)
                                                  (setf (gethash p new-map) t)
                                                  (setf (gethash (list (- n (- (car p) n)) (cadr p)) new-map) t))))
                                   (progn
                                     (setf last-y n)
                                     (loop for p being the hash-keys of map
                                           do (if (< (cadr p) n)
                                                  (setf (gethash p new-map) t)
                                                  (setf (gethash (list (car p) (- n (- (cadr p) n))) new-map) t)))))
                               (setf map new-map))
                          when first do
                            (progn
                              (format t "~A~%" (hash-table-count new-map))
                              (setf first nil))
                          finally (return new-map))))
    (loop for y below last-y
          do (loop for x below last-x
                   do (format t "~A" (if (gethash (list x y)  final-map) "#" " "))
                   finally (format t "~%")))))
