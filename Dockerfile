FROM lsiobase/alpine:3.8

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

# package version
ARG SATIP_VER="master"

RUN \
 echo "**** install build packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	g++ \
	gcc \
	git \
	make \
	mercurial \
	openssl-dev \
	perl && \
 echo "**** install runtime packages ****" && \
 apk add --no-cache \
	libdvbcsa-dev \
	linux-headers \
	openssl && \
 echo "**** build dvb-apps ****" && \
 hg clone http://linuxtv.org/hg/dvb-apps /tmp/dvb-apps && \
 cd /tmp/dvb-apps && \
 make -C lib && \
 make -C lib install && \
 echo "***** compile satip ****" && \
 git clone https://github.com/catalinii/minisatip \
	/app/satip && \
 cd /app/satip && \
 git checkout "${SATIP_VER}" && \
 ./configure && \
 make && \
 echo "**** clean up ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8875 554 1900/udp
