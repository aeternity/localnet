#!/bin/bash

# As this script might be used as docker health check it should exit with either 0/1

EXTERNAL_ADDRESS=${EXTERNAL_ADDRESS:-localhost:3013}
INTERNAL_ADDRESS=${INTERNAL_ADDRESS:-localhost:3113}
MIN_PEERS=${MIN_PEERS:-2}

# External API
curl -sSf -o /dev/null --retry 10 --retry-connrefused http://${EXTERNAL_ADDRESS}/v2/status || exit 1

# Internal API
PEERS_COUNT=$(curl -s -S ${INTERNAL_ADDRESS}/v2/debug/peers | grep -o aenode | wc -l)

# Explicit exit because otherwise test would exit with status 127
test $PEERS_COUNT -ge $MIN_PEERS || exit 1
