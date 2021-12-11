;;; Advent Of Code 2021 - Day 11 - Anthony Green <green@moxielogic.com>

;;; -- inspiration from https://www.reddit.com/user/landimatte/

(ql:quickload :alexandria)

(defparameter +neighbour-map+ '((-1 0) (-1 1) (0 1) (1 1) (1 0) (1 -1) (0 -1) (-1 -1)))

(let* ((data (uiop:read-file-lines "11.input"))
       (omap (make-hash-table :test 'equal)))

  (loop for i below (length data)
        for row in data
        do (loop for j below (length row)
                 for c across row
                 do (setf (gethash (list i j) omap)
                          (- (char-code c) (char-code #\0)))))

  (labels ((neighbors (omap p)
             (loop for d in +neighbour-map+ for n = (mapcar #'+ p d)
                   when (gethash n omap) collect n))

           (sim-step (omap &aux (flashed (list)))
             (loop for p being the hash-keys of omap do
               (incf (gethash p omap))
               (when (> (gethash p omap) 9)
                 (loop with remaining = (list p)
                       while remaining
                       for n = (pop remaining)
                       unless (find (+ (* (car n) 1000) (cadr n)) flashed) do
                         (incf (gethash n omap))
                         (when (> (gethash n omap) 9)
                           (setf flashed (cons (+ (* (car n) 1000) (cadr n)) flashed))
                           (setf remaining (append remaining (neighbors omap n)))))))
             (loop for p being the hash-keys of omap using (hash-value e)
                   count (when (> e 9) (setf (gethash p omap) 0)))))

    (print (loop with curr = (alexandria:copy-hash-table omap)
                 repeat 100
                 sum (sim-step curr)))

    (print (loop with curr = (alexandria:copy-hash-table omap)
                 for sim-step from 1
                 when (= (sim-step curr) 100) return sim-step))))
