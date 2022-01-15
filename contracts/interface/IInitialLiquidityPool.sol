pragma solidity ^0.8.0;

/**
 * @dev Interface of the InitialLiquidityPool
 */
interface IInitialLiquidityPool {

    function name() external view returns (string memory);

    function symbol() external view returns (string memory);

    function totalSupply() external view returns (uint256);

    function referenceToken() external view returns (address);

    function ilsPeriodEnd() external view returns (uint256);

    function devReserveTokenNumber() external view returns (uint256);

    function currentPrice() external view returns (uint256);

    function totalBid() external view returns (uint256);

    function launchedToken() external view returns (address);

    /**
     * @dev Places a bid for the specified amount
     *
     * Emits a {BidPlaced} event.
     */
    function placeBid(uint256 amount) external returns (bool);

    /**
     * @dev Withdraws the specified amount from bids balance
     *
     * Emits a {BidWithdrawn} event.
     */
    function withdrawBid(uint256 amount) external returns (bool);

    /**
     * @dev Performs the Initial Liquidity Swap.
     *
     * Emits a {InitialLiquiditySwap} event.
     */
    function initialLiquiditySwap() external returns (bool);

    /**
    * @dev Mints tokens to send to claimants who had bids at ILS
    *
    * Emits a {Transfer} event from underlying ERC20 contract
    */
    function claimTokens() external returns (bool);

    /**
     * @dev Emitted when the a bid is placed.
     */
    event BidPlaced(address indexed owner, uint256 amount);

    /**
     * @dev Emitted when the a bid is withdrawn.
     */
    event BidWithdrawn(address indexed owner, uint256 amount);

    /**
     * @dev Emitted when a swap happens.
     */
    event InitialLiquiditySwap(address indexed newToken);
}
