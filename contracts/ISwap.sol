//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;


interface ISwap{
    function removeLiquidity(
        uint256 amount,
        uint256[] calldata minAmounts,
        uint256 deadline
    ) external returns (uint256[] memory);
}