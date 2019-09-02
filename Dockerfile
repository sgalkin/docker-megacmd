ARG VERSION=18.04
FROM ubuntu:$VERSION

ARG VERSION
ARG MEGACMD_DEB=megacmd-xUbuntu_${VERSION}_amd64.deb
ARG MEGACMD_URL=https://mega.nz/linux/MEGAsync/xUbuntu_18.04/amd64/${MEGACMD_DEB}

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        gnupg2 \
        libc-ares2 \
        libcrypto++6 \
        libmediainfo0v5 \
        libpcrecpp0v5 \
        libssl1.1 \
        libzen0v5 \
        wget \
    && echo 'path-include=/usr/share/doc/megacmd/*' > /etc/dpkg/dpkg.cfg.d/megacmd \
    && wget -O ${MEGACMD_DEB} ${MEGACMD_URL} \
    && dpkg -i ${MEGACMD_DEB} \
    && rm -rf ${MEGACMD_DEB} \
    && apt-get autoremove --purge -y wget \
    && apt-get update \
    && apt-get dist-upgrade --autoremove --purge -y --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

COPY secret.sh /usr/local/bin/secret.sh

ENV HOME=/tmp
USER nobody
