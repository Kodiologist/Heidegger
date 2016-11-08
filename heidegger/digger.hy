(require [kodhy.macros [lc amap filt afind-or]])

(import
  [heidegger.pos [Pos]]
  [collections [OrderedDict]]
  [random [random randint sample]]
  [kodhy.util [seq signum]])

(defmacro set-self [&rest props]
  `(do ~@(amap `(setv (. self ~it) ~it)  props)))

;; * generate-map

(defn generate-map
; Return a dictionary containing:
; - the map, as a list of lists
; - a list of rooms
; - a list of corridors
   [width height &optional
      ; Map dimensions. The outer border will always end up as wall.
    [room-width [3 9]]
      ; Minimum and maximum width of rooms.
    [room-height [3 5]]
      ; Minimum and maximum height of rooms.
    [corridor-length [3 10]]
      ; Minimum and maximum length of corridors.
    [dug-fraction .2]
      ; Keep digging until this fraction of the map is dug out.
    [feature-attempts 20]]
      ; Try this many times to create a feature in a selected
      ; position before giving up.

  (setv gmap (amap (amap True (range height)) (range width)))
    ; In gmap, True represents wall and False represents floor.
  (setv rooms [])
  (setv corridors [])
  (setv walls (OrderedDict))
    ; This is ordered so that reruns with the same random seed
    ; will produce the same map.
  (setv extra {"dug" 0})

  (setv area (* (- width 2) (- height 2)))

  (defn getp [pos]
    (get gmap pos.x pos.y))
  (defn setp [pos val]
    (setv (get gmap pos.x pos.y) val))

  (defn on-map [pos]
    (and (<= 0 pos.x (dec width)) (<= 0 pos.y (dec height))))
  (defn interior [pos]
    (and (< 0 pos.x (dec width)) (< 0 pos.y (dec height))))

  (defn wall? [pos]
    (and (on-map pos) (getp pos)))
  (defn diggable? [pos]
    (and (interior pos) (getp pos)))
  
  (defn dig [p is-wall]
    (if is-wall
      (setv (get walls p) :regular-wall)
    (do ; else
      (setp p False)
      (+= (get extra "dug") 1))))

  (defn get-digging-direction [p]
  ; If the Pos p is on the border of the map or does not have
  ; exactly one clear neighbor, return None. Otherwise, return
  ; the direction away from the neighbor (the direction you'd dig
  ; towards from that neighbor).
    (when (interior p)
      (setv dirs (filt (= (getp (+ p it)) 0) Pos.ORTHS))
      (when (= (len dirs) 1)
        (- (first dirs)))))

  (defn pop-wall []
    (setv l (or
      (lc [[p v] (.items walls)] (= v :corridor-end) p)
      (lc [[p v] (.items walls)] (= v :regular-wall) p)))
    (when l
      (setv p (first (sample l 1)))
      (del (get walls p))
      p))

  (defn try-feature [p dir]
    (setv feature-type (if (> (random) .5) Corridor Room))
    (setv feature (if (is feature-type Corridor)
      (.create-random-at Corridor p dir corridor-length)
      (.create-random-at Room p dir room-width room-height)))
    (when (.valid? feature wall? diggable?)
      (if (is feature-type Room) (do
        (.dig-out feature dig)
        (.append rooms feature))
      (do ; else
        (.dig-out feature dig)
        (.append corridors feature)
        (when (wall? (+ feature.end dir))
          ; Mark :corridor-end walls. They get priority for
          ; digging, to minimize dead-end corridors.
          (setv near (Pos dir.y (- dir.x)))
          (for [pe [(+ feature.end dir) (+ feature.end near) (- feature.end near)]]
            (setv (get walls pe) :corridor-end)))))
      True))

  (defn remove-surrounding-walls [p]
    (for [dir Pos.ORTHS]
      (walls.pop (+ p dir) None)
      (walls.pop (+ p dir dir) None)))

  ; Create the first room.
  (.append rooms (Room.create-random-centered-at
    (Pos (/ width 2) (/ height 2))
    room-width room-height))
  (.dig-out (get rooms -1) dig)

  ; Try to create features.
  (while True
    (setv wall (pop-wall))
    (unless wall
      ; No more walls to dig out.
      (break))
    (setv dir (get-digging-direction wall))
    (unless dir
      ; This wall is unsuitable.
      (continue))
    (for [_ (range feature-attempts)]
      (when (try-feature wall dir)
        ; We successfully added a feature.
        (remove-surrounding-walls wall)
        (remove-surrounding-walls (- wall dir))
        (break)))
    (unless (or
        (< (/ (get extra "dug") area) dug-fraction)
        (afind-or (= it :corridor-end) (.values walls)))
      (break)))

  ; Fix doors.
  (for [room rooms]
    (room.remake-doors wall?))

  ; Return the map along with the lists of rooms and corridors.
  {"map" gmap "rooms" rooms "corridors" corridors})

