(defn dist3 [x1 y1 z1 x2 y2 z2]
  (math/sqrt (+
    (math/pow (- x2 x1) 2)
    (math/pow (- y2 y1) 2)
    (math/pow (- z2 z1) 2))))

(def line-gram (peg/compile
  '{:main (* :num "," :num "," :num)
    :num (<- :d+)}))

(def rows @[])
(while (not (empty? (def line (getline))))
  (array/push rows (map scan-number (peg/match line-gram line))))

(def distances @[])
(loop [[i [x1 y1 z1]] :pairs rows
       [j [x2 y2 z2]] :pairs rows
       :when (< i j)]
  (array/push distances [i j (dist3 x1 y1 z1 x2 y2 z2)]))
(sort-by (fn [x] (x 2)) distances)

(def circuits @{})

(for i 0 1000
  (def [a b] (distances i))
  (def a-cir (circuits a))
  (def b-cir (circuits b))
  (if (and a-cir b-cir)
    (loop [j :keys b-cir]
      (put a-cir j true)
      (put circuits j a-cir)))
  (if (and (nil? a-cir) (nil? b-cir))
    (do
      (def new-cir @{a true b true})
      (put circuits a new-cir)
      (put circuits b new-cir))
    (if (nil? a-cir)
      (do
        (put b-cir a true)
        (put circuits a b-cir))
      (if (nil? b-cir)
        (do
          (put a-cir b true)
          (put circuits b a-cir))))))

(def unique-circuits @{})
(loop [[_ c] :pairs circuits] (put unique-circuits c true))
(def circuit-sizes (sort (map length (keys unique-circuits))))
(print "size: " (product (array/slice circuit-sizes -4 -1)))
