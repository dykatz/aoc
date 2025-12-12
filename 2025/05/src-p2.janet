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

(def non-overlapping-ranges @[;ranges])
(var a-id 0)

(while true
  (var clean true)
  (def [a-start a-end] (ranges a-id))
  (for i (+ a-id 1) (length non-overlapping-ranges)
    (def [b-start b-end] (ranges i))
    (if (and (<= a-start b-end) (<= b-start a-end))
      (do
        (set clean false)
        (array/remove non-overlapping-ranges i)
        (put non-overlapping-ranges a-id [(min a-start b-start) (max a-end b-end)])
        (break))))
  (if clean
    (if (= a-id (- (length non-overlapping-ranges) 1))
      (break)
      (++ a-id))))

(print "total fresh ids: " (sum
  (map (fn [[start end]] (- end start -1)) non-overlapping-ranges)))
