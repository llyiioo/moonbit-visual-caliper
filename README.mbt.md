# moonbit-visual-caliper

MoonBit 工业视觉卡尺，面向尺寸测量、边缘定位和质量判定场景。项目核心是一个纯 MoonBit 测量库：从灰度图采样开始，沿测量线生成剖面，定位边缘转折，再完成像素到物理单位换算、公差判断和 Markdown 报告输出。

这个项目不是通用图像处理框架，而是更垂直的“视觉量规”工具。它可以作为工厂视觉检测、教学演示、MoonBit 图像算法样例和后续相机/文件解码适配层的基础。

## Features

- `GrayImage`：轻量灰度图容器，支持双线性采样和 Sobel 边缘强度。
- `edge_profile`：沿任意测量线采样，生成一维灰度/梯度剖面。
- `ProfileSample::detect_edges`：支持 rising/falling/both 三种边缘极性。
- `gauge_width`：基于边缘对测量宽度，包含亚像素插值。
- `fit_line` / `detect_circle_from_points`：提供直线与圆的几何拟合入口。
- `calibration_from_reference`：用标准件把像素距离换算为毫米等物理单位。
- `Tolerance::judge` / `analyze_gap`：输出 PASS/WARN/FAIL 判定与偏差。
- `render_markdown_report`：生成可提交、可归档的测量报告。

## Quick Start

```bash
moon check --deny-warn
moon test --deny-warn
moon run cmd/main
```

The demo CLI builds a synthetic bracket-like part and reports its measured outer width.

```mbt check
///|
test "README quick measurement" {
  let image = make_demo_part()
  let gap = gauge_width(
    image,
    Point::Point(x=10.0, y=20.0),
    Point::Point(x=70.0, y=20.0),
  )
  let scale = calibration_from_reference(gap, 22.0)
  let tol = Tolerance::Tolerance(nominal=22.0, lower=21.8, upper=22.2)
  let m = analyze_gap("outer width", gap, scale, tol)
  debug_inspect(m.decision, content="Pass")
}
```

## Project Layout

- `types.mbt`：点、线、圆、边缘点、测量结果等公共类型。
- `image.mbt`：灰度图、采样、Sobel 边缘强度。
- `profile.mbt`：测量线剖面、亚像素边缘、卡尺宽度。
- `geometry.mbt`：直线和圆的几何拟合。
- `calibration.mbt`：标定与几何单位换算。
- `tolerance.mbt`：公差带判断与测量项生成。
- `report.mbt`：Markdown 报告渲染。
- `synthetic.mbt`：可重复的内置演示样件。
- `cmd/main`：命令行演示入口。

## Competition Notes

在 mooncakes.io 上检索后，MoonBit 生态已有通用图像处理、图像解码、SVG/图形等项目；本项目定位为工业测量 pipeline，避免和成熟通用图像库高度重叠。后续可以接入解码库或相机数据源，但本仓库先把测量核心保持为零 FFI、可测试、可跨后端运行的 MoonBit 包。

## License

Apache-2.0.
