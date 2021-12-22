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
     * @dev Mints the supply of this token. dests and amounts variables represent a mapping
     * of addresses to token balances determined by the InitialLiquidityPool deploying this
     * token contract. 
     *
     * Requires that the deployer of this contract also mints and can only mint the supply once.
     */
    function mintSupply(address[] calldata dests, uint256[] calldata amounts) public returns (bool) {
        require(_msgSender() == _initializer, "initializer must be sender");
        require(dests.length == amounts.length, "amounts and dests do not map");
        require(totalSupply() == 0, "supply already minted");

        for (uint256 i = 0; i < dests.length; i++) {
            _mint(dests[i], amounts[i]);
        }

        return true;
    }
}