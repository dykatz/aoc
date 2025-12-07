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

(def id-pattern (peg/compile id-pattern-src))
(def input (get-input "input.txt"))
(def ids (map scan-number (peg/match id-pattern input)))
(def invalid-ids (filter invalid-id? ids))
(print "sum of invalid ids: " (sum invalid-ids))
