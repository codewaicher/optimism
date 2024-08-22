#!/bin/bash

set -eu

# Run this with workdir set as root of the repo
if [ -f "versions.json" ]; then
    echo "Running create-chains script."
else
    echo "Cannot run create-chains script, must be in root of repository, but currently in:"
    echo "$(pwd)"
    exit 1
fi

# Check if already created
if [ -d ".devnet-interop" ]; then
    echo "Already created chains."
    exit 1
else
    echo "Creating new interop devnet chain configs"
fi

mkdir ".devnet-interop"

export CONTRACTS_ARTIFACTS_DIR="../packages/contracts-bedrock"

cd "../.devnet-interop/"

# OTOD: config interop genesis CLI
go run ../op-node interop --todo

# create L1 CL genesis
eth2-testnet-genesis deneb \
  --config=./beacon-data/config.yaml \
  --preset-phase0=minimal \
  --preset-altair=minimal \
  --preset-bellatrix=minimal \
  --preset-capella=minimal \
  --preset-deneb=minimal \
  --eth1-config=../.devnet-interop/out/l1/genesis.json \
  --state-output=../.devnet-interop/out/l1/beaconstate.ssz \
  --tranches-dir=../.devnet-interop/out/l1/tranches \
  --mnemonics=mnemonics.yaml \
  --eth1-withdrawal-address=0xaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa \
  --eth1-match-genesis-time
