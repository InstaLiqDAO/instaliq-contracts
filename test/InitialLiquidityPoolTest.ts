import { ethers } from 'hardhat';
import { expect } from 'chai';
import { Contract, Signer } from 'ethers';

describe('InitialLiquidityPool', function () {
  let initialLiquidityPool: Contract;
  let referenceToken: Contract;
  let sushiswapRouter: Contract;
  let signer: Signer;

  const totalSupply = 1000;

  beforeEach(async () => {
    const standardTokenFactory = await ethers.getContractFactory(
      'StandardToken'
    );
    referenceToken = await standardTokenFactory.deploy('NewToken', 'NTKN', 18);
    await referenceToken.deployed();

    const sushiswapRouterFactory = await ethers.getContractFactory(
      'MockSushiswapRouter'
    );
    sushiswapRouter = await sushiswapRouterFactory.deploy();
    await sushiswapRouter.deployed();

    const ilsContractFactory = await ethers.getContractFactory(
      'InitialLiquidityPool'
    );
    initialLiquidityPool = await ilsContractFactory.deploy(
      'NewToken',
      'NTKN',
      totalSupply,
      0,
      referenceToken.address,
      Date.now(),
      0,
      sushiswapRouter.address
    );
    await initialLiquidityPool.deployed();
    signer = initialLiquidityPool.signer;
  });

  it('should correctly execute bids and withdrawals', async function () {
    const signerAddress = await signer.getAddress();
    await referenceToken.mint(signerAddress, 2);

    // initial bid
    await referenceToken.approve(initialLiquidityPool.address, 1);
    await initialLiquidityPool.placeBid(1);
    expect(await initialLiquidityPool.getBid()).to.equal(1);
    expect(await referenceToken.balanceOf(signerAddress)).to.equal(1);

    // additional bid
    await referenceToken.approve(initialLiquidityPool.address, 1);
    await initialLiquidityPool.placeBid(1);
    expect(await initialLiquidityPool.getBid()).to.equal(2);
    expect(await referenceToken.balanceOf(signerAddress)).to.equal(0);

    // partial withdrawal
    await initialLiquidityPool.withdrawBid(1);
    expect(await initialLiquidityPool.getBid()).to.equal(1);
    expect(await referenceToken.balanceOf(signerAddress)).to.equal(1);

    // full withdrawal
    await initialLiquidityPool.withdrawBid(1);
    expect(await initialLiquidityPool.getBid()).to.equal(0);
    expect(await referenceToken.balanceOf(signerAddress)).to.equal(2);
  });

  it('should correctly perform the initial liquidity swap', async function () {
    const totalBid = 10;
    const signerAddress = await signer.getAddress();
    await referenceToken.mint(signerAddress, totalBid);

    await referenceToken.approve(initialLiquidityPool.address, totalBid);
    await initialLiquidityPool.placeBid(totalBid);

    await initialLiquidityPool.initialLiquiditySwap();
    expect(await initialLiquidityPool.ilsComplete()).to.equal(true);

    // new token launched and minted correctly
    const newTokenAddress = initialLiquidityPool.launchedToken();
    const newToken = await ethers.getContractAt('StandardToken', newTokenAddress);
    expect(await newToken.totalSupply()).to.equal(totalSupply/2);

    // liquidity added to DEX correctly
    expect(await referenceToken.balanceOf(sushiswapRouter.address)).to.equal(totalBid);
    expect(await newToken.balanceOf(sushiswapRouter.address)).to.equal(totalSupply/2);
  });
});
