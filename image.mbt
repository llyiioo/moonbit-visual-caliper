///|
pub(all) struct GrayImage {
  width : Int
  height : Int
  pixels : Array[Double]
} derive(Debug)

///|
pub fn GrayImage::GrayImage(
  width~ : Int,
  height~ : Int,
  fill? : Double = 0.0,
) -> GrayImage {
  { width, height, pixels: Array::make(width * height, fill) }
}

///|
pub fn GrayImage::from_rows(rows : Array[Array[Double]]) -> GrayImage {
  let height = rows.length()
  let width = if height == 0 { 0 } else { rows[0].length() }
  let pixels : Array[Double] = []
  for row in rows {
    if row.length() != width {
      panic()
    }
    for value in row {
      pixels.push(value)
    }
  }
  { width, height, pixels }
}

///|
pub fn GrayImage::inside(image : GrayImage, x : Int, y : Int) -> Bool {
  x >= 0 && y >= 0 && x < image.width && y < image.height
}

///|
pub fn GrayImage::at(image : GrayImage, x : Int, y : Int) -> Double {
  if image.inside(x, y) {
    image.pixels[y * image.width + x]
  } else {
    0.0
  }
}

///|
pub fn GrayImage::set(
  image : GrayImage,
  x : Int,
  y : Int,
  value : Double,
) -> Unit {
  if image.inside(x, y) {
    image.pixels[y * image.width + x] = value
  }
}

///|
pub fn GrayImage::sample_bilinear(image : GrayImage, p : Point) -> Double {
  let x0 = p.x.floor().to_int()
  let y0 = p.y.floor().to_int()
  let x1 = x0 + 1
  let y1 = y0 + 1
  let tx = p.x - Double::from_int(x0)
  let ty = p.y - Double::from_int(y0)
  let a = image.at(x0, y0) * (1.0 - tx) + image.at(x1, y0) * tx
  let b = image.at(x0, y1) * (1.0 - tx) + image.at(x1, y1) * tx
  a * (1.0 - ty) + b * ty
}

///|
pub fn GrayImage::sobel_magnitude(
  image : GrayImage,
  x : Int,
  y : Int,
) -> Double {
  let gx = -image.at(x - 1, y - 1) +
    image.at(x + 1, y - 1) -
    2.0 * image.at(x - 1, y) +
    2.0 * image.at(x + 1, y) -
    image.at(x - 1, y + 1) +
    image.at(x + 1, y + 1)
  let gy = -image.at(x - 1, y - 1) -
    2.0 * image.at(x, y - 1) -
    image.at(x + 1, y - 1) +
    image.at(x - 1, y + 1) +
    2.0 * image.at(x, y + 1) +
    image.at(x + 1, y + 1)
  (gx * gx + gy * gy).sqrt()
}

///|
pub fn GrayImage::threshold_edges(
  image : GrayImage,
  threshold : Double,
) -> Array[EdgePoint] {
  let edges : Array[EdgePoint] = []
  for y in 1..<(image.height - 1) {
    for x in 1..<(image.width - 1) {
      let strength = image.sobel_magnitude(x, y)
      if strength >= threshold {
        edges.push({
          point: Point(x=Double::from_int(x), y=Double::from_int(y)),
          strength,
          polarity: 0,
        })
      }
    }
  }
  edges
}
