pragma solidity ^0.8.0;

// interface to avoid solidity version mismatch errors
interface IUniswapV2Router02  {
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to
    ) external returns (uint amountA, uint amountB);
}