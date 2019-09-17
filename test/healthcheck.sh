#!/bin/bash

# As this script might be used as docker health check it should exit with either 0/1

EXTERNAL_ADDR=${EXTERNAL_ADDR:-localhost:3013}
INTERNAL_ADDR=${INTERNAL_ADDR:-localhost:3113}
WEBSOCKET_ADDR=${WEBSOCKET_ADDR:-localhost:3014}

# External API
curl -sSf -o /dev/null --retry 6 http://${EXTERNAL_ADDR}/v2/status || exit 1

# Internal API
PEERS_COUNT=$(curl -sS ${INTERNAL_ADDR}/v2/debug/peers | grep -o aenode | wc -l)

test $PEERS_COUNT -eq 1 || exit 1

# State Channels WebSocket API
WS_STATUS=$(curl -sS -o /dev/null --retry 6 \
    -w "%{http_code}" \
    http://${WEBSOCKET_ADDR}/channel)
# The proxy handles connection upgrade, and we send bad request anyway.
# It shouldn't be 404 so we're good.
[ $WS_STATUS -eq 400 ]
