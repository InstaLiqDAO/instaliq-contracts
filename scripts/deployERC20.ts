import { ethers } from "hardhat";

async function main() {
  const erc20ContractFactory = await ethers.getContractFactory("ERC20");
  const erc20Contract = await erc20ContractFactory.deploy("NewToken", "NTKN");

  await erc20Contract.deployed();

  console.log("ERC20 deployed to:", erc20Contract.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
