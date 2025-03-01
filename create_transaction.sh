#!/bin/bash
# Create multisig transaction
# Usage: ./create_transaction.sh <amount> <address>

AMOUNT=$1
ADDRESS=$2
echo "Creating transaction for $AMOUNT XMR to $ADDRESS"

monero-wallet-cli --testnet --wallet multisig.wallet transfer $AMOUNT $ADDRESS