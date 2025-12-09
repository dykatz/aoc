(var splits 0)
(var beams @{})

(while (not (empty? (def line (getline))))
  (for i 0 (length line)
    (def ch (line i))
    (if (= ch 83)
      (put beams i true))
    (if (and (= ch 94) (beams i))
      (do
        (put beams i nil)
        (put beams (+ i 1) true)
        (put beams (- i 1) true)
        (++ splits)))))

(print "splits: " splits)
