#!/bin/sh -e

if [ $# -eq 0 ]; then
   LOGIN=${LOGIN?no login}
   VAULT=${VAULT?no vault}
elif [ $# -eq 2 ]; then
   LOGIN=${1?no login}
   VAULT=${2?no vault}
else
   echo usage $0 login vault
   exit 1
fi

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
