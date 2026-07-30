// Learn more about moon.mod configuration:
// https://docs.moonbitlang.com/en/latest/toolchain/moon/module.html
//
// To add a dependency, run this command in your terminal:
//   moon add moonbitlang/x
//
// Or manually declare it in `import`, for example:
// import {
//   "moonbitlang/x@0.4.6",
// }

name = "PaiGack/moonbit-visual-caliper"

version = "0.1.0"

readme = "README.mbt.md"

repository = "https://github.com/PaiGack/moonbit-visual-caliper"

license = "Apache-2.0"

keywords = [
  "industrial-vision",
  "caliper",
  "measurement",
  "geometry",
  "quality-control",
]

preferred_target = "wasm-gc"

description = "MoonBit-native industrial visual caliper toolkit for edge-based measurement and tolerance reports."
