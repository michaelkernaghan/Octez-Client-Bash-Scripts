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

## Contributing

Contributions are always welcome! If you have any suggestions, bug reports, or feature requests, please open an issue or submit a pull request.

## License

These scripts are released under the MIT License.
