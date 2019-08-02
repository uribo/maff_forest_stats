FROM rocker/tidyverse:3.6.1

RUN set -x && \
  apt-get update && \
  apt-get install -y --no-install-recommends \
    fonts-ipaexfont && \
  apt-get clean && \
  rm -rf /var/lib/apt/lists/*

ARG GITHUB_PAT

ENV RENV_VERSION 0.6.0-41

RUN set -x && \
  install2.r --error \
    styler && \
  installGithub.r \
    "rstudio/renv@${RENV_VERSION}" && \
  rm -rf /tmp/downloaded_packages/ /tmp/*.rds
