; -*- Hy -*-

(defclass Pos [object] [

  __init__ (fn [self x y]
    (setv self.x (int x))
    (setv self.y (int y)))

  __eq__ (fn [self o]
    (and (is-not o None) (= self.x o.x) (= self.y o.y)))

  __hash__ (fn [self]
    (hash (, self.x self.y)))

  __repr__ (fn [self]
    (.format "(Pos {} {})" self.x self.y))

  __neg__ (fn [self]
    (Pos (- self.x) (- self.y)))

  __add__ (fn [self o]
    (if (instance? Pos o)
      (Pos (+ self.x o.x) (+ self.y o.y))
      (Pos (+ self.x o) (+ self.y o))))

  __sub__ (fn [self o]
    (if (instance? Pos o)
      (Pos (- self.x o.x) (- self.y o.y))
      (Pos (- self.x o) (- self.y o))))

  __rmul__ (fn [self factor]
    (Pos (* factor self.x) (* factor self.y)))])

(def Pos.NORTH (Pos 0 1))
(def Pos.SOUTH (Pos 0 -1))
(def Pos.EAST (Pos 1 0))
(def Pos.WEST (Pos -1 0))

(def Pos.NE (+ Pos.NORTH Pos.EAST))
(def Pos.NW (+ Pos.NORTH Pos.WEST))
(def Pos.SE (+ Pos.SOUTH Pos.EAST))
(def Pos.SW (+ Pos.SOUTH Pos.WEST))

(def Pos.DIRNAMES {
  Pos.NORTH "north"
  Pos.SOUTH "south"
  Pos.EAST "east"
  Pos.WEST "west"
  Pos.NE "northeast"
  Pos.NW "northwest"
  Pos.SE "southeast"
  Pos.SW "southwest"})

; In these tuples, directions are ordered the same way angles are
; in coordinate geometry.
(def Pos.ORTHS (, Pos.EAST Pos.NORTH Pos.WEST Pos.SOUTH))
(def Pos.DIAGS (, Pos.NE Pos.NW Pos.SW Pos.SE))
(def Pos.DIR8 (, Pos.EAST Pos.NE Pos.NORTH Pos.NW Pos.WEST Pos.SW Pos.SOUTH Pos.SE))
