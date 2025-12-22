#!/bin/bash

# ไฟล์ .env ที่ต้องการแก้ไข
ENV_FILE=".env"

# ตรวจสอบว่ามีไฟล์ .env หรือไม่
if [ ! -f "$ENV_FILE" ]; then
    echo "Error: $ENV_FILE not found"
    exit 1
fi

# Check Public IP Address
echo "Checking Public IP Address..."
PUBLIC_IP=$(curl -s https://api.ipify.org)

# ตรวจสอบว่าได้ IP หรือไม่
if [ -z "$PUBLIC_IP" ]; then
    echo "Error: Unable to retrieve Public IP"
    exit 1
fi

echo "Your Public IP is: $PUBLIC_IP"

# Backup .env file
cp "$ENV_FILE" "${ENV_FILE}.backup"
echo "Backup created: ${ENV_FILE}.backup"

# Update NODE_PUBLIC_IP in .env file
if grep -q "^NODE_PUBLIC_IP=" "$ENV_FILE"; then
    # If variable exists, update it
    sed -i.tmp "s/^NODE_PUBLIC_IP=.*/NODE_PUBLIC_IP=$PUBLIC_IP/" "$ENV_FILE"
    rm -f "${ENV_FILE}.tmp"
    echo "Updated NODE_PUBLIC_IP=$PUBLIC_IP successfully"
elif grep -q "^NODE_PUBLIC_IP=$" "$ENV_FILE"; then
    # If variable exists but empty
    sed -i.tmp "s/^NODE_PUBLIC_IP=$/NODE_PUBLIC_IP=$PUBLIC_IP/" "$ENV_FILE"
    rm -f "${ENV_FILE}.tmp"
    echo "Updated NODE_PUBLIC_IP=$PUBLIC_IP successfully"
else
    # If variable doesn't exist, add it
    echo "NODE_PUBLIC_IP=$PUBLIC_IP" >> "$ENV_FILE"
    echo "Added NODE_PUBLIC_IP=$PUBLIC_IP successfully"
fi

echo "Done!"

echo "Generating nodekey..."
openssl rand -hex 32 > ./config/nodekey
echo "nodekey generated successfully"
echo "nodekey: $(cat ./config/nodekey)"
