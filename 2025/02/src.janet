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

(defn invalid-id-p2? [id]
  (def num-digits (+ 1 (math/floor (math/log10 id))))
  (var is-invalid false)
  (for i 2 (+ 1 (/ num-digits 2))
    (def j (/ num-digits i))
    (if (= j (math/floor j))
      (do
        (def base-divider (math/pow 10 i))
        (var base-split-value nil)
        (var id-for-base id)
        (var is-invalid-by-split true)
        (for k 0 j
          (def l (- j k 1))
          (def divider (math/pow base-divider l))
          (def split-value (math/floor (/ id-for-base divider)))
          (-= id-for-base (* split-value divider))
          (if (= base-split-value nil)
            (set base-split-value split-value))
          (if (not= base-split-value split-value)
            (do
              (set is-invalid-by-split false)
              (break))))
        (if is-invalid-by-split
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
    (if (invalid-id-p2? i)
      (+= total-sum i))))

(def id-pattern (peg/compile id-pattern-src))
(def input (get-input "input.txt"))
(def id-ranges (map scan-number (peg/match id-pattern input)))
(each-ranges id-ranges each-range)
(print "sum of invalid ids: " total-sum)
