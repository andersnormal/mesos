#!/bin/bash

# principal
PRINCIPAL=${PRINCIPAL:-root}

# set secret
if [ -n "$SECRET" ]; then
    touch /tmp/credential
    chmod 600 /tmp/credential
    printf '%s %s' "$PRINCIPAL" "$SECRET" > /tmp/credential
    export MESOS_CREDENTIAL=/tmp/credential
fi

# start service
exec "$@"