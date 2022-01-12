pragma solidity ^0.8.0;

import "../interface/ISushiSwap.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Context.sol";

contract MockSushiswapRouter is IUniswapV2Router02, Context {
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to
    ) external override returns (uint amountA, uint amountB) {
        ERC20 ercA = ERC20(tokenA);
        ERC20 ercB = ERC20(tokenB);

        // actual implementation sends to DEX pair, but this should be sufficent for test for now
        ercA.transferFrom(_msgSender(), address(this), amountADesired);
        ercB.transferFrom(_msgSender(), address(this), amountBDesired);

        return (amountADesired, amountBDesired);
    }
}