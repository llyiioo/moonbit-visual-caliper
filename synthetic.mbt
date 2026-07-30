///|
pub fn make_demo_part() -> GrayImage {
  let image = GrayImage(width=80, height=40, fill=0.08)
  for y in 8..<32 {
    for x in 18..<62 {
      image.set(x, y, 0.88)
    }
  }
  for y in 10..<30 {
    image.set(18, y, 1.0)
    image.set(61, y, 1.0)
  }
  image
}
