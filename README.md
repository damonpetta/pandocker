[![Docker Build Statu](https://img.shields.io/docker/build/damonpetta/pandocker.svg)]()

Pandocker provides a consistent pandoc + latex typesetting environment

Currently used for

  * Presentations - (markdown -> beamer pdf)
  * Documentation - (markdown -> {pdf,docx,rtf})

Includes LaTex CTAN packages

  * lastpage
  * moderncv
  * tufte-latex
  * changepage
  * paralist
  * titlesec
  * ec
  * units
  * lipsum
  * palatino
  * mathpazo
  * fpl
  * ucs
  * etoolbox
  * fontawesome


## Usage

To use as a drop in replacement for pandoc + latex add the following to `.bash_profile` or `.zshrc`

```
pandoc() {
  docker run -v $(pwd):/source damonpetta/pandocker $@
}
```

### Beamer

`docker run -v $$(pwd):/source damonpetta/pandocker --latex-engine=xelatex -t beamer -H your_style.tex -o beamer.pdf beamer.md`

