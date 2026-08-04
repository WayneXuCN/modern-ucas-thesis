#import "../utils/style.typ": get-fonts, 字号
#import "../utils/double-underline.typ": double-underline
#import "../utils/invisible-heading.typ": invisible-heading
#import "../utils/supervisor.typ": normalize-supervisors

// 本科生英文摘要页
#let bachelor-abstract-en(
  // documentclass 传入的参数
  anonymous: false,
  twoside: false,
  fontset: "mac",
  fonts: (:),
  info: (:),
  // 其他参数
  keywords: (),
  outline-title: "Abstract",
  outlined: false,
  anonymous-info-keys: ("author-en", "supervisors-en"),
  leading: 1.28em,
  spacing: 1.38em,
  body,
) = {
  // 1.  默认参数
  fonts = get-fonts(fontset) + fonts
  info = (
    (
      title-en: "UCAS Thesis Template for Typst",
      author-en: "Zhang San",
      department-en: "XX Department",
      major-en: "XX Major",
      supervisors-en: (
        (name: "Si Li", title: "Professor", affiliation: ""),
      ),
    )
      + info
  )

  // 2.  对参数进行处理
  // 2.1 如果是字符串，则使用换行符将标题分隔为列表
  if type(info.title-en) == str {
    info.title-en = info.title-en.split("\n")
  }
  // 2.2 导师信息归一化为字典列表
  info.supervisors-en = normalize-supervisors(info.supervisors-en)

  // 3.  内置辅助函数
  let info-value(key, body) = {
    if (not anonymous or (key not in anonymous-info-keys)) {
      body
    }
  }

  // 4.  正式渲染
  [
    #pagebreak(weak: true, to: if twoside { "odd" })

    #set text(font: fonts.楷体, size: 字号.小四)
    #set par(leading: leading, justify: true)
    #set par(spacing: spacing)

    // 标记一个不可见的标题用于目录生成
    #invisible-heading(level: 1, outlined: outlined, outline-title)

    #align(center)[
      #set text(size: 字号.小二, weight: "bold")

      #v(1em)

      #double-underline[*中国科学院大学本科生毕业论文（设计、作品）英文摘要*]
    ]

    #v(2pt)

    THESIS: #info-value("title-en", (("",) + info.title-en).sum())

    DEPARTMENT: #info-value("department-en", info.department-en)

    SPECIALIZATION: #info-value("major-en", info.major-en)

    UNDERGRADUATE: #info-value("author-en", info.author-en)

    MENTOR: #info-value(
      "supervisors-en",
      info.supervisors-en.map(s => {
        // 英文习惯职称在前（如 "Professor Si Li"），与英文封面一致
        (s.at("title", default: ""), s.at("name", default: "")).filter(x => x != "").join(" ")
      }).filter(s => s != "").join(", "),
    )

    ABSTRACT: #body

    #v(1em)

    #strong[Key Words]: #(("",) + keywords.intersperse(", ")).sum()
  ]
}
