# The CTH Blockchain Network

A Proof-of-Stake (PoS) blockchain network deployment for CTH using Ethereum's execution and consensus layer clients.

## Overview

This repository contains the deployment configuration for running a CTH blockchain node. The CTH network uses:

- **Execution Layer**: Geth v1.16.7 (Ethereum client)
- **Consensus Layer**: Lighthouse v8.0.1 (Beacon Chain)
- **Validator Client**: Lighthouse v8.0.1

### Network Details

- **Network ID**: 5858
- **Chain ID**: 5858
- **Checkpoint Sync URL**: https://cl.cthscan.com
- **Consensus Mechanism**: Proof of Stake (PoS)

## Prerequisites

Before deploying, ensure you have the following installed:

- Docker (v20.10 or higher)
- Docker Compose (v2.0 or higher)
- OpenSSL (for generating nodekey)
- curl (for IP detection)

## Project Structure

```
.
├── config/                 # Network configuration files
│   ├── config.yaml        # Lighthouse beacon chain config
│   ├── genesis.json       # Genesis block configuration
│   ├── genesis.ssz        # Genesis state for beacon chain
│   └── deposit_contract.txt
├── data/                  # Node data (created automatically)
│   ├── geth/             # Geth blockchain data
│   └── lighthouse/       # Lighthouse beacon & validator data
├── keys/                 # Validator keys (for validators only)
├── .env                  # Environment configuration
├── docker-compose.yml    # Docker services definition
├── init-script.sh        # Geth initialization script
├── import-key.sh         # Validator key import script
└── update_ip_and_nodekey.sh  # IP and nodekey setup script
```

## Deployment Instructions

### Step 1: Clone the Repository

```bash
git clone https://github.com/Chang-Chain-Foundation/node.git
cd node
```

### Step 2: Configure Environment Variables

Edit the `.env` file to configure your node:

```bash
vim .env
```

**Required Configuration**:

```env
## BOOTNODE Configuration
NODE_PUBLIC_IP=49.13.153.208
CHAIN_ID=5858
ELNODES=enode://ca2d0011d2561ea1af8f3ca4adbe1cc00f778394e7c24879fdd7d4cc1317c1fe1673bd683f5c7acd5842d0b54fed88acbab60f942f82900893d76b406229fc48@152.42.244.16:30303,enode://b88bb8937836ce1d9a284c5a45113955ab72c171733688e234c86b9daa494b57f6b85a363626e875124b0e3e96662ff55d11b9e0f625c8c16591228c7a157da2@5.78.64.180:30303,enode://b6e3e76d6f62e8e7770e509d49074a6f3023c9389d717da441199e83adecde1be286b78d7105c8bf1c0d2d6400587d6c51757f2d745e523bf52e655893618328@159.69.17.47:30303
CLNODES=enr:-Oy4QPK7ODcgObGdqVV99SDTu0QBu-aLZ1sLk56s8fpaKC5xPr0-vgDLkpBoqAf9GTq2qnpe-Fxl6_-zyn3uLk8cS9gHh2F0dG5ldHOIAAAAYAAAAACDY2djgYCGY2xpZW500YpMaWdodGhvdXNlhTguMC4xhGV0aDKQnOXLznAAADj__________4JpZIJ2NIJpcISYKvQQg25mZISc5cvOhHF1aWOCIymJc2VjcDI1NmsxoQKUgCQ443y4S7En-HX_1ULYNe9JyO0CmYSd1wi2UKaZk4hzeW5jbmV0cw-DdGNwgiMog3VkcIIjKA,enr:-Oy4QKgqIwIZMrYYpHgN4x6ogyMXR1-RRTUasCVATNFkUfDOTZJ3fFT73Lqsvfn0ZMBDi2uCdjJRbO99Dob-DzYNsHAOh2F0dG5ldHOIAAYAAAAAAACDY2djgYCGY2xpZW500YpMaWdodGhvdXNlhTguMC4xhGV0aDKQnOXLznAAADj__________4JpZIJ2NIJpcIQFTkC0g25mZISc5cvOhHF1aWOCIymJc2VjcDI1NmsxoQLfVaQOqoPqmU0E0BVB7uUpulMEr8AhnNrR3fxlxaB__IhzeW5jbmV0cw-DdGNwgiMog3VkcIIjKA,enr:-Oy4QO7KTH-sgrhK5ArKebThS1gbIKdrdD7Hby63CLLXTKpoXYT79HPSZR5Hl7UBGIfJOv_1RMFWtOAzOEH8piCDDkgKh2F0dG5ldHOIAIABAAAAAACDY2djgYCGY2xpZW500YpMaWdodGhvdXNlhTguMC4xhGV0aDKQnOXLznAAADj__________4JpZIJ2NIJpcISfRREvg25mZISc5cvOhHF1aWOCIymJc2VjcDI1NmsxoQK9L26-JTtzWSHrmIZH5nfqS_eNE03ZdQOCCfkQ5zPDjIhzeW5jbmV0cw-DdGNwgiMog3VkcIIjKA

## VALIDATOR Configuration
FEE_RECIPIENT=<Your Address For fee reception>
NODE_GRAFFITI=ChangeItForIdentityYourNode1NodePer1GraffitiOnly 
# example. NODE_GRAFFITI=node1_cth-thai

```

