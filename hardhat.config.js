/** @type import('hardhat/config').HardhatUserConfig */

require("dotenv").config();
require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");

module.exports = {
  solidity: {
    compilers: [
      { version: "0.8.17" },
    ]
  },
  networks: {
   /* goerli: {
      url: `https://eth-goerli.alchemyapi.io/v2/${process.env.ALCHEMY_API_KEY}`,
      accounts: [process.env.USER1_PRIVATE_KEY,],
    },
    mainnet: {
      url: `https://eth-mainnet.alchemyapi.io/v2/${process.env.ALCHEMY_API_KEY}`,
      accounts: [process.env.USER1_PRIVATE_KEY,],
    },
    local: {
      url: `http://127.0.0.1:8545`,
      accounts: [process.env.USER1_PRIVATE_KEY,],
    },*/
    nebulastaging: {
      url: `https://staging-v3.skalenodes.com/v1/staging-faint-slimy-achird`,
      accounts: [process.env.PRIVATE_KEY,],
    },
  },
  etherscan: {
    nebulastaging: process.env.ETHERSCAN_API_KEY,
  },


  etherscan: {
    apiKey: {
      nebulastaging: "W5WJQK111XVR9RQMQUIMZCCCAUWZ9GFIXS"
    },
    customChains: [
      {
        network: "nebulastaging",
        chainId: 503129905,
        urls: {
        apiURL: "https://staging-faint-slimy-achird.explorer.staging-v3.skalenodes.com/api",
        browserURL: "https://staging-faint-slimy-achird.explorer.staging-v3.skalenodes.com/"
        }
      }
    ]
  },
  mocha: {
    timeout: 100000000
  },
};