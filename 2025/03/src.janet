(def line-parser-src
  '{:main (some :num)
    :num (<- :d)})

(def line-parser (peg/compile line-parser-src))
(var sum-of-jolts-2 0)
(var sum-of-jolts-12 0)

(defn max-jolts-for-line [line num]
  (var jolts 0)
  (var start 0)
  (for i 0 num
    (def line-slice (array/slice line start (- i num)))
    (def slice-max (max ;line-slice))
    (for j 0 (length line-slice)
      (if (= slice-max (line-slice j))
        (do
          (+= start j 1)
          (break))))
    (set jolts (+ slice-max (* jolts 10))))
  jolts)

(defn handle-line [line]
  (+= sum-of-jolts-2 (max-jolts-for-line line 2))
  (+= sum-of-jolts-12 (max-jolts-for-line line 12)))

(while (not (empty? (def line (getline))))
  (def parsed-line (peg/match line-parser line))
  (if (array? parsed-line)
    (handle-line (map scan-number parsed-line))
    (break)))

(print "sum of jolts (2): " sum-of-jolts-2)
(print "sum of jolts (12): " sum-of-jolts-12)
