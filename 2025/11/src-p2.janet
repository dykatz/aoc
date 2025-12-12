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

(defn cached-count-paths [start successors success cache]
  (def cached (cache start))
  (if cached
    cached
    (if (success start)
      (do
        (put cache start 1)
        1)
      (do
        (def result
          (sum
            (map
              (fn [s] (cached-count-paths s successors success cache))
              (successors start))))
        (put cache start result)
        result))))

(defn count-paths [start successors success]
  (def cache @{})
  (cached-count-paths start successors success cache))

(defn successors-from-start [[label fft dac]]
  (map
    (fn [next-label] [next-label
      (or fft (= next-label "fft"))
      (or dac (= next-label "dac"))]) (or (graph label) [])))

(def initial-node ["svr" false false])
(def success-node ["out" true true])

(defn success-from-start [start] (= start success-node))

(print "svr -> out: "
  (count-paths initial-node successors-from-start success-from-start))
