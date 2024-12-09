// 文稿设置，可以进行一些像页面边距这类的全局设置
#let doc(
  // documentclass 传入参数
  info: (:),
  // 其他参数
  fallback: false, // 字体缺失时使用 fallback，不显示豆腐块
  lang: "zh",
  // top: 72pt 和 bottom: 72pt 设置了上下边距为 72pt（即 2.54厘米）。
  // x: 90pt 设置了左右边距为 90pt（即 3.17厘米）。
  margin: (top: 72pt, bottom: 72pt, x: 90pt),
  it,
) = {
  // 1.  默认参数
  info = (
    title: ("基于 Typst 的", "南京大学学位论文"),
    author: "张三",
  ) + info

  // 2.  对参数进行处理
  // 2.1 如果是字符串，则使用换行符将标题分隔为列表
  if type(info.title) == str {
    info.title = info.title.split("\n")
  }

  // 3.  基本的样式设置
  set text(fallback: fallback, lang: lang)
  set page(margin: margin)

  // 4.  PDF 元信息
  set document(
    title: (("",) + info.title).sum(),
    author: info.author,
  )

  it
}