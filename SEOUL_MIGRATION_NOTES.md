# Seoul Protocol Migration Notes

This document outlines the changes made to update the Octez Client Bash Scripts from Oxford protocol to Seoul protocol compatibility.

## Key Changes in Seoul Protocol

### 1. Timing Changes (Paris → Seoul)
- **Block time**: Reduced from 15 seconds to 10 seconds
- **Blocks per cycle**: Increased from 8192 to 24576 blocks
- **Total cycle time**: Remains approximately the same (~2 days, 20 hours)

### 2. Terminology Updates  
- "Endorsement" operations are now called "Attestation" operations
- Protocol-specific executables no longer include version numbers

### 3. New Features Available in Seoul
- **Native Multisig Accounts**: Built-in multisig functionality at the protocol level
- **Enhanced Staking**: Improved staking mechanisms with better delegation controls
- **Adaptive Issuance**: Dynamic inflation adjustments based on network participation

## Scripts Updated

### Core Scripts
- `common.sh`: Updated with Seoul protocol constants and helper functions
- `time-to-next-cycle.sh`: Updated timing calculations for 10s blocks and 24576 blocks/cycle
- `adaptive_issuance.sh`: Already compatible with Seoul adaptive issuance features

### New Scripts Added
- `unstake-workflow.sh`: Comprehensive unstaking workflow based on tezos-unstake documentation
- `native-multisig.sh`: Native multisig account management utilities

### Path Updates
All scripts have been updated to remove hardcoded paths:
- Removed `/home/mike/tezos/octez-client` references
- Now uses `octez-client` and `octez-admin-client` from PATH
- Added checks to ensure tools are available before execution

## Configuration Updates

### In `common.sh`:
- Added Seoul protocol constants:
  - `BLOCK_TIME_SECONDS=10`
  - `BLOCKS_PER_CYCLE=24576`
- Added utility functions:
  - `check_octez_client()`
  - `check_octez_admin_client()`
  - `get_current_cycle_info()`

## Migration Checklist

### Pre-Migration
- [ ] Backup existing baker configuration
- [ ] Ensure Octez is updated to Seoul-compatible version
- [ ] Update address configurations in `common.sh`

### Post-Migration  
- [ ] Test all scripts with new protocol
- [ ] Verify timing calculations are accurate
- [ ] Check staking operations work correctly
- [ ] Test native multisig functionality (if used)

## Breaking Changes

### 1. Executable Names
Old format: `octez-baker-018-PtOxford`
New format: `octez-baker-PtSeoulsh` (no version number)

### 2. RPC Responses
Some RPC responses may have different field names or structures due to attestation terminology changes.

### 3. Timing Assumptions
Any external scripts or monitoring that assumed 15-second blocks need updating for 10-second blocks.

## New Capabilities

### Native Multisig
Seoul protocol introduces native multisig accounts that can be created and managed entirely through the protocol:

```bash
# Create a 2-of-3 multisig
octez-client originate multisig contract --threshold 2 \
  --public-key <pubkey1> \
  --public-key <pubkey2> \
  --public-key <pubkey3>
```

### Enhanced Staking Commands
New staking commands are available:
- `octez-client stake <amount> for <delegate>`
- `octez-client unstake <amount> for <delegate>`
- `octez-client finalize unstake for <delegate>`
- `octez-client get staked balance for <address>`
- `octez-client get full balance for <address>`

## Testing

After migration, test the following:
1. Basic balance queries
2. Staking operations
3. Timing calculations in `time-to-next-cycle.sh`
4. Baker data retrieval in `adaptive_issuance.sh`
5. Native multisig operations (if applicable)

## Troubleshooting

### Common Issues
1. **Command not found**: Ensure octez binaries are in PATH
2. **Timing discrepancies**: Verify block time assumptions in monitoring
3. **RPC errors**: Check if RPC endpoints have changed between protocols

### Compatibility
These scripts are designed to work with:
- Seoul protocol (current)
- Compatible Octez versions (v21.0+)
- Both mainnet and testnet configurations

## Resources

- [Octez Documentation](https://octez.tezos.com/)
- [Seoul Protocol Changes](https://tezos.gitlab.io/protocols/021_seoul.html)
- [Adaptive Issuance Documentation](https://tezos.gitlab.io/protocols/021_seoul.html#adaptive-issuance)
- [Native Multisig Documentation](https://tezos.gitlab.io/protocols/021_seoul.html#native-multisig-accounts)