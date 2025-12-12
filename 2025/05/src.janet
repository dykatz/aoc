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

(while (not (empty? (def line (getline))))
  (def parsed-id (scan-number (string/trim line)))
  (array/push ids parsed-id))

(var fresh-id-count 0)

(each id ids
  (each [start end] ranges
    (if (and (>= id start) (<= id end))
      (do
        (++ fresh-id-count)
        (break)))))

(print "fresh ids from list: " fresh-id-count)
