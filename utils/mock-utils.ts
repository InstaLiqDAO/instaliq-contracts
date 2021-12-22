import { ethers } from 'hardhat';

export function getRandomWallet() {
  const randomMnemonic = ethers.Wallet.createRandom().mnemonic;
  return ethers.Wallet.fromMnemonic(randomMnemonic.phrase);
}
