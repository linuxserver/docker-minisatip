FROM lsiobase/alpine

# package version
ARG SATIP_VER="master"

# environment settings
ARG SATIP_SRC="/tmp"
ARG SATIP_URL="https://github.com/catalinii/minisatip/archive"
ARG SATIP_WWW="${SATIP_URL}/${SATIP_VER}.tar.gz"
ENV SATIP_ROOT="/app/satip"

# install build dependencies
RUN \
 apk add --no-cache --virtual=build-dependencies \
	curl \
	g++ \
	gcc \
	openssl-dev \
	make \
	tar && \


# add runtime dependencies required in build stage.
 apk add --no-cache \
	libdvbcsa-dev \
	linux-headers && \

# fetch satip source
 curl -o \
 "${SATIP_SRC}/satip.tar.gz" -L \
	"${SATIP_WWW}" && \

# unpack source
 mkdir -p \
	"${SATIP_ROOT}" && \
 tar xf "${SATIP_SRC}/satip.tar.gz" -C \
	"${SATIP_ROOT}" --strip-components=1 && \

# compile satip
 cd "${SATIP_ROOT}" && \
 ./configure && \
 make && \

 # uninstall build dependencies
 apk del --purge \
	build-dependencies && \

# clean up
 rm -rfv \
	/tmp/*

# add remaining runtime dependencies
RUN \
 apk add --no-cache \
	openssl

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8875 554 1900/udp
