import { ethers } from 'hardhat';
import { getRandomWallet } from '../utils/mock-utils';

async function main() {
  const standardTokenContractFactory = await ethers.getContractFactory(
    'StandardToken'
  );

  const standardToken = await standardTokenContractFactory.deploy(
    'NewToken',
    'NTKN',
    18,
    getRandomWallet().address
  );

  await standardToken.deployed();

  console.log('StandardToken deployed to:', standardToken.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
