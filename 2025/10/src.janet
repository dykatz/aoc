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

(defn handle-mach [ild bws jrs]
  (def goal (freeze (map (fn [x] (= x "#")) ild)))
  (def buttons (map frequencies bws))
  (def state-set @{})
  (put state-set (freeze (array/new-filled (length goal) false)) true)
  (while true
    (def new-state-set (table/clone state-set))
    (loop [state :keys new-state-set
           button :in buttons]
      (def new-state @[])
      (loop [[i v] :pairs state]
        (if (button (string i))
          (array/push new-state (not v))
          (array/push new-state v)))
      (put state-set (freeze new-state) true))
    (++ total-presses)
    (if (state-set goal)
      (break))))

(while (not (empty? (def line (getline))))
  (def parsed-line (peg/match mach-gram line))
  (if (array? parsed-line)
    (handle-mach ;parsed-line)
    (break)))

(print "fewest total presses: " total-presses)
