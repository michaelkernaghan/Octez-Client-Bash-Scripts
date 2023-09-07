# Octez-Client-Bash-Scripts

This repository contains a collection of Bash scripts for managing and interacting with a local Tezos baker running the Octez 18.1 with the Oxford protocol.

## Prerequisites

Before running these scripts, make sure you have the following:

- A local Tezos baker is running Octez 18.1 with the Oxford protocol.
- A baker address and three staker addresses were created.
- Oxford Tez acquired for transactions.

## Running the Scripts

Follow these steps to run the scripts:

1. Clone this repository to your local machine.
2. Navigate to the project root directory using the command line.
3. Edit the addresses in the script to use your stakers and baker
4. Make the desired script executable by running `chmod +x <script>.sh`, replacing `<script>.sh` with the script name you want to run.
5. Run the script with `./<script>.sh`, again replacing `<script>.sh` with the name of the script.

Please note that these scripts assume that the `octez-client` and `octez-admin-client` commands are available in your PATH. If you encounter any issues, please make sure these commands are correctly installed and set on your system.

## Example output

```bash
Cycle:22 Level:182987
Levels to next cycle: 5430
Minutes to next cycle: 724

tz1XDL5EuVrKXxa6bawcA7oRfLBgvH2uWtWi
Liquid balance: 7007.997155 ꜩ.
Staked balance: 31905.889907 ꜩ.
Full balance :  38913.887062 ꜩ.

tz1iwkGcTgtvLNe2p1hgZDjT44AEnqVECx9h
Liquid balance: 4004.997695 ꜩ.
Staked balance: 31905.889907 ꜩ.
Full balance :  35910.887602 ꜩ.

tz1QZZHTf8icGPUwiTCNd6n7zeAK8ZoU4QQo
Liquid balance: 4005.933173 ꜩ.
Staked balance: 31905.889907 ꜩ.
Full balance :  35911.82308 ꜩ.

Baker: tz1hyVeFrkoDG1eFTaQZoYKC93hGUdRVes4D
Liquid balance: 224361.708437 ꜩ.
Staked balance: 27745.628258 ꜩ.
Full balance :  252107.336695 ꜩ.

Baker Data
{
  "full_balance": "252107336695",
  "current_frozen_deposits": "123463297981",
  "frozen_deposits": "11001000000",
  "staking_balance": "440800919551",
  "delegated_contracts": [
    "tz1iwkGcTgtvLNe2p1hgZDjT44AEnqVECx9h",
    "tz1hyVeFrkoDG1eFTaQZoYKC93hGUdRVes4D",
    "tz1fWL6BuqXBPwtgce2qZQw3uEhGqvcZh84Y",
    "tz1cuCWeqsozFncacrT3oUqrD9fAtGcqDFiD",
    "tz1XDL5EuVrKXxa6bawcA7oRfLBgvH2uWtWi",
    "tz1TrsUtPaKFYwnNzxavGaSnsH72TNJBfm42",
    "tz1QZZHTf8icGPUwiTCNd6n7zeAK8ZoU4QQo",
    "tz1KuUjXyFppuhyx4MZJkedZt75Gqw57tY8c"
  ],
  "delegated_balance": "188693582856",
  "deactivated": false,
  "grace_period": 26,
  "voting_power": "280528500013",
  "remaining_proposals": 20,
  "active_consensus_key": "tz1hyVeFrkoDG1eFTaQZoYKC93hGUdRVes4D"
}

Active Staking Parameters
{
  "limit_of_staking_over_baking_millionth": 5000000,
  "edge_of_baking_over_staking_billionth": 150000000
}
```

## Contributing

Contributions are always welcome! If you have any suggestions, bug reports, or feature requests, please open an issue or submit a pull request.

## License

These scripts are released under the MIT License.

## Giggles

![adaptive_issuance__1__720](https://github.com/michaelkernaghan/Octez-Client-Bash-Scripts/assets/78441942/07567b03-d706-4068-9c79-8f236f760f4f)
