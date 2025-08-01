#import "@preview/i-figured:0.2.4"
#import "../utils/style.typ": get-fonts, 字号
#import "../utils/custom-numbering.typ": custom-numbering
#import "../utils/custom-heading.typ": (
  active-heading, current-heading, heading-display,
)
#import "../utils/unpairs.typ": unpairs

#let mainmatter(
  // documentclass 传入参数
  twoside: false,
  info: (:),
  fonts: (:),
  fontset: "mac",
  // 其他参数
  leading: 1.5 * 15.6pt - 0.7em,
  spacing: 1.5 * 15.6pt - 0.7em,
  justify: true,
  first-line-indent: (amount: 2em, all: true),
  numbering: custom-numbering.with(first-level: "第一章 ", depth: 4, "1.1 "),
  // 正文字体与字号参数
  text-args: auto,
  // 标题字体与字号
  heading-font: auto,
  heading-size: (字号.四号,),
  heading-weight: ("regular",),
  heading-above: (2 * 15.6pt - 0.7em, 2 * 15.6pt - 0.7em),
  heading-below: (2 * 15.6pt - 0.7em, 1.5 * 15.6pt - 0.7em),
  heading-pagebreak: (true, false),
  heading-align: (center, auto),
  // 页眉
  header-render: auto,
  header-vspace: 0em,
  display-header: false,
  skip-on-first-level: true,
  stroke-width: 0.5pt,
  reset-footnote: true,
  // caption 的 separator
  separator: "  ",
  // caption 样式
  caption-style: strong,
  caption-size: 字号.五号,
  // figure 计数
  show-figure: i-figured.show-figure,
  // equation 计数
  show-equation: i-figured.show-equation,
  ..args,
  it,
) = {
  // 0.  标志前言结束
  set page(numbering: "1")

  // 1.  默认参数

  // 1.  默认参数
  info = (
    (
      title: ("基于 Typst 的", "中国科学院大学学位论文"),
    )
      + info
  )
  fonts = get-fonts(fontset) + fonts
  if (text-args == auto) {
    text-args = (font: fonts.宋体, size: 字号.小四)
  }
  // 1.1 字体与字号
  if (heading-font == auto) {
    heading-font = (fonts.黑体,)
  }
  // 1.2 处理 heading- 开头的其他参数
  let heading-text-args-lists = args
    .named()
    .pairs()
    .filter(pair => pair.at(0).starts-with("heading-"))
    .map(pair => (pair.at(0).slice("heading-".len()), pair.at(1)))

  // 2.  辅助函数
  let array-at(arr, pos) = {
    arr.at(calc.min(pos, arr.len()) - 1)
  }

  // 3.  设置基本样式
  // 3.1 文本和段落样式
  set text(..text-args)
  set par(
    leading: leading,
    justify: justify,
    first-line-indent: first-line-indent,
    spacing: spacing,
  )
  show raw: set text(font: fonts.等宽)
  // 3.2 脚注样式
  show footnote.entry: set text(font: fonts.宋体, size: 字号.五号)
  // 3.3 设置 figure 的编号
  show heading: i-figured.reset-counters
  show figure: show-figure
  // 3.4 设置 equation 的编号和假段落首行缩进
  show math.equation.where(block: true): show-equation
  // 3.5 表格表头置顶 + 不用冒号用空格分割 + 样式
  show figure.where(
    kind: table,
  ): set figure.caption(position: top)
  set figure.caption(separator: separator)
  show figure.caption: caption-style
  show figure.caption: set text(font: fonts.宋体, size: 字号.五号)
  // 3.6 优化列表显示
  //     术语列表 terms 不应该缩进
  show terms: set par(first-line-indent: 0pt)

  // 4.  处理标题
  // 4.1 设置标题的 Numbering
  set heading(numbering: numbering)
  // 4.2 设置字体字号并加入假段落模拟首行缩进
  show heading: it => {
    set text(
      font: array-at(heading-font, it.level),
      size: array-at(heading-size, it.level),
      weight: array-at(heading-weight, it.level),
      ..unpairs(heading-text-args-lists.map(pair => (
        pair.at(0),
        array-at(pair.at(1), it.level),
      ))),
    )
    set block(above: array-at(heading-above, it.level), below: array-at(
      heading-below,
      it.level,
    ))
    it
  }
  // 4.3 标题居中与自动换页
  show heading: it => {
    if array-at(heading-pagebreak, it.level) {
      // 如果打上了 no-auto-pagebreak 标签，则不自动换页
      if "label" not in it.fields() or str(it.label) != "no-auto-pagebreak" {
        pagebreak(weak: true)
      }
    }
    if array-at(heading-align, it.level) != auto {
      set align(array-at(heading-align, it.level))
      it
    } else {
      it
    }
  }

  // 5.  处理页眉
  set page(..(
    if display-header {
      (
        header: context {
          // 重置 footnote 计数器
          if reset-footnote {
            counter(footnote).update(0)
          }

          // 获取当前页码
          let current-page = counter(page).get().first()

          // 判断是否为奇数页
          let is-odd-page = calc.odd(current-page)

          let header-content = ""

          if is-odd-page {
            // 奇数页：显示各章标题
            // 查询正文部分的一级标题（正文从mainmatter函数开始的页面开始）
            // 这里我们假设mainmatter从当前页开始，因为在mainmatter函数内部
            let chapter-headings = query(heading.where(level: 1))
              .filter(chapter => chapter.location().page() >= current-page)
            
            // 找到当前页面或之前页面的最新章节标题
            let prev-chapters = chapter-headings
              .filter(chapter => chapter.location().page() <= current-page)
            
            // 简化处理，直接取页面最大的章节
            let current-or-prev-chapter = if prev-chapters.len() > 0 {
              // 获取页面最大的章节
              let max-page = 0
              let max-chapter = none
              
              for chapter in prev-chapters {
                let chapter-page = chapter.location().page()
                if chapter-page >= max-page {
                  max-page = chapter-page
                  max-chapter = chapter
                }
              }
              max-chapter
            } else {
              // 如果没找到之前的章节，查找之后的第一个章节
              let next-chapters = chapter-headings
                .filter(chapter => chapter.location().page() > current-page)
              
              // 获取页面最小的章节
              if next-chapters.len() > 0 {
                let min-page = 9999
                let min-chapter = none
                
                for chapter in next-chapters {
                  let chapter-page = chapter.location().page()
                  if chapter-page <= min-page {
                    min-page = chapter-page
                    min-chapter = chapter
                  }
                }
                min-chapter
              } else {
                none
              }
            }
            
            if current-or-prev-chapter != none {
              // 使用找到的章节标题
              if current-or-prev-chapter.has("numbering") and current-or-prev-chapter.numbering != none {
                let counter-values = counter(heading).at(current-or-prev-chapter.location())
                header-content = custom-numbering(
                  first-level: "第一章 ",
                  depth: 4,
                  "1.1 ",
                  ..counter-values
                ) + " "
              }
              header-content += current-or-prev-chapter.body
            } else {
              header-content = "没有找到章标题"
            }
          } else {
            // 偶数页：显示论文标题
            // 确保正确获取论文标题
            let thesis-title = info.title
            if thesis-title != none {
              header-content = if type(thesis-title) == array {
                thesis-title.join("")
              } else {
                str(thesis-title)
              }
            }
            // 如果没有标题，使用默认
            if header-content == "" {
              header-content = "没有找到标题"
            }
          }

          // 渲染页眉
          set text(font: fonts.楷体, size: 字号.五号)

          // 显示页眉内容
          stack(
            align(center, header-content),
            v(0.25em),
            line(length: 100%, stroke: stroke-width + black),
          )
          
          v(header-vspace)
        },
      )
    } else {
      (
        header: {
          // 重置 footnote 计数器
          if reset-footnote {
            counter(footnote).update(0)
          }
        },
      )
    }
  ))
  context {
    if calc.even(here().page()) {
      set page(numbering: "I", header: none)
      // counter(page).update(1)
      pagebreak() + " "
    }
  }
  counter(page).update(1)

  it
}