- `NODE_PUBLIC_IP`: Your server's public IP (auto-detected in next step)
- `FEE_RECIPIENT`: Ethereum address to receive validator rewards
- `NODE_GRAFFITI`: Custom identifier for your node (visible in blocks you propose)
- `ELNODES`: Execution layer bootnodes (pre-configured)
- `CLNODES`: Consensus layer bootnodes (pre-configured)

### Step 3: Setup Public IP and Generate Nodekey

Run the automated setup script:

```bash
chmod +x update_ip_and_nodekey.sh
./update_ip_and_nodekey.sh
```

This script will:
- Auto-detect your public IP address
- Update `NODE_PUBLIC_IP` in `.env`
- Generate a unique `nodekey` in `./config/nodekey`
- Create a backup of your `.env` file

### Step 4: Import Validator Keys (Validators Only)

If you're running a validator, place your validator keystores in the `./keys` directory, then import them:

```bash
chmod +x import-key.sh
./import-key.sh
```

This will prompt you to enter the password for each validator key.

**Note**: Skip this step if you're only running a non-validating node.

### Step 5: Start the Node

Start all services using Docker Compose:

```bash
docker-compose up -d
```

This will start three services:
1. **geth** - Execution layer client (port 8545 HTTP RPC, 8546 WebSocket, 30303 P2P)
2. **beacon** - Consensus layer beacon chain (port 5052 HTTP API, 9000 P2P)
3. **validator** - Validator client (validators only)

### Step 6: Verify Node Operation

Check service status:

```bash
docker-compose ps
```

View logs:

```bash
# All services
docker-compose logs -f

# Specific service
docker-compose logs -f geth
docker-compose logs -f beacon
docker-compose logs -f validator
```

Check sync status:

```bash
# Execution layer sync status
docker-compose exec geth geth attach /data/geth.ipc --exec "eth.syncing"

# Beacon chain sync status
curl http://localhost:5052/eth/v1/node/syncing
```

## Service Configuration

### Geth (Execution Layer)

- **HTTP RPC**: `http://0.0.0.0:8545`
- **WebSocket**: `ws://0.0.0.0:8546`
- **P2P Port**: 30303
- **Sync Mode**: Full (archive mode)
- **Database**: Pebble
- **APIs**: debug, web3, eth, txpool, net, admin, engine

### Lighthouse Beacon (Consensus Layer)

