(def row-gram (peg/compile
  '{:main (* :num "," :num)
    :num (<- :d+)}))

(def rows @[])
(while (not (empty? (def line (getline))))
  (def parsed-line (peg/match row-gram line))
  (if (array? parsed-line)
    (array/push rows
      [(scan-number (parsed-line 0)) (scan-number (parsed-line 1))])
    (break)))

(def areas @[])
(loop [[i [x1 y1]] :pairs rows
       [j [x2 y2]] :pairs rows
       :when (< i j)]
  (array/push areas
    [i j (* (+ 1 (math/abs (- x1 x2))) (+ 1 (math/abs (- y1 y2))))]))
(sort-by (fn [x] (x 2)) areas)

(print "largest area: " ((areas (- (length areas) 1)) 2))
