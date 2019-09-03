#!/bin/sh -e

if [ $# -ne 2 ]; then
    echo usage $0 login vault
    exit 1
fi

LOGIN=$1
VAULT=$2

tail -F /tmp/.megaCmd/megacmdserver.log &
TAIL=$!

trap 'exit 0' HUP INT TERM QUIT
trap 'mega-logout || true; kill ${TAIL} || true; exit 0' EXIT

while true; do
    mega-login "${LOGIN}" "$(secret.sh ${LOGIN} mega ${VAULT})"
    while mega-whoami > /dev/null; do
        sleep 5m &
        wait $! || true
    done
done

wait ${TAIL}

exit 0
