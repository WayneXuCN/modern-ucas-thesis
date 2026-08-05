#import "../utils/bilingual-figured.typ"
#import "../utils/custom-figure.typ": thesis-bilingual-caption-style
#import "../utils/style.typ": get-fonts, 字号
#import "../utils/custom-numbering.typ": custom-numbering
#import "../utils/custom-heading.typ": (
  active-heading, current-heading, heading-display,
)
#import "../utils/citation-range-hyphen.typ": citation-range-hyphen
#import "../utils/unpairs.typ": unpairs

#let mainmatter(
  // documentclass 传入参数
  twoside: false,
  info: (:),
  fonts: (:),
  fontset: "mac",
  // 其他参数
  // 正文 1.25 倍行距，字体大小的 1.25 倍
  leading: 1.25em,
  // 正文段前段后 0 磅：段落间距 = 行距，无额外间距
  spacing: 1.25em,
  justify: true,
  first-line-indent: (amount: 2em, all: true),
  // 章节编号格式
  // 序号与题名间"空一个汉字符"（=1em=1 全角汉字宽）。
  // 用全角空格 U+3000（IDEOGRAPHIC SPACE）实现，其在 CJK 字体下宽度恒为 1em，
  // 均精确等于 1em。半角空格 U+0020 仅约 0.25em，不满足规范。
  numbering: custom-numbering.with(
    first-level: "第1章\u{3000}",
    depth: 4,
    "1.1\u{3000}",
  ),
  // 正文字体与字号参数
  text-args: auto,
  // 标题字体与字号
  heading-font: auto,
  heading-size: (字号.四号, 字号.小四, 字号.小四, 字号.小四),
  heading-weight: ("bold", "regular", "regular", "regular"),
  // 标题段前段后间距（规范值）
  // 一级标题：段前24pt，段后18pt
  // 二级标题：段前24pt，段后6pt
  // 三级标题：段前12pt，段后6pt
  // 四级标题：段前12pt，段后6pt
  heading-above: (24pt, 24pt, 12pt, 12pt),
  heading-below: (18pt, 6pt, 6pt, 6pt),
  heading-pagebreak: (true, false),
  heading-align: (center, auto),
  // 页眉
  header-render: auto,
  header-vspace: 0em,
  display-header: true,
  skip-on-first-level: true,
  // 页眉分隔线
  stroke-width: 0.8pt,
  reset-footnote: true,
  // caption 的 separator
  separator: "  ",
  // caption 样式
  caption-style: strong,
  caption-size: 字号.五号,
  ..args,
  it,
) = {
  // 0.  标志前言结束
  set page(numbering: "1")

  // 1.  默认参数
  info = (
    (
      title: ("基于 Typst 的", "中国科学院大学学位论文"),
    )
      + info
  )
  fonts = get-fonts(fontset) + fonts
  // 基础文字参数
  // 文字边缘设置，用于控制行高计算基准
  // "cap-height": 大写字母的大致高度
  // "baseline": 字母的基线
  let base-text-args = (top-edge: "cap-height", bottom-edge: "baseline")
  if (text-args == auto) {
    text-args = (font: fonts.宋体, size: 字号.小四) + base-text-args
  } else {
    // 合并用户自定义参数与边缘设置
    text-args = base-text-args + text-args
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
    // 如果值是数组，根据位置获取；如果是标量，直接使用该值
    if type(arr) == array {
      arr.at(calc.min(pos, arr.len()) - 1)
    } else {
      arr
    }
  }

  // 3.  设置基本样式
  // 3.1 文本和段落样式
  set text(..text-args)
  set par(
    leading: leading,
    spacing: spacing,
    justify: justify,
    first-line-indent: first-line-indent,
  )
  show raw: set text(font: fonts.等宽)

  // 3.2 脚注样式
  show footnote.entry: set text(font: fonts.宋体, size: 字号.五号)

  // 3.3 设置 figure 的编号
  show heading: bilingual-figured.reset-counters
  show figure: bilingual-figured.show-figure

  let bilingual-caption-style = thesis-bilingual-caption-style(fonts)
  show figure: bilingual-figured.show-bilingual.with(
    figure_style: bilingual-caption-style,
    table_style: bilingual-caption-style,
  )

  // 3.4 设置 equation 的编号和假段落首行缩进
  // 公式编号对齐到最后一行右侧（UCAS 规范：序号编于最后一行右顶格）
  set math.equation(number-align: bottom + end)
  // 公式编号字体：宋体。编号是 equation 元素渲染的文本部分，随 set text 生效；
  // 数学符号仍由 math 字体控制，不受影响。字号继承正文小四（规范要求五号 10.5pt，
  // 但 Typst 无法单独设编号字号而不影响公式正文，固有限制，详见 docs/CUSTOMIZE.md）。
  show math.equation.where(block: true): set text(font: fonts.宋体)
  show math.equation.where(block: true): bilingual-figured.show-equation

  // 3.5 表格表头置顶 + 不用冒号用空格分割 + 样式
  show figure.where(
    kind: table,
  ): set figure.caption(position: top)
  set figure.caption(separator: separator)
  show figure.caption: caption-style
  show figure.caption: set text(font: fonts.宋体, size: 字号.五号)

  // 3.6 顺序编码制参考文献引用：连续序号分隔符修正
  //     gb-7714-2015-numeric CSL 默认用 en dash"–"连接连续序号，UCAS 规范要求用 hyphen"-"。
  //     仅对参考文献引用（it.element == none）生效，图表/公式/标题引用原样返回。
  //     序号上标与多篇合并（[1,2]/[1-4]）由 CSL 默认提供，需用 @a@b 紧邻书写触发合并。
  show ref: citation-range-hyphen

  // 3.7 优化列表显示
  // 术语列表 terms 不应该缩进
  show terms: set par(first-line-indent: (amount: 0pt, all: true))

  // 4.  处理标题
  // 4.1 设置标题的 Numbering
  set heading(numbering: numbering)

  // 4.2 设置标题的段前段后间距
  show heading: it => {
    // block.above/below（块外间距）与 par.spacing（块内段落间距）取 max 而非叠加，
    // 故标题块外间距直接取规范值，无需为块内行距（leading 1em）额外补偿。
    let actual-above = array-at(heading-above, it.level)
    let actual-below = array-at(heading-below, it.level)
    set block(
      above: actual-above,
      below: actual-below,
    )
    it
  }

  // 4.3 设置标题的字体、字号、行距等样式
  show heading: it => {
    // 标题使用单倍行距
    set par(leading: 1em, spacing: 1em)
    // 设置标题字体、字号、加粗等样式
    set text(
      font: array-at(heading-font, it.level),
      size: array-at(heading-size, it.level),
      weight: array-at(heading-weight, it.level),
      ..unpairs(
        heading-text-args-lists.map(
          pair => (pair.at(0), array-at(pair.at(1), it.level)),
        ),
      ),
      top-edge: "cap-height",
      bottom-edge: "baseline",
    )
    it
  }

  // 4.4 标题居中与自动换页
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

  // 5.  处理页眉y页脚：页眉、页脚距页边界 1.5cm）
  //     不使用 page 的 header/footer + header-ascent/footer-descent（语义为"侵入 margin 的量"，
  //     无法精确表达"距边界 1.5cm"且会挤压正文区）。改用 page.foreground + place 绝对定位：
  //       place(top + center, dy: 1.5cm, ...)    —— 页眉锚定到页面顶边下方 1.5cm
  //       place(bottom + center, dy: -1.5cm, ...) —— 页脚锚定到页面底边上方 1.5cm
  //     Typst 的 number-align 不支持奇偶页交替，需自定义 footer 查询页码计数器。
  //     单面打印时居中；双面打印时奇数页(右页)右对齐、偶数页(左页)左对齐。
  //     页眉分隔线用 block(width: 100% - 3.17cm - 3.17cm) 约束到正文区宽度。
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

      // 查询当前页的一级标题；当前页没有则取当前位置之前最近的一级标题
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

      // 页眉渲染
      if current-heading != none {
        // 构造章节标题显示内容
        if (
          current-heading.has("numbering") and current-heading.numbering != none
        ) {
          let counter-values = counter(heading).at(
            current-heading.location(),
          )
          // 直接调用 heading 自身的 numbering 渲染章序号，
          // 而非硬编码"第1章"——这样附录（first-level 为空）的页眉
          // 不会错误显示"第1章"，而显示纯标题（如"附录"）。
          // 序号与章名间的"一个汉字符"由 numbering 模板内的全角空格
          // U+3000 提供，与正文标题保持一致。
          header-content = (current-heading.numbering)(..counter-values)
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

    // 渲染页脚（页码）：距页面底边 1.5cm，宋体小五号。
    // 单面居中；双面奇数页(右页)右对齐、偶数页(左页)左对齐。
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
        block(width: 100% - 3.17cm - 3.17cm)[
          #align(
            if twoside and calc.even(current-page) { left } else if twoside {
              right
            } else { center },
            counter(page).display("1"),
          )
        ]
      },
    )
  })
  context {
    if calc.even(here().page()) {
      // 双面打印时，如果当前页是偶数，插入空白页使正文从奇数页开始。
      // foreground: none 同时屏蔽页眉与页脚（原 header:none,footer:none 的等价语义）。
      set page(numbering: none, foreground: none)
      pagebreak() + " "
    }
  }
  counter(page).update(1)

  it
}
