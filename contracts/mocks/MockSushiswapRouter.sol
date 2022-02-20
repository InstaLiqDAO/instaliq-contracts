pragma solidity ^0.8.0;

import "../interface/ISushiSwap.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Context.sol";

contract MockSushiswapRouter is IUniswapV2Router02, Context {
    address _factory;

    constructor(address factory_) {
        _factory = factory_;
    }

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external override returns (uint amountA, uint amountB) {
        ERC20 ercA = ERC20(tokenA);
        ERC20 ercB = ERC20(tokenB);

        // actual implementation sends to DEX pair, but this should be sufficent for test for now
        ercA.transferFrom(_msgSender(), _factory, amountADesired);
        ercB.transferFrom(_msgSender(), _factory, amountBDesired);

        return (amountADesired, amountBDesired);
    }
}

contract MockSushiswapFactory is Context, IUniswapV2Factory {
    address _pair;

    function getPair() external view returns(address fact) {
        return _pair;
    }

    function createPair(address tokenA, address tokenB) external override returns (address pair) {
        _pair = address(this);
        return address(this);
    }
}     

