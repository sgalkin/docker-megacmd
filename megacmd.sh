#!/bin/sh -e

start() {
    docker run -d --name "${NAME}" sgalkin/megacmd:latest "${LOGIN}" "${STORE}"
}

stop() {
    docker stop ${NAME} || true
    docker rm ${NAME} || true
}

if [ $# -ne 2 ]; then
    echo "usage $0 start|stop id"
    exit 1
fi

echo "Running $0 for $2 ($1)"

OP=$1
ID=$2

STORE=${ID%:*}
if [ -z ${STORE} ]; then
    echo "store not found in ${ID}"
    exit 1
fi

LOGIN=${ID##*:}
if [ -z ${LOGIN} ]; then
    echo "login not found in ${ID}"
    exit 1
fi

NAME="megacmd.$(echo -n ${ID} | sha256sum | cut -f1 -d' ')"
echo ${NAME}

case $OP in
    start)
        stop
        start
        ;;
    stop)
        stop
        ;;
    *)
        echo unexpected operation \'$OP\'
        exit 1
        ;;
esac

exit 0
