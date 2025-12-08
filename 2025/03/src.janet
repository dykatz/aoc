(def line-parser-src
  '{:main (some :num)
    :num (<- :d)})

(def line-parser (peg/compile line-parser-src))
(var sum-of-jolts 0)

(defn handle-line [line]
  (def line-1 (array/slice line 0 -2))
  (def max-1 (max ;line-1))
  (var max-id-1 -1)
  (for i 0 (- (length line-1) 1)
    (if (= max-1 (line-1 i))
      (do
        (set max-id-1 i)
        (break))))
  (def line-2 (array/slice line (+ max-id-1 1) -1))
  (def max-2 (max ;line-2))
  (def max-jolts (+ (* 10 max-1) max-2))
  (+= sum-of-jolts max-jolts))

(while (not (empty? (def line (getline))))
  (def parsed-line (peg/match line-parser line))
  (if (array? parsed-line)
    (handle-line (map scan-number parsed-line))
    (break)))

(print "sum of jolts: " sum-of-jolts)
