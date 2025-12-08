(defn get-input [path]
  (def f (file/open path :r))
  (def b (file/read f :all))
  (file/close f)
  b)

(defn parse-input [b]
  (def t @[])
  (var x 0)
  (var y 0)
  (for i 0 (length b)
    (if (= 64 (b i))
      (array/push t [x y]))
    (++ x)
    (if (= 10 (b i))
      (do
        (++ y)
        (set x 0))))
  t)

(def- window
  (seq [x :range [-1 2]
        y :range [-1 2]
          :when (not (and (zero? x) (zero? y)))]
       [x y]))

(defn- neighbors
  [[x y]]
  (map (fn [[x1 y1]] [(+ x x1) (+ y y1)]) window))

(def input-buf (get-input "input.txt"))
(def input-arr (parse-input input-buf))
(def input-set (frequencies input-arr))
(def neighbor-set (frequencies (mapcat neighbors input-arr)))

(def reachable (seq [coord :keys input-set
      :let [count (or (get neighbor-set coord) 0)]
      :when (< count 4)] coord))

(print "reachable count: " (length reachable))
