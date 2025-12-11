#import "../utils/invisible-heading.typ": invisible-heading
#import "../utils/style.typ": get-fonts, 字号

// 目录生成
#let outline-page(
  // documentclass 传入参数
  twoside: false,
  fontset: "mac",
  fonts: (:),
  // 其他参数
  depth: 4,
  title: [报告提纲],
  outlined: false,
  title-above: 0pt,
  title-below: 0pt,
  title-text-args: auto,
  // 引用页数的字体，这里用于显示 Times New Roman
  reference-font: auto,
  reference-size: 字号.四号,
  // 字体与字号
  font: auto,
  size: (字号.四号, 字号.小四),
  // 垂直间距
  above: (22pt, 15pt),
  below: (16pt, 15pt),
  indent: (0pt, 12pt, 12pt),
  // 全都显示点号
  fill: (repeat([·], gap: 0.2em), repeat(text([·], size: 0.9em), gap: 0.15em)),
  inset: ((left: 2pt, right: 24pt), (left: 0.3em, right: 18pt)),
  gap: .3em,
  ..args,
) = {
  // 1.  默认参数
  fonts = get-fonts(fontset) + fonts
  if title-text-args == auto {
    title-text-args = (font: fonts.黑体, size: 字号.四号)
  }
  // 引用页数的字体，这里用于显示 Times New Roman
  if reference-font == auto {
    reference-font = fonts.宋体
  }
  // 字体与字号
  if font == auto {
    font = (fonts.黑体, fonts.黑体)
  }

  // 2.  正式渲染
  pagebreak(weak: true, to: if twoside { "odd" })

  // 默认显示的字体
  set text(font: reference-font, size: reference-size)

  v(title-above)
  {
    set align(center)
    text(..title-text-args, title)
    // 标记一个不可见的标题用于目录生成
    invisible-heading(level: 1, outlined: outlined, title)
  }

  v(title-below)

  // 目录样式
  set outline(indent: level => indent
    .slice(0, calc.min(level + 1, indent.len()))
    .sum())
  show outline.entry: entry => block(
    above: above.at(entry.level - 1, default: above.last()),
    below: below.at(entry.level - 1, default: below.last()),
    link(entry.element.location(), entry.indented(
      none,
      {
        text(
          font: font.at(entry.level - 1, default: font.last()),
          size: size.at(entry.level - 1, default: size.last()),
          {
            if entry.prefix() not in (none, []) {
              entry.prefix()
              h(gap)
            }
            entry.body()
          },
        )
        box(
          width: 1fr,
          inset: inset.at(entry.level - 1, default: inset.last()),
          fill.at(
            entry.level - 1,
            default: fill.last(),
          ),
        )
        entry.page()
      },
      gap: 0pt,
    )),
  )

  // 显示目录
  outline(title: none, depth: depth)
}
