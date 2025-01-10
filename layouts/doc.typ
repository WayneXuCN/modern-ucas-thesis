#import "@preview/cuti:0.3.0": show-cn-fakebold
#import "../utils/globals.typ": fontset

// 文稿设置，可以进行一些像页面边距这类的全局设置
#let doc(
  // documentclass 传入参数
  info: (:),
  // 其他参数
  fallback: false, // 字体缺失时使用 fallback，不显示豆腐块
  lang: "zh",
  margin: (top: 2.54cm, bottom: 2.54cm, left: 3.17cm, right: 3.17cm),
  it,
) = {
  // 1.  默认参数
  info = (
    (
      title: ("基于 Typst 的", "中国科学院大学学位论文"),
      author: "张三",
    )
      + info
  )

  // 2.  对参数进行处理
  // 2.1 如果是字符串，则使用换行符将标题分隔为列表
  if type(info.title) == str {
    info.title = info.title.split("\n")
  }

  // 3.  基本的样式设置
  set text(fallback: fallback, lang: lang)
  set page(
    paper: "a4",
    margin: margin,
    header-ascent: (2.54cm - 1.5cm),
    footer-descent: (2.54cm - 1.5cm),
  )

  // 4.  PDF 元信息
  set document(
    title: (("",) + info.title).sum(),
    author: info.author,
  )

  // 5.  中文伪加粗（针对没有粗体的字体）
  show: show-cn-fakebold

  it
}
