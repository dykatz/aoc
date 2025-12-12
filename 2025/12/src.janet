(def gram (peg/compile
  '{:main (* (group :shapes) "\n\n" (group :probs))
    :shape-list (* :shape "\n\n" :shapes)
    :shapes (+ :shape-list :shape)
    :shape (* :d+ ":\n" (group :shape-lines))
    :shape-line-list (* :shape-line "\n" :shape-lines)
    :shape-lines (+ :shape-line-list :shape-line)
    :shape-line (<- (some (+ "." "#")))
    :prob-line-list (* :prob-line "\n" :probs)
    :probs (+ :prob-line-list :prob-line)
    :prob-line (group (* :prob-size (group :prob-shapes)))
    :prob-size (group (* (<- :d+) "x" (<- :d+) ": "))
    :prob-shapes (+ :prob-shape-list :prob-shape)
    :prob-shape-list (* :prob-shape " " :prob-shapes)
    :prob-shape (<- :d+)}))

(defn get-input [path]
  (def f (file/open path :r))
  (def b (file/read f :all))
  (file/close f)
  b)

(def input-buf (get-input "input.txt"))
(def [shapes problems] (peg/match gram input-buf))

(def shape-areas
  (map
    (fn [shape] (sum (map
      (fn [shape-row] ((frequencies shape-row) 35))
      shape)))
    shapes))

(def problem-areas
  (map
    (fn [[[x y] shape-ids]] [
      (* (scan-number x) (scan-number y))
      (sum (seq [[shape-id shape-count] :pairs shape-ids]
        (* (scan-number shape-count) (shape-areas shape-id))))])
    problems))

(def problem-count
  (sum (seq [[prob-area shape-area] :in problem-areas]
    (if (> prob-area shape-area) 1 0))))

(print "number of passing problems: " problem-count)
