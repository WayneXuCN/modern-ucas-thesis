# AGENTS.md

This file provides guidance to Code Agent when working with code in this repository.

## 项目概览

基于 Typst 的中国科学院大学（UCAS）学位论文模板，包名 `modern-ucas-thesis`（v0.2.0，入口 `lib.typ`，`typst.toml` 声明 `compiler = "0.15.0"`）。遵循《中国科学院大学研究生学位论文撰写规范指导意见（2022年）》。本地 Typst CLI 可能为更高版本（如 0.15.x），通常可正常编译。

## 常用命令

```bash
# 编译（必须指定字体目录，否则中文会渲染为豆腐块；必须指定 --root，否则 ../lib.typ 触发 sandbox 逃逸）
typst compile template/thesis.typ --root . --font-path fonts
typst watch   template/thesis.typ --root . --font-path fonts   # 实时预览

# 格式化（工具为 typstyle，需先 brew install typstyle 或 cargo install typstyle）—— 提交前必跑
make format                 # 格式化所有 .typ
make format-main            # 仅 lib.typ 与 template/thesis.typ
make format-check           # 只检查不改，CI 守门
make format-file FILE=path/to/file.typ

# 包检查
make lint-quick             # 不依赖外部 index，检查 typst.toml 字段与入口
make lint                   # 需 typst/package-check（make lint-install 安装，且要本地 package index）
```

无测试套件；"验证"等于 `make format-check` + `typst compile` 能出 PDF。

## 架构

### 核心模式：`documentclass` 闭包工厂（`lib.typ`）

`documentclass(...)` 是整个模板的中枢。它接收全局配置（`doctype`/`degree`/`fontset`/`fonts`/`info`/`bibliography`/`twoside`/`anonymous`），返回一个字典，其中每个值都是**已闭包绑定了全局配置的函数**。这是理解全项目的关键——所有页面/布局函数都不直接调用，而是由 `documentclass` 包装后暴露。**调用这些函数时不要重复传 `fontset`/`fonts`/`info` 等已被闭包持有的参数**，只在 `documentclass` 顶层设置一次。

返回的函数分两类：

1. **按 `doctype` 分发的页面函数**（`cover`/`decl-page`/`abstract`/`abstract-en`）：内部 `if doctype == "master" or "doctor"` 路由到 `pages/master-*.typ`，否则到 `pages/bachelor-*.typ`；`postdoc` 当前 `panic`（未实现）。
2. **直接透传的工具函数**（`bifigure`/`bitable`/`continued-table`/`auto-table`/`aligned-equation`）。

使用方式见 `template/thesis.typ`：解构返回的字典，再按固定顺序 `#show: doc` → `#cover()` → `#decl-page()` → `#show: preface` → 摘要/目录/符号表 → `#show: mainmatter` → 正文 → `#bilingual-bibliography(full: true)` → `#show: appendix` → `#acknowledgement()` → `#backmatter()`。前言/正文/附录靠 `#show:` 触发布局切换（页码制式、页眉、编号随之改变），**不要**改成普通函数调用；调用顺序对应论文物理结构，不能随意调换。

### 分层职责

- `layouts/`：页面级布局，控制页码制式、页眉页脚、标题编号。
  - `doc.typ`：全局 `set page`（A4，上下 2.54cm / 左右 3.17cm）、PDF 元信息、中文伪加粗（非 fandol 字体组经 `@preview/cuti:0.4.0` 的 `show-cn-fakebold` 启用——改 `doc.typ` 时不要漏掉这条 `show` 规则）。页眉/页脚距页边界 1.5cm 不在 `doc.typ`，而由 `preface.typ`/`mainmatter.typ` 的 `page.foreground` + `place(top+center, dy:1.5cm)` / `place(bottom+center, dy:-1.5cm)` 绝对定位实现（不使用 `header-ascent`/`footer-descent`——其语义是侵入 margin 的量，非距边界）。
  - `preface.typ`：前置部分，罗马数字页码。
  - `mainmatter.typ`：正文，阿拉伯页码，章节编号（`custom-numbering`，默认 `第1章` / `1.1`），1.25 倍行距，首行缩进 2em，页眉显示当前章名。一级标题前默认 `pagebreak(weak: true)`；若需禁止（如"致谢"紧接上文），给标题打标签 `<no-auto-pagebreak>`，`mainmatter.typ` 会识别。
  - `appendix.typ`：附录。一级标题无编号（`custom-numbering` 的 `first-level: ""`），子节 `1.1`，图表 `1-1`，公式 `(1-1)`。
