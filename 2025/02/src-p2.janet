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
  (var is-invalid false)
  (for i 1 (+ 1 (/ num-digits 2))
    (def j (/ num-digits i))
    (if (= j (math/floor j))
      (do
        (var is-invalid-by-split true)
        (def pow-10 (math/pow 10 i))
        (def base (% id pow-10))
        (var num base)
        (for k 1 j
          (set num (+ base (* num pow-10))))
        (if (= id num)
          (do
            (set is-invalid true)
            (break))))))
  is-invalid)

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
