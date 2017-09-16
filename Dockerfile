FROM debian:latest

ENV DEBIAN_FRONTEND noninteractive

# install pandoc & latex packages
RUN apt-get update -y && \

  apt-get install -y --no-install-recommends \
    texlive-latex-base \
    texlive-xetex latex-xcolor \
    texlive-latex-extra \
    texlive-fonts-extra \
    texlive-fonts-recommended \
    texlive-generic-recommended \
    fontconfig \
    pandoc \
    python3-pandocfilters \
    lmodern \
    wget \
    xzdec && \
  useradd -ms /bin/bash pandoc

USER pandoc

# Install latex and dependencies
RUN tlmgr init-usertree ; \
  tlmgr update --self && \
  tlmgr install lastpage && \
  tlmgr install moderncv && \
  tlmgr install tufte-latex && \
  tlmgr install changepage && \
  tlmgr install paralist && \
  tlmgr install titlesec && \
  tlmgr install ec && \
  tlmgr install units && \
  tlmgr install lipsum && \
  tlmgr install palatino && \
  tlmgr install mathpazo && \
  tlmgr install fpl && \
  tlmgr install ucs && \
  tlmgr install etoolbox && \
  tlmgr install fontawesome

WORKDIR /source

ENTRYPOINT ["pandoc"]

CMD ["--help"]
