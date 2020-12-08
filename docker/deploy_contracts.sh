#!/usr/bin/env bash
NODEOS_RUNNING=$1
RUNNING_IN_GITPOD=$2

set -m

# CAUTION: Never use these development keys for a production account!
# Doing so will most certainly result in the loss of access to your account, these private keys are publicly known.
SYSTEM_ACCOUNT_PRIVATE_KEY="5KQwrPbwdL6PhXujxW37FSSQZ1JiwsST4cqQzDeyXtP79zkvFD3"
SYSTEM_ACCOUNT_PUBLIC_KEY="EOS6MRyAjQq8ud7hVNYcfnVPJqcVpscN5So8BhtHuGYqET5GDW5CV"

if [ -z "$RUNNING_IN_GITPOD" ]; then
  echo "Running locally..."
  ROOT_DIR="/opt"
  CONTRACTS_DIR="$ROOT_DIR/eosio/bin/contracts"
  BLOCKCHAIN_DATA_DIR=/root/.local/share
  BLOCKCHAIN_CONFIG_DIR=/opt/eosio/bin/config-dir
  WALLET_DIR="/root/eosio-wallet"
else
  echo "Running in Gitpod..."
  export NODEOS_URL=$(gp url 8888)
  ROOT_DIR="/home/gitpod"
  CONTRACTS_DIR="/opt/eosio/bin/contracts"
  BLOCKCHAIN_DATA_DIR=$ROOT_DIR/eosio/chain/data
  BLOCKCHAIN_CONFIG_DIR=$ROOT_DIR/eosio/chain/config
  WALLET_DIR="$ROOT_DIR/eosio-wallet"
fi

mkdir -p $ROOT_DIR/bin

PATH="$PATH:$ROOT_DIR/bin:$ROOT_DIR/bin/scripts"
GITPOD_WORKSPACE_ROOT="/workspace/key-value-example-app"
CONFIG_DIR="$ROOT_DIR/bin/config-dir"

function post_preactivate {
  curl -X POST http://127.0.0.1:8888/v1/producer/schedule_protocol_feature_activations -d '{"protocol_features_to_activate": ["0ec7e080177b2c02b278d5088611686b49d739925a92d9bfcacd7fc6b74053bd"]}'
}

# $1 feature disgest to activate
function activate_feature {
  cleos push action eosio activate '["'"$1"'"]' -p eosio
  if [ $? -ne 0 ]; then
    exit 1
  fi
}

# $1 account name
# $2 contract directory
# $3 wasm file name
# $4 abi file name
function setcode {
  retry_count="4"

  while [ $retry_count -gt 0 ]; do
    cleos set code $1 $2 -p $1@active
    if [ $? -eq 0 ]; then
      break
    fi

    echo "setcode failed retrying..."
    sleep 1s
    retry_count=$[$retry_count-1]
  done

  if [ $retry_count -eq 0 ]; then
    echo "setcode failed too many times, bailing."
    exit 1
  fi
}

# $1 account name
# $2 contract directory
# $3 abi file name
function setabi {
  retry_count="4"

  while [ $retry_count -gt 0 ]; do
    cleos set abi $1 $2 -p $1@active
    if [ $? -eq 0 ]; then
      break
    fi

    echo "setcode failed retrying..."
    sleep 1s
    retry_count=$[$retry_count-1]
  done

  if [ $retry_count -eq 0 ]; then
    echo "setcode failed too many times, bailing."
    exit 1
  fi
}

# Move into the executable directory
cd $ROOT_DIR/bin/
mkdir -p $CONFIG_DIR
mkdir -p $BLOCKCHAIN_DATA_DIR
mkdir -p $BLOCKCHAIN_CONFIG_DIR

function start_wallet {
  echo "Starting the wallet"
  rm -rf $WALLET_DIR
  mkdir -p $WALLET_DIR
  nohup keosd --unlock-timeout 999999999 --wallet-dir $WALLET_DIR --http-server-address 127.0.0.1:8900 2>&1 &
  sleep 1s
  wallet_password=$(cleos wallet create --to-console | awk 'FNR > 3 { print $1 }' | tr -d '"')
  echo $wallet_password > "$CONFIG_DIR"/keys/default_wallet_password.txt

  cleos wallet import --private-key $SYSTEM_ACCOUNT_PRIVATE_KEY
}

