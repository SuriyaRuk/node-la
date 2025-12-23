#!/bin/bash
docker run -ti --rm -v ./data/lighthouse:/root/lighthouse -v ./data/lighthouse/custom/validators:/root/.lighthouse/custom/validators -v ./config:/config -v ./keys:/keys sigp/lighthouse:v8.0.1 lighthouse account validator import --directory=/keys --testnet-dir=/config
