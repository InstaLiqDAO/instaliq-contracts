import { expect } from 'chai';
import { ethers } from 'hardhat';

describe('StandardToken', function () {
  it('Should be initialized properly after deploy ', async function () {
    const standardTokenContractFactory = await ethers.getContractFactory(
      'StandardToken'
    );
    const standardToken = await standardTokenContractFactory.deploy(
      'NewToken',
      'NTKN',
      18
    );

    await standardToken.deployed();

    expect(await standardToken.name()).to.equal('NewToken');
    expect(await standardToken.symbol()).to.equal('NTKN');
    expect(await standardToken.decimals()).to.equal(18);
  });
});
