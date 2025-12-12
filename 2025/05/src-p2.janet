(def ranges @[])
(def ids @[])

(def range-parser (peg/compile
  '{:num (<- :d+)
    :main (* :num "-" :num)}))

(while (not (empty? (def line (getline))))
  (def parsed-line (peg/match range-parser line))
  (if (array? parsed-line)
    (array/push ranges [(scan-number (parsed-line 0)) (scan-number (parsed-line 1))])
    (break)))

(sort-by (fn [[start _]] start) ranges)
(var a-id 0)

(while (< a-id (- (length ranges) 1))
  (def [a-start a-end] (ranges a-id))
  (def [b-start b-end] (ranges (+ a-id 1)))
  (if (> b-start a-end)
    (++ a-id)
    (do
      (array/remove ranges (+ a-id 1))
      (put ranges a-id [a-start (max a-end b-end)]))))

(print "total fresh ids: " (sum
  (map (fn [[start end]] (- end start -1)) ranges)))
