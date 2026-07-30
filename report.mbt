///|
fn decision_text(decision : MeasurementDecision) -> String {
  match decision {
    Pass => "PASS"
    Warn => "WARN"
    Fail => "FAIL"
  }
}

///|
pub fn render_markdown_report(report : MeasurementReport) -> String {
  let out = StringBuilder()
  out.write_string("# Visual Caliper Report\n\n")
  out.write_string("Part: ")
  out.write_string(report.part_id)
  out.write_string("\n\n")
  out.write_string("| Item | Value | Deviation | Decision |\n")
  out.write_string("| --- | ---: | ---: | --- |\n")
  for m in report.measurements {
    out.write_string("| ")
    out.write_string(m.name)
    out.write_string(" | ")
    out.write_string(m.value.to_string())
    out.write_string(" ")
    out.write_string(m.unit)
    out.write_string(" | ")
    out.write_string(m.deviation.to_string())
    out.write_string(" ")
    out.write_string(m.unit)
    out.write_string(" | ")
    out.write_string(decision_text(m.decision))
    out.write_string(" |\n")
  }
  if !report.notes.is_empty() {
    out.write_string("\n## Notes\n")
    for note in report.notes {
      out.write_string("- ")
      out.write_string(note)
      out.write_string("\n")
    }
  }
  out.to_string()
}
