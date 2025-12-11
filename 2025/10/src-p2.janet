(def mach-gram (peg/compile
  '{:main (* "[" :ild "]" :s :bws :s "{" :jrs "}")
    :ild (group (some :il))
    :il (<- (+ "." "#"))
    :bws (group :bwx)
    :bwx (+ :bwy :bwz)
    :bwy (* :bwz :s :bwx)
    :bwz (group (* "(" :numl ")"))
    :numl (+ :nums :num)
    :nums (* :num "," :numl)
    :num (<- :d+)
    :jrs (group :numl)}))

(var total-presses 0)

(defn cmp-state [goal state]
  (var clean true)
  (loop [[i v] :pairs goal]
    (def sv (state i))
    (if (> sv v)
      (do
        (set clean false)
        (break))))
  clean)

(defn handle-mach [ild bws jrs]
  (def goal (freeze (map scan-number jrs)))
  (def buttons (map frequencies bws))
  (def state-set @{})
  (put state-set (freeze (array/new-filled (length goal) 0)) true)
  (while true
    (def new-state-set (table/clone state-set))
    (loop [state :keys new-state-set
           button :in buttons]
      (def new-state @[])
      (loop [[i v] :pairs state]
        (if (button (string i))
          (array/push new-state (+ v 1))
          (array/push new-state v)))
      (if (cmp-state goal new-state)
        (put state-set (freeze new-state) true)))
    (++ total-presses)
    (if (state-set goal)
      (break))))

(while (not (empty? (def line (getline))))
  (def parsed-line (peg/match mach-gram line))
  (if (array? parsed-line)
    (handle-mach ;parsed-line)
    (break)))

(print "fewest total presses: " total-presses)
