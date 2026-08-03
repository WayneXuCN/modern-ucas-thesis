#import "../utils/bilingual-figured.typ"
#import "../utils/custom-numbering.typ": custom-numbering

// 后记，重置 heading 计数器
#let appendix(
  numbering: custom-numbering.with(first-level: "", depth: 4, "1.1 "),
  // figure 计数
  show-figure: bilingual-figured.show-figure.with(numbering: "1-1"),
  // equation 计数
  show-equation: bilingual-figured.show-equation.with(numbering: "(1-1)"),
  // 重置计数
  reset-counter: false,
  it,
) = {
  set heading(numbering: numbering)
  // 公式编号对齐到最后一行右侧（UCAS 规范：序号编于最后一行右顶格）
  set math.equation(number-align: bottom + end)
  if reset-counter {
    counter(heading).update(0)
  }
  // 设置 figure 的编号
  show figure: show-figure
  // 设置 equation 的编号
  show math.equation.where(block: true): show-equation
  it
}
