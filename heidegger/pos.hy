; -*- Hy -*-

(defclass Pos [object] [

  [__init__ (fn [self x y]
    (setv self.x (int x))
    (setv self.y (int y))
    None)]

  [__eq__ (fn [self o]
    (and (= self.x o.x) (= self.y o.y)))]

  [__hash__ (fn [self]
    (hash (, self.x self.y)))]

  [__repr__ (fn [self]
    (.format "(Pos {} {})" self.x self.y))]

  [__neg__ (fn [self]
    (Pos (- self.x) (- self.y)))]

  [__add__ (fn [self o]
    (if (instance? Pos o)
      (Pos (+ self.x o.x) (+ self.y o.y))
      (Pos (+ self.x o) (+ self.y o))))]

  [__sub__ (fn [self o]
    (if (instance? Pos o)
      (Pos (- self.x o.x) (- self.y o.y))
      (Pos (- self.x o) (- self.y o))))]

  [__rmul__ (fn [self factor]
    (Pos (* factor self.x) (* factor self.y)))]])

(def Pos.NORTH (Pos 0 1))
(def Pos.SOUTH (Pos 0 -1))
(def Pos.EAST (Pos 1 0))
(def Pos.WEST (Pos -1 0))

(def Pos.ORTHS [Pos.EAST Pos.NORTH Pos.WEST Pos.SOUTH])
  ; Ordered the same way angles are in coordinate geometry.
