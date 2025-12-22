#!/bin/sh

geth --db.engine=pebble --datadir /data  init /config/genesis.json

exec geth "$@"
