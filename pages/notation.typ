#let notation(
  twoside: false,
  title: "符号列表",
  outlined: true,
  width: 350pt,
  ..args,
  body,
) = {
  heading(
    level: 1,
    numbering: none,
    outlined: outlined,
    title,
  )

  // 直接输出 body 内容，不做解析
  align(left, block(
    width: width,
    body,
  ))

  // 手动分页
  if (twoside) {
    pagebreak() + " "
  }
}
