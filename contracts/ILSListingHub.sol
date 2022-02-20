pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Context.sol";
import "./InitialLiquidityPool.sol";

/**
 * @dev Home and factory for InitialLiquidityPool listings
 *
 */
contract ILSListingHub is Context {
    address[] private _listings;
    address private  _sushiswapRouter;
    address private _sushiswapFactory;

    constructor(address sushiswapRouter_, address sushiswapFactory_) {
        _sushiswapRouter = sushiswapRouter_;
        _sushiswapFactory = sushiswapFactory_;
    }

    function createInitialLiquidityPool(
        string memory name,
        string memory symbol,
        uint256 totalSupply,
        uint8 decimals,
        address referenceToken,
        uint256 ilsPeriodEnd,
        uint256 devReserveTokenNumber
    ) external returns (address) {
        InitialLiquidityPool newPool = new InitialLiquidityPool(
            name,
            symbol,
            totalSupply,
            decimals,
            referenceToken,
            ilsPeriodEnd,
            devReserveTokenNumber,
            _sushiswapRouter,
            _sushiswapFactory
        );
        _listings.push(address(newPool));
        return address(newPool);
    }

    function getListings() external view returns (address[] memory) {
        return _listings;
    }

}