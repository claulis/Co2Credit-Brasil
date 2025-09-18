const { ethers } = require("hardhat");

async function main() {
  const CarbonCreditNFT = await ethers.getContractFactory("CarbonCreditNFT");
  const contract = await CarbonCreditNFT.deploy();

  await contract.waitForDeployment();

  console.log("✅ Contrato implantado em:", await contract.getAddress());
}

main().catch(console.error);
