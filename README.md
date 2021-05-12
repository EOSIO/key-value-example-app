# Key Value Example App

Key Value Example App lets developers start using the new key value database feature with EOSIO and eosjs in a matter of minutes. We built this example application with ease of use and simplicity in mind. It can be used by new and advanced developers to try out the new feature. We hope you will find this example application insightful and welcome feedback on future improvements. There are two methods for running the example application at this time.  It can be run locally on your development environment or run with Gitpod.io, a development environment in the cloud.

### Gitpod

Powered by Gitpod.io and Docker, it provides developers with a personal single-node EOSIO blockchain for development and testing purposes without a need of going through advanced local environment setup. It also includes a simple example application with a concise smart contract and web frontend, connected to the blockchain. Developers can also use EOSIO tools like cleos and eosio.cdt straight out of the box. This Gitpod option requires zero installation on the user's machine. All code is stored and managed on the developer's personal GitHub account, with the changes saved automatically.

1. Fork this repo to your personal GitHub account so that you can save your work into your personal Github account.

2. Point your browser to the following URL https://gitpod.io/#https://github.com/your-github-account/key-value-example-app to start the IDE. You will be automatically prompted to create a Gitpod account (all types of Gitpod accounts (including free) will work). You can also choose to provide multiple developers push access to your personal github fork of this repo to collaborate with them (one developer working on the smart contract (C++) while the other working on the front-end decentralized application (EOSJS), etc.). Each such developer sharing access to the forked repo will get their own copy of the EOSIO blockchain components to enable independent development.

Upon launching the IDE, the nodeos and webpack processes will start the chain and webapp respectively and you view and change the todo application that the smart contract manages. You can test drive the system by accessing the IDE at https://gitpod.io/#https://github.com/EOSIO/key-value-example-app (however you will not be able to save your work into the EOSIO/key-value-example-app Github repository).

### Local Development Environment

To add more control over the codebase and allow for local development, the example application can also be run locally. However, this example application requires some software to be installed locally to operate correctly in the local environment.

1. Docker for the blockchain instance (https://www.docker.com/)
2. Node.js and either NPM/Yarn for the web frontend (https://nodejs.org/en/ & https://yarnpkg.com/)
3. eosio.cdt to build the contract (https://github.com/EOSIO/eosio.cdt)
4. (Optionally) cmake to build the contract (https://cmake.org/)

Once the required software is installed, setting up and running the example application is quick and easy with a few npm/yarn commands run from the repository's root directory:

1. Run `npm install` or `yarn` to install dependencies
2. Run `npm run serve` or `yarn run serve` to start the web frontend
3. Run `npm run docker-run` or `yarn run docker-run` to start the blockchain in a non-persistent state docker process ***OR...***
4. Run `npm run docker-persistent` or `yarn run docker-persistent` to start the blockchain in a persistent state docker process

## Smart Contract

The example application has the simple smart contract located in `contracts`.  This version is already set on the chain and is available after the chain initializes.

### Building the contract

If you would like, this contract can be changed and re-built using Gitpod or vscode "Run Build Task" command which will give you the option to either build with eosio-cpp or cmake (requires cmake to be installed).  Additionally, it can be run manually using either of the following options run from the repository's root directory:

```shell
eosio-cpp -abigen ./contracts/kv_todo/src/kv_todo.cpp -o ./contracts/kv_todo/build/kv_todo.wasm -R ./contracts/kv_todo/ricardian/ -I ./contracts/kv_todo/include/
```

```shell
cd ./contracts/kv_todo/build
cmake ..
make
```

Running any of these options will produce `kv_todo.abi` and `kv_todo.wasm` files inside the contract's build directory.

### Installing the contract

To set the contract onto the chain, you will need to run these two commands to update the abi and code.  Depending on how you built the contract, the `{path to file}` will need to be adjusted.

```
cleos set abi todo {path to file}/kv_todo.abi -p todo@active -p eosio@active
cleos set code todo {path to file}/kv_todo.wasm -p todo@active -p eosio@active
```

## Viewing the front-end decentralized web app:

The source code for the React WebApp can be found within the `src` folder. To preview the WebApp in Gitpod, run this in a terminal:

```
gp preview $(gp url 8000)
```

To run and view the WebApp in a local development environment, run either `npm run serve` or `yarn run serve` in a terminal and access the example by navigating to http://localhost:8080

## Resetting the chain

To remove the existing chain in Gitpod and create another:

* Switch to the terminal running `nodeos`
* Press `ctrl+c` to stop it
* Run the following

```
rm -rf ~/eosio/chain
nodeos --config-dir ~/eosio/chain/config --data-dir ~/eosio/chain/data -e -p eosio --plugin eosio::chain_api_plugin
```

In a local development environment setup, stop the currently running docker instance and then simply run the `npm run docker-run` or `yarn run docker-run` command to clear the docker volume containing the chain.  If you were running in a persistent state, you can then terminate the docker process again and run the persistent docker script.

## Contributing

[Contributing Guide](./CONTRIBUTING.md)

[Code of Conduct](./CONTRIBUTING.md#conduct)

## License

[MIT](./LICENSE)

## Important

See [LICENSE](./LICENSE) for copyright and license terms.

All repositories and other materials are provided subject to the terms of this [IMPORTANT](./IMPORTANT.md) notice and you must familiarize yourself with its terms.  The notice contains important information, limitations and restrictions relating to our software, publications, trademarks, third-party resources, and forward-looking statements.  By accessing any of our repositories and other materials, you accept and agree to the terms of the notice.
