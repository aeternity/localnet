#!/bin/bash

# As this script might be used as docker health check it should exit with either 0/1

EXTERNAL_ADDR=${EXTERNAL_ADDR:-localhost:3013}
INTERNAL_ADDR=${INTERNAL_ADDR:-localhost:3113}
WEBSOCKET_ADDR=${WEBSOCKET_ADDR:-localhost:3014}
MIN_PEERS=${MIN_PEERS:-2}

echo "Testing external API: ${EXTERNAL_ADDR}"
curl -sSf -o /dev/null --retry 6 http://${EXTERNAL_ADDR}/v3/status || exit 2

echo "Testing internal API: ${INTERNAL_ADDR}"
PEERS_COUNT=$(curl -sS ${INTERNAL_ADDR}/v3/debug/peers | grep -o aenode | wc -l)

echo "Testing internal API: $PEERS_COUNT peers"
test $PEERS_COUNT -ge $MIN_PEERS || exit 3

# Disable State Channels websocket test as the node crash with 500 and curl retry on 500
# This takes ~1 minute to complete this test - each time
# https://github.com/aeternity/aeternity/issues/3131

# echo "Testing WebSockets API: ${WEBSOCKET_ADDR}"
# WS_STATUS=$(curl -sS -o /dev/null --retry 6 \
#     -w "%{http_code}" \
#     http://${WEBSOCKET_ADDR}/channel)
# # The proxy handles connection upgrade, and we send bad request anyway.
# # It shouldn't be 404 so we're good.
# test $WS_STATUS -ne 404
