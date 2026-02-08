# 🛡️ Blokan Phase 2: ERC20 Security Testing

**Comprehensive test suite demonstrating security-focused smart contract auditing skills**

[![Tests](https://img.shields.io/badge/tests-18%2F18%20passing-brightgreen)](https://github.com/abbasbukhari/blokan-phase2)
[![Coverage](https://img.shields.io/badge/coverage-100%25-brightgreen)](https://github.com/abbasbukhari/blokan-phase2)
[![Foundry](https://img.shields.io/badge/Built%20with-Foundry-blue)](https://book.getfoundry.sh/)

## 📋 Overview

This repository contains a complete security-focused test suite for an ERC20 token implementation, developed as part of my journey toward becoming a professional smart contract auditor.

**Project Goals:**

- Master fundamental smart contract testing patterns
- Build reference test suite for future audits
- Demonstrate security-first thinking
- Achieve 100% code coverage

## ✅ Test Coverage

**18 comprehensive tests covering all ERC20 functions:**

### Core Functions

- ✅ `totalSupply()` - Initial supply verification
- ✅ `balanceOf()` - Balance queries and edge cases
- ✅ `transfer()` - Success cases, zero address protection, insufficient balance
- ✅ `approve()` - Allowance setting, zero address protection, overwrite behavior
- ✅ `allowance()` - Allowance queries
- ✅ `transferFrom()` - Delegated transfers, allowance checks, balance validations

### Security Validations

- Zero address rejections (3 tests)
- Insufficient balance/allowance checks (3 tests)
- Edge cases (self-transfers, zero amounts)
- State consistency (balance + allowance updates)

## 📊 Coverage Report

```
File                 | % Lines         | % Statements    | % Branches      | % Funcs
=====================|=================|=================|=================|===============
src/Blokan_Token.sol | 100.00% (34/34) | 100.00% (27/27) | 100.00% (12/12) | 100.00% (7/7)
```

**100% coverage across all metrics** ✅

## 🛠️ Built With

- **Foundry** - Fast, portable Ethereum development toolkit
- **Solidity ^0.8.20** - Smart contract programming language
- **Forge** - Testing framework

## 🚀 Quick Start

### Prerequisites

```bash
# Install Foundry
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### Installation

```bash
# Clone the repository
git clone https://github.com/abbasbukhari/blokan-phase2.git
cd blokan-phase2

# Install dependencies
forge install

# Run tests
forge test

# Run tests with gas reporting
forge test --gas-report

# Generate coverage report
forge coverage
```

## 📁 Project Structure

```
blokan-phase2/
├── src/
│   └── Blokan_Token.sol       # ERC20 token implementation
├── test/
│   └── BlokanTokenTest.t.sol  # Comprehensive test suite
├── foundry.toml               # Foundry configuration
└── README.md                  # Project documentation
```

## 🧪 Test Suite Highlights

### Pattern-Based Testing

All tests follow industry-standard patterns:

- **Success tests** - Verify correct behavior with valid inputs
- **Revert tests** - Ensure proper rejection of invalid operations
- **Edge case tests** - Cover boundary conditions and unusual scenarios
- **State consistency tests** - Validate state changes across operations

### Example Test

```solidity
function test_transferFrom_success() public {
    // Setup: Alice has tokens and approves Bob
    token.transfer(alice, 1000e18);
    vm.prank(alice);
    token.approve(bob, 500e18);

    // Record state before
    uint256 aliceBalanceBefore = token.balanceOf(alice);
    uint256 charlieBalanceBefore = token.balanceOf(charlie);
    uint256 allowanceBefore = token.allowance(alice, bob);

    // Execute: Bob transfers Alice's tokens to Charlie
    vm.prank(bob);
    token.transferFrom(alice, charlie, 100e18);

    // Verify state changes
    assertEq(token.balanceOf(alice), aliceBalanceBefore - 100e18);
    assertEq(token.balanceOf(charlie), charlieBalanceBefore + 100e18);
    assertEq(token.allowance(alice, bob), allowanceBefore - 100e18);
}
```

## 🎯 Learning Outcomes

Through this project, I've developed:

- ✅ Systematic approach to smart contract testing
- ✅ Understanding of common ERC20 vulnerabilities
- ✅ Proficiency with Foundry testing tools (`vm.prank`, `vm.expectRevert`, assertions)
- ✅ Pattern recognition for security-critical code paths
- ✅ Test organization and documentation skills

## 📈 Next Steps

This project is **Phase 2** of my path toward professional smart contract auditing:

- **Phase 1** ✅ - Solidity fundamentals, ERC20 understanding
- **Phase 2** ✅ - Testing patterns, reference test suite (this repo)
- **Phase 3** 🔄 - Practice audits on real contracts
- **Phase 4** ⏳ - DeFi protocol testing (vaults, staking, AMMs)
- **Phase 5** ⏳ - Advanced topics (oracles, bridges, account abstraction)
- **Phase 6** ⏳ - Professional auditing, bug bounties

## 🔗 Connect

Building security skills in public. Follow my journey:

- GitHub: [@abbasbukhari](https://github.com/abbasbukhari)
- Portfolio: [More audits coming soon]

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

**Status:** Phase 2 Complete ✅ | **Date:** February 8, 2026 | **Tests:** 18/18 Passing | **Coverage:** 100%
