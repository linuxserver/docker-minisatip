FROM ghcr.io/linuxserver/baseimage-alpine:3.13

# set version label
ARG BUILD_DATE
ARG VERSION
ARG MINISATIP_COMMIT
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

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
	openssl \
  curl && \
 echo "**** build dvb-apps ****" && \
 hg clone http://linuxtv.org/hg/dvb-apps /tmp/dvb-apps && \
 cd /tmp/dvb-apps && \
 make -C lib && \
 make -C lib install && \
 echo "***** compile satip ****" && \
 if [ -z ${MINISATIP_COMMIT+x} ]; then \
	MINISATIP_COMMIT=$(curl -sX GET https://api.github.com/repos/catalinii/minisatip/commits/master \
	| awk '/sha/{print $4;exit}' FS='[""]'); \
 fi && \
 mkdir -p \
   /app/satip && \
 curl -o \
 /tmp/satip.tar.gz -L \
   "https://github.com/catalinii/minisatip/archive/${MINISATIP_COMMIT}.tar.gz" && \
 tar xf \
 /tmp/satip.tar.gz -C \
   /app/satip --strip-components=1 && \
 cd /app/satip && \
 ./configure && \
 make && \
 echo "**** clean up ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/tmp/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8875 554 1900/udp
