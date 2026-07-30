///|
pub fn calibration_from_reference(
  pixel_distance : Double,
  physical_distance : Double,
) -> Double {
  if pixel_distance <= 0.0 {
    panic()
  }
  physical_distance / pixel_distance
}

///|
pub fn Point::scale(point : Point, factor : Double) -> Point {
  Point(x=point.x * factor, y=point.y * factor)
}

///|
pub fn Line::offset(line : Line, pixels : Double) -> Line {
  { ..line, c: line.c - pixels }
}
