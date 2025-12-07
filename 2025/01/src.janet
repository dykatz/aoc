(var current-position 50)
(var times-at-zero 0)

(defn handle-line [dir cnt]
  (if (= dir "R")
    (set current-position (+ current-position cnt))
    (set current-position (- current-position cnt)))
  (while (< current-position 0)
    (set current-position (+ current-position 100)))
  (while (>= current-position 100)
    (set current-position (- current-position 100)))
  (if (= current-position 0)
    (set times-at-zero (+ times-at-zero 1))))

(def line-parser-src
  '{:dir (<- (+ "L" "R"))
    :cnt (<- :d+)
    :main (* :dir :cnt)})

(def line-parser (peg/compile line-parser-src))

(while (not (empty? (def line (getline))))
  (def parsed-line (peg/match line-parser line))
  (if (array? parsed-line)
    (handle-line (parsed-line 0) (scan-number (parsed-line 1)))
    (break)))

(print "times at zero: " times-at-zero)
