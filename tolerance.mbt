///|
pub fn Tolerance::Tolerance(
  nominal~ : Double,
  lower~ : Double,
  upper~ : Double,
  unit? : String = "mm",
) -> Tolerance {
  if lower > upper {
    panic()
  }
  { nominal, lower, upper, unit }
}

///|
pub fn Tolerance::judge(
  tolerance : Tolerance,
  value : Double,
) -> MeasurementDecision {
  if value < tolerance.lower || value > tolerance.upper {
    Fail
  } else {
    let band = tolerance.upper - tolerance.lower
    let margin = (value - tolerance.lower).min(tolerance.upper - value)
    if band > 0.0 && margin / band < 0.1 {
      Warn
    } else {
      Pass
    }
  }
}

///|
pub fn analyze_gap(
  name : String,
  pixel_gap : Double,
  scale : Double,
  tolerance : Tolerance,
) -> Measurement {
  let value = pixel_gap * scale
  {
    name,
    value,
    unit: tolerance.unit,
    decision: tolerance.judge(value),
    deviation: value - tolerance.nominal,
  }
}