- **HTTP API**: `http://0.0.0.0:5052`
- **P2P Ports**: 9000 (TCP/UDP)
- **Checkpoint Sync**: Enabled (https://cl.cthscan.com)
- **Staking**: Enabled
- **Supernode**: Enabled

### Lighthouse Validator

- **Beacon Node**: `http://<NODE_PUBLIC_IP>:5052`
- **Slashing Protection**: Enabled
- **Fee Recipient**: Configured via `FEE_RECIPIENT`
- **Graffiti**: Configured via `NODE_GRAFFITI`

## Network Ports

Ensure the following ports are open in your firewall:

| Port  | Protocol | Service | Purpose |
|-------|----------|---------|---------|
| 30303 | TCP/UDP  | Geth    | P2P communication |
| 8545  | TCP      | Geth    | HTTP RPC (optional, can restrict) |
| 8546  | TCP      | Geth    | WebSocket RPC (optional, can restrict) |
| 9000  | TCP/UDP  | Beacon  | P2P communication |
| 5052  | TCP      | Beacon  | HTTP API (optional, can restrict) |
| 8551  | TCP      | Geth    | Engine API (localhost only) |

**Security Note**: For production deployments, restrict RPC/API ports (8545, 8546, 5052) to trusted IPs only.

## Maintenance Commands

### Stop Services

```bash
docker-compose down
```

### Restart Services

```bash
docker-compose restart
```

### Update Services

```bash
docker-compose pull
docker-compose up -d
```

### View Resource Usage

```bash
docker stats
```

### Clean Up Old Logs

Logs are automatically rotated (max 100MB per file, 10 files retained).

### Backup Important Data

```bash
# Backup validator keys and slashing protection DB
tar -czf validator-backup.tar.gz ./data/lighthouse/custom/validators

# Backup configuration
tar -czf config-backup.tar.gz ./config .env
```

## Troubleshooting

### Geth not syncing

1. Check bootnode connectivity:
   ```bash
   docker-compose logs geth | grep "peer"
   ```

2. Verify public IP is correct:
   ```bash
   grep NODE_PUBLIC_IP .env
   curl https://api.ipify.org
   ```

### Beacon chain not syncing

1. Check checkpoint sync:
   ```bash
   docker-compose logs beacon | grep checkpoint
   ```

2. Verify execution layer connection:
   ```bash
   docker-compose logs beacon | grep "execution"
   ```

### Validator not attesting

1. Check validator is imported:
   ```bash
   docker-compose exec validator lighthouse account validator list --testnet-dir=/config
   ```

2. Verify beacon node connection:
   ```bash
   docker-compose logs validator | grep beacon
   ```

### Reset and Resync

If you need to completely reset the node:

```bash
docker-compose down
rm -rf ./data/geth ./data/lighthouse
docker-compose up -d
```

**Warning**: This will delete all blockchain data and require a full resync.

## Performance Optimization

### Hardware Requirements

**Minimum Requirements**:
- CPU: 4 cores
- RAM: 16 GB
- Storage: 500 GB SSD
- Network: 10 Mbps

**Recommended Requirements**:
- CPU: 8+ cores
- RAM: 32 GB
- Storage: 1 TB NVMe SSD
- Network: 100 Mbps

### Disk Space Management

Monitor disk usage:

```bash
du -sh ./data/*
```

Archive mode keeps all historical state. For reduced storage, consider switching to full mode (requires configuration changes).

## Security Best Practices

1. **Firewall Configuration**: Only expose necessary P2P ports
2. **Validator Keys**: Store securely, never commit to version control
3. **Regular Updates**: Keep Docker images updated
4. **Monitoring**: Set up alerting for node downtime
5. **Backups**: Regularly backup validator keys and slashing protection DB
6. **SSH Security**: Use key-based authentication, disable password auth
7. **Environment Variables**: Never commit `.env` with sensitive data

## Monitoring and Metrics

### Check Node Health

```bash
# Execution layer
curl -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_syncing","params":[],"id":1}' http://localhost:8545

# Consensus layer
curl http://localhost:5052/eth/v1/node/health
```

### Peer Count

```bash
# Execution peers
docker-compose exec geth geth attach /data/geth.ipc --exec "net.peerCount"

# Consensus peers
curl http://localhost:5052/eth/v1/node/peer_count
```

## Support and Resources

- **Block Explorer**: https://cthscan.com (if available)
- **Checkpoint Sync**: https://cl.cthscan.com

## License

This project is licensed under the MIT License.

## Contributing

Contributions are welcome! Please submit pull requests or open issues for any improvements or bug fixes.

---

**Note**: This is a CTH blockchain node deployment. Ensure you understand the responsibilities of running a blockchain node, especially if operating as a validator with staked funds.
