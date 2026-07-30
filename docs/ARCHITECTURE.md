# Architecture

`moonbit-visual-caliper` separates measurement work into small stages that can be tested independently.

## Pipeline

1. `GrayImage` stores normalized grayscale values in row-major order.
2. `edge_profile` samples a line segment with bilinear interpolation.
3. `ProfileSample::detect_edges` finds gradient transitions and estimates subpixel positions.
4. `gauge_width` pairs the first and last detected transition as a width measurement.
5. `calibration_from_reference` converts pixels to physical units.
6. `Tolerance::judge` classifies the result as `Pass`, `Warn`, or `Fail`.
7. `render_markdown_report` emits a compact report for CI artifacts or inspection logs.

## Extension Points

- Add image decoders as optional adapter packages instead of coupling them to the core.
- Add Hough accumulator packages for robust line/circle search on dense edge maps.
- Add camera calibration models for lens distortion and affine transforms.
- Add report exporters for JSON, CSV, and HTML.

## Design Boundaries

The package owns its public measurement types in the root package, so generated `pkg.generated.mbti` remains easy to review. Implementation files are split by responsibility, but file names do not define namespaces in MoonBit.
