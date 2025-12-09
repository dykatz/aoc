(def rows @[])

(while (not (empty? (def line (getline))))
  (array/push rows line))

(def op-gram (peg/compile
  '{:main (* :s* :ops)
    :op (<- (+ "*" "+"))
    :op-row (* :op :s+ :ops)
    :ops (+ :op-row :op)}))

(def op-cols (peg/match op-gram (rows (- (length rows) 1))))
(def cols (map (fn [op] [op @[]]) op-cols))
(array/remove rows (- (length rows) 1))

(var i-col 0)

(for i 0 (length (rows 0))
  (def proto-num @[])
  (each row rows
    (def char-in-row (string/from-bytes (row i)))
    (if (and (not= char-in-row " ") (not= char-in-row "\n"))
      (array/push proto-num char-in-row)))
  (if (zero? (length proto-num))
    (++ i-col)
    (do
      (var real-num 0)
      (each char-in-row proto-num
        (def num-in-row (scan-number char-in-row))
        (set real-num (+ num-in-row (* 10 real-num))))
      (array/push ((cols i-col) 1) real-num))))

(var total 0)

(each col cols
  (if (= "+" (col 0))
    (+= total (sum (col 1)))
    (+= total (product (col 1)))))

(print "total: " total)
