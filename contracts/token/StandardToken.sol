pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

/**
 * @dev Extension of OpenZeppelin {ERC20}.
 *
 */
contract StandardToken is ERC20 {
    uint8 private _decimals;
    address private _initializer;

    /**
     * @dev Sets the values for {name}, {symbol}, {initializer}, and {decimals}.
     *
     * All of these values are immutable: they can only be set once during
     * construction.
     */
    constructor(string memory name_, string memory symbol_, uint8 decimals_, address initializer_) ERC20(name_, symbol_) {
        _decimals = decimals_;
        _initializer = initializer_;
    }

    /**
     * @dev Returns the number of decimals used to get its user representation.
     * For example, if `decimals` equals `2`, a balance of `505` tokens should
     * be displayed to a user as `5.05` (`505 / 10 ** 2`).
     *
     * Tokens usually opt for a value of 18, imitating the relationship between
     * Ether and Wei. This is the value {ERC20} uses, unless this function is
     * overridden;
     *
     * NOTE: This information is only used for _display_ purposes: it in
     * no way affects any of the arithmetic of the contract, including
     * {IERC20-balanceOf} and {IERC20-transfer}.
     */
    function decimals() public view override returns (uint8) {
        return _decimals;
    }

    /**
     * @dev Mints the amount of tokens for the claimant.
     *
     * Only the initializing contract, which should be an InitialLiquidityPool,
     * can call this function to create tokens based on bids placed during ILS.
     */
    function claimTokens(address claimant, uint256 amount) external returns (bool) {
        require(_msgSender() == _initializer, "initializer must be sender");

        _mint(claimant, amount);

        return true;
    }
}