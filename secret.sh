#!/bin/sh -e

if [ $# -ne 3 ]; then
    echo usage $0 identity type vaule
    exit 1
fi

IDENTITY=$1
TYPE=$2
VAULT=$3


METADATA_HEADER="Metadata: true"
METADATA_URL="http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https%3A%2F%2Fvault.azure.net"

TOKEN=$(curl -s -H "${METADATA_HEADER}" "${METADATA_URL}" | \
        sed -n 's/.*"access_token":"\([^"]*\)".*/\1/gp')

SECRET_ID=$(echo -n ${TYPE}:${IDENTITY} | sha256sum | sed -n 's/^\(^\S*\) .*$/\1/gp')

VAULT_HEADER="Authorization: Bearer ${TOKEN}"
VAULT_URL="https://${VAULT}/secrets/${SECRET_ID}?api-version=2016-10-01"

SECRET=$(curl -s -H "${VAULT_HEADER}" "${VAULT_URL}" | \
         sed -n 's/.*"value":"\([^"]*\)".*/\1/gp')

echo -n ${SECRET}
