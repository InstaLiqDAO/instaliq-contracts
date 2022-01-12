import { ethers } from 'hardhat';
import { getRandomWallet } from '../utils/mock-utils';

async function main() {
  const ilsContractFactory = await ethers.getContractFactory(
    'InitialLiquidityPool'
  );

  const initialLiquidityPool = await ilsContractFactory.deploy(
    'NewToken',
    'NTKN',
    1000,
    0,
    getRandomWallet().address,
    Date.now(),
    0,
    getRandomWallet().address
  );

  await initialLiquidityPool.deployed();

  console.log('InitialLiqudityPool deployed to:', initialLiquidityPool.address);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
