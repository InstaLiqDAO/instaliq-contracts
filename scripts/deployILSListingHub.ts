import { ethers } from 'hardhat';

async function main() {
  const ilsContractFactory = await ethers.getContractFactory(
    'ILSListingHub'
  );

  const ilsListingHub = await ilsContractFactory.deploy(
    '0x39B3AA2693C12dA383ABa6A6e404f1383a914f0e'
  );

  await ilsListingHub.deployed();

  console.log('ILSListingHub deployed to:', ilsListingHub.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
