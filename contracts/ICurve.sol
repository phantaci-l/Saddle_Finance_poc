// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;
import "./IERC20.sol";


interface ICurve{
    function add_liquidity(uint256[3] memory _amounts, uint256 min_mint_amount) external;

    function add_liquidity(uint256[2] memory _amounts, uint256 min_mint_amount) external;

    function calc_token_amount(uint256[3] memory amounts, bool deposit) external returns (uint256);
    
    function calc_token_amount(uint256[2] memory amounts, bool deposit) external returns (uint256);

    function remove_liquidity_one_coin(
        uint256 _token_amount,
        int128 i,
        uint256 min_amount
    ) external;

    function exchange(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 min_dy
    ) external;
    
    function get_dy(
        int128 i,
        int128 j,
        uint256 dx
    ) external view returns (uint256);

    /**
     * @notice Borrow the specified token from this pool for this transaction only. This function will call
     * `IFlashLoanReceiver(receiver).executeOperation` and the `receiver` must return the full amount of the token
     * and the associated fee by the end of the callback transaction. If the conditions are not met, this call
     * is reverted.
     * @param receiver the address of the receiver of the token. This address must implement the IFlashLoanReceiver
     * interface and the callback function `executeOperation`.
     * @param token the protocol fee in bps to be applied on the total flash loan fee
     * @param amount the total amount to borrow in this transaction
     * @param params optional data to pass along to the callback function
     */
    function flashLoan(
        address receiver,
        IERC20 token,
        uint256 amount,
        bytes memory params
    ) external;
}

interface ICurve_Pair{

    function exchange(
        int128 i,
        int128 j,
        uint256 dx,
        uint256 min_dy
    ) external;

    function get_dy(
        int128 i,
        int128 j,
        uint256 dx
    ) external view returns (uint256);

    function balances(int128 i) external returns (uint256);
}