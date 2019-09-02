#!/bin/sh -e

if [ $# -ne 2 ]; then
    echo usage $0 login vault
    exit 1
fi

LOGIN=$1
VAULT=$2

mega-login "${LOGIN}" "$(secret.sh ${LOGIN} mega ${VAULT})"
echo $?

tail -f /tmp/.megaCmd/megacmdserver.log
