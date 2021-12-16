;;; Advent Of Code 2021 - Day 16 - Anthony Green <green@moxielogic.com>

(let* ((hex (car (uiop:read-file-lines "16.input")))
       (versions (list))
       (bits (alexandria:flatten
              (loop for c across hex
                    for n = (parse-integer (string c) :radix 16)
                    collect (loop for index from 3 downto 0
                                  collect (if (logbitp index n) 1 0))))))
  (labels ((read-bits (bit-count)
             (let ((r 0))
               (dotimes (i bit-count r)
                 (setf r (+ (* r 2) (pop bits))))))
           (read-packet ()
             (let ((version (read-bits 3))
                   (type-id (read-bits 3)))
               (push version versions)
               (if (eq type-id 4)
                   (loop with v = 0
                         until (eq (read-bits 1) 0)
                         do (setf v (+ (* v 2) (read-bits 4)))
                         finally (return (+ (* v 2) (read-bits 4))))
                   (let ((operands (let ((length-type-id (read-bits 1)))
                                     (if (eq length-type-id 0)
                                         (let ((sub-packet-length (read-bits 15)))
                                           (let* ((pre-length (length bits))
                                                  (target-length (- pre-length sub-packet-length)))
                                             (loop until (eq (length bits) target-length)
                                                   collect (read-packet))))
                                         (let ((sub-packet-count (read-bits 11)))
                                           (loop for x below sub-packet-count
                                                 collect (read-packet)))))))
                     (cond
                       ((eq type-id 0) (reduce '+ operands))
                       ((eq type-id 1) (reduce '* operands))
                       ((eq type-id 2) (reduce 'min operands))
                       ((eq type-id 3) (reduce 'max operands))
                       ((eq type-id 5) (if (> (car operands) (cadr operands)) 1 0))
                       ((eq type-id 6) (if (< (car operands) (cadr operands)) 1 0))
                       ((eq type-id 7) (if (equal (car operands) (cadr operands)) 1 0))))))))
    (let ((result (read-packet)))
      (print (reduce '+ versions))
      (print result))))
