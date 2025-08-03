# Octez-Client-Bash-Scripts

A comprehensive collection of Bash scripts for managing and interacting with Tezos baking operations using Octez client tools. **Fully compatible with Seoul protocol** featuring 10-second blocks, enhanced staking mechanisms, and native multisig support.

## 🚀 Features

- **Seoul Protocol Compatible**: Updated for 10s blocks (24,576 blocks/cycle)
- **Enhanced Staking**: Full support for Seoul's improved staking operations
- **Native Multisig**: Built-in multisig account management
- **Adaptive Issuance**: Comprehensive monitoring and analysis tools
- **Interactive Workflows**: Menu-driven scripts for complex operations
- **Automated Testing**: Compatibility verification tools

## 📋 Prerequisites

Before running these scripts, ensure you have:

- **Octez**: Latest version with Seoul protocol support
- **Network Access**: Connection to Tezos mainnet or testnet
- **Addresses**: Baker address and staker addresses configured
- **Permissions**: Ability to execute bash scripts
- **Dependencies**: `jq`, `bc` for JSON processing and calculations

### Installation Check
```bash
# Verify Octez installation
octez-client --version
octez-admin-client --version

# Check network connectivity
octez-client rpc get /chains/main/blocks/head/helpers/current_level
```

## 📁 Script Overview

### Core Scripts
- **`adaptive_issuance.sh`** - Comprehensive adaptive issuance monitoring and analysis
- **`time-to-next-cycle.sh`** - Cycle timing calculations (Seoul 10s blocks)
- **`stake.sh`** - Stake tez to addresses
- **`balances.sh`** - Check account balances
- **`transfer.sh`** - Transfer operations

### Seoul Protocol Features
- **`unstake-workflow.sh`** - Interactive unstaking workflow with validation
- **`native-multisig.sh`** - Native multisig account management
- **`test-compatibility.sh`** - Seoul protocol compatibility testing

### Baker Management
- **`baker-transactions.sh`** - Baker transaction history
- **`baker-stake.sh`** - Baker staking operations
- **`baker-data-diffs.sh`** - Baker data comparison
- **`staking-balance-histories.sh`** - Historical staking data

### Utility Scripts
- **`rewards.sh`** - Reward calculations
- **`staker-transactions.sh`** - Staker transaction monitoring
- **`common.sh`** - Shared configuration and functions

## 🔧 Setup & Configuration

### 1. Clone and Setup
```bash
git clone <repository-url>
cd Octez-Client-Bash-Scripts
chmod +x *.sh
```

### 2. Configure Addresses
Edit `common.sh` with your addresses:
```bash
# Update these with your actual addresses
baker_address="tz1your_baker_address_here"
staker_addresses=(
    "tz1your_staker_address_1"
    "tz1your_staker_address_2"  
    "tz1your_staker_address_3"
)
```

### 3. Test Compatibility
```bash
./test-compatibility.sh
```

### 4. Run Scripts
```bash
# Monitor adaptive issuance
./adaptive_issuance.sh

# Check cycle timing
./time-to-next-cycle.sh

# Interactive unstaking workflow
./unstake-workflow.sh

# Native multisig management  
./native-multisig.sh
```

## 💡 Seoul Protocol Features

### Native Multisig Accounts
Create and manage multisig accounts directly in the protocol:
```bash
./native-multisig.sh
# Interactive menu for:
# - Creating multisig accounts
# - Preparing transactions  
# - Collecting signatures
# - Executing transactions
```

### Enhanced Staking Operations
Seoul protocol provides improved staking with new commands:
```bash
# Check staking balances
octez-client get staked balance for <address>
octez-client get full balance for <address>

# Staking operations
octez-client stake <amount> for <delegate>
octez-client unstake <amount> for <delegate>  
octez-client finalize unstake for <delegate>
```

### Unstaking Workflow
Complete interactive unstaking process:
```bash
./unstake-workflow.sh
# Guided workflow including:
# - Setting staking limits
# - Unstaking procedures
# - Finalization timing
# - Fund transfers
```

## 📊 Example Output

### Adaptive Issuance Monitoring
```bash
$ ./adaptive_issuance.sh

Cycle:850 Level:20971520
Baker: tz1hyVeFrkoDG1eFTaQZoYKC93hGUdRVes4D
Liquid balance: 15000.50 ꜩ
Staked balance: 85000.75 ꜩ  
Full balance: 100001.25 ꜩ

Active Staking Parameters:
{
  "limit_of_staking_over_baking_millionth": 5000000,
  "edge_of_baking_over_staking_billionth": 150000000
}

Current Yearly Rate: 4.52%
Issuance Per Minute: 85.33 ꜩ
Total Frozen Stake: 875,432,100.50 ꜩ
```

### Cycle Timing (Seoul 10s Blocks)
```bash
$ ./time-to-next-cycle.sh

Cycle:850 Level:20971520
Levels done this cycle: 15360
Levels to next cycle: 9216
Minutes to next cycle: 1536  
Hours to next cycle: 25.6
```

