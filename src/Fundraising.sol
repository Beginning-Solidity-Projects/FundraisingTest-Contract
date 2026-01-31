//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {ETHToUSDConverter} from "./ETHToUSDConverter.sol";
error NotOwner();

contract Fundraising {
    using ETHToUSDConverter for uint;

    uint256 public constant minimumAmount = 10e18;
    address[] public listOfSenders;
    mapping(address sender => uint256 amountSent) public amountSentByAddress;
    address public immutable i_owner;

    constructor() {
        i_owner = msg.sender;
    }

    receive() external payable {
        sendMoney();
    }

    fallback() external payable {
        sendMoney();
    }

    modifier onlyOwner() {
        _onlyOwner();
        _;
    }

    function _onlyOwner() internal view {
        if(msg.sender != i_owner) {revert NotOwner();}
    }

    function sendMoney() public payable {
        require(msg.value.convertETHToUSD() >= minimumAmount, "Not enough ether");
        listOfSenders.push(msg.sender);
        amountSentByAddress[msg.sender] += msg.value;
    }

    function withdrawMoney() public onlyOwner {
        for (uint256 senderIndex = 0; senderIndex < listOfSenders.length; senderIndex++) {
            address sender = listOfSenders[senderIndex];
            amountSentByAddress[sender] = 0;
        }
        listOfSenders = new address[](0);

        (bool callSuccess, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(callSuccess, "Failed");
    }
}
