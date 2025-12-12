#let 字号 = (
  初号: 14.82mm,
  小初: 12.7mm,
  一号: 9.17mm,
  小一: 8.47mm,
  二号: 7.76mm,
  小二: 6.35mm,
  三号: 5.64mm,
  小三: 5.29mm,
  四号: 4.94mm,
  小四: 4.23mm,
  五号: 3.7mm,
  小五: 3.18mm,
  六号: 2.56mm,
  小六: 2.29mm,
  七号: 1.94mm,
  八号: 1.74mm,
)

#let 等宽字体 = (
  "Noto Sans Mono CJK SC",
)

#let 字体组 = (
  windows: (
    宋体: ("Times New Roman", "SimSun"),
    黑体: ("Times New Roman", "SimHei"),
    楷体: ("Times New Roman", "KaiTi"),
    仿宋: ("Times New Roman", "FangSong"),
    西文: ("Times New Roman"),
    等宽: 等宽字体,
  ),
  mac: (
    宋体: ("Times New Roman", "Songti SC"),
    黑体: ("Times New Roman", "Heiti SC"),
    楷体: ("Times New Roman", "Kaiti SC"),
    仿宋: ("Times New Roman", "STFangSong"),
    西文: ("Times New Roman"),
    等宽: 等宽字体,
  ),
  fandol: (
    宋体: ("Times New Roman", "FandolSong"),
    黑体: ("Times New Roman", "FandolHei"),
    楷体: ("Times New Roman", "FandolKai"),
    仿宋: ("Times New Roman", "FandolFang R"),
    西文: ("Times New Roman"),
    等宽: 等宽字体,
  ),
  adobe: (
    宋体: ("Times New Roman", "Adobe Song Std"),
    黑体: ("Times New Roman", "Adobe Heiti Std"),
    楷体: ("Times New Roman", "Adobe Kaiti Std"),
    仿宋: ("Times New Roman", "Adobe Fangsong Std"),
    西文: ("Times New Roman"),
    等宽: 等宽字体,
  ),
)

#let get-fonts(fontset) = {
  if fontset == "windows" {
    字体组.windows
  } else if fontset == "mac" {
    字体组.mac
  } else if fontset == "adobe" {
    字体组.adobe
  } else {
    字体组.fandol
  }
}
