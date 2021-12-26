pragma solidity ^0.8.0;

import "./interface/IInitialLiquidityPool.sol";
import "./token/StandardToken.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/utils/Context.sol";
import "@sushiswap/core/contracts/uniswapv2/UniswapV2Router02.sol";

/**
 * @dev Bidding pool for token launches implementing the Initial Liquidity Swap
 *
 */
contract InitialLiquidityPool is Context, IInitialLiquidityPool {

    string private _name;
    string private _symbol;
    uint256 private _totalSupply;
    uint8 private _decimals;
    address private _referenceToken;
    uint256 private _ilsPeriodEnd;
    uint256 private _devReserveTokenNumber;
    address private _sushiswapRouter;

    mapping(address => uint256) private _bids;
    uint256 private _totalBid = 0;
    address private _launchedToken;
    bool private _ilsComplete;

    constructor(
        string memory name_,
        string memory symbol_,
        uint256 totalSupply_,
        uint8 decimals_,
        address referenceToken_,
        uint256 ilsPeriodEnd_,
        uint256 devReserveTokenNumber_,
        address sushiswapRouter_
    ) {
        _name = name_;
        _symbol = symbol_;
        _totalSupply = totalSupply_;
        _decimals = decimals_;
        _referenceToken = referenceToken_;
        _ilsPeriodEnd = ilsPeriodEnd_;
        _devReserveTokenNumber = devReserveTokenNumber_;
        _sushiswapRouter = sushiswapRouter_;
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

    function referenceToken() external view returns (address) {
        return _referenceToken;
    }

    function ilsPeriodEnd() external view returns (uint256) {
        return _ilsPeriodEnd;
    }

    function devReserveTokenNumber() external view returns (uint256) {
        return _devReserveTokenNumber;
    }

    function launchedToken() external view returns (address) {
        return _launchedToken;
    }

    function currentPrice() external view returns (uint256) {
        return _totalBid / _totalSupply;
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
        require (!ilsComplete, "ILS has occurred");
        _bids[_msgSender()] += amount;
        _totalBid += amount;
        ERC20(_referenceToken).transferFrom(_msgSender(), address(this), amount);

        emit BidPlaced(_msgSender(), amount);

        return true;
    }

    /**
     * @dev Withdraws the specified amount from bids balance
     *
     * Emits a {BidWithdrawn} event.
     */
    function withdrawBid(uint256 amount) external returns (bool) {
        require (!ilsComplete, "ILS has occurred");
        uint256 existingBid = _bids[_msgSender()];
        require(existingBid >= amount, "amount not available to withdraw");
        _bids[_msgSender()] -= amount;
        _totalBid -= amount;
        ERC20(_referenceToken).transfer(_msgSender(), amount);
        
        emit BidWithdrawn(_msgSender(), amount);

        return true;
    }

    /**
     * @dev Performs the Initial Liquidity Swap.
     *
     * Emits a {InitialLiquiditySwap} event.
     */
    function initialLiquiditySwap() external returns (bool) {
        require (!ilsComplete, "ILS already occurred");
        StandardToken newToken = new StandardToken(_name, _symbol, _decimals);
        ERC20 referenceToken = ERC20(_referenceToken);
        _launchedToken = address(newToken);
        uint256 liqPoolNewTokenSupply = (_totalSupply - _devReserveTokenNumber)/2;
        newToken.mintLiquidityPoolSupply(liqPoolNewTokenSupply);

        sushiswapRouter = UniswapV2Router02(_sushiswapPairFactory);
        newToken.approve(address(this), liqPoolNewTokenSupply);
        referenceToken.approve(address(this), _totalBid);
        
        // Currently locking LP tokens into this contract (burned)
        sushiswapRouter.addLiquidity(
            _launchedToken,
            _referenceToken, 
            liqPoolNewTokenSupply,
            _totalBid,
            liqPoolNewTokenSupply,
            _totalBid,
            address(this)
        );

        // TODO: Do something with the dev supply

        _ilsComplete = true;
    
        return true;
    }

    /**
    * @dev Mints tokens to send to claimants who had bids at IL`        S
    *
    * Emits a {Transfer} event from underlying ERC20 contract   `
    */
    function claimTokens() external returns (uint256) {
        require(ilsComplete, "ILS has not occurred yet");

        return 0;
    }
}