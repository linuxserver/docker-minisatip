FROM lsiobase/alpine
MAINTAINER sparklyballs

# package version
ARG SATIP_VER="master"

# install build dependencies
RUN \
 apk add --no-cache --virtual=build-dependencies \
	g++ \
	gcc \
	git \
	make \
	openssl-dev && \

# install runtime packages
 apk add --no-cache \
	libdvbcsa-dev \
	linux-headers \
	openssl && \

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
