FROM lsiobase/alpine.python:3.7

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="sparklyballs"

ENV PLEXPY_VERSION v2.0.1-beta

RUN \
 echo "**** install packages ****" && \
 apk add --no-cache --virtual=build-dependencies \
	g++ \
	gcc \
	make \
	python-dev && \
 echo "**** install pip packages ****" && \
 pip install --no-cache-dir -U \
	pycryptodomex && \
 echo "**** install app ****" && \
 curl -L https://github.com/JonnyWong16/plexpy/archive/${PLEXPY_VERSION}.tar.gz --output ${PLEXPY_VERSION}.tar.gz && \
 mkdir -p /app/plexpy && \
 tar --strip-components=1 -C /app/plexpy -zxf ${PLEXPY_VERSION}.tar.gz && \
 echo "**** cleanup ****" && \
 apk del --purge \
	build-dependencies && \
 rm -rf \
	/root/.cache \
	${PLEXPY_VERSION}.tar.gz

# add local files
COPY root/ /

# ports and volumes
VOLUME /config /logs
EXPOSE 8181
