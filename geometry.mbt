///|
pub fn fit_line(points : Array[Point]) -> Line {
  if points.length() < 2 {
    panic()
  }
  let n = Double::from_int(points.length())
  let mut sx = 0.0
  let mut sy = 0.0
  for p in points {
    sx += p.x
    sy += p.y
  }
  let cx = sx / n
  let cy = sy / n
  let mut sxx = 0.0
  let mut sxy = 0.0
  let mut syy = 0.0
  for p in points {
    let dx = p.x - cx
    let dy = p.y - cy
    sxx += dx * dx
    sxy += dx * dy
    syy += dy * dy
  }
  if sxy.abs() <= 0.0000001 && sxx >= syy {
    Line(a=0.0, b=1.0, c=-cy)
  } else if sxy.abs() <= 0.0000001 {
    Line(a=1.0, b=0.0, c=-cx)
  } else {
    let theta = 0.5 * (2.0 * sxy / (sxx - syy + 0.0000001))
    let slope = theta
    Line(a=-slope, b=1.0, c=slope * cx - cy)
  }
}

///|
pub fn detect_dominant_line(edges : Array[EdgePoint]) -> Line {
  fit_line(edges.map(fn(edge) { edge.point }))
}

///|
pub fn detect_circle_from_points(points : Array[Point]) -> Circle {
  if points.length() < 3 {
    panic()
  }
  let mut sx = 0.0
  let mut sy = 0.0
  for p in points {
    sx += p.x
    sy += p.y
  }
  let center = Point(
    x=sx / Double::from_int(points.length()),
    y=sy / Double::from_int(points.length()),
  )
  let mut radius = 0.0
  for p in points {
    radius += distance(center, p)
  }
  radius = radius / Double::from_int(points.length())
  let mut err = 0.0
  for p in points {
    let d = distance(center, p) - radius
    err += d * d
  }
  {
    center,
    radius,
    rms_error: (err / Double::from_int(points.length())).sqrt(),
  }
}
