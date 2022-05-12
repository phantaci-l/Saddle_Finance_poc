// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const { ethers } = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');
  const [signer] = await ethers.getSigners();
  console.log("signer address is: ",signer.address, "the balance of ETH is: ", await signer.getBalance());
  console.log("the block number is :", await ethers.provider.getBlockNumber());

  // We get the contract to deploy
  const Flashloan = await ethers.getContractFactory("falshloan");
  const Flashloan_test = await Flashloan.deploy();

  await Flashloan_test.deployed();

  console.log("Flashloan_test deployed to:", Flashloan_test.address);

  const uniswap_abi = ["function swapExactETHForTokens(uint256 amountOutMin,address[] memory path,address to,uint256 deadline) external payable returns (uint256[] memory amounts)"];
  const erc20_abi = ["function balanceOf(address account) external view returns (uint256)", "function approve(address spender, uint256 amount) external returns (bool)", "function transferFrom(address from, address to, uint256 amount) external returns (bool)"];
  
  const WETH_address = "0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2";
  const USDC_address = "0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48";
  const UNI_V2_router = "0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D";         //swap

  const unirouter = new ethers.Contract(UNI_V2_router, uniswap_abi, signer);
  const USDC_token = new ethers.Contract(USDC_address, erc20_abi, signer);

  await unirouter.swapExactETHForTokens(0, [WETH_address, USDC_address], signer.address, Date.now(), {value : ethers.utils.parseEther('7000')});
  console.log("I have got USDC: ",await USDC_token.balanceOf(signer.address));
  await USDC_token.approve(signer.address, BigInt(99999999999999));
  await USDC_token.transferFrom(signer.address, Flashloan_test.address, 15000000000000);
  
  console.log("Flashloan_test have got USDC: ",await USDC_token.balanceOf(Flashloan_test.address));

  await Flashloan_test.set_all_approve();
  await Flashloan_test.borrow_USDC_from_Euler();
  await Flashloan_test.swap_sUSD_from_curve();

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
