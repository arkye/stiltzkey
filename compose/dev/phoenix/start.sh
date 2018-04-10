#!/usr/bin/env bash

printf "\n## Initializing Stiltzkey\n\n"
echo "Hostname: $HOSTNAME"
echo "Port: $PORT"
mix phx.server
