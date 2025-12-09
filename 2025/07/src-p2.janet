(var beams @{})

(defn inc-beams [i c]
  (if (beams i)
    (put beams i (+ c (beams i)))
    (put beams i c)))

(while (not (empty? (def line (getline))))
  (for i 0 (length line)
    (def ch (line i))
    (if (= ch 83)
      (inc-beams i 1))
    (if (and (= ch 94) (beams i))
      (do
        (def beam-strength (beams i))
        (put beams i nil)
        (inc-beams (+ i 1) beam-strength)
        (inc-beams (- i 1) beam-strength)))))

(print "timelines: " (sum (values beams)))
