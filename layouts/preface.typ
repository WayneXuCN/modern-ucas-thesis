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
  // 1.25 倍行距，字体大小的 1.25 倍
  leading: 1.25em,
  // 段前段后 0 磅：段落间距 = 行距，无额外间距
  spacing: 1.25em,
  justify: true,
  first-line-indent: (amount: 2em, all: true),
  // 章节编号格式
  numbering: custom-numbering.with(
    first-level: "第1章\u{3000}",
    depth: 3,
    "1.1\u{3000}",
  ),
  // 页眉
  header-render: auto,
  header-vspace: 0em,
  display-header: true,
  skip-on-first-level: true,
  // 页眉分隔线
  stroke-width: 0.8pt,
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

  // 3  页眉与页脚：页眉、页脚距页边界 1.5cm）
  // 不使用 page 的 header/footer + header-ascent/footer-descent（语义为"侵入 margin 的量"，
  // 无法精确表达"距边界 1.5cm"且会挤压正文区）。改用 page.foreground + place 绝对定位：
  //   place(top + center, dy: 1.5cm, ...)    —— 页眉锚定到页面顶边下方 1.5cm
  //   place(bottom + center, dy: -1.5cm, ...) —— 页脚锚定到页面底边上方 1.5cm
  // place 的父容器是整个页面（含 margin 区），dy 为正向下、负向上。
  // top-edge/bottom-edge: "bounds" 让文本框边界即字体边界，消除 ascender/descender 偏移，
  // 使 dy:1.5cm 精确等于"页眉文字顶边到页面顶边 1.5cm"。
  // 页眉分隔线用 block(width: 100% - 3.17cm - 3.17cm) 约束到正文区宽度（与左右页边距对齐）。
  set page(foreground: context {
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
      let current-page = here().page()
      let current-headings = query(heading.where(level: 1)).filter(
        h => h.location().page() == current-page,
      )
      let filtered-headings = if current-headings.len() > 0 {
        current-headings
      } else {
        query(selector(heading.where(level: 1)).before(here()))
      }
      let current-heading = if filtered-headings.len() > 0 {
        filtered-headings.last()
      } else { none }
      if current-heading != none {
        if (
          current-heading.has("numbering") and current-heading.numbering != none
        ) {
          let counter-values = counter(heading).at(
            current-heading.location(),
          )
          // 直接调用 heading 自身的 numbering 渲染章序号，
          // 而非硬编码"第1章"——附录等 first-level 为空的场景下
          // 页眉不会错误显示"第1章"。序号与章名间的"一个汉字符"
          // 由 numbering 模板内的全角空格 U+3000 提供。
          header-content = (current-heading.numbering)(..counter-values)
        }
        header-content += current-heading.body
      } else {
        header-content = "没有找到章标题"
      }
    } else {
      // 偶数页：显示论文标题
      // 规范：英文摘要偶数页标明英文题目，其余前置部分标明中文题目。
      // 判断方法：查询当前位置之前最近的一级标题（与奇数页分支同源 query 模式），
      // 若其文本含 "Abstract" 则当前处于英文摘要部分，用 info.title-en；否则用 info.title。
      let current-page-num = here().page()
      let current-headings = query(heading.where(level: 1)).filter(
        h => h.location().page() == current-page-num,
      )
      let recent-heading = if current-headings.len() > 0 {
        current-headings.last()
      } else {
        let before-headings = query(
          selector(heading.where(level: 1)).before(here()),
        )
        if before-headings.len() > 0 { before-headings.last() } else {
          none
        }
      }

      // 递归把 content 转为 str（复用 bilingual-bibliography.typ:38-50 的 to-string 模式）
      let content-to-str(c) = {
        if c == none { "" } else if type(c) == str { c } else if c.has("text") {
          c.text
        } else if c.has("children") {
          c.children.map(content-to-str).join("")
        } else if c.has("child") { content-to-str(c.child) } else if c.has(
          "body",
        ) { content-to-str(c.body) } else if c.has("supplement") {
          content-to-str(c.supplement)
        } else { "" }
      }

      let heading-text = content-to-str(
        if recent-heading != none { recent-heading.body } else { none },
      )
      let thesis-title = if heading-text.contains("Abstract") {
        info.title-en
      } else {
        info.title
      }

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

    // 渲染页眉：距页面顶边 1.5cm，宋体小五号，居中，下方 0.5em 处加正文区宽度的分隔线。
    // display-header 为 false 时省略页眉（仅保留 footnote 重置与页脚页码）。
    if display-header {
      place(
        top + center,
        dy: 1.5cm,
        {
          set text(
            font: fonts.宋体,
            size: 字号.小五,
            top-edge: "bounds",
            bottom-edge: "bounds",
          )
          block(width: 100% - 3.17cm - 3.17cm)[
            #align(center, header-content)
            #v(0.5em)
            #line(length: 100%, stroke: stroke-width + black)
          ]
        },
      )
    }

    // 渲染页脚（页码）：距页面底边 1.5cm，宋体小五号居中，大写罗马数字
    place(
      bottom + center,
      dy: -1.5cm,
      {
        set text(
          font: fonts.宋体,
          size: 字号.小五,
          top-edge: "bounds",
          bottom-edge: "bounds",
        )
        counter(page).display("I")
      },
    )
  })

  it
}
