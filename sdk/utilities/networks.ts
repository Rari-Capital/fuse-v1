export enum ChainID {
  ETHEREUM = 1,
  ARBITRUM = 42161,
  ARBITRUM_RINKEBY = 421611,
  HARDHAT = 31337,
}

export const isSupportedChainId = (chainId: number) =>
  Object.values(ChainID).includes(chainId);