- `pages/`：具体页面内容实现，`bachelor-*` 与 `master-*` 成对存在。
- `utils/`：可复用构件（见下）。

### 关键 utils

- `style.typ`：`字号`（中文字号→pt 字典）、`字体组`（`windows`/`mac`/`fandol`/`adobe` 四套预设，每套含宋体/黑体/楷体/仿宋/等宽）、`get-fonts(fontset)`。`documentclass` 的 `fontset` 选预设、`fonts` 字典覆盖单项（如 `fonts: (楷体: (...))`），二者合并。
- `bilingual-figured.typ`：**通用双语图表引擎**（源自 RubixDev，可独立作为外部包使用）。提供 `bifigure`/`bitable`/`bilingual-caption-style` 及计数器重置逻辑，通过 `prefixed-kind` 区分双语图表种类。
- `custom-figure.typ`：模板内层封装，用 `thesis-bilingual-caption-style` 给引擎套上 UCAS 规范样式（宋体五号加粗、`*注：*` 前缀、`keep_together: true` 默认防跨页、块外间距"规范值 + 1.25em 行距"舒展口径）。修改双语标题行距/跨页策略改这里。
- `continued-table.typ`：`auto-table`（自动跨页续表，主动分页，不受 `keep_together` 约束，适合长表；`landscape: true` 时改为整表卧排并强制 `breakable: false`）+ `continued-table`（手动续表，需先有原表 label）。`bifigure`/`bitable`/`auto-table` 三者均有 `landscape` 参数，由 `bilingual-figured._render-bilingual` 的 `rotate(-90deg, reflow: true, ...)` 实现卧排（顶左底右）。
- `aligned-equation.typ`：多行对齐公式，纯透传（语义标记）；编号底部对齐由 `mainmatter`/`appendix` 全局 `set math.equation(number-align: bottom + end)` 提供。
- `custom-heading.typ`：`active-heading`/`current-heading` 供页眉显示当前章名。

### 交叉引用约定

正文统一使用带前缀引用：图 `@fig:label`、表 `@tbl:label`、行间公式 `@eqt:label`（`aligned-equation` 同样用 `@eqt:label`）。行间公式加 `<->` 标签表示不编号。双语标题通过 `caption-zh`/`caption-en` 传入，或用 `caption: metadata((zh, en, none, [表], [Table]))` 形式（`bitable` 兼容原生 `figure` 的 metadata 写法）。

### 外部依赖

`@preview/cuti:0.4.0`（中文伪加粗）、`@preview/tablex:0.0.9`。升级这些依赖或 Typst compiler 版本时需同步核验兼容性。

### 工作要求

Typst 是较新的语言，语法和 API 演进快，**不要凭记忆写 Typst**。涉及语法、函数签名、参数、包用法时，先用 Context7 查证再写：

- 语法/函数文档：`/websites/typst_app`（官网实时文档，时效性最好）。
- **不要**把 `/typst/typst`（GitHub 源）的 release tag 快照当作"最新版本"，它有滞后性；查最新版本以本地 `typst --version` 或 [GitHub Releases](https://github.com/typst/typst/releases) 为准。

## 边界与红线

- `others/`：**独立**的本科生/研究生开题报告（`bachelor-proposal.typ`、`master-proposal.typ`），只 `#import "style.typ"`（自带一份），不走 `documentclass`。改主模板时不要顺手碰这里。
- `fonts/`：只放 README 和子目录占位，**不要提交字体文件**（版权原因，见 `fonts/README.md` 与 `docs/LOGO_COPYRIGHT.md`）。本地编译必须用 `--font-path fonts` 指向用户自行放入的字体。
- `assets/vi/`：校徽等 UCAS 视觉标识版权归学校，仅限个人学位论文合理使用，不得商用。
- `.env`：被 gitignore 且含密钥——绝不提交、绝不写进文档。

## 仓库约定

- 主分支 `main`；另有 `style` 长期分支。提交信息沿用现有 gitmoji 风格（`feat(utils): ✨ ...`、`fix(layouts): 🐛 ...`、`docs(docs): 📝 ...`）。
- `.editorconfig`：`.typ` 2 空格缩进，`Makefile` 用 tab，`.sh` 4 空格，`.md` 不裁尾随空格。
- `template/thesis.pdf` 被 gitignore；其他 `*.pdf` 由 `make clean` 清理。

## 模式开关

- `twoside: true`：双面打印，自动插入空白页使各部分从奇数页（右页）开始。
- `anonymous: true`：盲审模式，隐藏作者/导师等身份信息。
- `degree: "academic" | "professional"`：学术型 / 专业学位，影响封面与摘要的学位类别显示。
