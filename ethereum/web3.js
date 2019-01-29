import Web3 from "web3";
const HDWalletProvider = require("truffle-hdwallet-provider");

let web3;

if (typeof window !== "undefined" && typeof window.web3 !== "undefined") {
  web3 = new Web3(window.web3.currentProvider);
} else {
  const provider = new Web3.providers.HttpProvider(
    "https://rinkeby.infura.io/v3/c38093a8292d46fd9b80eb285f63ab93"
  );
  web3 = new Web3(provider);
}

export default web3;
