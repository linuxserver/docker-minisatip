# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-ubuntu:noble

# set version label
ARG BUILD_DATE
ARG VERSION
ARG MINISATIP_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="notdriz"

ENV \
  DEBIAN_FRONTEND="noninteractive" \
  MAKEFLAGS="-j4" \
  ATTACHED_DEVICES_PERMS="/dev/dvb -type c"

RUN \
  echo "**** install packages ****" && \
  apt-get update && \
  apt-get install --no-install-recommends -y \
    build-essential \
    git \
    libdvbcsa-dev \
    libssl-dev \
    linux-headers-generic \
    openssl \
    perl && \
  echo "***** compile satip ****" && \
  if [ -z ${MINISATIP_VERSION+x} ]; then \
    MINISATIP_VERSION=$(curl -sX GET https://api.github.com/repos/catalinii/minisatip/releases/latest \
    | awk '/tag_name/{print $4;exit}' FS='[""]'); \
  fi && \
  mkdir -p \
    /app/satip && \
  curl -o \
    /tmp/satip.tar.gz -L \
    "https://github.com/catalinii/minisatip/archive/${MINISATIP_VERSION}.tar.gz" && \
  tar xf \
    /tmp/satip.tar.gz -C \
    /app/satip --strip-components=1 && \
  cd /app/satip && \
  ./configure && \
  make DDCI=1 && \
  printf "Linuxserver.io version: ${VERSION}\nBuild-date: ${BUILD_DATE}" > /build_version && \
  echo "**** clean up ****" && \
  apt-get -y purge \
    build-essential \
    git \
    libssl-dev \
    linux-headers-generic \
    perl && \
  apt-get -y autoremove && \
  rm -rf \
    /tmp/* \
    /var/lib/apt/lists/* \
    /var/tmp/* \
    /root/.cache

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8875 554 1900/udp
