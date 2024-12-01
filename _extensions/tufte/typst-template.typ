#let wideblock(content) = block(width: 100% + 2.5in, content)


#let colorize-first-chars(content, color) = {
  let text-str = to-string(content)

  if text-str.len() == 0 { return [] }

  // 先尝试UTF-8编码长度
  let bytes = bytes(text-str)
  let first-len = if bytes.at(0) < 128 { 1 }
    else if bytes.at(0) < 224 { 2 }
    else if bytes.at(0) < 240 { 3 }
    else { 4 }

  let first = text-str.slice(0, first-len)
  let rest = text-str.slice(first-len)

  [#text(fill: color)[#first]#rest]
}

#let tufte(
  title: none,
  subtitle: none,
  shorttitle: none,
  document-number: none,
  authors: none,
  date: datetime.today(),
  abstract: none,
  publisher: none,
  abstract-title: none,
  margin: (left: 1in, right: 3.5in, y: 1.5in),
  paper: "us-letter",
  lang: "en",
  region: "US",
  font: "New Computer Modern", // 更具学术感的字体
  sansfont: "Optima Nova", // 更优雅的无衬线字体
  codefont: "JetBrains Mono", // 更精致的等宽字体
  fontsize: 10pt, // 略微减小正文字号
  sectionnumbering: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  draft: false,
  footer-content: none,
  distribution: none,
  external-link-circle: true,
  theme-color: rgb("#1B255A"),
  doc,
) = {
  set document(title: title)

  // 2. 基础段落和块级元素设置
  set block(spacing: 1.1em)  // 增加段落间距
  set par(
    leading: 1.0em,        // 增加行距
    justify: true,
    first-line-indent: 1em
  )

  // Document metadata
  if authors != none {
    set document(
      title: title,
      author: authors.map(author => to-string(author.name)),
    )
  } else {
    set document(title: title)
  }

  // Just a suttle lightness to decrease the harsh contrast
  set text(
    fill: luma(30), // 借鉴第二个模板的文字颜色
    historical-ligatures: true, // 优雅的连字
    tracking: 0.3pt // 微调字距
  )


  // Tables and figures
  show figure: set figure.caption(separator: [.#h(0.3em)])
  show figure.caption: set align(left)
  show figure.caption: set text(
    font: sansfont,
    size: 8.5pt,
    style: "italic",
    fill: luma(50)
  )


  set table(
    stroke: none,  // 先移除所有线条
    align: center,
    inset: 6pt
  )

  // 添加三线表样式
  show table: it => {
    set text(11pt)  // 设置表格文字大小
    grid(
      rows: (auto),
      grid.hline(),  // 顶线
      it,  // 表格内容
      grid.hline()   // 底线
    )
  }

  // 表头样式，添加下边线
  show table.header: it => {
    set text(weight: "bold")  // 表头文字加粗
    style(styles => {
      grid(
        columns: 1,
        it,
        grid.hline()  // 表头下方线
      )
    })
  }

  show figure.where(kind: "quarto-float-tbl"): set figure.caption(position: top)
  show figure.where(kind: "quarto-float-tbl"): set figure(numbering: "I")
  // 修改表格标题样式
  show figure.where(kind: table): set figure.caption(
    position: top     // 标题位于表格上方
  )

  // 设置表格标题的文本样式和对齐方式
  show figure.where(kind: table): set figure.caption(
    position: top     // 标题位于表格上方
  )

  // 设置所有表格标题的对齐和样式
  show figure.caption: it => {
    set align(center)  // 居中对齐
    set text(
      font: sansfont,
      size: 8.5pt,
      style: "italic",
      fill: luma(50)
    )
    it
  }
  show figure.where(kind: image): set figure(
    supplement: [Fig.],
    numbering: "1",
  )

  show figure.where(kind: "quarto-float-fig"): set figure(
    supplement: [Figure],
    numbering: "1",
  )

  show figure.where(kind: raw): set figure.caption(position: top)
  show figure.where(kind: raw): set figure(supplement: [Code], numbering: "1")

  show raw: set text(
    font: codefont,
    size: 9pt,
    ligatures: false
  )
  // Equations
  set math.equation(numbering: "(1)")
  show math.equation: set block(spacing: 0.5em)

  show link: it => {
    it
    // Workaround for ctheorems package so that its labels keep the default link styling.
    if external-link-circle and type(it.dest) != label  {
      sym.wj
      h(1.6pt)
      sym.wj
      super(box(height: 3.8pt, circle(radius: 1.2pt, stroke: 0.7pt + theme-color)))
    }
  }

  // Lists
  set enum(
    indent: 0.8em,
    body-indent: 0.8em,
  )
  set list(
    indent: 0.8em,
    body-indent: 0.8em,
  )

  show list: set par(justify: false)

  // Headings
  show heading: set text()
  show heading.where(level: 1): it => {
    block(
      width: 100%,
      {
        v(1.5em)       // 标题前间距
        text(
          size: 16pt,
          weight: "bold",
          tracking: 0.6pt,
          font: sansfont
        )[#colorize-first-chars(it, theme-color)]
        v(1em)       // 标题后间距
      }
    )
  }

  show heading.where(level: 2): it => {
    block(
      width: 100%,
      {
        v(1.2em)
        text(
          size: 14pt,
          weight: "medium",
          style: "italic",
          tracking: 0.3pt
        )[#colorize-first-chars(it, theme-color)]
        v(0.8em)
      }
    )
  }

  show heading.where(level: 3): it => {
    block(
      width: 100%,
      {
        v(0.8em)
        text(
          size: 11pt,
          style: "italic",
          weight: "medium"
        )[#colorize-first-chars(it, theme-color)]
        v(0.5em)
      }
    )
  }

  // show heading: it => {
  //   if it.level <= 3 {
  //     it
  //   } else { }
  // }

  // Page setup
  set page(
    paper: paper,
    margin: (
      left: 1in,
      right: 3.5in,
      top: 1.5in,
      bottom: 1.5in,
    ),
    header: context {
      if counter(page).get().first() > 1 {
        let header-color = if theme-color != none { theme-color } else { default-theme-color }

        block(
          width: 100% + 3.5in - 1in,
          inset: (y: 8pt),
          {
            grid(
              columns: (1fr, auto),
              gutter: 1em,
              {
                // 左侧标题
                let title-text = if shorttitle != none { shorttitle } else { title }
                text(
                  font: sansfont,
                  size: 9.5pt,
                  weight: "medium",
                  tracking: 0.3pt,
                )[#colorize-first-chars(title-text, header-color)]
              },
              {
                // 右侧页码
                text(
                  font: sansfont,
                  size: 8.5pt,
                  fill: rgb(100,100,100)
                )[#counter(page).display()]
              }
            )
          }
        )
      }
    },
    footer: context {
      set text(font: sansfont, size: 8pt, fill: luma(100))
      block(
        width: 100% + 3.5in - 1in,
        align(right)[#counter(page).display()]
      )
    }
  )


  // frontmatter
  if title != none {
    wideblock({
      set text(
        hyphenate: false,
        size: 20pt,
        font: sansfont,
        weight: "bold"
      )
      set par(
        justify: false,
        leading: 0.35em,
        first-line-indent: 0pt,
      )
      colorize-first-chars(title, theme-color)

      if subtitle != none {
        set text(size: fontsize)
        v(-0.65em)
        colorize-first-chars(subtitle, theme-color)
      }
    })
  }

  if authors != none {
    wideblock({
      set text(font: sansfont, size: 10pt)
      v(1em)
      for i in range(calc.ceil(authors.len() / 3)) {
        let end = calc.min((i + 1) * 3, authors.len())
        let is-last = authors.len() == end
        let slice = authors.slice(i * 3, end)
        grid(
          columns: slice.len() * (1fr,),
          gutter: fontsize,
          ..slice.map(author => align(
            left,
            {
              colorize-first-chars(author.name, theme-color)
              if "university" in author [
                \ #author.university
              ]
              if "email" in author [
                \ #to-string(author.email)
              ]
            }
          ))
        )

        if not is-last {
          v(16pt, weak: true)
        }
      }
    })
  }

  // 日期处理部分
  if date != none {
    wideblock({
      set text(font: sansfont, size: 10pt)
      v(1em)

      // 格式化日期
      let formatted-date = {
        let month = datetime.today().display("[month repr:long]")
        let day = str(datetime.today().day())
        let year = str(datetime.today().year())
        [#month #day, #year]
      }

      // 应用首字母着色
      colorize-first-chars(formatted-date, theme-color)
    })
  }

  if abstract != none {
    wideblock({
      set text(font: sansfont)
      let abs-text = to-string(abstract)
      let words = abs-text.split(" ")

      if words.len() > 0 {
        colorize-first-chars(abstract, theme-color)
      } else {
        abstract
      }
    })
  }

  if toc {
    wideblock({
      v(1em)
      set text(font: sansfont)
      outline(indent: 1em, title: none, depth: 2)
    })
  }

  // Finish setting up sidenotes
  set-page-properties()
  set-margin-note-defaults(
    stroke: none,
    side: right,
    margin-right: 2.35in,
    margin-left: 1.35in,
  )

  // Body text
  set text(
    lang: lang,
    region: region,
    font: font,
    style: "normal",
    weight: "regular",
    hyphenate: true,
    size: fontsize,
  )

  show cite.where(form: "prose"): notecite

  doc

}
