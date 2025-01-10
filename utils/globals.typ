#let globals = (
  doctype: "master", // "master" | "doctor" | "postdoc", 文档类型，默认为博士生 doctor，为空是本科论文模板
  degree: "academic", // "academic" | "professional", 学位类型，默认为学术型 academic
  anonymous: false, // 盲审模式
  twoside: true, // 双面模式，会加入空白页，便于打印
  // 可自定义字体，先英文字体后中文字体，应传入「宋体」、「黑体」、「楷体」、「仿宋」、「等宽」
  // fonts: (楷体: ("Times New Roman", "FZKai-Z03S")),
  info: (
    title: ("基于 Typst 的", "中国科学院大学学位论文"),
    title-en: "Typst Thesis Template of UCAS",
    supervisors: ("李四 教授", "王五 研究员"),
    supervisors-en: ("Professor Si Li", "Professor Wu Wang"),
    grade: "20XX",
    student-id: "1234567890",
    author: "张三",
    author-en: "Zhang San",
    department: "中国科学院xxxx研究所",
    department-en: "Institutes of Science and Development",
    major: "管理科学与工程",
    major-en: "Management Science and Engineering",
    category: "管理学博士",
    category-en: "Management Science",
    supervisor: ("李四", "教授"),

    // supervisor-ii: ("王五", "副教授"),
    // supervisor-ii-en: "Professor My Supervisor",
    submit-date: datetime.today(),
  ),
)

#let fontset = "fandol" // "windows" | "mac" | "fandol" | "adobe"，使用的字体组
