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
(sort-by (fn [x] (- (x 2))) areas)

(each [a b area] areas
  (var is-largest true)
  (def [ax ay] (rows a))
  (def [bx by] (rows b))
  (loop [[i [ix iy]] :pairs rows]
    (def j (% (+ i 1) (length rows)))
    (def [jx jy] (rows j))
    (def left-of-rect (<= (max ax bx) (min ix jx)))
    (def right-of-rect (>= (min ax bx) (max ix jx)))
    (def above-rect (<= (max ay by) (min iy jy)))
    (def below-rect (>= (min ay by) (max iy jy)))
    (if (not (or left-of-rect right-of-rect above-rect below-rect))
      (do
        (set is-largest false)
        (break))))
  (if is-largest
    (do
      (print "largest area: " area)
      (break))))