## 🔧 Migration from Oxford

If upgrading from Oxford protocol, see `SEOUL_MIGRATION_NOTES.md` for:
- Timing calculation updates (15s → 10s blocks)
- New staking command syntax
- Native multisig migration
- Compatibility testing procedures

```bash
# Test Seoul compatibility
./test-compatibility.sh
```

## 🐛 Troubleshooting

### Common Issues

**Command not found errors:**
```bash
# Ensure Octez is in PATH
export PATH=$PATH:/path/to/octez/bin
# Or create symlinks
ln -s /path/to/octez-client /usr/local/bin/
```

**Connection errors:**
```bash
# Check node status
octez-client rpc get /chains/main/blocks/head/helpers/current_level

# Verify network connection
octez-client config show
```

**Timing calculation errors:**
- Scripts automatically use Seoul constants (10s blocks, 24576 blocks/cycle)
- If using custom network, update `BLOCK_TIME_SECONDS` and `BLOCKS_PER_CYCLE` in `common.sh`

**Permission denied:**
```bash
chmod +x *.sh
```

### Getting Help

1. **Test compatibility first**: `./test-compatibility.sh`
2. **Check configuration**: Review addresses in `common.sh`
3. **Verify network**: Ensure node is synced and accessible
4. **Read migration notes**: `SEOUL_MIGRATION_NOTES.md`

## 🤖 AI Assistant Prompt

Copy and paste this prompt into a **Claude Sonnet session** to get personalized help with this repository:

```
I'm working with the Octez-Client-Bash-Scripts repository, a comprehensive collection of Bash scripts for managing Tezos baking operations with Seoul protocol compatibility. 

**Repository Overview:**
- Seoul protocol compatible (10-second blocks, 24,576 blocks/cycle)
- Enhanced staking mechanisms and native multisig support
- Adaptive issuance monitoring and analysis tools
- Interactive workflows for complex operations

**Available Scripts:**
Core Scripts:
- adaptive_issuance.sh: Comprehensive adaptive issuance monitoring and analysis
- time-to-next-cycle.sh: Cycle timing calculations (Seoul 10s blocks)
- stake.sh: Stake tez to addresses
- balances.sh: Check account balances
- transfer.sh: Transfer operations

Seoul Protocol Features:
- unstake-workflow.sh: Interactive unstaking workflow with validation
- native-multisig.sh: Native multisig account management
- test-compatibility.sh: Seoul protocol compatibility testing

Baker Management:
- baker-transactions.sh: Baker transaction history
- baker-stake.sh: Baker staking operations
- baker-data-diffs.sh: Baker data comparison
- staking-balance-histories.sh: Historical staking data

Utility Scripts:
- rewards.sh: Reward calculations
- staker-transactions.sh: Staker transaction monitoring
- common.sh: Shared configuration and functions

**Key Features:**
- Seoul protocol timing (10s blocks vs Oxford's 15s blocks)
- Native multisig account creation and management
- Enhanced staking operations (stake, unstake, finalize unstake)
- Adaptive issuance monitoring with real-time calculations
- Interactive menu-driven workflows
- Automated compatibility testing

**Configuration:**
- Baker and staker addresses configured in common.sh
- Protocol constants: BLOCK_TIME_SECONDS=10, BLOCKS_PER_CYCLE=24576
- Requires octez-client and octez-admin-client in PATH
- Dependencies: jq, bc for JSON processing and calculations

Please help me with: [DESCRIBE YOUR SPECIFIC QUESTION OR TASK HERE]

Some examples of what I might need help with:
- Setting up and configuring the scripts for my baker
- Understanding Seoul protocol differences from Oxford
- Troubleshooting specific script errors
- Optimizing staking strategies using the tools
- Creating custom workflows combining multiple scripts
- Understanding the adaptive issuance data and calculations
- Setting up native multisig accounts
- Migrating from Oxford protocol configurations
```

**How to Use:**
1. **Open this repository in Cursor workspace** (essential for optimal assistance)
2. Copy the entire prompt above
3. Paste it into a new Claude Sonnet conversation in Cursor
4. Replace `[DESCRIBE YOUR SPECIFIC QUESTION OR TASK HERE]` with your actual question
5. Get personalized assistance tailored to this repository!

## 📚 Documentation

- **`SEOUL_MIGRATION_NOTES.md`** - Complete migration guide
- **`common.sh`** - Configuration and helper functions
- **Individual scripts** - Each contains usage examples in comments

## 🤝 Contributing

Contributions welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Test with `./test-compatibility.sh`
4. Submit a pull request

## 📄 License

MIT License - see LICENSE file for details.

## 🙏 Acknowledgments

- Tezos Foundation for the Octez client tools
- Seoul protocol development team
- Community contributors and testers

---
**Octez-Client-Bash-Scripts** - Making Tezos baking operations simple and efficient with Seoul protocol support.
