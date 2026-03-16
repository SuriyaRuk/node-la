#!/bin/sh

reth init --chain /config/genesis.json --datadir /data

exec reth "$@"
