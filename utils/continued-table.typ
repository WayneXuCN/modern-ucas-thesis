#import "bilingual-figured.typ"
#import "style.typ": 字号

#let _typst-numbering = numbering

#let continuation-style(
  separator: h(1em),
  caption_align: center,
  caption_par: (leading: 1.25em),
  note_par: auto,
  zh_text: (size: 字号.五号, weight: "bold"),
  en_text: (size: 字号.五号, weight: "bold"),
  note_text: (size: 字号.五号),
  note_prefix: [*注：* ],
  note_align: left,
  zh_block: (above: 6pt + 1.25em, below: 0pt + 1.25em),
  en_block: (above: 0pt + 1.25em, below: 12pt),
  note_block: (above: 6pt + 1.25em, below: 0pt + 1.25em, inset: (left: 2em)),
  continued_mark_zh: [（续表）],
  continued_mark_en: [(continued)],
  header_cell: (stroke: none, inset: (x: 0pt, top: 0pt, bottom: 0.6em)),
  auto_header_gap: 0.2em,
  table_align: center,
  cell_align: center,
  continued_block: (above: 1.25em, below: 1em),
) = (
  separator: separator,
  caption_align: caption_align,
  caption_par: caption_par,
  note_par: note_par,
  zh_text: zh_text,
  en_text: en_text,
  note_text: note_text,
  note_prefix: note_prefix,
  note_align: note_align,
  zh_block: zh_block,
  en_block: en_block,
  note_block: note_block,
  continued_mark_zh: continued_mark_zh,
  continued_mark_en: continued_mark_en,
  header_cell: header_cell,
  auto_header_gap: auto_header_gap,
  table_align: table_align,
  cell_align: cell_align,
  continued_block: continued_block,
)

#let _default-continuation-style = continuation-style()

#let _auto-caption-style(style) = (
  style
    + (
      zh_block: (above: 0pt, below: 0pt),
      en_block: (above: 0pt, below: 0pt),
    )
)

#let _render-auto-header-caption(
  number,
  caption_zh,
  caption_en,
  supplement_zh,
  supplement_en,
  style,
  continued: false,
) = [
  #set align(style.caption_align)
  #set text(..style.zh_text)
  #block(above: 0pt, below: 0pt)[
    #supplement_zh #number #style.separator #caption_zh
    #if continued { [#style.continued_mark_zh] }
  ]
  #if caption_en != none {
    v(0.15em)
    set text(..style.en_text)
    block(above: 0pt, below: 0pt)[
      #supplement_en #number #style.separator #caption_en
      #if continued { [#h(0.4em) #style.continued_mark_en] }
    ]
  }
  #v(style.auto_header_gap)
]

#let _render-caption(
  number,
  caption_zh,
  caption_en,
  supplement_zh,
  supplement_en,
  style,
  continued: false,
) = [
  #set align(style.caption_align)
  #if style.caption_par != none and style.caption_par != (:) {
    set par(..style.caption_par)
  }
  #set text(..style.zh_text)
  #block(..style.zh_block)[
    #supplement_zh #number #style.separator #caption_zh
    #if continued { [#style.continued_mark_zh] }
  ]
  #if caption_en != none {
    set text(..style.en_text)
    block(..style.en_block)[
      #supplement_en #number #style.separator #caption_en
      #if continued { [#h(0.4em) #style.continued_mark_en] }
    ]
  }
]

#let _render-note(note, style) = if note == none {
  []
} else {
  let note-par = if style.note_par == auto {
    style.caption_par
  } else {
    style.note_par
  }
  [
    #set align(style.note_align)
    #if note-par != none and note-par != (:) {
      set par(..note-par)
    }
    #set text(..style.note_text)
    #block(..style.note_block)[
      #style.note_prefix #note
    ]
  ]
}

#let _prepare-heading-prefix(
  loc,
  level: 1,
  zero-fill: true,
  leading-zero: true,
) = {
  let numbers = counter(heading).at(loc)
  while zero-fill and numbers.len() < level {
    numbers.push(0)
  }
  if numbers.len() > level {
    numbers = numbers.slice(0, level)
  }
  if not leading-zero and numbers.at(0, default: none) == 0 {
    numbers = numbers.slice(1)
  }
  numbers
}

#let _table-index-at(loc, kind: "bitable") = {
  let prefixed-index = counter(
    figure.where(kind: bilingual-figured.prefixed-kind(kind)),
  )
    .at(loc)
    .at(0, default: 0)
  if prefixed-index > 0 {
    prefixed-index
  } else {
    counter(figure.where(kind: kind)).at(loc).at(0, default: 1)
  }
}

