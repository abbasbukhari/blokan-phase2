// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test} from "forge-std/Test.sol";
import {BlokanToken} from "../src/Blokan_Token.sol";

contract BlokanTokenTest is Test {
    BlokanToken token;
    address deployer = address(this);
    address alice = makeAddr("alice");
    address bob = makeAddr("bob");
    address charlie = makeAddr("charlie");

    function setUp() public {
        token = new BlokanToken(1_000_000);
    }

    function test_initialSupply() public {
        // ACTION: Get the values
        uint256 totalSupply = token.totalSupply();
        uint256 deployerBalance = token.balanceOf(deployer);

        // CHECK: Are they what we expect?
        assertEq(totalSupply, 1_000_000 * 10 ** token.decimals());
        assertEq(deployerBalance, totalSupply);
    }

    function test_transfer_success() public {
        // STEP 1: SETUP - Give Alice some tokens
        uint256 transferAmount = 100 * 10 ** token.decimals();

        // Deployer transfers tokens to Alice (so she has tokens to transfer)
        token.transfer(alice, 1000 * 10 ** token.decimals());

        // STEP 2: RECORD STATE BEFORE
        uint256 aliceBalanceBefore = token.balanceOf(alice);
        uint256 bobBalanceBefore = token.balanceOf(bob);
        uint256 totalSupplyBefore = token.totalSupply();

        // STEP 3: ACTION - Alice transfers to Bob
        vm.prank(alice); // This makes the next call come from Alice
        token.transfer(bob, transferAmount);

        // STEP 4: RECORD STATE AFTER
        uint256 aliceBalanceAfter = token.balanceOf(alice);
        uint256 bobBalanceAfter = token.balanceOf(bob);
        uint256 totalSupplyAfter = token.totalSupply();

        // STEP 5: ASSERTIONS - Check everything is correct
        assertEq(
            aliceBalanceAfter,
            aliceBalanceBefore - transferAmount,
            "Alice balance should decrease"
        );
        assertEq(
            bobBalanceAfter,
            bobBalanceBefore + transferAmount,
            "Bob balance should increase"
        );
        assertEq(
            totalSupplyAfter,
            totalSupplyBefore,
            "Total supply should not change"
        );
    }

    // function test_transfer_failsOnZeroAddress() public {
    //     // SETUP: Give Alice tokens
    //     token.transfer(alice, 1000 * 10 ** token.decimals());

    //     // ACTION: Alice tries to transfer to zero address
    //     vm.prank(alice);

    //     // EXPECTATION: This should revert with specific error message
    //     vm.expectRevert("ERC20: transfer to zero address");
    //     token.transfer(address(0), 100 * 10 ** token.decimals());
    // }

    // function test_transfer_failsOnZeroAddress() public {
    //     // SETUP: Give Alice tokens
    //     token.transfer(alice, 1000 * 10 ** token.decimals());

    //     // EXPECTATION: Alice's transfer to zero address should revert
    //     vm.expectRevert("ERC20: transfer to zero address");
    //     vm.prank(alice);
    //     token.transfer(address(0), 100 * 10 ** token.decimals());
    // }

    function test_transfer_failsOnZeroAddress() public {
        // SETUP: Give Alice tokens
        uint256 transferAmount = 1000 * 10 ** token.decimals();
        token.transfer(alice, transferAmount);

        // Calculate amount BEFORE prank
        uint256 zeroTransferAmount = 100 * 10 ** token.decimals();

        // EXPECTATION: Transfer to zero address should revert
        vm.expectRevert("ERC20: transfer to zero address");
        vm.prank(alice);
        token.transfer(address(0), zeroTransferAmount); // ← Use pre-calculated amount!
    }

    function test_transfer_failsInsufficientBalance() public {
        // SETUP: Give Alice only 100 tokens
        token.transfer(alice, 100e18);

        // TEST: Alice tries to transfer 200 tokens (More then she has)
        vm.expectRevert("ERC20: insufficient balance");
        vm.prank(alice);
        token.transfer(bob, 200e18); // She only has 100!
    }

    function test_approve_success() public {
        // SETUP: Deployer approves Alice to spend 500 tokens
        uint256 approveAmount = 500e18;

        // TODO ACTION:
        // The approve function takes an address and an amount and then returns a boolean value.
        // It then requires that the spender is not the zero address.
        // And the allowences mapping is updated to set the allowance for the spender to the specified amount.
        // And then it emits an Approval event.
        // And then reutrns true.

        // STEP 2: Record allowance BEFORE
        uint256 allowanceBefore = token.allowance(address(this), alice);

        // STEP 3: ACTION - Deployer approves Alice
        token.approve(alice, approveAmount);

        // STEP 4: Record allowance AFTER
        uint256 allowanceAfter = token.allowance(address(this), alice);

        // STEP 5: ASSERTIONS - Check allowance updated correctly
        assertEq(allowanceAfter, approveAmount);
        assertEq(allowanceBefore, 0);
    }

    function test_approve_failsOnZeroAddress() public {
        // EXPECTATION: Approving zero address should revert
        vm.expectRevert("ERC20: approve to zero address");
        token.approve(address(0), 100e18);
    }

    function test_allowance_returnsZeroWhenNotApproved() public {
        uint256 allowance = token.allowance(address(this), alice);
        assertEq(allowance, 0, "Allowance should be zero when not approved");
    }

    function test_balanceOf_returnsCorrectBalance() public {
        token.transfer(alice, 500e18);

        uint256 balance = token.balanceOf(alice);
        assertEq(balance, 500e18);
    }

    function test_balanceOf_returnsZeroForNewAddress() public {
        uint256 balance = token.balanceOf(address(0x123));
        assertEq(balance, 0);
    }

    function test_allowance_returnsCorrectValue() public {
        token.approve(alice, 500e18);

        uint256 allowance = token.allowance(address(this), alice);
        assertEq(allowance, 500e18);
    }

    function test_approve_overwritesPreviousAllowance() public {
        token.approve(alice, 500e18);
        assertEq(token.allowance(address(this), alice), 500e18);

        token.approve(alice, 300e18);
        assertEq(token.allowance(address(this), alice), 300e18);
    }

    function test_transfer_zeroAmount() public {
        token.transfer(alice, 1000e18);

        uint256 aliceBefore = token.balanceOf(alice);
        uint256 bobBefore = token.balanceOf(bob);

        vm.prank(alice);
        token.transfer(bob, 0);

        assertEq(token.balanceOf(alice), aliceBefore);
        assertEq(token.balanceOf(bob), bobBefore);
    }

    function test_transfer_toSelf() public {
        token.transfer(alice, 1000e18);

        uint256 balanceBefore = token.balanceOf(alice);

        vm.prank(alice);
        token.transfer(alice, 100e18);

        assertEq(token.balanceOf(alice), balanceBefore);
    }

    function test_transferFrom_failsWithoutAllowance() public {
        token.transfer(alice, 1000e18);

        vm.expectRevert("ERC20: transfer amount exceeds allowance");
        vm.prank(bob);
        token.transferFrom(alice, charlie, 100e18);
    }

    function test_transferFrom_success() public {
        // Setup: Alice has tokens and approves Bob
        token.transfer(alice, 1000e18);
        vm.prank(alice);
        token.approve(bob, 500e18);

        // Record before
        uint256 aliceBalanceBefore = token.balanceOf(alice);
        uint256 charlieBalanceBefore = token.balanceOf(charlie);
        uint256 allowanceBefore = token.allowance(alice, bob);

        // Action: Bob transfers Alice's tokens to Charlie
        vm.prank(bob);
        token.transferFrom(alice, charlie, 100e18);

        // Record after
        uint256 aliceBalanceAfter = token.balanceOf(alice);
        uint256 charlieBalanceAfter = token.balanceOf(charlie);
        uint256 allowanceAfter = token.allowance(alice, bob);

        // Assert
        assertEq(aliceBalanceAfter, aliceBalanceBefore - 100e18);
        assertEq(charlieBalanceAfter, charlieBalanceBefore + 100e18);
        assertEq(allowanceAfter, allowanceBefore - 100e18);
    }

    function test_transferFrom_failsExceedingAllowance() public {
        // Setup: Alice approves Bob for only 100
        token.transfer(alice, 1000e18);
        vm.prank(alice);
        token.approve(bob, 100e18);

        // Expect revert
        vm.expectRevert("ERC20: transfer amount exceeds allowance");

        // Action: Bob tries to transfer 200 (more than approved)
        vm.prank(bob);
        token.transferFrom(alice, charlie, 200e18);
    }

    function test_transferFrom_failsInsufficientOwnerBalance() public {
        // Setup: Alice has 100, approves Bob for 500
        token.transfer(alice, 100e18);
        vm.prank(alice);
        token.approve(bob, 500e18);

        // Expect revert
        vm.expectRevert("ERC20: insufficient balance");

        // Action: Bob tries to transfer 200 (Alice doesn't have it)
        vm.prank(bob);
        token.transferFrom(alice, charlie, 200e18);
    }

    function test_transferFrom_failsOnZeroAddress() public {
        // Setup
        token.transfer(alice, 1000e18);
        vm.prank(alice);
        token.approve(bob, 500e18);

        // Expect revert
        vm.expectRevert("ERC20: transfer to zero address");

        // Action: Bob tries to send to zero address
        vm.prank(bob);
        token.transferFrom(alice, address(0), 100e18);
    }
}
