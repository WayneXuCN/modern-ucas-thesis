# 中国科学院大学学位论文 Typst 模板 typst-ucas-thesis

![Project Status](https://img.shields.io/badge/Status-In%20Progress-yellow)

> 🚧 **Project Status: In Progress** 🚧

## 开发者指南

### template 目录

- `thesis.typ` 文件: 你的论文源文件，可以随意更改这个文件的名字，甚至你可以将这个文件在同级目录下复制多份，维持多个版本。
- `ref.bib` 文件: 用于放置参考文献。
- `images` 目录: 用于放置图片。


### 内部目录

- `utils` 目录: 包含了模板使用到的各种自定义辅助函数，存放没有外部依赖，且 **不会渲染出页面的函数**。
- `pages` 目录: 包含了模板用到的各个 **独立页面**，例如封面页、声明页、摘要等，即 **会渲染出不影响其他页面的独立页面的函数**。
- `layouts` 目录: 布局目录，存放着用于排篇布局的、应用于 `show` 指令的、**横跨多个页面的函数**，例如为了给页脚进行罗马数字编码的前言 `preface` 函数。
  - 主要分成了 `doc` 文稿、`preface` 前言、`mainmatter` 正文与 `appendix` 附录/后记。
- `lib.typ`:
  - **职责一**: 作为一个统一的对外接口，暴露出内部的 utils 函数。
  - **职责二**: 使用 **函数闭包** 特性，通过 `documentclass` 函数类进行全局信息配置，然后暴露出拥有了全局配置的、具体的 `layouts` 和 `pages` 内部函数。

## 致谢

- 感谢 [nju-lug](https://github.com/nju-lug) 开发的 [modern-nju-thesis](https://github.com/nju-lug/modern-nju-thesis) 模板，为此版本的开发提供了良好基础。
- 感谢 [mohuangrui](https://github.com/mohuangrui) 开发的 [ucasthesis](https://github.com/mohuangrui/ucasthesis) LaTeX 模板，本模板大体结构都是参考 ucasthesis 的文档开发的。
- 感谢 [HUST-typst-template](https://github.com/werifu/HUST-typst-template) 与 [sysu-thesis-typst](https://github.com/howardlau1999/sysu-thesis-typst) 等 Typst 中文论文模板。

https://github.com/mohuangrui/ucasthesis

## License

This project is licensed under the MIT License.
