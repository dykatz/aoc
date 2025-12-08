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

(defn reachable-items [arr]
  (def set (frequencies arr))
  (def neighbor-set (frequencies (mapcat neighbors arr)))
  (seq [coord :keys set
        :let [count (or (get neighbor-set coord) 0)]
        :when (< count 4)] coord))

(defn iterate-reachable-items [arr]
  (def i-arr (array ;arr))
  (var count-reachable 0)
  (while true
    (def reachable (reachable-items i-arr))
    (if (zero? (length reachable))
      (break))
    (+= count-reachable (length reachable))
    (for i 0 (length reachable)
      (for j 0 (length i-arr)
        (if (= (i-arr j) (reachable i))
          (do
            (array/remove i-arr j)
            (break))))))
  count-reachable)

(def input-buf (get-input "input.txt"))
(def input-arr (parse-input input-buf))
(def reachable (reachable-items input-arr))
(print "initial reachable count: " (length reachable))

(def iterated-reachable (iterate-reachable-items input-arr))
(print "total reachable count: " iterated-reachable)
