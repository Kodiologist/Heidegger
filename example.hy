(import heidegger.digger random)

(random.seed 100)

(def result (heidegger.digger.generate-map
  :width 60 :height 18
  :room-width [3 7] :room-height [3 5]
  :corridor-length [3 10]
  :dug-fraction .2))

(def gmap (get result "map"))

(for [r (get result "rooms")]
  (for [d r.doors]
    (setv (get gmap d.x d.y) :door)))

(for [y (range (len (first gmap)))]
  (for [x (range (len gmap))]
    (setv val (get gmap x y))
    (print :sep "" :end "" (cond
      [(is val False) "."]
      [(is val True) " "] ;(ansicolor.black " " :reverse True)]
      [(= val :door) "#"] ;(ansicolor.yellow "#")]
      [True (raise ValueError)])))
  (print))

(print "\nCorridors")
(for [c (get result "corridors")]
  (print c.start c.end))

(print "\nRooms")
(for [r (get result "rooms")]
  (print r.p1 r.p2 r.doors))
