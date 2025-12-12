(def mach-gram (peg/compile
  '{:main (* "[" :ild "]" :s :bws :s "{" :jrs "}")
    :ild (some :il)
    :il (+ "." "#")
    :bws (group :bwx)
    :bwx (+ :bwy :bwz)
    :bwy (* :bwz :s :bwx)
    :bwz (group (* "(" :numl ")"))
    :numl (+ :nums :num)
    :nums (* :num "," :numl)
    :num (<- :d+)
    :jrs (group :numl)}))

(defn handle-mach [bws jrs]
  (def matrix @[])
  (loop [jr :in jrs]
    (def row @[jr])
    (array/push matrix row)
    (loop [_ :keys bws]
      (array/push row "0")))
  (loop [[x bw] :pairs bws
         y :in bw]
    (put (matrix (scan-number y)) (+ 1 x) "1"))
  (loop [row :in matrix]
    (print (string/join row ",")))
  (print " "))
  
(while (not (empty? (def line (getline))))
  (def parsed-line (peg/match mach-gram line))
  (if (array? parsed-line)
    (handle-mach ;parsed-line)
    (break)))
