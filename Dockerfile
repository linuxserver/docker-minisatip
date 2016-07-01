FROM lsiobase/alpine

# install build dependencies
RUN \
 apk add --no-cache --virtual=build-dependencies \
	curl \
	g++ \
	gcc \
	openssl-dev \
	make \
	tar \
	wget && \

# add runtime dependencies
 apk add --no-cache \
	libdvbcsa-dev \
	linux-headers && \

# fetch satip source
 wget -O \
	/tmp/satip.tar.gz https://github.com/catalinii/minisatip/archive/master.tar.gz && \
	mkdir -p /app/satip && \
	tar xvf /tmp/satip.tar.gz -C /app/satip --strip-components=1 && \

# compile satip
 cd /app/satip && \
	./configure && \
	make && \

 # uninstall build dependencies
 apk del --purge \
	build-dependencies && \

# clean up
 rm -rf /var/cache/apk/* /tmp/*

# add runtime dependencies
RUN \
 apk add --no-cache \
	openssl && \

# clean up
 rm -rf /var/cache/apk/*

# add local files
COPY root/ /

# ports and volumes
EXPOSE 8875 554 1900/udp

