///|
test "edge caliper measures synthetic part width" {
  let image = make_demo_part()
  let width = gauge_width(
    image,
    Point::Point(x=10.0, y=20.0),
    Point::Point(x=70.0, y=20.0),
  )
  assert_true(width > 42.0 && width < 46.0)
}

///|
test "tolerance decisions classify measurements" {
  let tol = Tolerance::Tolerance(nominal=10.0, lower=9.5, upper=10.5, unit="mm")
  debug_inspect(tol.judge(10.0), content="Pass")
  debug_inspect(tol.judge(9.52), content="Warn")
  debug_inspect(tol.judge(11.0), content="Fail")
}

///|
test "markdown report includes measurement decision" {
  let report : MeasurementReport = {
    part_id: "fixture-01",
    measurements: [
      { name: "slot", value: 12.0, unit: "mm", decision: Pass, deviation: 0.1 },
    ],
    notes: ["checked on synthetic profile"],
  }
  let text = render_markdown_report(report)
  assert_true(text.contains("fixture-01"))
  assert_true(text.contains("PASS"))
}

///|
test "calibration converts pixels to physical units" {
  let scale = calibration_from_reference(200.0, 10.0)
  assert_true(scale.is_close(0.05))
  let m = analyze_gap(
    "pin spacing",
    200.0,
    scale,
    Tolerance::Tolerance(nominal=10.0, lower=9.9, upper=10.1),
  )
  debug_inspect(m.decision, content="Pass")
}

///|
test "line fitting handles horizontal points" {
  let line = fit_line([
    Point::Point(x=0.0, y=3.0),
    Point::Point(x=4.0, y=3.0),
    Point::Point(x=8.0, y=3.0),
  ])
  assert_true(line.distance_to(Point::Point(x=2.0, y=3.0)).is_close(0.0))
}

///|
test "circle detection estimates radius" {
  let circle = detect_circle_from_points([
    Point::Point(x=2.0, y=0.0),
    Point::Point(x=-2.0, y=0.0),
    Point::Point(x=0.0, y=2.0),
    Point::Point(x=0.0, y=-2.0),
  ])
  assert_true(circle.radius.is_close(2.0))
  assert_true(circle.rms_error.is_close(0.0))
}
