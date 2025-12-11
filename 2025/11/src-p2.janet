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
    (put graph (parsed-line 0) (frequencies (parsed-line 1)))
    (break)))

(def stack @["svr"])
(var total 0)

(defn dfs-impl []
  (def from (array/peek stack))
  (if (= from "out")
    (if (and (has-value? stack "dac") (has-value? stack "fft"))
      (++ total))
    (if (table? (graph from))
      (loop [conn :keys (graph from)
             :when (not (has-value? stack conn))]
        (array/push stack conn)
        (dfs-impl)
        (array/pop stack)))))

(dfs-impl)

(print "svr -> out: " total)
