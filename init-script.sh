#!/bin/sh

reth init --chain /chainspec/genesis.json --datadir /data

exec reth "$@"
