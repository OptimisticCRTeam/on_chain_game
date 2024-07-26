require("@nomicfoundation/hardhat-toolbox");
const dotenv = require('dotenv');
dotenv.config();

const {OP_SEPOLIA_ALCHEMY_RPC, WALLET_PRIVATE_KEY, ETHERSCAN_API_KEY} = process.env

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.26",
  networks: {
    optimismSepolia: {
      url: `https://opt-sepolia.g.alchemy.com/v2/${OP_SEPOLIA_ALCHEMY_RPC}`,
      accounts: [WALLET_PRIVATE_KEY],
    },
  },
  etherscan: {
    apiKey: {
      optimismSepolia: ETHERSCAN_API_KEY,
    },
    customChains: [
      {
        network: "optimismSepolia",
        chainId: 11155420,
        urls: {
          apiURL: "https://api-sepolia-optimistic.etherscan.io/api",
          browserURL: "https://api-sepolia-optimistic.etherscan.io/"
        }
    },
  ]
  }
};
