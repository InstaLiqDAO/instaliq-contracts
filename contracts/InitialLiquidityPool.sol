pragma solidity ^0.8.0;

import "./interface/IInitialLiquidityPool.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @dev Bidding pool for token launches implementing the Initial Liquidity Swap
 *
 */
contract InitialLiquidityPool is IInitialLiquidityPool {

    string private _name;
    string private _symbol;
    uint256 private _totalSupply;
    ERC20 private _referenceToken;
    uint256 private _ilsPeriodEnd;
    uint256 private _devReserveTokenNumber;

    mapping(address => uint256) private _bids;
    uint256 private _totalBid = 0;

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 totalSupply_,
        ERC20 referenceToken_,
        uint256 ilsPeriodEnd_,
        uint256 devReserveTokenNumber_
    ) {
        _name = name_;
        _symbol = symbol_;
        _totalSupply = totalSupply_;
        _referenceToken = referenceToken_;
        _ilsPeriodEnd = ilsPeriodEnd_;
        _devReserveTokenNumber = devReserveTokenNumber_;
    }

    function name() external view returns (string memory) {
        return _name;
    }

    function symbol() external view returns (string memory) {
        return _symbol;
    }

    function totalSupply() external view returns (uint256) {
        return _totalSupply;
    }

    function referenceToken() external view returns (IERC20) {
        return _referenceToken;
    }

    function ilsPeriodEnd() external view returns (uint256) {
        return _ilsPeriodEnd;
    }

    function devReserveTokenNumber() external view returns (uint256) {
        return _devReserveTokenNumber;
    }

    function currentPrice() external view returns (uint256) {
        uint8 decimals = _referenceToken.decimals();
        return (_totalBid / _totalSupply) / 10 ** decimals;
    }

    function totalBid() external view returns (uint256) {
        return _totalBid;
    }

    /**
     * @dev Places a bid for the specified amount
     *
     * Emits a {BidPlaced} event.
     */
    function placeBid(uint256 amount) external returns (bool) {
        return true;
    }

    /**
     * @dev Withdraws the specified amount from bids balance
     *
     * Emits a {BidWithdrawn} event.
     */
    function withdrawBid(uint256 amount) external returns (bool) {
        return true;
    }

    /**
     * @dev Performs the Initial Liquidity Swap.
     *
     * Emits a {InitialLiquiditySwap} event.
     */
    function initialLiquiditySwap() external returns (bool) {
        return true;
    }

    /**
    * @dev Mints tokens to send to claimants who had bids at ILS
    *
    * Emits a {Transfer} event from underlying ERC20 contract
    */
    function claimTokens() external returns (uint256) {
        return 0;
    }
}