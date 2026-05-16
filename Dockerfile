ARG VERSION=26.04
FROM ubuntu:$VERSION

ARG VERSION
ARG MEGAIO_KEY=https://mega.nz/keys/MEGA_signing.key
ARG MEGAIO_SOURCE=https://mega.nz/linux/repo/xUbuntu_${VERSION}/

ENV DEBIAN_FRONTEND="noninteractive"

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        ca-certificates \
        curl \
        gpg \
    && curl -fsSL ${MEGAIO_KEY} \
        | gpg --dearmor > /etc/apt/keyrings/meganz-archive-keyring.gpg \
    && echo "Types: deb\nURIs: ${MEGAIO_SOURCE}\nSuites: ./\nSigned-By: /etc/apt/keyrings/meganz-archive-keyring.gpg" > /etc/apt/sources.list.d/megaio.sources \
    && apt-get update \
    && apt-get dist-upgrade --autoremove --purge -y --no-install-recommends \
    && apt-get install -y --no-install-recommends \
        megacmd \
    && rm -rf /var/lib/apt/lists/*

COPY secret.sh /usr/local/bin/secret.sh
COPY login.sh /usr/local/bin/login.sh
RUN chmod 755 /usr/local/bin/login.sh

ENV HOME=/tmp
USER nobody

ENTRYPOINT ["/usr/local/bin/login.sh"]
