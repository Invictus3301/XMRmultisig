#!/bin/bash
# setup_multisig.sh
# Creates 2-of-3 multisig wallets for escrow
# Usage: ./setup_multisig.sh [testnet|mainnet]

NETWORK=${1:-testnet}
WALLETS=("buyer" "seller" "escrow")
MULTISIG_INFO_FILES=()

# Check for monero-wallet-cli
if ! command -v monero-wallet-cli &> /dev/null; then
  echo "Error: monero-wallet-cli not found. Install Monero CLI tools first."
  exit 1
fi

echo "Initializing 2-of-3 multisig wallets ($NETWORK)"
echo "This will create 3 wallets and generate multisig address"
echo "--------------------------------------------------------"

# Create base wallets and collect multisig info
for role in "${WALLETS[@]}"; do
  echo "Creating $role wallet..."
  monero-wallet-cli --$NETWORK --generate-new-wallet "$role" --password "" --command "exit" > /dev/null
  
  echo "Preparing $role multisig info..."
  INFO_FILE="${role}_multisig_info"
  monero-wallet-cli --$NETWORK --wallet "$role" --password "" \
    --command "prepare_multisig" | grep "Multisig" > "$INFO_FILE"
  
  MULTISIG_INFO_FILES+=("$INFO_FILE")
  echo "Generated $INFO_FILE"
done

# Combine multisig info
COMBINED_INFO="multisig_combined.info"
cat "${MULTISIG_INFO_FILES[@]}" > "$COMBINED_INFO"

# Create final multisig wallets
for role in "${WALLETS[@]}"; do
  echo "Making multisig wallet for $role..."
  monero-wallet-cli --$NETWORK --wallet "$role" --password "" \
    --command "make_multisig \"$COMBINED_INFO\" 2" > /dev/null
done

# Finalize multisig
echo "Finalizing multisig address..."
FINAL_INFO="multisig_final.info"
monero-wallet-cli --$NETWORK --wallet "${WALLETS[0]}" --password "" \
  --command "finalize_multisig \"$FINAL_INFO\"" > /dev/null

# Get multisig address
ADDRESS=$(monero-wallet-cli --$NETWORK --wallet "${WALLETS[0]}" --password "" \
  --command "address" | grep "Primary address" | awk '{print $3}')

echo "--------------------------------------------------------"
echo "Multisig setup complete!"
echo "Shared address: $ADDRESS"
echo "--------------------------------------------------------"
echo "Distribute these files to participants:"
echo "- buyer: buyer.keys, buyer_multisig_info"
echo "- seller: seller.keys, seller_multisig_info"
echo "- escrow: escrow.keys, escrow_multisig_info"
echo "--------------------------------------------------------"