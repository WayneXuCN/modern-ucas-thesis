#import "../utils/style.typ": get-fonts, 字号
#import "../utils/custom-numbering.typ": custom-numbering

// 前言
#let preface(
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
  numbering: custom-numbering.with(first-level: "第一章 ", depth: 3, "1.1 "),
  // 页眉
  header-render: auto,
  header-vspace: 0em,
  display-header: true,
  skip-on-first-level: true,
  stroke-width: 0.5pt,
  reset-footnote: true,
  ..args,
  it,
) = {
  // 1.  默认参数
  info = (
    (
      title: ("基于 Typst 的", "中国科学院大学学位论文"),
    )
      + info
  )
  fonts = get-fonts(fontset) + fonts

  // 2. 分页
  if twoside {
    pagebreak() + " "
  }
  counter(page).update(0)
  set page(numbering: "I")


  // 3. 处理页眉
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

          // 初始化页眉
          let header-content = ""

          if is-odd-page {
            // 奇数页：显示当前页的一级标题
            let all-headings = query(heading.where(level: 1))
            let current-position = here().position().page
            let current-heading = all-headings.filter(h => h.location().page() <= current-position).last()
            if current-heading != none {
              if current-heading.has("numbering") and current-heading.numbering != none {
                import "../utils/custom-numbering.typ": custom-numbering
                let counter-values = counter(heading).at(current-heading.location())
                header-content = (
                  custom-numbering(
                    first-level: "第一章 ",
                    depth: 3,
                    "1.1 ",
                    ..counter-values,
                  )
                    + " "
                )
              }
              header-content += current-heading.body
            } else {
              header-content = "没有找到章标题"
            }
          } else {
            // 偶数页：显示论文标题
            let thesis-title = info.title
            if thesis-title != none {
              header-content = if type(thesis-title) == array {
                thesis-title.join("")
              } else {
                str(thesis-title)
              }
            }
            if header-content == "" {
              header-content = "没有找到标题"
            }
          }

          // 渲染页眉
          set text(font: fonts.宋体, size: 字号.小五)

          // 显示页眉内容
          stack(
            align(center, header-content),
            v(0.5em),
            line(length: 100%, stroke: stroke-width + black),
          )

          v(header-vspace)
        },
      )
    } else {
      (
        header: {
          if reset-footnote {
            counter(footnote).update(0)
          }
        },
      )
    }
  ))

  it
}
