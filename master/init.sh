#!/bin/bash

# principal
PRINCIPAL=${PRINCIPAL:-root}

# scret
if [ -n "$SECRET" ]; then
    export MESOS_AUTHENTICATE=true
    export MESOS_AUTHENTICATE_SLAVES=true
    touch /tmp/credentials
    chmod 600 /tmp/credentials
    printf '%s %s' "$PRINCIPAL" "$SECRET" > /tmp/credentials
    export MESOS_CREDENTIALS=/tmp/credentials
fi

# start service
exec "$@"