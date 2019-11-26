FROM alpine:3.9

RUN apk -U add \
    curl \
    cabal \
    build-base \
    ca-certificates \
    make \
    git \
    ghc \
    texlive \
    texlive-xetex \
    texlive-luatex \
    fontconfig \
    wget \
    unzip \
    imagemagick6 \
    librsvg \
    librsvg-dev\
    zlib \
    zlib-dev \
    xz-dev && \

# fix the access rights for imagemagick
  sed -i -e 's/rights="none"/rights="read|write"/g' /etc/ImageMagick-6/policy.xml &&\
  sed -i -e 's/<\/policymap>/<policy domain="module" rights="read|write" pattern="{PS,PDF,XPS}" \/>\n<\/policymap>/g' /etc/ImageMagick-6/policy.xml &&\

# get the newest list of packages
    mkdir -p /root/.cabal &&\
    echo "jobs: 16" >> ~/.cabal/config &&\
    echo "remote-repo: hackage.haskell.org:http://hackage.haskell.org/packages" >> ~/.cabal/config &&\
    cabal update &&\

# install the dependencies of the packages we want
    cabal install --dependencies-only \
                  pandoc \
                  pandoc-citeproc \
                  pandoc-citeproc-preamble \
                  pandoc-crossref \
                  latex-formulae-pandoc &&\

# install the packages we want
    cabal install pandoc \
                  pandoc-citeproc \
                  pandoc-citeproc-preamble \
                  pandoc-crossref \
                  latex-formulae-pandoc &&\

# clear unnecessary cabal files
    rm -rf /root/.cabal/logs &&\
    rm -rf /root/.cabal/packages &&\

# clean up all temporary files
    apk -U del cabal build-base ghc &&\
    apk -v cache clean &&\

# add pandoc user
 useradd -ms /bin/bash pandoc

USER pandoc

WORKDIR /tmp

RUN tlmgr init-usertree ; tlmgr install \
      moderncv \
      etoolbox \
      fontawesome && \
  wget -O fonts.zip "https://fonts.google.com/download?family=Roboto|Noto%20Sans|Open%20Sans|Roboto%20Condensed|Source%20Sans%20Pro|Raleway|Merriweather|Roboto%20Slab|PT%20Sans|Open%20Sans%20Condensed|Droid%20Sans|Droid%20Serif|Fira%20Sans|Fira%20Sans%20Condensed|Fira%20Sans%20Extra%20Condensed|Fira%20Mono"  && \
  wget -O firacode.zip "https://github.com/tonsky/FiraCode/releases/download/1.204/FiraCode_1.204.zip" && \
  unzip fonts.zip -d ~/.fonts && \
  unzip firacode.zip -d ~/.fonts && \
  fc-cache -v -f && \
  rm -rf fonts.zip firacode.zip

WORKDIR /source

ENTRYPOINT ["pandoc"]

CMD ["--help"]
