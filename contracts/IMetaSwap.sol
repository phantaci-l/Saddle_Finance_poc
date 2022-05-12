//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

interface IMetaSwap{
    function swap(
        uint8 tokenIndexFrom,
        uint8 tokenIndexTo,
        uint256 dx,
        uint256 minDy,
        uint256 deadline
    ) external returns (uint256);
    
}