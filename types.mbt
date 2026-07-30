///|
pub(all) struct Point {
  x : Double
  y : Double
} derive(Debug)

///|
pub fn Point::Point(x~ : Double, y~ : Double) -> Point {
  { x, y }
}

///|
pub(all) struct Line {
  a : Double
  b : Double
  c : Double
} derive(Debug)

///|
pub fn Line::Line(a~ : Double, b~ : Double, c~ : Double) -> Line {
  let norm = (a * a + b * b).sqrt()
  if norm <= 0.0 {
    { a: 0.0, b: 1.0, c: 0.0 }
  } else {
    { a: a / norm, b: b / norm, c: c / norm }
  }
}

///|
pub(all) struct Circle {
  center : Point
  radius : Double
  rms_error : Double
} derive(Debug)

///|
pub(all) enum EdgeMode {
  Rising
  Falling
  Both
} derive(Debug, Eq)

///|
pub(all) struct EdgePoint {
  point : Point
  strength : Double
  polarity : Int
} derive(Debug)

///|
pub(all) struct ProfileSample {
  point : Point
  value : Double
  gradient : Double
} derive(Debug)

///|
pub(all) struct Tolerance {
  nominal : Double
  lower : Double
  upper : Double
  unit : String
} derive(Debug)

///|
pub(all) enum MeasurementDecision {
  Pass
  Warn
  Fail
} derive(Debug, Eq)

///|
pub(all) struct Measurement {
  name : String
  value : Double
  unit : String
  decision : MeasurementDecision
  deviation : Double
} derive(Debug)

///|
pub(all) struct MeasurementReport {
  part_id : String
  measurements : Array[Measurement]
  notes : Array[String]
} derive(Debug)

///|
pub fn distance(a : Point, b : Point) -> Double {
  let dx = a.x - b.x
  let dy = a.y - b.y
  (dx * dx + dy * dy).sqrt()
}

///|
pub fn Line::distance_to(line : Line, p : Point) -> Double {
  (line.a * p.x + line.b * p.y + line.c).abs()
}
