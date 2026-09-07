# modern-ucas-thesis 定制指南

> 本指南以《中国科学院大学研究生学位论文撰写规范指导意见（2022 年 3 月 7 日校长办公会议审议修订）》（见 [`docs/RULES.md`](./RULES.md)，以下简称《指导意见》）为标尺，结合本仓库 `lib.typ`、`layouts/`、`pages/`、`utils/`、`template/` 的实际代码与 `typst 0.15.x` 实测渲染输出（参见 [`docs/RULES_AUDIT.md`](./RULES_AUDIT.md) 的逐条核对结果），逐项说明每条规范要求由哪个文件、哪个参数落实，以及用户在撰写过程中应当如何配置、调用与定制。
>
> 阅读建议：先看 [§0 总览](#0-总览) 理解 `documentclass` 闭包工厂的设计哲学，再按论文物理顺序阅读各章节；遇到具体格式问题可直接跳至对应小节查表。已知与规范的偏差集中在 [§19 已知偏差与待办](#19-已知偏差与待办)，每个偏差均标注规范依据与受影响代码位置。

---

## 目录

- [0. 总览](#0-总览)
  - [0.1 模板定位与规范依据](#01-模板定位与规范依据)
  - [0.2 `documentclass` 闭包工厂设计](#02-documentclass-闭包工厂设计)
  - [0.3 论文物理结构与调用顺序](#03-论文物理结构与调用顺序)
  - [0.4 编译与字体准备](#04-编译与字体准备)
- [1. 文档级配置（`documentclass` 顶层参数）](#1-文档级配置documentclass-顶层参数)
  - [1.1 `doctype` / `degree` / `nl-cover`](#11-doctype--degree--nl-cover)
  - [1.2 `twoside`（双面打印）](#12-twoside双面打印)
  - [1.3 `anonymous`（盲审模式）](#13-anonymous盲审模式)
  - [1.4 `fontset` 与 `fonts`（字体配置）](#14-fontset-与-fonts字体配置)
  - [1.5 `bibliography`（参考文献源）](#15-bibliography参考文献源)
  - [1.6 `info`（论文元信息）](#16-info论文元信息)
- [2. 封面（Cover）](#2-封面cover)
  - [2.1 规范要求](#21-规范要求)
  - [2.2 代码实现](#22-代码实现)
  - [2.3 研究生封面定制参数](#23-研究生封面定制参数)
  - [2.4 专业型学位封面差异](#24-专业型学位封面差异)
  - [2.5 盲审模式下的封面](#25-盲审模式下的封面)
  - [2.6 待实现的封面元素](#26-待实现的封面元素)
- [3. 原创性声明与授权使用声明（Declaration）](#3-原创性声明与授权使用声明declaration)
  - [3.1 规范要求](#31-规范要求)
  - [3.2 代码实现](#32-代码实现)
  - [3.3 签名处理](#33-签名处理)
- [4. 摘要与关键词（Abstract）](#4-摘要与关键词abstract)
  - [4.1 规范要求](#41-规范要求)
  - [4.2 代码实现](#42-代码实现)
  - [4.3 中文摘要定制参数](#43-中文摘要定制参数)
  - [4.4 英文摘要定制参数](#44-英文摘要定制参数)
  - [4.5 关键词分隔符注意事项](#45-关键词分隔符注意事项)
  - [4.6 盲审模式下的摘要](#46-盲审模式下的摘要)
  - [4.7 已知偏差](#47-已知偏差)
- [5. 目录（Outline）](#5-目录outline)
  - [5.1 规范要求](#51-规范要求)
  - [5.2 代码实现](#52-代码实现)
  - [5.3 目录定制参数](#53-目录定制参数)
  - [5.4 标题段前段后间距计算逻辑](#54-标题段前段后间距计算逻辑)
- [6. 图表目录（List of Figures and Tables）](#6-图表目录list-of-figures-and-tables)
  - [6.1 规范要求](#61-规范要求)
  - [6.2 代码实现](#62-代码实现)
  - [6.3 图表目录定制参数](#63-图表目录定制参数)
- [7. 符号说明（Notation）](#7-符号说明notation)
  - [7.1 规范要求](#71-规范要求)
  - [7.2 代码实现](#72-代码实现)
  - [7.3 符号列表定制参数](#73-符号列表定制参数)
- [8. 正文（Main Matter）](#8-正文main-matter)
  - [8.1 规范要求](#81-规范要求)
  - [8.2 代码实现](#82-代码实现)
  - [8.3 正文排版参数](#83-正文排版参数)
  - [8.4 标题样式配置](#84-标题样式配置)
  - [8.5 标题段前段后间距计算逻辑](#85-标题段前段后间距计算逻辑)
  - [8.6 章节编号格式](#86-章节编号格式)
  - [8.7 页眉与页脚](#87-页眉与页脚)
  - [8.8 防止自动换页](#88-防止自动换页)
- [9. 图与表（Figures & Tables）](#9-图与表figures--tables)
  - [9.1 规范要求](#91-规范要求)
  - [9.2 代码实现：双层架构](#92-代码实现双层架构)
  - [9.3 双语图表示例](#93-双语图表示例)
  - [9.4 续表（自动 / 手动）](#94-续表自动--手动)
  - [9.5 图表交叉引用约定](#95-图表交叉引用约定)
  - [9.6 双语图表样式定制](#96-双语图表样式定制)
  - [9.7 三线表与卧排表](#97-三线表与卧排表)
  - [9.8 已知偏差](#98-已知偏差)
- [10. 公式（Equations）](#10-公式equations)
  - [10.1 规范要求](#101-规范要求)
  - [10.2 代码实现](#102-代码实现)
  - [10.3 多行对齐公式](#103-多行对齐公式)
  - [10.4 不编号公式](#104-不编号公式)
  - [10.5 已知偏差](#105-已知偏差)
- [11. 参考文献（References）](#11-参考文献references)
  - [11.1 规范要求](#111-规范要求)
  - [11.2 代码实现](#112-代码实现)
  - [11.3 参考文献定制参数](#113-参考文献定制参数)
  - [11.4 引用样式切换](#114-引用样式切换)
  - [11.5 中英文文献自动转换](#115-中英文文献自动转换)
  - [11.6 文献著录格式示例](#116-文献著录格式示例)
  - [11.7 已知偏差](#117-已知偏差)
- [12. 附录（Appendix）](#12-附录appendix)
  - [12.1 规范要求](#121-规范要求)
  - [12.2 代码实现](#122-代码实现)
  - [12.3 附录定制参数](#123-附录定制参数)
  - [12.4 附录模式机制](#124-附录模式机制)
- [13. 致谢（Acknowledgements）](#13-致谢acknowledgements)
  - [13.1 规范要求](#131-规范要求)
  - [13.2 代码实现](#132-代码实现)
- [14. 作者简历及攻读学位期间发表的学术论文与其它学术成果（Backmatter）](#14-作者简历及攻读学位期间发表的学术论文与其它学术成果backmatter)
  - [14.1 规范要求](#141-规范要求)
  - [14.2 代码实现](#142-代码实现)
- [15. 页面与字号基础](#15-页面与字号基础)
  - [15.1 页面尺寸与页边距](#151-页面尺寸与页边距)
  - [15.2 字号字典](#152-字号字典)
  - [15.3 字体组预设](#153-字体组预设)
  - [15.4 中文伪加粗](#154-中文伪加粗)
- [16. 印刷与装订要求](#16-印刷与装订要求)
- [17. 名词术语、量和单位规范](#17-名词术语量和单位规范)
- [18. 常见定制场景速查](#18-常见定制场景速查)
- [19. 已知偏差与待办](#19-已知偏差与待办)
- [附录 A：规范条文与代码位置对照表](#附录-a规范条文与代码位置对照表)

---

## 0. 总览

### 0.1 模板定位与规范依据

`modern-ucas-thesis`（v0.2.0，入口 `lib.typ`，`typst.toml` 声明 `compiler = "0.15.0"`）用于撰写中国科学院大学硕士、博士学位论文，遵循《指导意见》从 2023 年冬季批次开始实施的要求。本科生毕业论文（设计、作品）另设独立的封面/声明/摘要分支（见 [§2.6](#26-待实现的封面元素)），但同样适用本《指导意见》中正文、图表、参考文献等通用条款。

《指导意见》自身参照《学位论文编写规则》（GB/T 7713.1—2006）、《信息与文献 参考文献著录规则》（GB/T 7714—2015）、《学术出版规范 期刊学术不端行为界定》（CY/T 174—2019）；正文中另涉《标点符号用法》（GB/T 15834—2011）、《出版物上数字用法》（GB/T 15835—2011）、《中国人名汉语拼音字母拼写规则》（GB/T 28039—2011）、《国际单位制及其应用》（GB 3100-93）、《有关量、单位和符号的一般原则》（GB 3101—93）等国家标准。

> 各学科群学位评定分委员会可结合本学科特点制定更具体要求；使用本模板时，请同时核对本单位分会颁布的细则。

### 0.2 `documentclass` 闭包工厂设计

理解全项目的关键：`documentclass(...)` 不是简单的参数容器，而是一个**闭包工厂**。它接收全局配置（`doctype`/`degree`/`fontset`/`fonts`/`info`/`bibliography`/`twoside`/`anonymous`），返回一个**字典**，字典的每个值都是**已闭包绑定全局配置的函数**。

返回的函数分两类：

1. **按 `doctype` 分发的页面函数**（`cover`/`decl-page`/`abstract`/`abstract-en`）：内部按 `doctype` 路由到 `pages/master-*.typ`（硕士/博士）或 `pages/bachelor-*.typ`（本科）；`postdoc` 当前 `panic` 未实现。
2. **直接透传的工具函数**（`bifigure`/`bitable`/`continued-table`/`auto-table`/`aligned-equation`）：来自 `utils/custom-figure.typ`、`utils/continued-table.typ`、`utils/aligned-equation.typ`。

> ⚠️ **重要**：调用这些返回函数时，**不要重复传 `fontset`/`fonts`/`info` 等已被闭包持有的参数**。它们已在 `documentclass` 顶层设置一次，下游函数会自动接收。仅在需要"覆盖单次调用"的少数高级场景下才显式传参（如临时改字体）。

源码位置：`lib.typ:36-308`。

### 0.3 论文物理结构与调用顺序

《指导意见》规定论文由以下部分组成（顺序即物理结构）：

```
封面 → 原创性声明及授权使用声明 → 摘要（中/英） → 目录 → 符号说明（若有）
     → 正文 → 参考文献 → 附录（若有） → 致谢 → 作者简历及攻读学位期间发表的学术论文与其他相关学术成果
```

`template/thesis.typ` 严格按此顺序组织，并通过 `#show:` 触发布局切换（页码制式、页眉、编号随之改变）：

```typst
#show: doc              // 1. 全局页面设置（A4、页边距、PDF 元信息、中文伪加粗）
#cover()                // 2. 封面
#decl-page()            // 3. 原创性声明与授权使用声明
#show: preface          // 4. 进入前言（罗马数字页码、页眉开始）
#abstract(...)          // 5. 中文摘要
#abstract-en(...)       // 6. 英文摘要
#outline-page()         // 7. 目录
#list-of-figures-and-tables()  // 8. 图表目录
#notation()[...]        // 9. 符号列表（可选）
#show: mainmatter       // 10. 进入正文（阿拉伯页码、章节编号、页眉显示章名）
// ... 正文章节 ...
#bilingual-bibliography(full: true)  // 11. 参考文献
#show: appendix         // 12. 进入附录
// ... 附录内容 ...
#acknowledgement[...]   // 13. 致谢
#backmatter[...]        // 14. 作者简历及学术成果
```

> **不要**把 `#show: preface` / `#show: mainmatter` / `#show: appendix` 改成普通函数调用——它们依赖 `show` 规则触发布局切换。调用顺序对应论文物理结构，不能随意调换。

> 规范依据：《指导意见》一·总述规定论文组成与顺序；三·（八）要求各主要部分"均须由另页右页（奇数页）开始"。

### 0.4 编译与字体准备

```bash
# 必须指定字体目录，否则中文渲染为豆腐块；必须指定 --root，否则 ../lib.typ 触发 sandbox 逃逸
typst compile template/thesis.typ --root . --font-path fonts
typst watch   template/thesis.typ --root . --font-path fonts   # 实时预览
```

字体文件需用户自行放入 `fonts/` 子目录（版权原因仓库不含字体，见 `fonts/README.md`）。`fonts/` 下应至少包含：

- **Times New Roman**（西文正文与标题、阿拉伯数字）
- **方正楷体 / 方正仿宋**（用于摘要字段、封面"院系/专业"等楷体项）
- 所选 `fontset` 对应的中文字体（如 macOS 用户用系统自带宋体/黑体即可，Windows 用户需 SimSun/SimHei/KaiTi/FangSong）

可通过 `#fonts-display-page()` 临时插入字体渲染测试页，确认字体是否被正确识别。

> 规范依据：《指导意见》三·（一）页面设置要求；三·（二）封面表格明示"英文和阿拉伯数字用 Times New Roman 体"贯穿全文。

---

## 1. 文档级配置（`documentclass` 顶层参数）

`documentclass` 是模板的入口函数，定义于 `lib.typ:36-308`。

### 1.1 `doctype` / `degree` / `nl-cover`

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `doctype` | string | `"doctor"` | 文档类型：`"bachelor"` \| `"master"` \| `"doctor"` \| `"postdoc"`（`"postdoc"` 当前 `panic`，未实现） |
| `degree` | string | `"academic"` | 学位类型：`"academic"`（学术型） \| `"professional"`（专业型）。影响封面"学位类别"字段显示与封面分类逻辑 |
| `nl-cover` | boolean | `false` | 是否使用国家图书馆封面（含密级/中图分类号/UDC/学校代码）。**当前未实现**，仅预留参数 |

> 规范依据：《指导意见》一·（一）·5「学位类别包括学科门类（学术型）或专业学位类别以及学位级别」。

### 1.2 `twoside`（双面打印）

`twoside: true` 启用双面打印模式：

- 封面段（中文封面/英文封面/声明页）单面连续分页，不插空白页；自摘要起进入双面对开
- 摘要起各部分通过 `pagebreak(weak: true, to: "odd")` 保证从奇数页（右页）起：中文摘要、英文摘要、目录、图表目录、符号列表、正文各章、致谢、作者简历等
- 页码遵循"左页左下、右页右下"的双面分置规则（见 [§8.7](#87-页眉与页脚)）
- 前言页码用 `counter(page).update(1)` 重置为 1（非 0），确保摘要首页 counter=1 与物理奇数页一致（见 [§8.7](#87-页眉与页脚) 前言页码）

> 规范依据：《指导意见》三·（八）「自中文摘要起双面印刷，之前部分单面印刷……均须由另页右页（奇数页）开始。」；二·（六）·2·（3）「页码应位居左页左下角、右页右下角」。

> ✅ **P2 已修复**：参考文献已由 `bilingual-bibliography` 内置 `pagebreak(to: "odd")` 保证从奇数页开始（详见 [§11.7](#117-已知偏差) 与 [§19](#19-已知偏差与待办)）。

### 1.3 `anonymous`（盲审模式）

`anonymous: true` 启用盲审模式：

- 封面：作者、导师、学号、答辩主席、评阅人、培养单位等字段以黑块"██████"代替（具体清单见 [§2.5](#25-盲审模式下的封面)）
- 中文摘要：隐藏作者、年级、导师、第二导师
- 英文摘要：隐藏作者英文、导师英文、第二导师英文
- 原创性声明页、致谢页、作者简历页**整体跳过**（`pages/master-decl-page.typ:11-13`、`pages/acknowledgement.typ:16`、`pages/backmatter.typ:11`）

需隐藏的字段由各页面的 `anonymous-info-keys` 参数控制，详见对应章节。

### 1.4 `fontset` 与 `fonts`（字体配置）

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `fontset` | string | `"mac"` | 预定义字体组：`"windows"` \| `"mac"` \| `"fandol"` \| `"adobe"` |
| `fonts` | dictionary | `(:)` | 自定义字体配置，**覆盖** `fontset` 中对应键 |

合并逻辑（`lib.typ:54`）：`fonts = get-fonts(fontset) + fonts`，即用户传入的 `fonts` 字典中已有的键会覆盖预设字体组中的同名键。

支持的字体键：`宋体`、`黑体`、`楷体`、`仿宋`、`等宽`。每个键的值是字体名数组（英文优先，中文在后），例如：

```typst
#let (..., doc) = documentclass(
  fontset: "mac",
  fonts: (
    // 修正楷体在 macOS 下的异常：英文字体在前、中文在后
    楷体: ((name: "Times New Roman", covers: "latin-in-cjk"), "FZKai-Z03S"),
    // 替换等宽字体
    等宽: ("JetBrains Mono", "思源黑体"),
  ),
  ...
)
```

四种预设的字体组见 [§15.3](#153-字体组预设)。

### 1.5 `bibliography`（参考文献源）

| 参数 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `bibliography` | function | `none` | 参考文献函数，通常为 `bibliography.with("ref.bib")` |

该参数会被闭包持有，传给 `bilingual-bibliography` 函数。若不设置，调用 `#bilingual-bibliography(full: true)` 时会触发断言错误。

### 1.6 `info`（论文元信息）

`info` 是字典类型，包含论文所有元信息。`documentclass` 内部有一份默认 `info`（`lib.typ:55-90`），用户传入的 `info` 会与之合并（用户字段覆盖默认）。

**封面与摘要必填字段**：

| 字段 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `title` | array/string | `("基于 Typst 的", "中国科学院大学学位论文")` | 论文题目，不超 25 汉字（一·（一）·2）；用于封面、英文封面、页眉偶数页 |
| `title-en` | string | `"UCAS Thesis Template for Typst"` | 英文题目，不超 150 字母；用于英文封面 |
| `author` / `author-en` | string | `"张三"` / `"Zhang San"` | 作者姓名；英文按 GB/T 28039—2011，姓全大写、名首字母大写（一·（一）·3） |
| `grade` | string | `"20XX"` | 年级；用于摘要页 |
| `student-id` | string | `"1234567890"` | 学号；用于摘要页 |
| `department` / `department-en` | string | `"某研究所"` / `"XX Institute"` | 培养单位全称（一·（一）·7） |
| `major` / `major-en` | string | `"xx 专业"` / `"xx major"` | 一级/二级学科或专业学位领域全称，须与学籍一致（一·（一）·6） |
| `category` / `category-en` | string | `"学科门类或专业学位类别"` / `"XX category"` | 学科门类（学术型）或专业学位类别 + 学位级别（一·（一）·5） |
| `supervisors` | array | `((name: "李四", title: "教授", affiliation: "中国科学院××研究所"),)` | 导师列表，每项为字典 `(name:, title:, affiliation:)`，分别对应姓名、专业技术职务、工作单位，多导师第一导师在前（一·（一）·4）；用于封面、摘要。由 `utils/supervisor.typ` 的 `normalize-supervisors` 校验归一化 |
| `supervisors-en` | array | `((name: "Si Li", title: "Professor", affiliation: "×× Institute, CAS"),)` | 英文导师列表，结构同 `supervisors`；用于英文封面、英文摘要 |
| `submit-date` | datetime | `datetime.today()` | 论文提交年月，夏季填 6 月、冬季填 12 月（一·（一）·8）；用于封面、致谢末尾 |
| `degree` / `degree-en` | string/auto | `auto` | 学位名称，`auto` 时按 `doctype` 自动生成（"工程博士"/"工程硕士"）；用于封面（专业型） |

**国图封面预留字段**（`nl-cover` 未实现，见 [§2.7](#27-待实现的封面元素)）：`defend-date`（答辩日期）、`confer-date`（学位授予日期）、`bottom-date`（封面底部日期）、`chairman`（答辩委员会主席）、`reviewer`（答辩委员会成员）、`clc`（中图分类号）、`udc`（UDC 分类号）、`secret-level`（密级）、`email`（作者邮箱）、`school-code`（学校代码，UCAS 固定 `"14430"`）。这些字段已在 `lib.typ` 定义，但当前封面不渲染。

> `utils/datetime-display.typ` 将 `datetime` 渲染为 `[year] 年 [month padding:none] 月`（中文）或 `[month repr:short], [year]`（英文）。

> ✅ **P9 已修复**：指导教师支持结构化填写"姓名、专业技术职务、工作单位"三项（《指导意见》一·（一）·4）。`supervisors`/`supervisors-en` 为字典列表 `(name:, title:, affiliation:)`，由 `utils/supervisor.typ` 校验归一化，封面渲染"姓名 职称 工作单位"。详见 [§19](#19-已知偏差与待办)。

---

## 2. 封面（Cover）

### 2.1 规范要求

《指导意见》一·（一）封面 + 三·（二）封面表格：

| 项目 | 中文要求 | 英文要求 |
|------|---------|---------|
| 论文题目 | 黑体小三号加粗居中，单倍行距 | Times New Roman 小三号加粗居中，单倍行距 |
| 作者姓名 | 宋体四号加粗，2 倍行距 | Times New Roman 四号加粗居中，2 倍行距 |
| 指导教师 | 宋体四号加粗，2 倍行距 | Times New Roman 四号加粗居中，2 倍行距 |
| 学位类别 | 宋体四号加粗，2 倍行距 | Times New Roman 四号加粗居中，2 倍行距 |
| 学科专业 | 宋体四号加粗，2 倍行距 | Times New Roman 四号加粗居中，2 倍行距 |
| 培养单位 | 宋体四号加粗，2 倍行距 | Times New Roman 四号加粗居中，2 倍行距 |
| 完成日期 | 阿拉伯数字 Times New Roman 四号加粗居中 | Times New Roman 四号加粗居中 |

并要求（一·（一）·1-8）：**密级**——涉密或延迟公开论文须在封面标注密级与保密年限，公开论文不标注此行；**论文题目**——不宜超过 25 个汉字，英文不超 150 字母，避免缩略词、代号、公式，必要时可加副标题；**作者姓名**——按 GB/T 28039—2011 拼写，英文封面姓在前、名在后，姓全大写、名首字母大写，留学生姓名以护照格式为准；**指导教师**——须同时填写姓名、专业技术职务和工作单位，多导师时第一导师在前，指导小组指导完成的应注明成员信息；**学位类别**——学科门类（学术型）或专业学位类别 + 学位级别；**学科专业**——一级/二级学科或专业学位领域全称，须与学籍一致；**培养单位**——就读研究所或学院、系全称；**时间**——阿拉伯数字标注，夏季 6 月、冬季 12 月。

### 2.2 代码实现

`documentclass` 通过 `doctype` 分发（`lib.typ:149-174`）：

- 硕士/博士 → `pages/master-cover.typ`（`master-cover` 函数）
- 本科 → `pages/bachelor-cover.typ`（`bachelor-cover` 函数）

调用方式（用户无需传任何参数，全部由闭包持有）：

```typst
#cover()
```

实现要点（`pages/master-cover.typ`）：标题字号 `字号.小三`（15pt）、`fonts.黑体`、加粗、下加双下划线（`underline(offset: .4em, stroke: .05em, evade: false)`），居中；"博士学位论文"/"硕士学位论文" `字号.一号`（26pt）黑体加粗；信息字段（作者/导师/学位类别/学科专业/培养单位）`字号.四号`（14pt）宋体加粗，2 倍行距通过 `info-row-gutter: 1.2em` 实现；日期 Times New Roman 四号加粗；英文封面单独一页（`pagebreak(weak: true)`），标题 Times New Roman 小三号加粗，下方"A dissertation submitted to University of Chinese Academy of Sciences..."。

> ⚠️ **已知偏差 P8**：封面"2 倍行距"实现为 `info-row-gutter: 1.2em`，与 Word 中"2 倍行距"的定义口径存在差异。规范文字未给出精确的 pt 值，实测视觉接近，但严格按 Word 定义会有偏差。详见 [§19](#19-已知偏差与待办)。

### 2.3 研究生封面定制参数

位于 `pages/master-cover.typ:6-49`。常用参数：

| 参数名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| `stroke-width` | length | `0.5pt` | 信息区域下划线宽度 |
| `min-title-lines` | int | `2` | 标题最小行数（不足则填充空行） |
| `min-supervisor-lines` | int | `2` | 导师区域最小行数 |
| `min-reviewer-lines` | int | `5` | 评审人区域最小行数 |
| `info-inset` | dictionary | `(x: 0pt, bottom: 0.5pt)` | 信息区域内边距 |
| `info-key-width` | length | `70pt` | 信息标签（"作者姓名："等）宽度 |
| `info-column-gutter` | length | `6pt` | 信息列间距 |
| `info-row-gutter` | length | `1.2em` | 信息行间距（约 2 倍行距） |
| `meta-block-inset` | dictionary | `(left: -15pt)` | 元数据块内边距 |
| `meta-info-inset` | dictionary | `(x: 0pt, bottom: 2pt)` | 元信息内边距 |
| `meta-info-key-width` | length | `35pt` | 元信息标签宽度 |
| `meta-info-column-gutter` | length | `10pt` | 元信息列间距 |
| `meta-info-row-gutter` | length | `1pt` | 元信息行间距 |
| `defence-info-inset` | dictionary | `(x: 0pt, bottom: 0pt)` | 答辩信息内边距 |
| `defence-info-key-width` | length | `110pt` | 答辩信息标签宽度 |
| `defence-info-column-gutter` | length | `2pt` | 答辩信息列间距 |
| `defence-info-row-gutter` | length | `12pt` | 答辩信息行间距 |
| `anonymous-info-keys` | array | 见代码 | 盲审时需隐藏的字段名列表 |

### 2.4 专业型学位封面差异

`degree: "professional"` 时（`pages/master-cover.typ:271-288`）：

- 不显示"学科专业"行
- 改为"专业学位类别（领域）"行，格式 `info.degree + "（" + info.major + "）"`
- "专业学位类别（领域）"标签宽度通过 `scale(x: 55%)` 压缩以适配

### 2.5 盲审模式下的封面

`anonymous: true` 时（`master-cover.typ:218-223`）：封面图标（UCAS Logo）不渲染，改为 `v(93.5pt)` 空白。`anonymous-info-keys` 列表中的字段以黑块代替（`master-cover.typ:34-46, 180-199`）：

```
student-id, author, author-en, supervisors, supervisors-en,
chairman, reviewer, department
```

> 说明：盲审模式下不渲染校徽等可识别身份的视觉元素，符合盲审要求。

### 2.6 待实现的封面元素

- **密级行**（规范一·（一）·1）— ❌ 未实现。`info.secret-level` 字段已定义（`lib.typ:82`），但封面未渲染该字段。公开论文可省略此行，故对公开论文无影响；涉密论文需手动添加密级行。
- **国家图书馆封面**（含密级/中图分类号/UDC/学校代码）— ❌ 未实现。`nl-cover` 参数已预留（`lib.typ:39` 标注 TODO），`secret-level`/`clc`/`udc`/`school-code` 字段已定义（`lib.typ:80-85`），但封面未渲染。
- **书脊**（规范三·（三））— ❌ 未实现。规范要求：黑体小四号，上=题目、中=作者、下="中国科学院大学"，距上下边界 3cm；当前未实现，需要用户手动生成。
- **指导教师工作单位**（规范一·（一）·4）— ✅ 已实现。`supervisors`/`supervisors-en` 为字典列表 `(name:, title:, affiliation:)`，`affiliation` 即工作单位，由 `utils/supervisor.typ` 归一化，封面/摘要渲染为"姓名 职称 工作单位"。

> 规范依据：《指导意见》三·（三）「学位论文的书脊用黑体，英文和阿拉伯数字用 Times New Roman 体，字号一般为小四号，可根据论文厚度适当调整。上方写论文题目，中间写作者姓名，下方写'中国科学院大学'，距上下边界均为 3cm 左右。」

---

## 3. 原创性声明与授权使用声明（Declaration）

### 3.1 规范要求

《指导意见》一·（二）与样张 3：本部分提供统一模板，提交时作者和导师须**亲笔签名**。如遇导师无法签字，培养单位应做出适当处理。

声明包含两段：

1. **原创性声明**：作者签名 + 日期
2. **授权使用声明**：作者签名 + 导师签名 + 日期（涉密及延迟公开论文在解密或延迟期后适用）

### 3.2 代码实现

- 研究生：`pages/master-decl-page.typ`
- 本科：`pages/bachelor-decl-page.typ`

调用方式：

```typst
#decl-page()
```

`pages/master-decl-page.typ` 实现要点：标题"中国科学院大学 学位论文原创性声明"用黑体四号加粗居中；正文宋体小四、两端对齐、首行缩进 2em、`leading: 1.2em`；签名行用 `h(8em)`、`h(5.8em)` 控制留白；两段声明之间 `v(48pt)` 分隔；`anonymous: true` 时整体 `return` 跳过。声明正文文字内容与样张 3 完全一致，使用统一的固定模板。

### 3.3 签名处理

> ⚠️ 模板仅渲染签名占位（"作者签名：____"），用户须**打印后手写签名，再扫描插入 PDF**，或在 Typst 中通过 `image()` 临时插入签名图片。

---

## 4. 摘要与关键词（Abstract）

### 4.1 规范要求

《指导意见》一·（三）与三·（四）：

| 项目 | 中文摘要 | 英文摘要 |
|------|---------|---------|
| 标题 | "摘　要"二字间空一个汉字符位，黑体四号加粗居中，单倍行距，段前 24 磅，段后 18 磅 | "Abstract" Times New Roman 四号加粗居中，单倍行距，段前 24 磅，段后 18 磅 |
| 段落文字 | 宋体小四号，1.25 倍行距，段前段后 0 磅 | Times New Roman 小四号，1.25 倍行距，段前段后 0 磅 |
| 关键词 | 与摘要间空一行，宋体小四号，1.25 倍行距，"关键词"三字加粗，**中文逗号隔开** | 与摘要间空一行，Times New Roman 小四号，1.25 倍行距，"Key Words"加粗，**英文逗号隔开**，首字母大写 |

并要求：摘要应概括研究目的、内容、方法、结论，突出创造性成果或新见解，**不使用公式、图表、表格或其他插图材料，不标注引用文献**；关键词 3~5 个，另起一行隔行排列于摘要下方，左顶格，中文用中文逗号、英文用英文逗号分隔，英文关键词首字母大写；摘要另起一页，与正文前内容连续编页（罗马数字）；英文摘要与中文摘要内容应一致；留学生用其他语种撰写时应有详细中文摘要，建议不少于 5000 字。

> 规范依据：《指导意见》一·（三）全文 + 三·（四）摘要表格。

### 4.2 代码实现

- 研究生中文摘要：`pages/master-abstract.typ`（`master-abstract` 函数）
- 研究生英文摘要：`pages/master-abstract-en.typ`（`master-abstract-en` 函数）
- 本科对应：`pages/bachelor-abstract.typ` / `pages/bachelor-abstract-en.typ`

调用方式：

```typst
// 中文摘要
#abstract(
  keywords: ("关键词1", "关键词2", "关键词3")
)[
  摘要正文内容...（不标注引用文献，不含图表）
]

// 英文摘要
#abstract-en(
  keywords: ("Keyword1", "Keyword2", "Keyword3")
)[
  Abstract content...
]
```

实现要点（`pages/master-abstract.typ`）：标题 `[摘#h(1em)要]` 二字间空 1em，黑体四号加粗居中；标题上方 `v(title-above)`（默认 24pt）、下方 `v(title-below)`（默认 18pt）对应规范段前段后；正文宋体小四、`leading: 1.25em`、两端对齐、首行缩进 2em；关键词与正文之间 `v(15pt)`；关键词行 `fakebold[关键词]：` + 关键词列表，`fakebold` 来自 `@preview/cuti:0.4.0` 确保中文伪加粗生效。

### 4.3 中文摘要定制参数

`pages/master-abstract.typ:6-32`：

| 参数名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| `keywords` | array | `()` | 关键词列表（3-5 个） |
| `outline-title` | content | `[摘#h(1em)要]` | 目录中显示的标题（用于 `invisible-heading`） |
| `outlined` | boolean | `false` | 是否加入目录（摘要通常不进目录） |
| `title-above` | length | `24pt` | 标题上方间距（规范段前 24 磅） |
| `title-below` | length | `18pt` | 标题下方间距（规范段后 18 磅） |
| `abstract-title-weight` | string | `"regular"` | 标题字重（默认 `regular`，因 `strong` 已加粗） |
| `stroke-width` | length | `0.5pt` | 信息区下划线宽度 |
| `info-value-align` | alignment | `center` | 信息值对齐方式 |
| `info-inset` | dictionary | `(x: 0pt, bottom: 0pt)` | 信息区内边距 |
| `info-key-width` | length | `74pt` | 信息标签宽度 |
| `grid-inset` | length | `0pt` | 网格内边距 |
| `column-gutter` | length | `0pt` | 列间距 |
| `row-gutter` | length | `10pt` | 行间距 |
| `leading` | length | `1.25em` | 行距（1.25 倍） |
| `spacing` | length | `1.25em` | 段间距 |

### 4.4 英文摘要定制参数

`pages/master-abstract-en.typ:5-32`：与中文摘要参数基本一致，差异：

- `outline-title` 默认 `"Abstract"`
- `column-gutter` 默认 `2pt`
- `anonymous-info-keys` 为 `("author-en", "supervisors-en")`
- 正文与关键词均使用 `Times New Roman` 字体（`master-abstract-en.typ:84, 110`）
- `show smartquote: set text(font: "Times New Roman")` 处理智能引号字体（`master-abstract-en.typ:102, 111`）

### 4.5 关键词分隔符注意事项

> ✅ **当前实现符合规范**：模板使用 `keywords.intersperse("，")` 渲染中文关键词、`keywords.intersperse(", ")` 渲染英文关键词（`master-abstract.typ:116`、`master-abstract-en.typ:112`），符合《指导意见》一·（三）「中文关键词间用中文逗号隔开」「英文关键词应与中文关键词对应，首字母应大写，用英文逗号隔开」的要求。如发现关键词分隔符显示为分号，请检查是否被自定义函数覆盖。

### 4.6 盲审模式下的摘要

- 中文摘要：隐藏 `author`、`grade`、`supervisors`（`master-abstract.typ:29`）
- 英文摘要：隐藏 `author-en`、`supervisors-en`（`master-abstract-en.typ:28`）

### 4.7 已知偏差

- **P13**：英文摘要所在偶数页的页眉仍显示中文论文题目，规范要求英文摘要页标英文题目。当前 `preface.typ:104-115` 的偶数页页眉固定用 `info.title`，未识别"英文摘要"上下文。英文摘要通常恰好一页、落在奇数页，此问题仅在英文摘要多于 1 页且其偶数页出现时暴露。
- **P14**：摘要标题"单倍行距"未显式设置，单行标题不受影响。

> 规范依据：《指导意见》三·（八）「均须由另页右页（奇数页）开始」；一·（三）末段「英文摘要标明英文题目」。详见 [§19](#19-已知偏差与待办)。

---

## 5. 目录（Outline）

### 5.1 规范要求

《指导意见》一·（四）与三·（五）规定：目录**不包括**中英文摘要，须包括论文正文全部内容标题，以及参考文献、附录（若有）和致谢等；正文章节题名**最多编到第三级标题**（即 `1.1.1`）；一级标题顶格，二级缩进一个汉字符，三级缩进两个汉字符；目录另起一页，与正文前内容连续编页（罗马数字）；页码右对齐，用点号 `.` 引导。

各级行格式：

| 级别 | 字号 | 字体 | 段前 | 段后 | 缩进 |
|------|------|------|------|------|------|
| 章目录（一级） | 四号 | 黑体 | 6pt | 0pt | 顶格 |
| 二级标题目录 | 小四号 | 黑体 | 6pt | 0pt | 1 个汉字符 |
| 三级标题目录 | 小四号 | 黑体 | 6pt | 0pt | 2 个汉字符 |
| 其他（参考文献/附录/致谢） | 四号 | 黑体 | 6pt | 0pt | 顶格 |

### 5.2 代码实现

`pages/outline-page.typ`。调用方式：

```typst
#outline-page()
```

实现要点：通过 `invisible-heading` 插入不可见标题使目录本身不被列入目录但占位；标题 `[目#h(1em)录]` 二字间空 1em（一个汉字符位），黑体四号加粗居中，段前 24pt、段后 18pt 对应规范要求；`set outline(indent: ...)` 控制各级缩进——注意 Typst `outline.indent` 回调为 0-indexed（level1→0、level2→1、level3→2），配合默认 `indent: (0pt, 12pt, 12pt)` 得一级=0pt、二级=12pt、三级=24pt；`show outline.entry` 自定义条目渲染（字号、字体、段前段后、点号引导）。

### 5.3 目录定制参数

`pages/outline-page.typ:5-32`：

| 参数名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| `depth` | int | `3` | 目录深度（最多显示几级标题）。规范要求最多三级（1.1.1） |
| `title` | content | `[目#h(1em)录]` | 目录标题 |
| `outlined` | boolean | `false` | 目录自身是否加入目录 |
| `title-above` | length | `24pt` | 标题上方间距 |
| `title-below` | length | `18pt` | 标题下方间距 |
| `title-text-args` | dictionary | `auto` | 标题文本参数（auto 时为 `(font: 黑体, size: 四号, weight: "bold")`） |
| `reference-font` | font | `auto` | 页码字体（auto 时为 `fonts.宋体`，因含 Times New Roman） |
| `reference-size` | length | `字号.小四` | 页码字号 |
| `font` | font/list | `auto` | 条目字体（auto 时 `(黑体, 黑体)`） |
| `size` | array | `(字号.四号, 字号.小四)` | 各级条目字号 |
| `above` | array | `(6pt, 6pt)` | 各级条目上方间距（规范 6pt） |
| `below` | array | `(0pt, 0pt)` | 各级条目下方间距（规范 0pt） |
| `indent` | array | `(0pt, 12pt, 12pt)` | 各级条目缩进增量（0 顶格、12pt = 1 汉字符、12pt = 1 汉字符，累加得二级 12pt、三级 24pt） |
| `fill` | content | `(repeat([.], gap: 0.15em),)` | 引导符样式 |
| `gap` | length | `.3em` | 条目与页码间距 |

### 5.4 标题段前段后间距计算逻辑

目录条目实际间距采用动态计算（`pages/outline-page.typ:68-78`）：

```
实际段前 = 规范值（不加行距，优化视觉效果）
实际段后 = 规范值 + 当前级别字体大小（单倍行距）
```

> 源码注释明确：「不去除会导致间距过大」。这是 Typst 渲染机制与 Word 段间距语义差异的折中处理。

> ⚠️ **已知偏差 P7**：目录条目段后实际渲染为 `0pt + 字号(14/12pt)`，即一级约 14pt、二三级约 12pt，并非规范表三·（五）要求的"段后 0 磅"。属有意的视觉优化，但与规范数值不符。详见 [§19](#19-已知偏差与待办)。

---

## 6. 图表目录（List of Figures and Tables）

### 6.1 规范要求

《指导意见》一·（四）「论文中若有图表，应有图表目录，置于目录页之后，另页编排。图表目录应有序号、图题或表题和页码」与一·（六）·6「先列图后列表，置于目录页后，另页编排」。

图表目录标题规范（三·（五））：黑体四号加粗居中，单倍行距，段前 24 磅，段后 18 磅。条目黑体四号，单倍行距，段前 6 磅，段后 0 磅，两端对齐，页码右对齐。

### 6.2 代码实现

`pages/list-of-figures-and-tables.typ`。调用方式：

```typst
#list-of-figures-and-tables()
```

实现要点：先渲染图目录，再渲染表目录（先图后表）；通过 `bilingual-figured.outline(target-kind: "bifigure")` 与 `target-kind: "bitable"` 分别生成；自定义 `show outline.entry` 使双语图表目录仅显示中文标题（`lang: "zh"`）；两目录之间 `v(title-above)` 分隔；`twoside: true` 时末尾 `pagebreak() + " "` 对齐到奇数页。

### 6.3 图表目录定制参数

`pages/list-of-figures-and-tables.typ:6-25`：

| 参数名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| `title` | string | `"图表目录"` | 总标题（不显示，仅作为不可见 heading 用于目录） |
| `fig-title` | string | `"图目录"` | 图目录标题 |
| `tbl-title` | string | `"表目录"` | 表目录标题 |
| `outlined` | boolean | `false` | 是否加入目录 |
| `title-above` | length | `24pt` | 标题上方间距（规范 24pt） |
| `title-below` | length | `18pt` | 标题下方间距（规范 18pt） |
| `title-text-args` | dictionary | `auto` | 标题文本参数 |
| `font` | font | `auto` | 字体（auto 时 `fonts.黑体`） |
| `size` | length | `字号.四号` | 字号 |
| `above` | length | `6pt` | 条目上方间距（规范 6pt） |
| `below` | length | `0pt` | 条目下方间距（规范 0pt） |

---

## 7. 符号说明（Notation）

### 7.1 规范要求

《指导意见》一·（五）：

- 若论文中使用了大量的物理量符号、标志、缩略词、专门计量单位、自定义名词和术语等，应编写成注释说明汇集表
- 若使用数量不多，可以不设此部分，但必须在论文中首次出现时加以说明
- 置于目录之后、正文之前，另起一页，与正文前的内容连续编页（罗马数字）

### 7.2 代码实现

`pages/notation.typ`。调用方式：

```typst
#notation()[
  == 字符

  #table(
    columns: (1fr, auto, auto),
    table.header([*符号*][*说明*][*单位*]),
    [$R$], [气体常数], [$m^2 dot s^(-2) dot K^(-1)$],
  )

  == 算子

  #table(...)

  == 缩写

  #table(...)
]
```

实现要点：标题黑体四号加粗居中，段前 24pt、段后 18pt；首行缩进设为 0（符号列表不缩进）；通过 `invisible-heading` 让符号列表可选地出现在目录中。

### 7.3 符号列表定制参数

`pages/notation.typ:5-21`：

| 参数名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| `title` | string | `"符号列表"` | 页面标题 |
| `outlined` | boolean | `false` | 是否加入目录 |
| `title-above` | length | `24pt` | 标题上方间距 |
| `title-below` | length | `18pt` | 标题下方间距 |
| `title-text-args` | dictionary | `auto` | 标题文本参数 |
| `font` | font | `auto` | 字体 |
| `size` | length | `字号.小四` | 字号 |

---

## 8. 正文（Main Matter）

### 8.1 规范要求

《指导意见》一·（六）规定正文一般包括绪论、论文主体、研究结论与展望三部分。**绪论**应独立成章，涵盖选题背景与意义、国内外研究述评、所要解决的科学问题、主要理论方法与论文结构，不与摘要雷同；**论文主体**可按章与节的结构组织，也可按"研究背景与意义—研究方法与过程—研究结果与讨论"形式展开；**研究结论与展望**须凝练主要创新点，分析学术价值与应用价值，说明研究局限并展望后续工作，严格区分本人成果与他人成果。

**版式与编号**方面，正文须由另页右页（奇数页）开始，阿拉伯数字连续编码至全文末；正文内部新章节无须另页右页起。标题分层以阿拉伯数字连续编号，以三级为宜、最多四级，末位数字后不加点号（如 `1.1`、`1.1.1`）；章标题居中排版，各层次序号左起顶格排，序号与题名间空一个汉字符。图、表、附注、公式一律分章连续编码（如 `图1-1`、`表3-2`），附录图表参考正文方式但用"附图/附表"前缀。

**页码与页眉**方面，正文页码位居左页左下、右页右下；正文前部分（摘要、目录等）用大写罗马数字单独编排，页码居中。页眉从摘要开始：奇数页标"摘要"/"Abstract"/"目录"/"图表目录"/当前章名/"参考文献"/"附录"/"致谢"等，偶数页标论文题目（英文摘要页标英文题目），居中设置，宋体小五号。

**正文段落**为宋体小四号（英文用 Times New Roman），两端对齐，首行缩进两个汉字符，段前段后 0 磅，1.25 倍行距（含数学表达式的段落可调整）。章标题字号如下：

| 级别 | 示例 | 字号 | 字体 | 段前 | 段后 | 对齐 |
|------|------|------|------|------|------|------|
| 一级 | `第1章 ×××` | 四号 | 黑体加粗 | 24pt | 18pt | 居中 |
| 二级 | `1.2 ××××` | 小四号 | 黑体 | 24pt | 6pt | 顶左 |
| 三级 | `1.2.1 ×××` | 小四号 | 黑体 | 12pt | 6pt | 顶左 |
| 四级 | `1.2.1.1 ××` | 小四号 | 黑体 | 12pt | 6pt | 居左 |

### 8.2 代码实现

`layouts/mainmatter.typ`。调用方式：

```typst
#show: mainmatter

= 绪论<chap:introduction>

== 研究背景

正文内容...
```

实现要点（行号集中于 `layouts/mainmatter.typ`）：通过 `set page(numbering: "1")` 切换为阿拉伯页码，`counter(page).update(1)` 重置计数器；双面模式下若当前页为偶数则插入空白页使正文从奇数页起；通过三层叠加的 `show heading` 规则分别处理段前段后间距、字体字号、自动换页与对齐；`set math.equation(number-align: bottom + end)` 实现公式编号底部右对齐；`show figure.where(kind: table): set figure.caption(position: top)` 将表题置于表上方。

### 8.3 正文排版参数

`layouts/mainmatter.typ:10-60`：

| 参数名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| `leading` | length | `1.25em` | 行距（1.25 倍） |
| `spacing` | length | `1.25em` | 段间距 |
| `justify` | boolean | `true` | 两端对齐 |
| `first-line-indent` | dictionary | `(amount: 2em, all: true)` | 首行缩进 2 字符 |
| `numbering` | function | `custom-numbering.with(first-level: "第1章\u{3000}", depth: 4, "1.1\u{3000}")` | 章节编号格式 |
| `text-args` | dictionary | `auto` | 正文文本参数（auto 时 `(font: 宋体, size: 小四, top-edge: "cap-height", bottom-edge: "baseline")`） |
| `display-header` | boolean | `true` | 是否显示页眉 |
| `header-vspace` | length | `0em` | ⚠️ 自 `foreground`+`place` 重构后**不再生效**（`place` 的 body 内 `v()` 不推后续元素），保留签名仅为向后兼容。原作用是调整 `header-ascent` 锚定下页眉块的总高度。见 [§15.1](#151-页面尺寸与页边距) |
| `skip-on-first-level` | boolean | `true` | 是否跳过一级标题页眉 |
| `stroke-width` | length | `0.8pt` | 页眉分隔线宽度 |
| `reset-footnote` | boolean | `true` | 是否重置脚注计数器 |
| `separator` | string | `"  "` | 图表标题分隔符（图序与图题间两个空格） |
| `caption-style` | function | `strong` | 图表标题样式（加粗） |
| `caption-size` | length | `字号.五号` | 图表标题字号（规范五号） |
| `show-figure` | function | `bilingual-figured.show-figure` | 图编号函数 |
| `show-equation` | function | `bilingual-figured.show-equation` | 公式编号函数 |

### 8.4 标题样式配置

`layouts/mainmatter.typ:36-46`：

| 参数名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| `heading-font` | array | `(fonts.黑体,)` | 标题字体 |
| `heading-size` | array | `(字号.四号, 字号.小四, 字号.小四, 字号.小四)` | 各级标题字号 |
| `heading-weight` | array | `("bold", "regular", "regular", "regular")` | 各级标题字重（仅一级加粗） |
| `heading-above` | array | `(24pt, 24pt, 12pt, 12pt)` | 标题段前间距（规范值） |
| `heading-below` | array | `(18pt, 6pt, 6pt, 6pt)` | 标题段后间距（规范值） |
| `heading-pagebreak` | array | `(true, false)` | 是否自动换页（索引 0 对应一级标题） |
| `heading-align` | array | `(center, auto)` | 标题对齐方式（一级居中、其余顶左） |

### 8.5 标题段前段后间距计算逻辑

`layouts/mainmatter.typ:153-164` 采用动态计算，实际渲染时在规范值基础上**加当前级别的单倍行距（1em = 字体大小）**：

```typst
let actual-above = array-at(heading-above, it.level) + current-size
let actual-below = array-at(heading-below, it.level) + current-size
set block(above: actual-above, below: actual-below)
```

| 级别 | 字体大小 | 规范段前 | 规范段后 | 实际段前 | 实际段后 |
|------|---------|---------|---------|---------|---------|
| 一级 | 14pt | 24pt | 18pt | 38pt | 32pt |
| 二级 | 12pt | 24pt | 6pt | 36pt | 18pt |
| 三级 | 12pt | 12pt | 6pt | 24pt | 18pt |
| 四级 | 12pt | 12pt | 6pt | 24pt | 18pt |

> ⚠️ **已知偏差 P6**：所有标题的实际段前段后比规范表三·（六）的 24/18、24/6、12/6、12/6 系统性偏大（+字号）。源码注释表明这是与 Word「段前段后+行距」口径差异的折中处理；当一级标题处于页首时，Typst 会自动裁剪页面顶部首个块的 `above` 间距，故视觉上章标题在页首时段前接近 0。详见 [§19](#19-已知偏差与待办)。

> 上一版文档列出的"实际段后"误算（一级 20pt、其余 18pt），实际计算应为：18pt + 14pt = 32pt、6pt + 12pt = 18pt。本表已更正。

### 8.6 章节编号格式

由 `utils/custom-numbering.typ` 的 `custom-numbering` 函数实现（`layouts/mainmatter.typ:27-31`）：

```typst
numbering: custom-numbering.with(
  first-level: "第1章\u{3000}",
  depth: 4,
  "1.1\u{3000}",
)
```

效果：

- 一级标题：`第1章`、`第2章`……（`first-level` 参数控制）
- 二级标题：`1.1`、`1.2`……（缺省 `1.1` 格式）
- 三级标题：`1.1.1`、`1.1.2`……
- `depth: 4` 表示最多编号到第四级；超过则不显示编号（但仍可显示标题文字）

序号与题名间空一个汉字符由 `first-level: "第1章\u{3000}"` 末尾的 **U+3000 全角空格**实现（在 CJK 字体下宽度恒为 1em），二三级由 `custom-numbering` 内部 `numbering(...)` 渲染后追加 `\u{3000}`。

> 规范依据：《指导意见》二·（六）·2·（1）「序号与题名间空一个汉字符」。注意半角空格 U+0020 在 CJK 字体下仅约 0.25em，**不满足规范**；模板统一使用 U+3000 全角空格。

### 8.7 页眉与页脚

**页眉与页脚的定位机制**（`layouts/mainmatter.typ:220-331`、`layouts/preface.typ:63-199`，二者同构）：页眉、页脚距页边界 1.5cm **不**经 `page` 的 `header-ascent`/`footer-descent` 实现（那两个参数语义是「侵入 margin 的量」，无法精确表达"距边界 1.5cm"），而由 `set page(foreground: context { ... })` 内两个 `place` 绝对定位：

```typst
// 页眉：距页顶 1.5cm
place(top + center, dy: 1.5cm, {
  set text(font: fonts.宋体, size: 字号.小五, top-edge: "bounds", bottom-edge: "bounds")
  block(width: 100% - 3.17cm - 3.17cm)[
    #align(center, header-content)
    #v(0.5em)
    #line(length: 100%, stroke: stroke-width + black)
  ]
})
// 页脚：距页底 1.5cm
place(bottom + center, dy: -1.5cm, {
  set text(font: fonts.宋体, size: 字号.小五, top-edge: "bounds", bottom-edge: "bounds")
  counter(page).display("1")  // preface 用 "I"
})
```

实测（typst 0.15.1，PyMuPDF）：页眉文字 bbox 顶距顶 1.472–1.506cm，页脚页码**基线**距底精确 1.5000cm。`place(top, dy)` 锚定 body 块顶边、`place(bottom, dy)` 锚定文字基线；`top-edge:"bounds"` 让块顶边=字形 bbox 顶。详见 [§15.1](#151-页面尺寸与页边距)。

**页眉内容逻辑**（`mainmatter.typ:235-285`、`preface.typ:78-161`）：

- **奇数页**：显示当前页的一级标题（章名）。通过 `query(heading.where(level: 1)).filter(h => h.location().page() == current-page)` 找到当前页的章标题；若当前页无章标题，回退到 `selector(heading.where(level: 1)).before(here())` 的最后一个（`mainmatter.typ:235-250`）
- **偶数页**：显示论文题目（`info.title` 拼接，`mainmatter.typ:272-285`）；前言部分若当前处于英文摘要则用 `info.title-en`（`preface.typ:109-149` 检测 `heading-text.contains("Abstract")`）
- 字体 `fonts.宋体`、`字号.小五`，居中，下方 `0.8pt` 黑色实线分隔（`stroke-width` 参数，`block(width: 100% - 3.17cm - 3.17cm)` 约束到正文区宽度）
- 章标题编号通过 `heading.numbering` 函数直接渲染——这是关键设计：调用 `(current-heading.numbering)(..counter-values)`，而非硬编码"第1章"（`mainmatter.typ:251-266`）。这样附录（`first-level: ""`）的页眉不会错误显示"第1章"，而显示纯标题"附录"。序号与章名间的"一个汉字符"由 `numbering` 模板内的全角空格 U+3000 提供。

> ✅ **P1 已修复**：早期版本中页眉代码硬编码 `custom-numbering(first-level: "第1章\u{3000}", ...)`，导致附录页眉显示"第1章　附录"。现已改为调用 `heading.numbering` 自身的函数，附录页眉正确显示"附录"。

**页脚（页码）对齐**（`mainmatter.typ:311-330`）：

- `twoside: false`（单面）：页码居中
- `twoside: true`（双面）：奇数页右对齐、偶数页左对齐（`place(bottom+center)` 内 `block` 的 `align` 按页码奇偶切换）

> 规范依据：《指导意见》二·（六）·2·（3）「页码应位居左页左下角、右页右下角」——本模板已通过 `place(bottom)` + 奇偶对齐实现。

**前言页码**（`layouts/preface.typ:44-62`）：

- 双面：`pagebreak(to: "odd")` 强制摘要从奇数页（右页）起；单面：`pagebreak(weak: true)` 确保摘要从新页起
- `counter(page).update(1)` 重置为 1（**非 0**）——page counter 在 pagebreak 后的新页起始处生效，`update(1)` 使摘要首页 counter=1（奇），与物理奇数页一致；若用 `update(0)`，首页 counter=0（偶），页码渲染为 "N"（`numbering("I", 0)` = "N"）、页眉误显论文题目（odd(0)=false）
- `set page(numbering: "I")` 大写罗马数字
- 居中显示（前言部分规范要求"页面下方居中"）

> ⚠️ **已知偏差 P4**：前言（罗马数字页码）的页脚步未显式设置字体字号，使用 Typst 默认字体（约 11pt），与规范"Times New Roman 体小五号"（9pt）不符；与正文页码（`mainmatter.typ:208` 显式 `fonts.宋体, size: 字号.小五`）也不一致。详见 [§19](#19-已知偏差与待办)。

### 8.8 防止自动换页

默认情况下，一级标题（`heading-pagebreak: (true, false)`）前会自动 `pagebreak(weak: true)`（`mainmatter.typ:187-193`）。但在以下场景需要禁止自动换页：

- 致谢、作者简历等位于文末的部分（已通过 `<no-auto-pagebreak>` 标签处理）
- 用户自定义场景：给标题打标签 `<no-auto-pagebreak>`

```typst
// layouts/mainmatter.typ:187-193
show heading: it => {
  if array-at(heading-pagebreak, it.level) {
    if "label" not in it.fields() or str(it.label) != "no-auto-pagebreak" {
      pagebreak(weak: true)
    }
  }
  // ...
}
```

`pages/acknowledgement.typ:24` 和 `pages/backmatter.typ:19` 内部已为标题打上此标签。

> 规范依据：《指导意见》二·（六）·1「正文内部新章节无须另页右页（奇数页）开始」——但章（一级标题）须另页起。模板默认行为符合此规范，仅在致谢/简历等需要紧接前文时禁用。

---

## 9. 图与表（Figures & Tables）

### 9.1 规范要求

《指导意见》二·（六）·6 与三·（六）正文表格规定了图表的通用要求：

**图与表的共同要求**——均应具有"自明性"（只看图表及其题注即可理解，不阅读正文）；每一图表应有简短确切的题名，连同序号居中排列；题名建议用中英文两种文字表达；引用的图表必须注明来源；图表序与题名间空一个汉字符位；中文（宋体）英文（Times New Roman）题注为五号字，1.25 倍行距；中文题名段前 6pt 段后 0pt，英文题名段前 0pt 段后 12pt；序号、题名加粗；"注"字加粗，左缩进两个汉字符，续行缩进至"注"后。

**图的特有要求**——图序、图题、图注依次置于**图下居中**；图中的符号标记、代码及实验条件等可横排于图框内或外作图注；图片一般设为高 6cm × 宽 8cm，可按比例缩放；若图片含文字，文字大小不超过正文文字；涉国界图件须使用自然资源部标准地图底图（http://bzdt.ch.mnr.gov.cn），底图边界无修改，比例尺用线段比例尺，并在图题下注明审图号。

**表的特有要求**——表序、表题置于**表上居中**，表注位于表下；表内同一栏数字必须上下对齐；表内不应用"同上""同左"等词及"″"符号，"空白"代表无此项，"—"或"..."代表未发现，"0"代表实测结果为零，"N.D."表示未测出；表格尽量用**三线表**，避免竖线；确有必要时可用卧排表，方位"顶左底右"；表格太大需要转页时，续表表头上方注明"续表"，表头重复排出。

### 9.2 代码实现：双层架构

图表功能采用**双层架构**：

1. **底层引擎** `utils/bilingual-figured.typ`（源自 RubixDev，MIT 许可，可独立作为外部包使用）：

   - 通用双语图表引擎，提供 `bifigure`/`bitable`/`bilingual-caption-style`/`show-bilingual`/`show-figure`/`show-equation`/`outline`/`reset-counters`/`extract-bilingual-caption`/`show-bilingual-outline-entry`
   - 通过 `prefixed-kind` 给图表打上 `bilingual-figured-bifigure` / `bilingual-figured-bitable` 内部 kind，便于 `show` 规则识别
   - 支持 `keep_together: true` 防止图表主体与双语标题跨页拆分（`bilingual-figured.typ:496-500`）
   - 支持续表（`continued: true` 参数追加"（续表）"/"(continued)"标记）
   - 通过 `_appendix-state` 状态机记录"是否处于附录模式"，供 `auto-table` 等无 `show-figure` 路径的工具读取（`bilingual-figured.typ:30-36`）

2. **模板内层封装** `utils/custom-figure.typ`：

   - `bifigure` / `bitable` 直接透传底层引擎（`custom-figure.typ:4-5`）
   - `thesis-bilingual-caption-style(fonts)` 给引擎套上 UCAS 规范样式（宋体五号加粗、`*注：*` 前缀、`keep_together: true` 默认防跨页，`custom-figure.typ:7-62`）
   - 详见 [§9.6](#96-双语图表样式定制)

`documentclass` 返回的 `bifigure` / `bitable` 直接来自 `utils/custom-figure.typ`：

```typst
// lib.typ:24
#import "utils/custom-figure.typ": bifigure, bitable
```

### 9.3 双语图表示例

**图（双语）**：

```typst
#bifigure(
  image("images/ucas-emblem.svg", width: 10%),
  caption-zh: [中国科学院],
  caption-en: [Chinese Academy of Sciences],
  note: [可选图注内容。],  // 可选
) <ucasLogo>

见 @fig:ucasLogo 所示。
```

**表（双语）**：

```typst
#bitable(
  table(
    columns: 3,
    align: center,
    table.header([项目], [数值], [单位]),
    [A], [10.5], [cm],
    [B], [20.3], [kg],
  ),
  caption-zh: [带注释的实验数据表],
  caption-en: [Experimental Data Table with Note],
  note: [所有数值均为三次测量的平均值。],  // 可选
) <with-note>

见 @tbl:with-note。
```

底层 `bifigure` / `bitable` 签名（`utils/bilingual-figured.typ:345-397`）：

```typst
#let bifigure(
  body,
  caption-zh: none, caption-en: none, note: none,
  kind: "bifigure",
  supplement-zh: [图], supplement-en: [Figure],
  numbering: "1-1",
  ..args,
) = ...

#let bitable(
  body,
  caption-zh: none, caption-en: none, note: none,
  kind: "bitable",
  supplement-zh: [表], supplement-en: [Table],
  numbering: "1-1",
  ..args,
) = ...
```

`bitable` 兼容原生 `figure` 的 `metadata` 写法：

```typst
#figure(
  table(...),
  kind: "bitable",
  caption: metadata((zh: [表题], en: [Table Title], note: none)),
  numbering: "1-1",
) <label>
```

### 9.4 续表（自动 / 手动）

`utils/continued-table.typ` 提供两种续表工具：

#### 自动续表 `auto-table`

主动采用可分页渲染，**不受** `bitable` 默认 `keep_together: true` 的防跨页约束，适合长表。每页自动重复表头并标注"续表"/"(continued)"（`continued-table.typ:215-340`）：

```typst
#auto-table(
  caption-zh: [各地区经济指标],
  caption-en: [Regional Economic Indicators],
  columns: 5,
  align: center,
  stroke: none,
  header: (
    table.hline(), [地区], [GDP（亿元）], [增长率（%）], [人口（万）], [人均GDP（元）],
    table.hline(stroke: .5pt),
  ),
  label: <regional>,
  ..rows,
  table.hline(),
)
```

`auto-table` 在附录中通过 `bilingual-figured.in-appendix()` 读取附录状态，自动将前缀切换为"附表/Appendix Table"（`continued-table.typ:254-265`）。

#### 手动续表 `continued-table`

需先有一个原表（带 label），再调用 `continued-table` 显式指定续表位置。**`source` 参数必须使用带前缀的标签**（如 `<tbl:label>`）：

```typst
// 原表
#bitable(
  table(...),
  caption-zh: [实验数据],
  caption-en: [Experimental Data],
) <tbl:manual-continued>  // 注意：必须带 tbl: 前缀

// 手动续表
#continued-table(
  <tbl:manual-continued>,  // ← 带前缀的标签
  align(center)[#table(...)],
  note: [续表数据为补充实验结果。],
)
```

`continued-table` 会从原表的 caption 元数据中提取中英文标题、supplement，自动以相同编号渲染"（续表）"标题（`continued-table.typ:342-412`）。

> ⚠️ 续表编号必须与原表一致（章节号 + 表序号），故 `continued-table` 沿用 `auto-table` 的 `_display-table-number`（`continued-table.typ:384-391`），而非 `display-figure-number`——后者只取 figure 计数器单值，会把章节号位错填成表序号，渲染成"表 1"而非"表 1-1"。

### 9.5 图表交叉引用约定

本模板统一使用**带前缀引用**：

| 引用对象 | 标签前缀 | 引用语法 | 示例 |
|---------|---------|---------|------|
| 图 | `fig:` | `@fig:label` | `@fig:ucasLogo` → `图 1-1` |
| 表 | `tbl:` | `@tbl:label` | `@tbl:with-note` → `表 1-1` |
| 行间公式 | `eqt:` | `@eqt:label` | `@eqt:golden-ratio` → `(1-1)` |
| 代码块 | `lst:` | `@lst:label` | `@lst:code` → `1-1` |

底层 `bilingual-figured.show-figure` 会自动给用户标签补全前缀（`bilingual-figured.typ:155-177`）：

```typst
let prefixes = (
  table: "tbl:", raw: "lst:",
  bitable: "tbl:", bifigure: "fig:",
) + extra-prefixes
```

> 若用户标签已带正确前缀（如 `<fig:ucasLogo>`），不会被重复添加；若未带前缀（如 `<ucasLogo>`），会自动补全为 `fig:ucasLogo`。

### 9.6 双语图表样式定制

模板默认通过 `utils/custom-figure.typ:7-65` 的 `thesis-bilingual-caption-style(fonts)` 统一配置双语图表样式。该函数内部调用 `bilingual-figured.bilingual-caption-style(...)`，传入了 UCAS 规范值：

- `zh_text` / `en_text`: `(font: 宋体, size: 五号, weight: "bold")` ——宋体五号加粗
- `note_text`: `(font: 宋体, size: 五号)` ——注五号不加粗
- `note_prefix`: `[*注：* ]` ——"注"字加粗
- `note_align: left`
- `zh_block`: `(above: 6pt + leading, below: 0pt + leading)` ——中文标题段前 6pt、段后 0pt（+ 行距）
- `en_block`: `(above: 0pt + leading, below: 12pt)` ——英文标题段前 0pt、段后 12pt
- `note_block`: `(above: 6pt + leading, below: 0pt + leading, inset: (left: 2em))` ——注左缩进 2 字符
- `keep_together: true` ——防跨页
- `caption_par: (leading: 1.25em)` ——1.25 倍行距
- `float_clearance: 1.5em`、`float_align: center`、`float_width: 100%`

如需修改双语标题行距、跨页策略、段前段后间距，编辑 `utils/custom-figure.typ` 中的 `thesis-bilingual-caption-style`。常用定制参数：

| 参数 | 默认 | 说明 |
|------|------|------|
| `leading` | `1.25em` | 标题段落行距 |
| `keep_together` | `true` | 是否尽量保持"图表主体 + 双语标题 + 注释"在同页 |
| `caption_par` | `auto`（→ `(leading: leading)`） | 标题段落参数 |
| `note_par` | `auto`（→ 继承 `caption_par`） | 注释段落参数 |
| `zh_block` | `auto` | 中文标题段前段后 |
| `en_block` | `auto` | 英文标题段前段后 |
| `note_block` | `auto` | 注释段前段后与缩进 |
| `note_inset` | `(left: 2em)` | 注释左缩进 |

### 9.7 三线表与卧排表

**三线表**：通过 `table.hline()` 组合实现，模板内置示例：

```typst
#bitable(
  table(
    columns: 4,
    stroke: none,
    table.hline(),                       // 顶线
    [t], [1], [2], [3],
    table.hline(stroke: .5pt),           // 栏目线
    [y], [0.3s], [0.4s], [0.8s],
    table.hline(),                       // 底线
  ),
  caption-zh: [三线表],
  caption-en: [Three-line Table],
) <timing-tlt>
```

**卧排表**：规范要求"顶左底右"方位（即表格逆时针旋转 90°，表顶朝页面左侧、表底朝右侧）。`bitable`、`bifigure` 与 `auto-table` 均内置 `landscape` 参数，置 `landscape: true` 即可将整个图表（含标题与注释）逆时针旋转 90°，标题与注释随表格一同旋转，方位保持一致：

```typst
#bitable(
  table(
    columns: 7 * (auto,),
    align: center + horizon,
    stroke: none,
    table.hline(),
    [序号], [样本编号], [测量项目], [测量值], [单位], [方法], [备注],
    table.hline(stroke: .5pt),
    [1], [S-001], [长度], [12.45], [cm], [游标卡尺], [室温],
    table.hline(),
  ),
  caption-zh: [多列宽表（卧排）],
  caption-en: [Wide Multi-column Table (Landscape)],
  landscape: true,
) <landscape-table>
```

实现要点（`utils/bilingual-figured.typ` 的 `_render-bilingual`）：`landscape` 标志存入 caption metadata，渲染时用 `rotate(-90deg, reflow: true, rendered)` 包裹整个图表块——`-90deg`（逆时针）使表顶朝左、表底朝右，`reflow: true` 让旋转后包围盒重算以正确影响布局（Typst 官方 tables 指南方案）。`auto-table`（`utils/continued-table.typ`）不经 `show-figure` 重建，在其内部自行包裹 `rotate`，并强制 `breakable: false`。

> 限制：旋转内容不跨页，故卧排表应控制在一页之内；若宽表旋转后仍超出版心（A4 页高减上下边距约 24.62cm），Typst 会溢出而非自动分页，需自行缩减列宽或列数。

> 规范依据：《指导意见》二·（六）·6·（2）「表格尽量用'三线表'，避免出现竖线，避免使用过大的表格，确有必要时可采用卧排表，正确方位应为'顶左底右'」。

### 9.8 已知偏差

- ✅ **P12**（已修复）：图注续行缩进已通过 grid 两列分置"注："前缀与注释正文实现几何对齐——前缀列 `auto` 取自身宽度，正文列 `1fr` 填满剩余，换行时续行自然落在前缀之后，满足"续行缩进至'注'后"。整体左缩进 2em 由 `note_block.inset` 提供。实现见 `utils/bilingual-figured.typ:488-500`，`auto-table`/`continued-table` 同构（`utils/continued-table.typ:131-141`）。

> 规范依据：《指导意见》二·（六）·6「'注'字加粗，左缩进两个汉字符，续行缩进至'注'后」。详见 [§19](#19-已知偏差与待办)。

---

## 10. 公式（Equations）

### 10.1 规范要求

《指导意见》二·（六）·7 表达式（公式）：

- 论文中的表达式需**另行起**，原则上应**居中**
- 若有两个以上的表达式，应从"1"开始的阿拉伯数字进行编号，编号置于**括号内**
- 编号采用**右端对齐**
- 表达式较多时可**分章编号**，如第 3 章第 1 个表达式 `(3-1)`
- 较长的表达式如必须转行，只能在 `+ - × ÷ < >` 等运算符**之后转行**
- 序号编于**最后一行右顶格**

### 10.2 代码实现

公式编号通过 `bilingual-figured.show-equation` 实现（`layouts/mainmatter.typ:132-134`）：

```typst
set math.equation(number-align: bottom + end)  // 编号底部右对齐
// 公式编号字体：宋体。编号是 equation 元素渲染的文本部分，随 set text 生效；
// 数学符号仍由 math 字体控制，不受影响。
show math.equation.where(block: true): set text(font: fonts.宋体)
show math.equation.where(block: true): bilingual-figured.show-equation
```

`show-equation`（`utils/bilingual-figured.typ:180-225`）关键逻辑：仅对块级公式（`block: true`）应用编号；`only-labeled: false` + `it.has("label")` 检测，仅给带标签的公式编号；默认 `numbering: "(1-1)"`、`prefix: "eqt:"`、`unnumbered-label: "-"`；标签自动补 `eqt:` 前缀；不编号公式通过 `<->` 标签标识。`layouts/appendix.typ` 同样设此两条规则，使附录公式编号亦为宋体。

> ⚠️ **编号字号限制**：规范要求"序号加圆括号，宋体五号（10.5pt）"。模板已设编号字体为宋体；但 Typst 0.15 的公式编号是 equation 元素的内部渲染，无独立字段可单独样式化字号——`show math.equation.where(block: true): set text(size: ...)` 会同时改变公式正文字号（规范要求正文小四 12pt），二者无法兼得。故编号字号继承正文小四 12pt，这是 Typst 的固有限制，非模板可绕过。详见 [§19](#19-已知偏差与待办) P5。

### 10.3 多行对齐公式

`utils/aligned-equation.typ` 提供多行对齐公式，编号对齐到最后一行右侧：

```typst
#aligned-equation[$
  f(x) & = a x^2 + b x + c \
       & = a(x + b/(2a))^2 + c - b^2/(4a)
$] <quadratic>

由 @eqt:quadratic 可知...
```

> 注：`aligned-equation` 是**语义标记**，本身只是 `let aligned-equation(body) = body` 透传（`aligned-equation.typ:9`）。编号底部对齐由 `mainmatter`/`appendix` 的全局 `set math.equation(number-align: bottom + end)` 提供。

### 10.4 不编号公式

行间公式加 `<->` 标签表示不编号：

```typst
// 不带编号的行间公式
$ y = integral_1^2 x^2 dif x $ <->
```

后续公式仍能正常编号。

### 10.5 已知偏差

- ⚠️ **P5**：公式编号**字体已设为宋体**（`mainmatter.typ:138`、`appendix.typ:73` 的 `show math.equation.where(block: true): set text(font: fonts.宋体)`）；但**字号继承正文小四 12pt**，规范要求"序号加圆括号，宋体五号 10.5pt"。Typst 0.15 的公式编号是 equation 元素内部渲染，无独立字段单独样式化字号——`set text(size:)` 会同时改变公式正文字号（规范要求正文小四 12pt），二者无法兼得，属 Typst 固有限制。

> 规范依据：《指导意见》二·（六）·7 + 三·（六）正文中"序号五号"（与图表标题同号）。详见 [§19](#19-已知偏差与待办)。

---

## 11. 参考文献（References）

### 11.1 规范要求

《指导意见》一·（七）、二·（七）与三·（七）规定：参考文献格式参照 GB/T 7714—2015 或国际刊物通行格式；文后参考文献与正文引用一一对应，严禁抄袭剽窃；标注方式可采用**顺序编码制**或**著者—出版年制**，二者必须对应；文后参考文献加标题"参考文献"并列入全文目录，集中著录于正文之后、不分章节著录；正文中未被引用但被阅读或具有补充信息的文献可集中列入附录，标题为"荐读书目"。

**正文引用标注**：顺序编码制将序号置于方括号中并上标（如 `[1]`、`[2]`），同一处引用多篇文献用 `[1, 2]` 或 `[1-3]`（连续序号用短横线）；著者—出版年制用 `（裴丽生，1981）`、`（Simon & Feenberg, 2003; Wang, 2010）` 形式；多次引用同一著者的同一文献，在序号"[ ]"外著录引文页码，如 `[2]260`、`[2]326-329`。

**文后著录格式**（GB/T 7714—2015）：主要责任者. 题名: 其他题名信息[文献类型标志/文献载体标志]. 其他责任者. 版本项. 出版地: 出版者, 出版年: 引文页码[引用日期]. 获取和访问路径. 数字对象唯一标识符。

**文后注意事项**：编著者姓名一律姓在前、名在后，西文和俄文的姓全部著录、名字用大写首字母缩写（不加缩写点）；机构署名用全称；编著者不明注明"佚名"；3 人及以下全部著录，3 人以上只著录前 3 人，中文加"，等"、外文加", et al."（"et al."不必斜体）；外文期刊刊名应列全名、排正体；卷或期至少标注一项，不必标注"卷"或"Vol"；版次、卷、期、页码一律用阿拉伯数字，中文版次著录为"第2版"，西文为"2nd ed"；出版年用公元纪年阿拉伯数字，其他纪年形式置于"（）"内（如 `1947（民国三十六年）`）；日文文献汉字用日文汉字；中英文一律用正体（拉丁文生物学名词必须斜体除外）；"著者—出版年制"续行缩进两个汉字符，"顺序编码制"缩进至编码之后；著录字号宋体小四号、1.25 倍行距、段前段后 0 磅、两端对齐。

**标点符号用法**：`，` 用于责任者间、"等"/"译"字样、出版年、年卷期标识的年与卷号前；`：` 用于其他题名信息、出版者、引文页码、析出文献页码、专利号前；`（）` 用于期号、报纸版次、电子资源更新日期、非公元纪年；`[]` 用于序号、文献类型、引用日期、自拟信息；`//` 用于专著析出文献出处项前；`-` 用于起讫序号和起讫页码间；`.` 用于题名项、析出文献题名项、年卷期标识、版本项、出版项等之前，每条文献结尾可用"."。

### 11.2 代码实现

`utils/bilingual-bibliography.typ`（源自 csimide/OrangeX4，仅 GB-7714-2015-Numeric 测试通过）。

调用方式：

```typst
// 在 documentclass 中配置
#let (..., bilingual-bibliography) = documentclass(
  bibliography: bibliography.with("ref.bib"),
  ...
)

// 在论文末尾调用
#bilingual-bibliography(full: true)
```

实现要点（`utils/bilingual-bibliography.typ`）：通过 `show grid.cell.where(x: 1)` 钩子对参考文献的每个条目进行字符串处理；检测是否为中文文献（去除特定字符后仍有连续两个汉字）——中文文献保留原样，仅将"标准..."行中的 `[Z]` 替换为 `[S]`；非中文文献将"第X卷"→"Vol. X"、"第X册"→"Bk. X"、"第X版"→"1st ed"、`等`→`et al.`、"译"→", trans" 等；`set text(lang: "zh")` 设置语言；调用原生 `bibliography(title: title, full: full, style: style)`。

### 11.3 参考文献定制参数

`utils/bilingual-bibliography.typ:3-13`：

| 参数名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| `bibliography` | function | `none` | 参考文献函数（必需，由 `documentclass` 注入） |
| `title` | string | `"参考文献"` | 标题 |
| `full` | boolean | `false` | 是否显示所有条目（包括未引用的） |
| `style` | string | `"gb-7714-2015-numeric"` | 引用样式 |
| `mapping` | dictionary | `(:)` | 额外词汇映射（默认含 `"卷"→"Vol."`、`"册"→"Bk."`） |
| `extra-comma-before-et-al-trans` | boolean | `false` | 译者数量 >1 时是否加逗号（`et al. tran` vs `et al., tran`） |
| `allow-comma-in-name` | boolean | `false` | 姓名中是否允许逗号（部分 CSL 方言需要） |

### 11.4 引用样式切换

默认 `gb-7714-2015-numeric`（顺序编码制）。切换为著者—出版年制：

```typst
#bilingual-bibliography(full: true, style: "gb-7714-2015-author-date")
```

> ⚠️ 著者—出版年制（author-date）续行缩进由 Typst 引擎硬编码为约 1.5em（`ShowSet` 的 `PadElem.left=1em` + CSL hanging indent），规范要求 2 个汉字符（2em），存在约 0.5em 偏差。Typst 0.15.1 未暴露 bibliography 的 indent 参数，`set par`/`set pad`/`show` 规则均无法穿透（引擎限制，非模板可修）。顺序编码制（numeric，默认）不受影响——其续行天然对齐至编码之后，合规。如需严格 2em 缩进，请等待 Typst 后续版本暴露 bibliography indent 参数，或临时改用顺序编码制。

### 11.5 中英文文献自动转换

`utils/bilingual-bibliography.typ:46-173` 实现以下自动转换：

| 中文 | 英文（自动转换后） |
|------|------------------|
| 第X卷 | Vol. X |
| 第X册 | Bk. X |
| 第X版 | 1st ed / 2nd ed / 3rd ed / Xth ed |
| 译（单数） | , trans |
| 译（复数，多位译者） | tran 或 , tran（取决于 `extra-comma-before-et-al-trans`） |
| 等 | et al. |
| 标准...[Z] | 标准...[S] |

判断译者数量的方法：检测 `,?\s?译` 前是否有逗号。若使用的 CSL 中英文姓名会出现逗号，需设 `allow-comma-in-name: true`。

> GB/T 7714—2015 P8 7.2 小节规定："译"前需加逗号。因此单个作者的情形，"译" 会被替换为 ", trans"。与"等"并用时，本工具会译作 `et al. tran`（GB/T 7714—2015 原文未给出"等译"的英文缩写，CSL 社区库内的 GB/T 7714-2015 会使用 `等, 译` 和 `et al., tran`）。若需要添加逗号，请将 `extra-comma-before-et-al-trans` 设为 `true`。

### 11.6 文献著录格式示例

各文献类型著录格式（GB/T 7714—2015）：

```bibtex
@article{key,
  author  = {作者姓名},
  title   = {文章标题},
  journal = {期刊名称},
  year    = {2023},
  volume  = {1},
  number  = {1},
  pages   = {1--10},
}

@book{key2,
  author    = {作者姓名},
  title     = {书名},
  publisher = {出版社},
  year      = {2023},
  address   = {出版地},
}
```

各类型文献类型标志：

- `[M]` 专著（普通图书）
- `[M/OL]` 联机专著
- `[C]` 论文集、会议集
- `[G]` 汇编
- `[R/OL]` 报告（联机）
- `[D]` 学位论文
- `[P]` 专利文献
- `[S]` 标准文献
- `[J]` 期刊
- `[N/OL]` 报纸（联机）
- `[A]` 档案
- `[EB/OL]` 电子资源

### 11.7 已知偏差

- ✅ **P2**（已修复）：参考文献已保证从奇数页开始。`utils/bilingual-bibliography.typ:22-23` 在双面印刷时 `pagebreak(weak: true, to: if twoside { "odd" })`；`template/thesis.typ:762-764` 注释说明不再额外 `pagebreak` 以免多余空白页。符合《指导意见》三·（八）「参考文献…须由另页右页开始」。
- **P3**：参考文献所在页为偶数页时页眉为论文题目，规范要求奇数页页眉标"参考文献"。当前偶数页页眉逻辑固定用 `info.title`（`mainmatter.typ:272-285`），未识别"参考文献"上下文。

> 规范依据：《指导意见》三·（八）「中文摘要、英文摘要、目录、论文正文、参考文献、附录、致谢、作者简历及攻读学位期间发表的学术论文与其他相关学术成果等，均须由另页右页（奇数页）开始」；二·（六）·3「参考文献、附录、致谢等的页眉，奇数页标明'参考文献'、'附录'、'致谢'等」。详见 [§19](#19-已知偏差与待办)。

---

## 12. 附录（Appendix）

### 12.1 规范要求

《指导意见》一·（八）：

- 附录主要列入：正文内过分冗长的公式推导、辅助性数学工具或表格、数据图表、程序全文及说明、调查问卷、实验说明等
- 附录章节标题格式同正文：黑体四号加粗居中，"附录"二字与题名间空一个汉字符位（多个附录用"附录一"、"附录二"）
- 附录内容：宋体小四号，两端对齐，首行缩进 2 字符，1.25 倍行距
- 附录图表参考正文编号方式，如 `附图1-1` 或 `附表1-1`

### 12.2 代码实现

`layouts/appendix.typ`。调用方式：

```typst
#show: appendix

= 附录标题

附录内容...
```

实现要点（`layouts/appendix.typ`）：一级标题无编号（`first-level: ""`），子节 `1.1`、三级 `1.1.1`；图表沿用正文编号形式 `1-1`；公式沿用正文编号形式 `(1-1)`；附录在目录中只列一级标题（`show heading.where(level: 2/3/4): set heading(outlined: false)`）；`set math.equation(number-align: bottom + end)` 公式编号底部右对齐；**`reset-counter: true`**（默认值）让附录作为独立编号单元，图表/公式编号从 1 重新计数（附图1-1、附表1-1）；**`enter-appendix-mode()`** 标记进入附录模式，让 `auto-table` 等无 `show-figure` 路径的工具能读取此状态自行解析 supplement。

### 12.3 附录定制参数

`layouts/appendix.typ:37-47`：

| 参数名 | 类型 | 默认值 | 说明 |
|-------|------|--------|------|
| `numbering` | function | `custom-numbering.with(first-level: "", depth: 4, "1.1\u{3000}")` | 章节编号格式（一级为空，即不编号） |
| `show-figure` | function | `_appendix-show-figure.with(numbering: "1-1")` | 图编号函数（自动切换"附图/附表"前缀） |
| `show-equation` | function | `bilingual-figured.show-equation.with(numbering: "(1-1)")` | 公式编号格式 |
| `reset-counter` | boolean | **`true`** | 是否重置章节计数器（让附录图表从 1 开始） |

> 注：附录编号默认**重置**章节计数器（`reset-counter: true`），所以附录的图表编号是"附图1-1"而非"附图4-1"——但因 `first-level: ""`，一级标题不显示编号，仅在目录中显示"附录 题名"。如需禁用重置（让附录继承正文章号），设 `reset-counter: false`。

### 12.4 附录模式机制

附录图表前缀的自动切换通过两层机制实现：

1. **`show-figure` 层**：`_appendix-show-figure` 函数（`appendix.typ:9-34`）按 `kind` 自动选择"附图/附表"前缀，再交由通用 `bilingual-figured.show-figure` 重建。`bifigure`/`bitable` 调用时经此路径，前缀正确切换。
2. **`auto-table` 层**：`auto-table` 不经 `show-figure` 重建，故需通过 `bilingual-figured.in-appendix()` 读取附录状态（`continued-table.typ:255-265`），自行解析前缀为"附表/Appendix Table"。`enter-appendix-mode()` 在 `appendix.typ:52` 被调用，将 `_appendix-state` 置为 `true`。
3. **`continued-table` 层**：从原表的 caption 元数据中提取 `supplement_zh`/`supplement_en`，原表若在附录中已被改写为"附表"前缀，则续表自动继承。

> ⚠️ **`continued-table` 的 `source` 参数必须使用带前缀的标签**（如 `<tbl:label>`）。源码 `continued-table.typ:357-359` 通过 `query(source)` 查找原表，若使用裸标签（如 `<label>`），`show-figure` 已将原表标签补全为带前缀的形式，原表查询会失败。

---

## 13. 致谢（Acknowledgements）

### 13.1 规范要求

《指导意见》一·（九）与三·（七）：

- 对给予各类资助、指导和协助完成研究工作，以及提供各种对论文工作有利条件的单位及个人表示感谢
- 致谢应实事求是，切忌浮夸与庸俗之词
- 致谢末尾应具日期，**日期与论文封面一致**
- 标题黑体四号加粗居中，"致谢"二字间空一个汉字符位
- 内容：宋体小四号，1.25 倍行距，段前段后 0 磅，英文和阿拉伯数字用 Times New Roman

### 13.2 代码实现

`pages/acknowledgement.typ`。调用方式：

```typst
#acknowledgement[
  感谢导师的悉心指导...

  感谢家人的支持...

  2023年6月  // 末尾日期与封面一致
]
```

实现要点（`pages/acknowledgement.typ`）：标题 `[致#h(1em)谢]` 二字间空 1em，`level: 1, numbering: none, outlined: true`；标题打上 `<no-auto-pagebreak>` 标签避免在前一部分末尾插入空白页；默认 `date` 参数取 `info.submit-date`（由 `lib.typ:288` 注入），`datetime` 类型自动格式化为"YYYY 年 M 月"，字符串/内容原样使用，`none` 不显示，末尾日期右对齐；`anonymous: true` 时整体跳过（盲审不显示致谢）；`twoside: true` 时从奇数页起。

定制参数：`anonymous`、`twoside`、`date`、`title`、`outlined`、`body`。

---

## 14. 作者简历及攻读学位期间发表的学术论文与其它学术成果（Backmatter）

### 14.1 规范要求

《指导意见》一·（十）与三·（七）：

- 作者简历应包括从大学起到申请学位时的个人学习工作经历
- 按学术论文发表的时间顺序，列出作者本人在攻读学位期间发表或已录用的学术论文清单（**著录格式同参考文献**）
- 其他相关学术成果可以是申请的专利、获得的奖项及完成的项目等
- 标题黑体四号加粗居中
- 内容：宋体小四号，1.25 倍行距，段前段后 0 磅，学术论文书写格式同参考文献

### 14.2 代码实现

`pages/backmatter.typ`。调用方式：

```typst
#backmatter[
  // 作者简历部分
  #strong[作者简历：]

  ××××年××月——××××年××月，在××大学××院（系）获得学士学位。

  ××××年××月——××××年××月，在中国科学院××研究所攻读博士学位。

  // 学术论文部分
  #v(1em)
  #strong[已发表（或正式接受）的学术论文：（书写格式同参考文献）]

  (1) 已发表工作 1

  (2) 已发表工作 2

  // 专利部分
  #v(1em)
  #strong[申请或已获得的专利：（无专利时此项不必列出）]

  (1) 专利名称

  // 研究项目及获奖情况
  #v(1em)
  #strong[参加的研究项目及获奖情况：]

  (1) 项目名称
]
```

实现要点（`pages/backmatter.typ`）：标题 `[作者简历及攻读学位期间发表的学术论文与其他相关学术成果]`，`level: 1, numbering: none, outlined: true`；标题打上 `<no-auto-pagebreak>`；`set par(first-line-indent: (amount: 0pt, all: true))` 让简历不缩进；`anonymous: true` 时整体跳过。

定制参数：`anonymous`、`twoside`、`title`、`outlined`、`body`。

---

## 15. 页面与字号基础

### 15.1 页面尺寸与页边距

`layouts/doc.typ:14-19`：

| 参数 | 默认值 | 规范依据 |
|------|--------|---------|
| `paper` | `"a4"` | 三·（一）「A4（210mm×297mm）」 |
| `margin` | `(top: 2.54cm, bottom: 2.54cm, left: 3.17cm, right: 3.17cm)` | 三·（一）「上下 2.54cm，左右 3.17cm」 |

> **页眉、页脚距页边界 1.5cm 的实现**（三·（一））：**不**使用 `page` 的 `header-ascent`/`footer-descent`——这两个参数的 Typst 语义是「页眉/页脚向正文 margin 内抬升/下沉的量」，基准是正文内容区边界而非页面物理边界，直接写 `1.5cm` 会让页眉落在距顶 1.04cm、页脚落在距底 0.75cm 处（见 [§19 P20](#19-已知偏差与待办)）。
>
> 改由 `preface.typ` / `mainmatter.typ` 的 `set page(foreground: context { ... })` + `place` 绝对定位实现（`place` 的父容器是整个页面含 margin 区，`dy` 锚定页物理边界）：
>
> | 部位 | 定位 | 实测距边（typst 0.15.1，PyMuPDF 测） |
> |------|------|---------|
> | 页眉文字 | `place(top + center, dy: 1.5cm, ...)` | 文字 bbox 顶距页顶 **1.472–1.506cm**（残差 ≤0.03cm，来自宋体与 Times 的 bbox 顶差异） |
> | 页脚页码 | `place(bottom + center, dy: -1.5cm, ...)` | 文字**基线**距页底 **1.5000cm**（精确；`place(bottom, dy)` 锚定基线） |
>
> `place(top, dy:1.5cm)` 把 body 块顶边锚到距顶 1.5cm，`top-edge:"bounds"` 让块顶边=字形 bbox 顶（不同字体 bbox 顶有 ≤0.03cm 差异，故页眉文字顶在 1.47–1.51cm 间）；`place(bottom, dy:-1.5cm)` 锚定文字**基线**距底 1.5cm（`bottom-edge` 只影响行框高、不改基线锚点，故页脚基线精确 1.5cm）。零魔法常数、字号无关。页眉分隔线用 `block(width: 100% - 3.17cm - 3.17cm)` 约束到正文区宽度，位于文字下方 0.5em 处（距顶约 2.0cm，属页眉块内部结构，非"距边界 1.5cm"锚点）。代码：`layouts/preface.typ:63-199`、`layouts/mainmatter.typ:220-331`。
>
> ⚠️ **联动**：若用户改 `margin.top`/`margin.bottom`，页眉页脚的 `dy: 1.5cm` 不受影响（`place` 锚定页物理边界，与 margin 无关）；但若要改「距边界 1.5cm」这个值本身，需同步改 `preface.typ` 与 `mainmatter.typ` 中两处 `dy`。`header-vspace` 参数在此机制下不再生效（见 [§8.3](#83-正文排版参数)）。

`doc` 函数还负责（`layouts/doc.typ`）：

- `set text(fallback: fallback, lang: "zh")` 默认中文（`doc.typ:37`）
- `set document(title: ..., author: ...)` 设置 PDF 元信息（标题为 `info.title` 拼接，作者为 `info.author`，`doc.typ:46-49`）
- 中文伪加粗（见 [§15.4](#154-中文伪加粗)）

### 15.2 字号字典

`utils/style.typ:1-19` 定义中文字号到 pt 的映射：

| 名称 | pt | 用途 |
|------|-----|------|
| `初号` | 42pt | 特大标题 |
| `小初` | 36pt | 大标题 |
| `一号` | 26pt | 封面"博士/硕士学位论文" |
| `小一` | 24pt | 本科声明页标题 |
| `二号` | 22pt | - |
| `小二` | 18pt | 本科封面摘要标题 |
| `三号` | 16pt | 本科封面信息字段 |
| `小三` | 15pt | 封面论文题目 |
| `四号` | 14pt | 一级标题、摘要标题、封面信息字段 |
| `中四` | 13pt | - |
| `小四` | 12pt | 正文、二级及以下标题 |
| `五号` | 10.5pt | 图表标题、脚注 |
| `小五` | 9pt | 页眉 |
| `六号` | 7.5pt | - |
| `小六` | 6.5pt | - |
| `七号` | 5.5pt | - |
| `小七` | 5pt | - |

实际使用字号：

| 内容 | 字号 | 字体 | 备注 |
|------|------|------|------|
| 正文 | `字号.小四` (12pt) | 宋体 | 1.25 倍行距，首行缩进 2 字符 |
| 一级标题 | `字号.四号` (14pt) | 黑体加粗 | 居中 |
| 二级标题 | `字号.小四` (12pt) | 黑体 | 顶左 |
| 三级标题 | `字号.小四` (12pt) | 黑体 | 顶左 |
| 四级标题 | `字号.小四` (12pt) | 黑体 | 居左 |
| 图表标题 | `字号.五号` (10.5pt) | 宋体加粗 | 居中 |
| 页眉 | `字号.小五` (9pt) | 宋体 | 居中，下加分隔线 |
| 页脚（页码） | `字号.小五` (9pt) | 宋体 | 单面居中、双面分置 |
| 脚注 | `字号.五号` (10.5pt) | 宋体 | - |

> 规范依据：《指导意见》三·（一）表格「页眉 宋体小五号居中」「页码 Times New Roman 体小五号」；三·（六）正文表格各项。

### 15.3 字体组预设

`utils/style.typ:41-70` 定义四种字体组：

| 字体组 | 宋体 | 黑体 | 楷体 | 仿宋 | 适用场景 |
|-------|------|------|------|------|---------|
| `windows` | `("Times New Roman", "SimSun")` | `("Times New Roman", "SimHei")` | `("Times New Roman", "KaiTi")` | `("Times New Roman", "FangSong")` | Windows 系统 |
| `mac` | `("Times New Roman", "Songti SC")` | `("Times New Roman", "Heiti SC")` | `("Times New Roman", "Kaiti SC")` | `("Times New Roman", "STFangSong")` | macOS 系统 |
| `fandol` | `("Times New Roman", "FandolSong")` | `("Times New Roman", "FandolHei")` | `("Times New Roman", "FandolKai")` | `("Times New Roman", "FandolFang R")` | 跨平台自由字体 |
| `adobe` | `("Times New Roman", "Adobe Song Std")` | `("Times New Roman", "Adobe Heiti Std")` | `("Times New Roman", "Adobe Kaiti Std")` | `("Times New Roman", "Adobe Fangsong Std")` | Adobe 字体 |

等宽字体列表（`utils/style.typ:21-39`）：

```typst
#let 等宽字体 = (
  "DejaVu Sans Mono",
  "Courier New", "Courier",
  "SF Mono", "Monaco", "Menlo",
  "IBM Plex Mono",
  "Source Han Sans HW SC", "Source Han Sans HW",
  "Noto Sans Mono CJK SC",
  "SimHei", "Heiti SC", "STHeiti",
)
```

每个字体组都遵循"**英文 Times New Roman 优先，中文跟随**"的顺序——这是中英文混排的最佳实践，确保阿拉伯数字与西文字符统一使用 Times New Roman。

> 规范依据：《指导意见》三·（二）封面表格、三·（四）摘要表格、三·（六）正文表格等均明示"英文和阿拉伯数字用 Times New Roman 体"。

### 15.4 中文伪加粗

`layouts/doc.typ:1, 51-62`：

```typst
#import "@preview/cuti:0.4.0": show-cn-fakebold
...
if fontset != "fandol" {
  { show: show-cn-fakebold; it }
} else {
  it
}
```

- 非 fandol 字体组（windows/mac/adobe）启用 `@preview/cuti:0.4.0` 的 `show-cn-fakebold` 进行中文伪加粗
- fandol 字体组自带粗体，无需伪加粗

> ⚠️ 修改 `doc.typ` 时不要漏掉这条 `show` 规则，否则中文字体的 `weight: "bold"` 不会生效。

---

## 16. 印刷与装订要求

《指导意见》三·（八）「印刷及装订要求」明确规定（规范条文，模板不直接实现，但用户须知晓）：

- 论文封面使用中国科学院大学**统一的封面格式**
- 学位论文用 **A4 标准纸**（210mm×297mm）打印、印刷或复印，按顺序装订成册
- **自中文摘要起双面印刷，之前部分单面印刷**（封面与声明页单面）
- 中文摘要、英文摘要、目录、论文正文、参考文献、附录、致谢、作者简历及攻读学位期间发表的学术论文与其他相关学术成果等，**均须由另页右页（奇数页）开始**
- 论文必须用**线装或热胶装订**，不使用钉子装订
- 封面用纸一般为 **150 克花纹纸**（需保证论文封面印刷质量，字迹清晰、不脱落）
- **博士学位论文封面颜色为红色，硕士学位论文封面颜色为蓝色**

模板对应实现：

- A4 纸张：`layouts/doc.typ:39` `paper: "a4"`
- 页边距：`layouts/doc.typ:14` `margin: (top: 2.54cm, bottom: 2.54cm, left: 3.17cm, right: 3.17cm)`
- 双面印刷：`twoside: true` 时启用（默认 `template/thesis.typ:34` 设为 `true`）
- 各部分奇数页开始：摘要、目录、图表目录、符号列表、附录、参考文献、致谢、作者简历均通过 `pagebreak(weak: true, to: "odd")` 保证（参考文献见 `utils/bilingual-bibliography.typ:23`、附录见 `layouts/appendix.typ:58`）；正文通过对齐逻辑保证（`mainmatter.typ:311-317`）
- ✅ 参考文献、附录均已保证奇数页开始（[§11.7 P2](#117-已知偏差) 已修复）
- 印刷用纸、装订方式、封面颜色属打印阶段，不在代码范围

> 规范依据：《指导意见》三·（八）全文。

---

## 17. 名词术语、量和单位规范

《指导意见》二·（六）·4-5 明确规定（属内容规范，模板不强制实现，但用户撰写时须遵守）：

**名词和术语**（二·（六）·4）：

- 科技名词术语及设备、元件的名称，应采用**全国科学技术名词审定委员会**公布的权威标准或其他相关权威信息源规定的术语或名称
- 标准中未规定的术语要采用**行业通用术语**或名称
- 全文名词术语必须**统一**
- 一些特殊名词或新名词应在适当位置加以说明或注解
- 双名法的生物学名部分均为**拉丁文，并为斜体字**
- 采用英语缩写词时，除本行业广泛应用的通用缩写词外，文中第一次出现的缩写词应该用括号注明英文原词
- 新的外来名词应用括号注明英语全称和缩写语

**量和单位**（二·（六）·5）：

- 量和单位要严格执行《国际单位制及其应用》（GB 3100-93）、《有关量、单位和符号的一般原则》（GB 3101—93）
- 量的符号一般为**单个拉丁字母或希腊字母**，并**一律采用斜体**（pH 例外）

> 模板支持：在 Typst 数学模式中，单个字母自动为斜体（如 `$R$`、`$alpha$`），符合"量的符号一律采用斜体"的要求；生物学名需用户手动用 `#emph[...]` 或 `*...*` 标注斜体。

---

## 18. 常见定制场景速查

| 场景 | 修改位置 | 关键参数 |
|------|---------|---------|
| 切换本/硕/博 | `template/thesis.typ` | `documentclass(doctype: "bachelor" \| "master" \| "doctor")` |
| 切换学术型/专业型 | `template/thesis.typ` | `degree: "academic" \| "professional"` |
| 启用盲审 | `template/thesis.typ` | `anonymous: true` |
| 启用双面打印 | `template/thesis.typ` | `twoside: true` |
| 切换字体组 | `template/thesis.typ` | `fontset: "windows" \| "mac" \| "fandol" \| "adobe"` |
| 替换单种字体 | `template/thesis.typ` | `fonts: (楷体: (...))` |
| 修改论文信息 | `template/thesis.typ` | `info: (title: ..., author: ..., ...)` |
| 修改正文行距 | `layouts/mainmatter.typ` | `leading`、`spacing` |
| 修改标题字号 | `layouts/mainmatter.typ` | `heading-size`、`heading-weight` |
| 修改标题段前段后 | `layouts/mainmatter.typ` | `heading-above`、`heading-below` |
| 禁止一级标题自动换页 | 章节标题处 | 加标签 `<no-auto-pagebreak>` |
| 修改图表标题样式 | `utils/custom-figure.typ` | `thesis-bilingual-caption-style` 内 `zh_text`/`en_text`/`note_text` |
| 修改图表跨页策略 | `utils/custom-figure.typ` | `keep_together: true \| false` |
| 切换引用样式 | `template/thesis.typ` | `bilingual-bibliography(style: "gb-7714-2015-author-date")` |
| 修改页眉分隔线 | `layouts/mainmatter.typ` / `preface.typ` | `stroke-width` |
| 修改目录深度 | `template/thesis.typ` | `outline-page(depth: 3)` |
| 修改封面字段 | `pages/master-cover.typ` | `info-key-width`、`info-row-gutter` 等 |
| 自定义符号列表 | `template/thesis.typ` | `#notation()[ ... ]` 内的 `table` |
| 添加附录 | `template/thesis.typ` | `#show: appendix` 后写章节 |
| 附录中续表 | `template/thesis.typ` | `auto-table` / `continued-table` 自动切换"附表"前缀 |
| 不编号的展示性表格 | 用户代码 | 原生 `table` + `align(center)[#strong[标题]]` |

---

## 19. 已知偏差与待办

状态符号：✅ 已修复 ／ ⚠️ 部分实现或存在偏差 ／ ❌ 缺失。每项后括注《指导意见》规范依据与受影响代码位置。

**高严重度**：

- ✅ **P1**（页眉）：附录页眉曾显示"第1章　附录"，应为"附录"。`layouts/mainmatter.typ:251-266`、`layouts/preface.typ:88-98`。规范二·（六）·3。已修复为直接调用 `heading.numbering`。
- ✅ **P2**（分页）：已修复。`utils/bilingual-bibliography.typ:22-23` 在双面印刷时 `pagebreak(weak: true, to: if twoside { "odd" })`，保证参考文献由奇数页（右页）开始；`template/thesis.typ:762-764` 注释说明不再额外 `pagebreak` 以免多余空白页。规范三·（八）「参考文献…须由另页右页开始」。
- ❌ **P3**（页眉）：参考文献所在偶数页页眉为论文题目，应为"参考文献"。`layouts/mainmatter.typ:272-285` 偶数页固定用 `info.title`。规范二·（六）·3。

**中严重度**：

- ⚠️ **P4**（页码）：前言罗马数字页码字号未按规范（实测约 11pt/默认字体，规范要求 Times New Roman 小五 9pt）。`layouts/preface.typ` 未设页脚步 font/size。规范三·（一）。
- ⚠️ **P5**（公式）：公式编号**字体已设为宋体**（`layouts/mainmatter.typ:138`、`layouts/appendix.typ:73` 的 `show math.equation.where(block: true): set text(font: fonts.宋体)`）；但**字号继承正文小四 12pt**，规范要求"序号五号 10.5pt"——Typst 0.15 的公式编号是 equation 元素内部渲染，无独立字段单独样式化字号，`set text(size:)` 会同时改变公式正文字号，二者无法兼得，属 Typst 固有限制。规范二·（六）·7。
- ⚠️ **P6**（标题）：标题段前/段后实现为"规范值+字号"，系统性比规范偏大；页首段前被 Typst 裁剪为 0。`layouts/mainmatter.typ:153-164`。规范三·（六）正文表。
- ⚠️ **P7**（目录）：目录条目段后实为"0+字号"（14/12pt），非规范要求的 0 磅。`pages/outline-page.typ:68-78`。规范三·（五）目录表。
- ✅ **P20**（页眉页脚）：已修复。此前 `layouts/doc.typ` 用 `header-ascent: 1.5cm` / `footer-descent: 1.5cm` 实现"距页边界 1.5cm"，但 Typst 这两个参数的语义是「页眉/页脚向正文 margin 内抬升/下沉的量」（基准为正文内容区边界，非页面物理边界），实测页眉文字距顶仅 0.61cm、页眉横线距顶 1.04cm、页脚文字距底 0.75cm，均严重偏离 1.5cm。已移除 `header-ascent`/`footer-descent`，改由 `preface.typ` / `mainmatter.typ` 的 `set page(foreground: ...)` + `place(top+center, dy: 1.5cm)` / `place(bottom+center, dy: -1.5cm)` 绝对定位：页脚页码**基线**距底精确 1.5000cm，页眉文字 bbox 顶距顶 1.47–1.51cm（残差 ≤0.03cm 为宋体/Times 字形 bbox 顶差异）。零魔法常数、跨字体稳定。改动文件：`layouts/doc.typ`、`layouts/preface.typ`、`layouts/mainmatter.typ`、`lib.typ`。规范三·（一）。详见 [§15.1](#151-页面尺寸与页边距)。

**低严重度**：

- ⚠️ **P8**（封面）：封面信息行"2 倍行距"实现为 `row-gutter: 1.2em`，与 Word 2 倍行距定义口径不一致。`pages/master-cover.typ:24`。规范三·（二）封面表。
- ✅ **P9**（封面）：已修复。指导教师以结构化字典列表 `supervisors: ((name:, title:, affiliation:), ...)` 填写，`affiliation` 即工作单位，封面/摘要渲染"姓名 职称 工作单位"，多导师第一导师在前。`utils/supervisor.typ` 提供 `normalize-supervisors`（校验归一化）、`supervisor-line`（中文序"姓名 职称 单位"）、`supervisor-en-line`（英文序"职称 姓名 单位"）。改动文件：`lib.typ`、`pages/master-cover.typ`、`pages/bachelor-cover.typ`、`pages/*-abstract*.typ`。规范一·（一）·4。
- ❌ **P10**（封面）：密级行未实现；`nl-cover`（国图封面）为 TODO。`lib.typ:39,82`。规范一·（一）·1。
- ❌ **P11**（封面）：书脊页完全未实现。规范三·（三）。
- ✅ **P12**（图注）：已修复。"注"区块整体左缩进 2em（`note_block.inset`），续行通过 grid 两列分置"注："前缀与注释正文实现几何对齐——前缀列 `auto` 取自身宽度，正文列 `1fr` 填满剩余，换行时续行自然落在前缀之后，满足"续行缩进至'注'后"。`utils/bilingual-figured.typ:488-500`（`bifigure`/`bitable`）与 `utils/continued-table.typ:131-141`（`auto-table`/`continued-table`）同构实现。规范二·（六）·6·（1）。
- ⚠️ **P13**（页眉）：英文摘要的偶数页页眉显示中文题目（规范要求英文题目）。`layouts/preface.typ:104-115`。规范二·（六）·3。
- ⚠️ **P14**（摘要）：摘要标题"单倍行距"未显式设置（单行标题不受影响）。`pages/master-abstract.typ:97-105`。规范三·（四）摘要表。

**功能待办**：

- ❌ **P15**：荐读书目未实现。规范二·（七）末段允许将未引用文献列入附录"荐读书目"。
- ✅ **P16**：已修复。`bitable`、`bifigure`、`auto-table` 均内置 `landscape` 参数，置 `landscape: true` 即将整个图表（含标题与注释）逆时针旋转 90°，方位"顶左底右"。实现见 `utils/bilingual-figured.typ` 的 `_render-bilingual`（`rotate(-90deg, reflow: true, rendered)`）与 `utils/continued-table.typ` 的 `auto-table`（自行包裹 `rotate` 并强制 `breakable: false`）。用法见 [§9.7](#97-三线表与卧排表)。规范二·（六）·6·（2）。
- ⚠️ **P17**：著者—出版年制（`gb-7714-2015-author-date`）未提供默认配置与样式校验。`utils/bilingual-bibliography.typ:7`。规范二·（七）·2。
- ⚠️ **P18**：学位类别中英文对照表（规范附件 2）当前仅作为附录示例表格存在于 `thesis.typ:865-910`，未抽取为可复用组件。
- ❌ **P19**：博士后学位论文（`postdoc`）`panic` 未实现。`lib.typ:162-163, 185-186, 211-212, 237-238`。

> 「内容-」层面（作者姓名大小写、题目字数上限、图表尺寸、表内填值、书目著录细节、地图底图、缩写首现说明、绪论独立成章不与摘要雷同等）由使用者负责，模板无法/不应强制，未列为缺陷。

---

## 附录 A：规范条文与代码位置对照表

| 规范章节 | 规范要点 | 代码位置 |
|---------|---------|---------|
| 一·（一）封面 | 论文题目不超 25 汉字，黑体小三号加粗居中 | `pages/master-cover.typ:241-251` |
| 一·（一）封面 | 字段宋体四号加粗，2 倍行距 | `pages/master-cover.typ:255-305` |
| 一·（一）封面 | 日期 Times New Roman 四号加粗 | `pages/master-cover.typ:309-311` |
| 一·（二）声明 | 统一模板，作者与导师签名 | `pages/master-decl-page.typ` |
| 一·（三）摘要 | "摘　要"空一字符，黑体四号加粗居中，段前 24 段后 18 | `pages/master-abstract.typ:97-102` |
| 一·（三）摘要 | 关键词 3-5 个，中文逗号隔开 | `pages/master-abstract.typ:116` |
| 一·（三）摘要 | 另起一页，罗马数字编页 | `layouts/preface.typ:44-45` |
| 一·（四）目录 | 不含摘要，最多三级，缩进递增 | `pages/outline-page.typ` |
| 一·（四）目录 | 图表目录先图后表，置于目录后 | `pages/list-of-figures-and-tables.typ` |
| 一·（五）符号 | 置于目录后正文前，另页 | `pages/notation.typ` |
| 二·（六）·2 标题序号 | 阿拉伯数字三级，章居中、节顶左 | `utils/custom-numbering.typ` + `layouts/mainmatter.typ:24` |
| 二·（六）·2 图表编号 | 分章连续 `图1-1`、`表3-2` | `utils/bilingual-figured.typ:129-178`；`layouts/appendix.typ:9-34` |
| 二·（六）·2 页码 | 正文阿拉伯数字，左页左下右页右下 | `layouts/mainmatter.typ:206-215` |
| 二·（六）·3 页眉 | 奇数页章名/部分名，偶数页题目，宋体小五居中 | `layouts/mainmatter.typ:216-310` + `layouts/preface.typ:48-140` |
| 二·（六）·4 名词术语 | 全国科学技术名词审定委员会标准；生物学名拉丁文斜体 | （内容责任） |
| 二·（六）·5 量和单位 | GB 3100-93/GB 3101—93；量符号一律斜体（pH 例外） | （Typst 数学模式自动斜体） |
| 二·（六）·6 图 | 图题图注居图下，宋体五号加粗，1.25 倍行距 | `utils/custom-figure.typ:7-62` |
| 二·（六）·6 表 | 表题居表上，三线表，续表表头重复 | `utils/continued-table.typ` |
| 二·（六）·7 公式 | 编号置于括号内，右端对齐，分章编号 | `utils/bilingual-figured.typ:180-225` + `layouts/mainmatter.typ:133-134` |
| 二·（七）参考文献 | GB/T 7714-2015，顺序编码制/著者-年制 | `utils/bilingual-bibliography.typ` |
| 三·（一）页面 | A4，上下 2.54cm 左右 3.17cm，页眉页脚 1.5cm | `layouts/doc.typ:14-19`（margin）+ `layouts/preface.typ:63-199` / `layouts/mainmatter.typ:220-331`（foreground+place 定位页眉页脚 1.5cm） |
| 三·（三）书脊 | 黑体小四号，上=题目、中=作者、下="中国科学院大学"，距上下边界 3cm | （未实现） |
| 三·（六）正文 | 宋体小四，1.25 倍行距，首行缩进 2 字符 | `layouts/mainmatter.typ:107-115` |
| 三·（七）其他 | 参考文献/附录/致谢/简历标题黑体四号加粗居中 | `pages/acknowledgement.typ` + `pages/backmatter.typ` |
| 三·（八）印刷 | 自中文摘要起双面，各部分另页右页起 | `twoside` 参数 + 各页 `pagebreak(weak: true, to: "odd")` |