// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/Counter.sol";

contract CounterTest is Test {
    Counter public counter;
    address donor1 = address(0xBEEF);
    address donor2 = address(0xCAFE);

    event DonationReceived(address indexed donor, uint amount);
    event Withdraw(address indexed owner, uint amount);

    function setUp() public {
        counter = new Counter();
    }

    /// @notice Kiểm tra trạng thái ban đầu
    function testInitialState() public {
        assertEq(counter.owner(), address(this), "Owner should be test contract");
        assertEq(counter.totalDonations(), 0, "Total donations should start at 0");
        assertEq(address(counter).balance, 0, "Contract balance should start at 0");
    }

    /// @notice Kiểm tra donate 1 lần từ donor1
    function testDonateIncreasesTotal() public {
        vm.deal(donor1, 5 ether);
        vm.prank(donor1);

        vm.expectEmit(true, false, false, true);
        emit DonationReceived(donor1, 1 ether);

        counter.donate{value: 1 ether}();

        assertEq(counter.totalDonations(), 1 ether);
        assertEq(address(counter).balance, 1 ether);
    }

    /// @notice Kiểm tra donate từ nhiều người
    function testMultipleDonations() public {
        vm.deal(donor1, 5 ether);
        vm.deal(donor2, 5 ether);

        vm.prank(donor1);
        counter.donate{value: 1 ether}();

        vm.prank(donor2);
        counter.donate{value: 2 ether}();

        assertEq(counter.totalDonations(), 3 ether);
        assertEq(address(counter).balance, 3 ether);

        Counter.Donor[] memory allDonors = counter.getDonors();
        assertEq(allDonors.length, 2, "Should have 2 donors recorded");
        assertEq(allDonors[0].amount, 1 ether);
        assertEq(allDonors[1].amount, 2 ether);
    }

    /// @notice Kiểm tra withdraw bởi owner
    function testWithdrawByOwner() public {
    // Gửi tiền từ donor1
    vm.deal(donor1, 5 ether);
    vm.prank(donor1);
    counter.donate{value: 2 ether}();

    uint beforeBalance = address(this).balance;

    // Chuẩn bị kỳ vọng event Withdraw
    vm.expectEmit(true, true, false, true, address(counter));
    emit Withdraw(address(this), 2 ether);

    // Ép context thành owner
    vm.prank(counter.owner());
    counter.withdraw();

    uint afterBalance = address(this).balance;

    assertGt(afterBalance, beforeBalance, "Owner should receive funds");
    assertEq(address(counter).balance, 0, "Contract balance should be 0 after withdraw");
}

    /// @notice Kiểm tra withdraw bởi người không phải owner
    function test_RevertWhen_NotOwnerWithdraws() public {
        vm.deal(donor1, 5 ether);
        vm.prank(donor1);

        vm.expectRevert("Only owner can withdraw");
        counter.withdraw();
    }

    /// @notice Kiểm tra không được donate giá trị 0
    function test_RevertWhen_DonateZeroValue() public {
        vm.deal(donor1, 5 ether);
        vm.prank(donor1);

        vm.expectRevert("Must send CELO to donate");
        counter.donate{value: 0}();
    }
}
