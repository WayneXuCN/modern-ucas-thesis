#import "../utils/bilingual-figured.typ"
#import "../utils/style.typ": get-fonts, 字号
#import "../utils/custom-numbering.typ": custom-numbering
#import "../utils/citation-range-hyphen.typ": citation-range-hyphen

// 附录图表"参考正文的编号方式，如附图1-1或附表1-1"，
// 即附录中图/表的前缀须为"附图/附表"（英文 Appendix Figure / Appendix Table），
// 与正文的"图/表"区分。supplement 写在双语 caption 的 metadata 中、绕开
// Typst 原生 supplement 字段，故须在 show-figure 重建 figure 时改写 metadata。
// 此函数按 kind 自动选择附图/附表前缀，再交由通用 show-figure 重建。
#let _appendix-show-figure(
  numbering: "1-1",
  supplement-zh-figure: [附图],
  supplement-en-figure: [Appendix Figure],
  supplement-zh-table: [附表],
  supplement-en-table: [Appendix Table],
  it,
) = {
  let is-table = (
    bilingual-figured.is-kind(it.kind, "bitable")
      or bilingual-figured.is-kind(
        it.kind,
        "table",
      )
  )
  bilingual-figured.show-figure(
    it,
    numbering: numbering,
    supplement-zh: if is-table { supplement-zh-table } else {
      supplement-zh-figure
    },
    supplement-en: if is-table { supplement-en-table } else {
      supplement-en-figure
    },
  )
}

// 后记，重置 heading 计数器
#let appendix(
  // documentclass 传入参数
  twoside: false,
  fontset: "mac",
  fonts: (:),
  numbering: custom-numbering.with(first-level: "", depth: 4, "1.1\u{3000}"),
  // figure 计数（附录图表前缀为"附图/附表"，编号 1-1）
  show-figure: _appendix-show-figure.with(numbering: "1-1"),
  // equation 计数
  show-equation: bilingual-figured.show-equation.with(numbering: "(1-1)"),
  // 重置计数：附录作为独立编号单元，图表/公式编号从 1 开始（附图1-1、附表1-1），
  // 而非继承正文章号（否则会显示附图4-1）。reset-counter 同时重置 heading 计数器，
  // 不影响附录标题显示（first-level 为空）及后续致谢/简历（同样无章号）。
  reset-counter: true,
  it,
) = {
  // 附录须由另页右页（奇数页）开始（双面印刷时）。
  // 与摘要/目录/致谢/简历等部分一致，由函数内部 pagebreak(to:"odd") 自包含处理，
  // 单面时 to:"odd" 退化为普通分页（无奇偶概念）。
  pagebreak(weak: true, to: if twoside { "odd" })
  fonts = get-fonts(fontset) + fonts
  set heading(numbering: numbering)
  // 标记附录模式：bifigure/bitable 经 _appendix-show-figure 改写前缀为"附图/附表"，
  // auto-table 等通过 in-appendix() 读取此标记自行解析 supplement。
  bilingual-figured.enter-appendix-mode()
  // UCAS 规范：附录在目录中只列一级标题（与参考文献/致谢等"其他"项一致），
  // 故将附录二、三、四级标题排除出目录。outlined: false 仅影响目录收录，
  // 不影响编号显示（附录子节仍按 1.1 / 1.1.1 编号）。
  show heading.where(level: 2): set heading(outlined: false)
  show heading.where(level: 3): set heading(outlined: false)
  show heading.where(level: 4): set heading(outlined: false)
  // 公式编号对齐到最后一行右侧（UCAS 规范：序号编于最后一行右顶格）
  set math.equation(number-align: bottom + end)
  // 公式编号字体：宋体（与正文 mainmatter 一致；字号继承正文，Typst 固有限制）
  show math.equation.where(block: true): set text(font: fonts.宋体)
  if reset-counter {
    counter(heading).update(0)
  }
  // 设置 figure 的编号
  show figure: show-figure
  // 设置 equation 的编号
  show math.equation.where(block: true): show-equation
  // 顺序编码制参考文献引用：连续序号分隔符修正（与正文 mainmatter 一致）
  show ref: citation-range-hyphen
  it
}
