#import "../utils/datetime-display.typ": datetime-display

// 致谢页
#let acknowledgement(
  // documentclass 传入参数
  anonymous: false,
  twoside: false,
  // 致谢末尾日期，与论文封面 submit-date 一致
  // 传 datetime 自动格式化为"YYYY 年 M 月"；传字符串/内容则原样使用；传 none 不显示
  date: none,
  // 其他参数
  title: [致#h(1em)谢],
  outlined: true,
  body,
) = {
  if (not anonymous) {
    pagebreak(weak: true, to: if twoside { "odd" })
    [
      #heading(
        level: 1,
        numbering: none,
        outlined: outlined,
        title,
      ) <no-auto-pagebreak>

      #body

      #if date != none {
        let date-content = if type(date) == datetime {
          datetime-display(date)
        } else {
          date
        }
        // 末尾右对齐日期
        align(right, date-content)
      }
    ]
  }
}
