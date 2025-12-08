(def row-gram (peg/compile
  '{:main (* :s* :row)
    :nm (<- :d+)
    :op (<- (+ "*" "+"))
    :nm-row (* :nm :s+ :nms)
    :nms (+ :nm-row :nm)
    :op-row (* :op :s+ :ops)
    :ops (+ :op-row :op)
    :row (+ :nms :ops)}))

(def rows @[])

(while (not (empty? (def line (getline))))
  (def parsed-line (peg/match row-gram line))
  (if (array? parsed-line)
    (array/push rows parsed-line)
    (break)))

(def cols @[])

(for i 0 (length (rows 0))
  (def col @[])
  (array/push cols col)
  (for j 0 (length rows)
    (array/push col ((rows j) i))))

(var total 0)

(each col cols
  (def nums (map scan-number (array/slice col 0 -2)))
  (if (= "+" (col (- (length col) 1)))
    (+= total (sum nums))
    (+= total (product nums))))

(print "total: " total)
