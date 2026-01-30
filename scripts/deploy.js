const hre = require("hardhat");

async function main() {
  console.log("Deploying ChainMosaic...");

  const ChainMosaic = await hre.ethers.getContractFactory("ChainMosaic");
  const contract = await ChainMosaic.deploy();

  await contract.waitForDeployment();

  console.log(`✅ ChainMosaic deployed at: ${await contract.getAddress()}`);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
