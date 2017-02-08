FROM lsiobase/alpine:3.5
MAINTAINER sparklyballs

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"

# package version
ARG SATIP_VER="master"

# install build dependencies
RUN \
 apk add --no-cache --virtual=build-dependencies \
	g++ \
	gcc \
	git \
	make \
	mercurial \
	openssl-dev \
	perl && \

# install runtime packages
 apk add --no-cache \
	libdvbcsa-dev \
	linux-headers \
	openssl && \

# build dvb-apps
 hg clone http://linuxtv.org/hg/dvb-apps /tmp/dvb-apps && \
 cd /tmp/dvb-apps && \
 make -C lib && \
 make -C lib install && \

# fetch satip source
 git clone https://github.com/catalinii/minisatip \
	/app/satip && \

# compile satip
 cd /app/satip && \
 git checkout "${SATIP_VER}" && \
 ./configure && \
 make && \

# uninstall build dependencies
 apk del --purge \
	build-dependencies && \

# clean up
 rm -rf \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8875 554 1900/udp
