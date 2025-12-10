(defn get-input [path]
  (def f (file/open path :r))
  (def b (file/read f :all))
  (file/close f)
  b)

(def id-pattern-src
  '{:id (<- :d+)
    :range (* :id "-" :id)
    :main (split "," :range)})

(defn invalid-id? [id]
  (def num-digits (+ 1 (math/floor (math/log10 id))))
  (def divider (math/pow 10 (/ num-digits 2)))
  (def top-half (math/floor (/ id divider)))
  (def bottom-half (- id (* top-half divider)))
  (and (= top-half bottom-half) (even? num-digits)))

(defn each-ranges [ranges pred]
  (var i 0)
  (while (< i (- (length ranges) 1))
    (pred (ranges i) (ranges (+ i 1)))
    (+= i 2)))

(var total-sum 0)

(defn each-range [start stop]
  (for i start (+ 1 stop)
    (if (invalid-id? i)
      (+= total-sum i))))

(def id-pattern (peg/compile id-pattern-src))
(def input (get-input "input.txt"))
(def id-ranges (map scan-number (peg/match id-pattern input)))
(each-ranges id-ranges each-range)
(print "sum of invalid ids: " total-sum)
