# Multisig Escrow Guide

## Workflow
1. Buyer initiates transaction to multisig address
2. Funds are locked in 2-of-3 multisig
3. Either:
   - Buyer + Seller release funds (successful transaction)
   - Buyer + Escrow release funds (buyer dispute)
   - Seller + Escrow release funds (seller dispute)

## Key Exchange Process
1. Each participant generates wallet
2. Exchange multisig keys securely
3. Finalize multisig address

## Transaction Process
1. Create unsigned transaction
2. First signature
3. Second signature
4. Broadcast transaction