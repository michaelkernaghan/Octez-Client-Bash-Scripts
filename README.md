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
Stakers
The balance of tz1fWL6BuqXBPwtgce2qZQw3uEhGqvcZh84Y is 11994.997956 ꜩ.
The balance of tz1TrsUtPaKFYwnNzxavGaSnsH72TNJBfm42 is 17995.997956 ꜩ.
The balance of tz1cuCWeqsozFncacrT3oUqrD9fAtGcqDFiD is 17995.997956 ꜩ.

Current cycle is 17

Baker Delegation
{
  "full_balance": "124024997346",
  "current_frozen_deposits": "11001000000",
  "frozen_deposits": "0",
  "staking_balance": "172011991214",
  "delegated_contracts": [
    "tz1hyVeFrkoDG1eFTaQZoYKC93hGUdRVes4D",
    "tz1fWL6BuqXBPwtgce2qZQw3uEhGqvcZh84Y",
    "tz1cuCWeqsozFncacrT3oUqrD9fAtGcqDFiD",
    "tz1TrsUtPaKFYwnNzxavGaSnsH72TNJBfm42"
  ],
  "delegated_balance": "47986993868",
  "deactivated": false,
  "grace_period": 21,
  "voting_power": "91506498019",
  "remaining_proposals": 20,
  "active_consensus_key": "tz1hyVeFrkoDG1eFTaQZoYKC93hGUdRVes4D"
}
Pending Staking Parameters
[
  {
    "cycle": 20,
    "parameters": {
      "limit_of_staking_over_baking_millionth": 5000000,
      "edge_of_baking_over_staking_billionth": 1000000000
    }
  }
]
```

## Contributing

Contributions are always welcome! If you have any suggestions, bug reports, or feature requests, please open an issue or submit a pull request.

## License

These scripts are released under the MIT License.

## Giggles

![adaptive_issuance__1__720](https://github.com/michaelkernaghan/Octez-Client-Bash-Scripts/assets/78441942/07567b03-d706-4068-9c79-8f236f760f4f)
