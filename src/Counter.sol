// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract Counter {
    address public owner;
    uint public totalDonations;

    struct Donor {
        address addr;
        uint amount;
    }

    Donor[] public donors;

    event DonationReceived(address indexed donor, uint amount);
    event Withdraw(address indexed owner, uint amount);

    constructor() {
        owner = msg.sender;
    }

    function donate() external payable {
        require(msg.value > 0, "Must send CELO to donate");
        totalDonations += msg.value;
        donors.push(Donor(msg.sender, msg.value));
        emit DonationReceived(msg.sender, msg.value);
    }

    function getDonors() external view returns (Donor[] memory) {
        return donors;
    }

    function getBalance() external view returns (uint) {
        return address(this).balance;
    }

    function withdraw() external {
        require(msg.sender == owner, "Only owner can withdraw");
        uint amount = address(this).balance;
        payable(owner).transfer(amount);
        emit Withdraw(owner, amount);
    }
}

