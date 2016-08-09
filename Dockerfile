FROM lsiobase/alpine
MAINTAINER sparklyballs

# install build dependencies
RUN \
 apk add --no-cache --virtual=build-dependencies \
	curl \
	g++ \
	gcc \
	make \
	openssl-dev \
	tar && \

# install runtime packages
 apk add --no-cache \
	libdvbcsa-dev \
	linux-headers \
	openssl && \

# fetch satip source
 curl -o \
 /tmp/satip-src.tar.gz -L \
	https://github.com/catalinii/minisatip/archive/master.tar.gz && \

# unpack source
 mkdir -p \
	/app/satip && \
 tar xf /tmp/satip-src.tar.gz -C \
	/app/satip --strip-components=1 && \

# compile satip
 cd /app/satip && \
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
