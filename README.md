# `tufte` Format

A Tufte template for Quarto with a Typst backend, adapted from [nogula/tufte-memo](https://github.com/nogula/tufte-memo)

<!-- pdftools::pdf_convert('template.pdf', pages = 1) -->
![[template.qmd](template.qmd)](template_1.png)

## Installing

```bash
quarto use template christopherkenny/tufte
```

This will install the format extension and create an example qmd file that you can use as a starting place for your document.

## Using this template

This template has many optional arguments, based on the underlying Typst template.

Some options to set include:

- `subtitle`: Your document's subtitle
- `shorttitle`: A short title to include in the document's header
- `author`: Author and affiliation information, following [Quarto's schema](https://quarto.org/docs/journals/authors.html).
    - `email`: Emails are listed as links under authors.
    - Institution names are listed. Other arguments to affiliation are ignored.
- `document-number`: A reference number for the document
- `distribution`: A footer distribution note
- `publisher`: A publisher to include under the header
- `footer-content`: A footer to include
- `mainfont`: A serif primary font
- `sansfont`: A non-serif secondary font
- `codefont`: A font for code chunks (aka "raw" blocks in Typst)
- `fontsize`: Set the default font size. Default is 11pt.


Note that you can modify the following, but this is not recommended:
- `margins`: These create a major column with room in the margin. You may want to adjust the top/bottom/y margins, but it is not recommended to adjust the left/right/x margins.

## License

This extension is licensed under the MIT license. The extension is based on ([nogula/tufte-memo](https://github.com/nogula/tufte-memo)), which is licensed under MIT by [nogula](https://github.com/nogula). All modifications by me are licensed under the MIT license. See the license file for futher details.
