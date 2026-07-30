///|
fn lerp_point(a : Point, b : Point, t : Double) -> Point {
  Point(x=a.x + (b.x - a.x) * t, y=a.y + (b.y - a.y) * t)
}

///|
fn matches_mode(mode : EdgeMode, gradient : Double) -> Bool {
  match mode {
    Rising => gradient > 0.0
    Falling => gradient < 0.0
    Both => gradient != 0.0
  }
}

///|
pub fn edge_profile(
  image : GrayImage,
  start : Point,
  finish : Point,
  steps? : Int = 96,
) -> Array[ProfileSample] {
  let n = if steps < 2 { 2 } else { steps }
  let samples : Array[ProfileSample] = []
  for i in 0..<n {
    let t = Double::from_int(i) / Double::from_int(n - 1)
    let p = lerp_point(start, finish, t)
    let value = image.sample_bilinear(p)
    let gradient = if i == 0 { 0.0 } else { value - samples[i - 1].value }
    samples.push({ point: p, value, gradient })
  }
  samples
}

///|
fn subpixel_edge(
  previous : ProfileSample,
  current : ProfileSample,
  threshold : Double,
) -> EdgePoint {
  let g0 = previous.gradient.abs()
  let g1 = current.gradient.abs()
  let total = g0 + g1
  let t = if total <= 0.0 { 1.0 } else { (threshold - g0) / total }
  let clamped = t.clamp(min=0.0, max=1.0)
  {
    point: lerp_point(previous.point, current.point, clamped),
    strength: current.gradient.abs(),
    polarity: if current.gradient >= 0.0 {
      1
    } else {
      -1
    },
  }
}

///|
pub fn ProfileSample::detect_edges(
  samples : Array[ProfileSample],
  threshold : Double,
  mode? : EdgeMode = Both,
) -> Array[EdgePoint] {
  let edges : Array[EdgePoint] = []
  for i in 1..<samples.length() {
    let current = samples[i]
    if current.gradient.abs() >= threshold &&
      matches_mode(mode, current.gradient) {
      edges.push(subpixel_edge(samples[i - 1], current, threshold))
    }
  }
  edges
}

///|
pub fn gauge_width(
  image : GrayImage,
  start : Point,
  finish : Point,
  threshold? : Double = 0.15,
) -> Double {
  let samples = edge_profile(image, start, finish)
  let edges = ProfileSample::detect_edges(samples, threshold, mode=Both)
  if edges.length() < 2 {
    panic()
  }
  distance(edges[0].point, edges[edges.length() - 1].point)
}
