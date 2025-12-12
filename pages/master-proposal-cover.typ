#import "../utils/datetime-display.typ": datetime-display, datetime-en-display
#import "../utils/justify-text.typ": justify-text
#import "../utils/style.typ": get-fonts, 字号

// 硕士研究生封面
#let master-proposal-cover(
  // documentclass 传入的参数
  process: "proposal", // "proposal" | "interim"
  nl-cover: false,
  twoside: false,
  fontset: "mac",
  fonts: (:),
  info: (:),
  // 其他参数
  stoke-width: 0.75pt, // 控制元素边框（如框架、分隔线等）的线宽度。
  info-inset: (
    x: 0pt,
    bottom: 1pt,
  ), // 控制信息区域的内边距。x 左右间距，bottom 底部间距
  info-width-ratio: 82%, // 控制信息框整体宽度（即所有信息列的总宽），当文章标题太长时可以调整这个参数
  info-column-gutter: 0pt, // 控制信息列之间的间距。
  info-row-gutter: 7pt, // 控制信息行之间的间距。
  defence-info-inset: (x: 0pt, bottom: 0pt), // 控制答辩信息区域的内边距。
  datetime-display: datetime-display, // 用于格式化日期显示。
) = {
  // 1.  默认参数
  fonts = get-fonts(fontset) + fonts
  info = (
    (
      title: "基于 Typst 的中国科学院大学学位论文",
      title-en: "Typst Thesis Template of UCAS",
      supervisors: ("李四 教授", "王五 研究员"),
      supervisors-en: ("Professor Si Li", "Professor Wu Wang"),
      grade: "20XX",
      student-id: "1234567890",
      author: "张三",
      department: "XX 研究所",
      major: "某专业",
      supervisor: ("李四", "教授"),
      submit-date: datetime.today(),
    )
      + info
  )

  // 2.  对参数进行处理
  // 2.1 如果是字符串，则使用换行符将标题分隔为列表
  if type(info.title) == str {
    info.title = info.title.split("\n")
  }
  if type(info.supervisor) == str {
    info.supervisor = info.supervisor.split("\n")
  }
  // 2.3 处理日期
  assert(
    type(info.submit-date) == datetime,
    message: "submit-date must be datetime.",
  )

  // 3.  内置辅助函数
  let info-key(body, info-inset: info-inset, is-meta: false) = {
    set text(
      font: if is-meta {
        fonts.宋体
      } else {
        fonts.宋体
      },
      size: if is-meta {
        字号.小五
      } else {
        字号.小三
      },
      weight: if is-meta {
        "regular"
      } else {
        "bold"
      },
    )
    rect(
      width: 100%,
      inset: info-inset,
      stroke: none,
      justify-text(with-tail: is-meta, body),
    )
  }

  let info-value(
    body,
    info-inset: info-inset,
    no-stroke: false,
  ) = {
    set align(center)
    rect(
      width: 100%,
      inset: info-inset,
      text(
        font: fonts.宋体,
        weight: "bold",
        size: 字号.小三,
        bottom-edge: "descender",
        body,
      ),
      stroke: if no-stroke {
        none
      } else {
        (bottom: stoke-width + black)
      },
    )
  }

  // set page(
  //   background: image("../中期报告-朱家祺.svg", width: 100%),
  //   // 也可以调整 opacity 让背景淡一点，但 Typst 目前 image opacity 支持有限，
  //   // 通常直接用图就行，或者用图片编辑软件把图弄淡。
  // )
  // 4.  正式渲染
  pagebreak(weak: true)

  v(25pt)

  // 居中对齐
  set align(center)

  // 封面图标
  image("../assets/vi/ucas-logo-H.svg", height: 2.26cm)

  v(-6pt)
  let cover_title = (
    "研究生学位论文"
      + if process == "proposal" {
        "开题"
      } else {
        "中期"
      }
      + "报告"
  )

  text(
    size: 字号.一号,
    font: fonts.黑体,
    weight: "bold",
    top-edge: "ascender",
    cover_title,
  )

  v(173pt)

  block(
    layout(size => {
      // 动态计算，使得col3永远能够居中显示
      // 将margin去掉后页面能用的宽度
      let block_width = size.width
      // 注：info-key和info-value字号都是小三
      let col1wid = calc.ceil(字号.小三.pt() * 4) * 1pt
      let col2wid = calc.ceil(block_width.pt() / 2 - col1wid.pt()) * 1pt
      let col3wid = calc.ceil(字号.小三.pt() * 2) * 1pt
      let col4wid = calc.ceil(block_width.pt() / 2 - col3wid.pt()) * 1pt
      grid(
        columns: (col1wid, col2wid, col3wid, col4wid),
        column-gutter: info-column-gutter,
        row-gutter: info-row-gutter,
        grid.cell(align: left, info-key("报告题目")),
        grid.cell(colspan: 3, info-value(info.title.sum())),
        info-key("学生姓名"),
        info-value(info.author),
        info-key("学号"),
        // 纯英文的学号会上浮，暂时用spacing来解决
        // 仅对Times New Roman比较合适，其他字体可能会有问题
        info-value([#v(1.6pt) #info.student-id]),
        info-key("指导教师"),
        info-value(info.supervisor.at(0)),
        info-key("职称"),
        info-value(info.supervisor.at(1)),
        info-key("学位类别"),
        grid.cell(colspan: 3, info-value(info.category)),
        info-key("学科专业"),
        grid.cell(colspan: 3, info-value(info.major)),
        info-key("研究方向"),
        grid.cell(colspan: 3, info-value(info.interest)),
        info-key("培养单位"),
        grid.cell(colspan: 3, info-value(info.department)),
        info-key("填表日期"),
        grid.cell(colspan: 3, info-value(datetime-display(info.submit-date))),
      )
    }),
    width: info-width-ratio,
  )

  v(38pt)

  text(font: fonts.宋体, size: 字号.小三, weight: "bold", "中国科学院大学制")

  // 第二页
  if twoside {
    pagebreak(
      weak: true,
      to: "odd",
    )
  }
}
