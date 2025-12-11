(def graph @{})

(def gram (peg/compile
  '{:main (* :name ":" :s+ :outs)
    :outs (group :name-list)
    :name (<- :w+)
    :name-list (+ :names :name)
    :names (* :name :s+ :name-list)}))

(while (not (empty? (def line (getline))))
  (def parsed-line (peg/match gram line))
  (if (array? parsed-line)
    (put graph (parsed-line 0) (parsed-line 1))
    (break)))

(var counts @{})

(defn visit [name]
  (if (counts name)
    (put counts name (+ (counts name) 1))
    (put counts name 1))
  (if (array? (graph name))
    (loop [out :in (graph name)]
      (visit out))))

(visit "you")
(print "total routes to out: " (counts "out"))