#let _display-table-number(
  loc,
  numbering: "1-1",
  level: 1,
  zero-fill: true,
  leading-zero: true,
  kind: "bitable",
) = {
  let heading-prefix = _prepare-heading-prefix(
    loc,
    level: level,
    zero-fill: zero-fill,
    leading-zero: leading-zero,
  )
  let index = _table-index-at(loc, kind: kind)
  _typst-numbering(numbering, ..heading-prefix, index)
}

#let _source-caption-data(source) = {
  let extracted = bilingual-figured.extract-bilingual-caption(source)
  if extracted == none {
    (
      zh: none,
      en: none,
      supplement_zh: [表],
      supplement_en: [Table],
    )
  } else {
    (
      zh: extracted.zh,
      en: extracted.en,
      supplement_zh: extracted.supplement_zh,
      supplement_en: extracted.supplement_en,
    )
  }
}

#let _resolve-columns(columns) = {
  if type(columns) == int {
    let resolved = ()
    for _i in range(0, columns) {
      resolved.push(auto)
    }
    resolved
  } else {
    columns
  }
}

#let auto-table(
  caption-zh: none,
  caption-en: none,
  note: none,
  columns: auto,
  header: (),
  label: none,
  numbering: "1-1",
  supplement-zh: [表],
  supplement-en: [Table],
  level: 1,
  zero-fill: true,
  leading-zero: true,
  style: (:),
  ..args,
) = {
  if caption-zh == none {
    panic("auto-table 需要提供 caption-zh")
  }
  if columns == auto {
    panic("auto-table 需要显式提供 columns")
  }

  let col-count = if type(columns) == int {
    columns
  } else if type(columns) == array {
    columns.len()
  } else {
    panic("auto-table 的 columns 需为整数或列宽数组")
  }

  let merged-style = _default-continuation-style + style
  let resolved-columns = _resolve-columns(columns)
  let table-named = args.named()

  context {
    let anchor-figure = figure(
      block(width: 0pt, height: 0pt)[],
      kind: "bitable",
      supplement: none,
      numbering: numbering,
      caption: metadata((
        zh: caption-zh,
        en: caption-en,
        note: note,
        supplement_zh: supplement-zh,
        supplement_en: supplement-en,
        render: false,
      )),
    )

    let anchor = if label != none {
      [#anchor-figure #label]
    } else {
      anchor-figure
    }

    [
      #anchor
      #block(breakable: true, width: 100%, above: 0pt, below: 0.9em, {
        set align(merged-style.table_align)
        table(
          columns: resolved-columns,
          ..table-named,
          table.header(
            table.cell(
              colspan: col-count,
              ..merged-style.header_cell,
              context {
                let number = _display-table-number(
                  here(),
                  numbering: numbering,
                  level: level,
                  zero-fill: zero-fill,
                  leading-zero: leading-zero,
                )
                let current-page = here().position().page
                let anchors = query(
                  selector(
                    figure.where(
                      kind: bilingual-figured.prefixed-kind("bitable"),
                    ),
                  ).before(here()),
                )
                let anchor-page = if anchors.len() > 0 {
                  anchors.last().location().page()
                } else {
                  current-page
                }
                let auto-style = _auto-caption-style(merged-style)
                _render-auto-header-caption(
                  number,
                  caption-zh,
                  caption-en,
                  supplement-zh,
                  supplement-en,
                  auto-style,
                  continued: current-page > anchor-page,
                )
              },
            ),
            ..header,
          ),
          ..args.pos(),
        )
        _render-note(note, merged-style)
      })
    ]
  }
}

#let continued-table(
  source,
  caption-zh: auto,
  caption-en: auto,
  supplement-zh: auto,
  supplement-en: auto,
  note: none,
  style: (:),
  body,
) = context {
  let matched = query(source)
  if matched.len() == 0 {
    panic("continued-table 未找到源表标签: " + repr(source))
  }

  let origin = matched.first()
  let source-data = _source-caption-data(origin)
  let zh = if caption-zh == auto { source-data.zh } else { caption-zh }
  let en = if caption-en == auto { source-data.en } else { caption-en }
  let supp-zh = if supplement-zh == auto {
    source-data.supplement_zh
  } else {
    supplement-zh
  }
  let supp-en = if supplement-en == auto {
    source-data.supplement_en
  } else {
    supplement-en
  }

  if zh == none {
    panic("continued-table 需要 caption-zh，或确保源表具有双语标题元数据")
  }

  let number = bilingual-figured.display-figure-number(origin)
  let merged-style = _default-continuation-style + style

  block(..merged-style.continued_block)[
    #_render-caption(
      number,
      zh,
      en,
      supp-zh,
      supp-en,
      merged-style,
      continued: true,
    )
    #align(merged-style.table_align)[
      #body
    ]
    #_render-note(note, merged-style)
  ]
}
