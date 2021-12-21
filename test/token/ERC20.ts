import { expect } from "chai";
import { ethers } from "hardhat";

describe("ERC20", function () {
  it("Should return the name/symbol after deploy", async function () {
    const erc20ContractFactory = await ethers.getContractFactory("ERC20");
    const erc20 = await erc20ContractFactory.deploy("NewToken", "NTKN");

    await erc20.deployed();

    expect(await erc20.name()).to.equal("NewToken");
    expect(await erc20.symbol()).to.equal("NTKN");
  });
});
