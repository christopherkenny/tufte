#let wideblock(content) = block(width: 100% + 2.5in, content)

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
  font: (),
  fontsize: 11pt,
  codefont: "DejaVu Sans Mono",
  sansfont: "Gill Sans MT",
  sectionnumbering: none,
  toc: false,
  toc_title: none,
  toc_depth: none,
  toc_indent: 1.5em,
  draft: false,
  footer-content: none,
  distribution: none,
  doc,
) = {

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
  set text(fill: luma(30))

  // Tables and figures
  show figure: set figure.caption(separator: [.#h(0.5em)])
  show figure.caption: set align(left)
  show figure.caption: set text(font: sansfont)

  show figure.where(kind: table): set figure.caption(position: top)
  show figure.where(kind: table): set figure(numbering: "I")
  show figure.where(kind: "quarto-float-tbl"): set figure.caption(position: top)
  show figure.where(kind: "quarto-float-tbl"): set figure(numbering: "I")

  show figure.where(kind: image): set figure(
    supplement: [Figure],
    numbering: "1",
  )
  show figure.where(kind: "quarto-float-fig"): set figure(
    supplement: [Figure],
    numbering: "1",
  )

  show figure.where(kind: raw): set figure.caption(position: top)
  show figure.where(kind: raw): set figure(supplement: [Code], numbering: "1")
  show raw: set text(font: "Lucida Console", size: 10pt)

  // Equations
  set math.equation(numbering: "(1)")
  show math.equation: set block(spacing: 0.65em)

  show link: underline

  // Lists
  set enum(
    indent: 1em,
    body-indent: 1em,
  )
  show enum: set par(justify: false)
  set list(
    indent: 1em,
    body-indent: 1em,
  )
  show list: set par(justify: false)

  // Headings
  set heading(numbering: none)
  show heading.where(level: 1): it => {
    v(2em, weak: true)
    text(size: 14pt, weight: "bold", it)
    v(1em, weak: true)
  }

  show heading.where(level: 2): it => {
    v(1.3em, weak: true)
    text(size: 13pt, weight: "regular", style: "italic", it)
    v(1em, weak: true)
  }

  show heading.where(level: 3): it => {
    v(1em, weak: true)
    text(size: fontsize, style: "italic", weight: "thin", it)
    v(0.65em, weak: true)
  }

  // show heading: it => {
  //   if it.level <= 3 {
  //     it
  //   } else { }
  // }

  // Page setup
  set page(
    paper: "us-letter",
    margin: (
      left: 1in,
      right: 3.5in,
      top: 1.5in,
      bottom: 1.5in,
    ),
    header: context {
      set text(font: sansfont)
      block(
        width: 100% + 3.5in - 1in,
        {
          if counter(page).get().first() > 1 {
            if document-number != none {
              document-number
            }
            h(1fr)
            if shorttitle != none {
              upper(shorttitle)
            } else {
              upper(title)
            }
            if publisher != none {
              linebreak()
              h(1fr)
              upper(publisher)
            }
          }
        },
      )
    },
    footer: context {
      set text(font: sansfont, size: 8pt)
      block(
        width: 100% + 3.5in - 1in,
        {
          if counter(page).get().first() == 1 {
            if type(footer-content) == array {
              footer-content.at(0)
              linebreak()
            } else {
              footer-content
              linebreak()
            }
            if draft [
              Draft document, #date.
            ]
            if distribution != none [
              Distribution limited to #distribution.
            ]
          } else {
            if type(footer-content) == array {
              footer-content.at(1)
              linebreak()
            } else {
              footer-content
              linebreak()
            }
            if draft [
              Draft document, #date.
            ]
            if distribution != none [
              Distribution limited to #distribution.
            ]
            linebreak()
            [Page #counter(page).display()]
          }
        },
      )
    },
    background: if draft {
      rotate(
        45deg,
        text(font: sansfont, size: 200pt, fill: rgb("FFEEEE"))[DRAFT],
      )
    },
  )

  set par(
    // justify: true,
    leading: 0.65em,
    first-line-indent: 1em
  )
  show par: set block(spacing: 0.65em)


  // frontmatter
  if title != none {
    wideblock({
      set text(
        hyphenate: false,
        size: 20pt,
        font: sansfont,
      )
      set par(
        justify: false,
        leading: 0.2em,
        first-line-indent: 0pt,
      )
      upper(title)
      set text(size: fontsize)
      v(-0.65em)
      upper(subtitle)
    })
  }

  if authors != none {
    wideblock({
      set text(font: sansfont, size: fontsize)
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
              upper(author.name)
              if "university" in author [
                \ #author.university
              ]
              if "email" in author [
                \ #to-string(author.email)
              ]
            },
          ))
        )

        if not is-last {
          v(16pt, weak: true)
        }
      }
    })
  }

  if date != none {
    upper(date)
    linebreak()
    if document-number != none {
      document-number
    }
  }

  if abstract != none {
    wideblock({
      set text(font: sansfont)
      set par(hanging-indent: 3em)
      h(3em)
      abstract
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

#set table(
  inset: 6pt,
  stroke: none,
)
