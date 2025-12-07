(var current-position 50)
(var times-at-zero 0)
(var passes-zero 0)

(defn handle-line [dir cnt]
  (def started-at-zero (= current-position 0))
  (var had-subtractive-pass false)
  (if (= dir "R")
    (set current-position (+ current-position cnt))
    (set current-position (- current-position cnt)))
  (while (< current-position 0)
    (set current-position (+ current-position 100))
    (set passes-zero (+ passes-zero 1))
    (set had-subtractive-pass true))
  (if (= current-position 0)
    (do
      (set had-subtractive-pass true)
      (set passes-zero (+ passes-zero 1))))
  (if (and started-at-zero had-subtractive-pass)
    (set passes-zero (- passes-zero 1)))
  (while (>= current-position 100)
    (set current-position (- current-position 100))
    (set passes-zero (+ passes-zero 1)))
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
(print "clicks at zero: " passes-zero)
