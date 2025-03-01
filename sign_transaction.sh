#!/bin/bash
# Sign transaction
# Usage: ./sign_transaction.sh <transaction_file>

TX_FILE=$1
echo "Signing transaction $TX_FILE"

monero-wallet-cli --testnet --wallet multisig.wallet sign $TX_FILE