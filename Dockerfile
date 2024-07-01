# syntax=docker/dockerfile:1

FROM ghcr.io/linuxserver/baseimage-alpine:3.20

# set version label
ARG BUILD_DATE
ARG VERSION
ARG MINISATIP_VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache --virtual=build-dependencies \
    build-base \
    git \
    mercurial \
    openssl-dev \
    perl && \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    libdvbcsa-dev \
    linux-headers \
    openssl \
  curl && \
  echo "**** build dvb-apps ****" && \
  hg clone http://linuxtv.org/hg/dvb-apps /tmp/dvb-apps && \
  cd /tmp/dvb-apps && \
  make -C lib && \
  make -C lib install && \
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
  apk del --purge \
    build-dependencies && \
  rm -rf \
    /tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8875 554 1900/udp