if [ -z "$NODEOS_RUNNING" ]; then
  echo "Starting the chain for setup"
  nodeos -e -p eosio \
  --data-dir $BLOCKCHAIN_DATA_DIR \
  --config-dir $BLOCKCHAIN_CONFIG_DIR \
  --http-validate-host=false \
  --plugin eosio::producer_api_plugin \
  --plugin eosio::chain_api_plugin \
  --plugin eosio::http_plugin \
  --http-server-address=0.0.0.0:8888 \
  --access-control-allow-origin=* \
  --contracts-console \
  --max-transaction-time=100000 \
  --verbose-http-errors &
fi

mkdir -p "$CONFIG_DIR"/keys

sleep 1s

echo "Waiting for the chain to finish startup"
until curl localhost:8888/v1/chain/get_info
do
  echo "Still waiting"
  sleep 1s
done

# Sleep for 2s to allow time for 4 blocks to be created so we have blocks to reference when sending transactions
sleep 2s
echo "Creating accounts and deploying contracts"

sleep 1s
start_wallet
cleos create account eosio todo $SYSTEM_ACCOUNT_PUBLIC_KEY

# preactivate concensus upgrades
post_preactivate

sleep 1s
setabi eosio $CONTRACTS_DIR/eosio.boot/eosio.boot.abi
setcode eosio $CONTRACTS_DIR/eosio.boot/eosio.boot.wasm

sleep 1s
activate_feature "299dcb6af692324b899b39f16d5a530a33062804e41f09dc97e9f156b4476707"
activate_feature "825ee6288fb1373eab1b5187ec2f04f6eacb39cb3a97f356a07c91622dd61d16"
activate_feature "c3a6138c5061cf291310887c0b5c71fcaffeab90d5deb50d3b9e687cead45071"
activate_feature "4e7bf348da00a945489b2a681749eb56f5de00b900014e137ddae39f48f69d67"
activate_feature "f0af56d2c5a48d60a4a5b5c903edfb7db3a736a94ed589d0b797df33ff9d3e1d"
activate_feature "2652f5f96006294109b3dd0bbde63693f55324af452b799ee137a81a905eed25"
activate_feature "8ba52fe7a3956c5cd3a656a3174b931d3bb2abb45578befc59f283ecd816a405"
activate_feature "ad9e3d8f650687709fd68f4b90b41f7d825a365b02c23a636cef88ac2ac00c43"
activate_feature "68dcaa34c0517d19666e6b33add67351d8c5f69e999ca1e37931bc410a297428"
activate_feature "e0fb64b1085cc5538970158d05a009c24e276fb94e1a0bf6a528b48fbc4ff526"
activate_feature "ef43112c6543b88db2283a2e077278c315ae2c84719a8b25f25cc88565fbea99"
activate_feature "4a90c00d55454dc5b059055ca213579c6ea856967712a56017487886a4d4cc0f"
activate_feature "1a99a59d87e06e09ec5b028a9cbb7749b4a5ad8819004365d02dc4379a8b7241"
activate_feature "bf61537fd21c61a60e542a5d66c3f6a78da0589336868307f94a82bccea84e88"
activate_feature "5443fcf88330c586bc0e5f3dee10e7f63c76c00249c87fe4fbf7f38c082006b4"

sleep 1s
setabi eosio $CONTRACTS_DIR/eosio.bios/eosio.bios.abi
setcode eosio $CONTRACTS_DIR/eosio.bios/eosio.bios.wasm

sleep 1s
cleos push action eosio setkvparams '[{"max_key_size":1024, "max_value_size":4096, "max_iterators":1024}]' -p eosio@active
cleos push action eosio setpparams '["01110000400100000000"]' -p eosio@active

sleep 1s
setabi todo $CONTRACTS_DIR/kv_todo/kv_todo.abi
setcode todo $CONTRACTS_DIR/kv_todo/kv_todo.wasm

sleep 1s
cleos push action todo upsert '["bf581bee-9f2c-447b-94ad-78e4984b6f51", "todo", "Write Hello World Contract", false]' -p todo@active
sleep 1s
cleos push action todo upsert '["b7b0d09d-a82b-44d9-b067-3bae2d02917e", "todo", "Start Blockchain", false]' -p todo@active
sleep 1s
cleos push action todo upsert '["ac8acfe7-cd4e-4d22-8400-218b697a4517", "todo", "Deploy Hello World Contract", false]' -p todo@active

echo "All done initializing the blockchain"

# If running in Gitpod, we *don't* want to shutdown the blockchain; we'll leave it running in the terminal window.
if [ -z "$RUNNING_IN_GITPOD" ]; then
  if [[ -z $NODEOS_RUNNING ]]; then
    echo "Shut down Nodeos, sleeping for 2 seconds to allow time for at least 4 blocks to be created after deploying contracts"
    sleep 2s
    kill %1
    fg %1
  fi
fi
