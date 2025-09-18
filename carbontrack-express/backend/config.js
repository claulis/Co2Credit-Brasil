require('dotenv').config();

const { ethers } = require("ethers");

const CONTRACT_ADDRESS = process.env.CONTRACT_ADDRESS;
const CONTRACT_ABI = require('../artifacts/contracts/CarbonCreditNFT.sol/CarbonCreditNFT.json').abi;

const provider = new ethers.JsonRpcProvider(process.env.POLYGON_MUMBAI_RPC);
const wallet = new ethers.Wallet(process.env.PRIVATE_KEY, provider);

const contract = new ethers.Contract(CONTRACT_ADDRESS, CONTRACT_ABI, wallet);

module.exports = {
  provider,
  wallet,
  contract,
  CONTRACT_ADDRESS,
  CONTRACT_ABI
};