;; * Room

(defclass MapFeature [object] [])

(defclass Room [MapFeature] [

  __init__ (fn [self p1 p2 &optional door]
    (set-self p1 p2)
    (setv self.doors [])
    (when door
      (.append self.doors door)))

  create-random-at (classmethod (fn [self door dir room-width room-height]
    (setv this-width (apply randint room-width))
    (setv this-height (apply randint room-height))
    (setv p1 (+ door (if (in dir [Pos.WEST Pos.EAST])
      (Pos
        (min 1 (* dir.x this-width))
        (- (randint 0 (dec this-height))))
      (Pos
        (- (randint 0 (dec this-width)))
        (min 1 (* dir.y this-height))))))
    (self p1 (+ p1 (Pos (dec this-width) (dec this-height)))
      :door door)))

  create-random-centered-at (classmethod (fn [self center room-width room-height]
    (setv this-width (apply randint room-width))
    (setv this-height (apply randint room-height))
    (setv p1 (Pos
      (- center.x (randint 0 (dec this-width)))
      (- center.y (randint 0 (dec this-height)))))
    (setv p2 (Pos
      (+ p1.x this-width -1)
      (+ p1.y this-height -1)))
    (self p1 p2)))

  borders (fn [self]
    (, (dec self.p1.x) (inc self.p2.x) (dec self.p1.y) (inc self.p2.y)))

  valid? (fn [self wall? diggable?]
    (setv [left right top bottom] (self.borders))
    (all (lc [x (seq left right) y (seq top bottom)]
       (if (or (in x [left right]) (in y [top bottom]))
        (wall? (Pos x y))
        (diggable? (Pos x y))))))

  dig-out (fn [self dig-f]
    (setv [left right top bottom] (self.borders))
    (for [x (seq left right)]
      (for [y (seq top bottom)]
        (dig-f (Pos x y) (and
          (not-in (Pos x y) self.doors)
          (or (in x [left right]) (in y [top bottom])))))))

  remake-doors (fn [self wall?]
    (setv self.doors [])
    (setv [left right top bottom] (self.borders))
    (for [p (+
        (amap (Pos left it) (seq top bottom))
        (amap (Pos right it) (seq top bottom))
        (amap (Pos it top) (seq left right))
        (amap (Pos it bottom) (seq left right)))]
      (unless (wall? p)
        (.append self.doors p))))])

;; * Corridor

(defclass Corridor [MapFeature] [

  __init__ (fn [self start end]
    (set-self start end)
    (setv self.ends-with-wall True))

  create-random-at (classmethod (fn [self start dir corridor-length]
    (setv length (apply randint corridor-length))
    (self start (+ start (* length dir)))))

  valid? (fn [self wall? diggable?]

    (setv diff (- self.end self.start))
    (setv length (inc (max (abs diff.x) (abs diff.y))))
    (setv dir (Pos (signum diff.x) (signum diff.y)))
    (setv near (Pos (signum diff.y) (- (signum diff.x))))

    ; Make sure the whole length of the corridor is valid.
    ; If not, shorten it.
    (for [i (range length)]
      (setv p (+ self.start (* i dir)))
      (unless (and (diggable? p) (wall? (+ p near)) (wall? (- p near)))
        (setv length i)
        (setv self.end (- p dir))
        (break)))

    (setv tail (+ self.end dir))
    (and
      ; Don't allow 0-length corridors.
      (> length 0) 
      ; If one of the corners diagonally after the final square
      ; is empty, the square orthogonally after the final square
      ; must be empty, too—no ugly diagonal contacts of dungeon
      ; features.
      (or
       (not (wall? tail))
       (and (wall? (+ tail near)) (wall? (- tail near))))
      ; Length-1 corridors must have a clear space after them.
      (or (> length 1) (not (wall? tail)))))

  dig-out (fn [self dig-f]
    (setv diff (- self.end self.start))
    (setv dir (Pos (signum diff.x) (signum diff.y)))
    (setv p self.start)
    (while True
      (dig-f p False)
      (when (= p self.end)
        (break))
      (+= p dir)))])
