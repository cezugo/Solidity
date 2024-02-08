
import "hardhat-deploy";
import { HardhatUserConfig } from "hardhat/config";
import fs from "fs";
import { ethers } from "ethers";
import "@nomicfoundation/hardhat-verify";
import "@nomicfoundation/hardhat-toolbox";
import '@openzeppelin/hardhat-upgrades';
import { todo } from "node:test";


require("dotenv").config();
//require('@nomiclabs/hardhat-etherscan');


const privateKey = fs.readFileSync(".secret").toString().trim();
const { POLYGONSCAN_API_KEY, INFURA_POLYGON_MUMBAI_URL, INFURA_POLYGON_MAINNET_URL } = process.env;


let config: HardhatUserConfig = {
  sourcify: {
    enabled: true
  },
  paths: {
    tests: "test",
    deployments: "deployments",
  },

  etherscan: {
    apiKey: {
      polygon: "SZUSCVKPNETQ6DPDB96R4S31VZ1PG668BA",
      polygonMumbai: "SZUSCVKPNETQ6DPDB96R4S31VZ1PG668BA"
    }
  },

  networks: {
    //   hardhat: {
    //     accounts: {
    //       count: 20,
    //     },
    //},
    mumbai: {
      url: INFURA_POLYGON_MUMBAI_URL,
      chainId: 80001,
      accounts: [privateKey],
      //gasPrice: Number(ethers.parseUnits("100", "gwei")), // 100 gwei
    },
    polygon: {
      url: INFURA_POLYGON_MAINNET_URL,
      chainId: 137, // Polygon Mainnet chainId
      accounts: [privateKey],
      //gasPrice: Number(ethers.parseUnits("100", "gwei")), // 100 gwei
    },

  },

  namedAccounts: {
    deployer: {
      default: 0,
    },
    // other named accounts
  },
  solidity: {
    compilers: [
      {
        version: "0.8.23",
        settings: {
          optimizer: {
            enabled: true,
            runs: 2000,
          },
          //viaIR: true,
        },
      },
    ],
  },
};

if (POLYGONSCAN_API_KEY && POLYGONSCAN_API_KEY.length > 0) {
  if (config.networks && config.networks.mumbai) {
    config.networks.mumbai = {
      ...config.networks.mumbai,
      accounts: [privateKey],
    };
  }
  if (config.networks && config.networks.polygon) {
    config.networks.polygon = {
      ...config.networks.polygon,
      accounts: [privateKey],
    };
  }
}

export default config;
