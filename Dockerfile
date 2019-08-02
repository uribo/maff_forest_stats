FROM rocker/geospatial:3.6.0

RUN set -x && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    fonts-ipaexfont && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

ARG GITHUB_PAT

RUN set -x && \
  install2.r --error \
    assertr \
    conflicted \
    drake \
    ensurer \
    gghighlight \
    here \
    styler && \
  installGithub.r \
    "rstudio/renv" \
    "uribo/odkitchen" && \
  rm -rf /tmp/downloaded_packages/ /tmp/*.rds
