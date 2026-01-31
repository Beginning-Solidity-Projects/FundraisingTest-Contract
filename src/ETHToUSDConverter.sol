//SPDX-license-Identifier: MIT
pragma solidity ^0.8;

import {AggregatorV3Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library ETHToUSDConverter {

    function priceOfOneETHInUSD() public view returns (uint256) {
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x694AA1769357215DE4FAC081bf1f309aDC325306);
        (, int256 price ,,,) = priceFeed.latestRoundData();
        return uint256(price) * 1e10;
    }
    
    function convertETHToUSD(uint256 amountOfETH) public view returns (uint256) {
        uint256 priceOfETH = priceOfOneETHInUSD();
        uint256 ethPriceInUSD = (priceOfETH * amountOfETH) / 1e18;
        return ethPriceInUSD;
    } 
}