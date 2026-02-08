// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/**
 * @dev Minimal ERC20 implementation.
 * Behavior aligned with OpenZeppelin ERC20.
 * No extensions included.
 */

contract BlokanToken {
    // Token metadata
    string public name = "Blokan Token"; // This is the name of the Token
    string public symbol = "BLK"; // This is the symbol of the Token
    uint8 public decimals = 18; // This is the number of decimals the Token uses

    // Core ERC20 storage
    uint256 private _totalSupply; // This is a storage variable for the Total Supply set to be private
    mapping(address => uint256) private _balances; // This is a mapping from address to uint256 for Balances
    mapping(address => mapping(address => uint256)) private _allowances; // This is a mapping from address to mapping of address to uint256 for Allowances (Not sure what this means)

    // Events
    event Transfer(address indexed from, address indexed to, uint256 value); // This event is emitted when address `from` transfers `value` tokens to address `to`
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    ); // This event is emitted when address `owner` approves `spender` to spend `value` tokens on their behalf

    // ERC20 PUBLIC VIEW FUNCTIONS
    function totalSupply() public view returns (uint256) {
        return _totalSupply;
    }

    /**
    1. What state does this function read?
    The above functions purpose is to return the _totalSupply variable which is private and is store in uint256 format.
    2. What state does this function change?
    This is a view function so it doesn't chage any state.
    3. What conditions must be true before it runs?
    There are no conditions that must be true before it runs.
    4. What must be true after it finishes?
    This function only returns the _totalSupply variable so after it finishes the _totalSupply variable must be returned.
    5. What invariant is it protecting?
    I am not sure about this one.
     **/

    function balanceOf(address account) public view returns (uint256) {
        return _balances[account];
    }

    /**
    1. What state does this function read?
    The above functions purpose is to return the balance of a specific account.
    2. What state does this function change?
    This is a view function so it doesn't chage any state.
    3. What conditions must be true before it runs?
    The account address must be a valid address.
    4. What must be true after it finishes?
    The balance of the account must be returned.
    5. What invariant is it protecting?
    I am not sure about this one.

     **/

    function allowance(
        address owner,
        address spender
    ) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    /**
    1. What state does this function read?
    The above functions purpose is to return the allowance that a spender has from an owner.
    2. What state does this function change?
    This is a view function so it doesn't change any state.
    3. What conditions must be true before it runs?
    The owner and spender addresses must be valid addresses.
    4. What must be true after it finishes?
    The allowance of the spender from the owner must be returned.
    5. What invariant is it protecting?
    I am not sure about this one.
     **/

    // ERC20 PUBLIC MUTATIVE FUNCTIONS
    function transfer(address to, uint256 amount) public returns (bool) {
        address owner = msg.sender;

        require(to != address(0), "ERC20: transfer to zero address");
        require(_balances[owner] >= amount, "ERC20: insufficient balance");

        _balances[owner] -= amount;
        _balances[to] += amount;

        emit Transfer(owner, to, amount);
        return true;
    }

    /**
    1. What state does this function read?
    I am not sure about this one.
    2. What state does this function change?
    I am not sure about this one, but it seems like it requres the balance of the owner and the to address to be changed.
    3. What conditions must be true before it runs?
    The to address must not be the zero address and the owner's balance must be greater than or equal to the amount being transferred.
    4. What must be true after it finishes?
    I am not sure about this one.
    5. What invariant is it protecting?
    I am not sure about this one.

     **/

    function approve(address spender, uint256 amount) public returns (bool) {
        address owner = msg.sender;

        require(spender != address(0), "ERC20: approve to zero address");

        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);
        return true;
    }

    /**
    1. What state does this function read?
    I am not sure about this one.
    2. What state does this function change?
    I am not sure about this one.
    3. What conditions must be true before it runs?
    The approve takes a spender address and an amount and then returns a boolean value.
    4. What must be true after it finishes?
    I am not sure about this one.
    5. What invariant is it protecting?
    I am not sure about this one.
     **/

    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public returns (bool) {
        address spender = msg.sender;

        require(to != address(0), "ERC20: transfer to zero address");
        require(_balances[from] >= amount, "ERC20: insufficient balance");
        require(
            _allowances[from][spender] >= amount,
            "ERC20: transfer amount exceeds allowance"
        );

        _balances[from] -= amount;
        _balances[to] += amount;
        _allowances[from][spender] -= amount;

        emit Transfer(from, to, amount);
        return true;
    }

    /**
    1. What state does this function read?
    I am not sure about this one.
    2. What state does this function change?
    I am not sure about this one.
    3. What conditions must be true before it runs?
    I am not sure about this one.
    4. What must be true after it finishes?
    I am not sure about this one.
    5. What invariant is it protecting?
    I am not sure about this one.
     **/

    // CONSTRUCTOR TO MINT INITIAL SUPPLY
    constructor(uint256 initialSupply) {
        _totalSupply = initialSupply * 10 ** uint256(decimals);
        _balances[msg.sender] = _totalSupply;

        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    /**
    1. What state does this function read?
    This is a contructor function so it doesn't read any state.
    2. What state does this function change?
    It changes the _totalSupply variable and the balance of the deployer (msg.sender).
    3. What conditions must be true before it runs?
    I am not sure about this one.
    4. What must be true after it finishes?
    I am not sure about this one.
    5. What invariant is it protecting?
    I am not sure about this one.
     **/

    /**
---

# ERC20 Contract Review — Function-by-Function Analysis

**Contract:** `BlokanToken.sol`
**Purpose:** Establish clear understanding of what each function does, what state it touches, and which invariants it protects.

---

## Global ERC20 Invariants (Reference)

These must hold true **at all times**:

1. `totalSupply == sum of all balances`
2. No balance can be negative
3. Allowances can never be negative
4. Transfers do **not** change `totalSupply`
5. Minting increases `totalSupply`
6. Burning decreases `totalSupply`
7. All state-changing operations emit correct events

---

## 1. `totalSupply()`

### Function Signature

```solidity
function totalSupply() public view returns (uint256)
```

### Purpose

Returns the total number of tokens in existence.

### State Interaction

* **Reads:** `_totalSupply`
* **Writes:** None

### Preconditions

* None

### Postconditions

* Returns the current value of `_totalSupply`
* Does not modify any state

### Invariant Relation

* Exposes the **supply consistency invariant**
* Used by tests and external callers to verify correctness

---

## 2. `balanceOf(address account)`

### Function Signature

```solidity
function balanceOf(address account) public view returns (uint256)
```

### Purpose

Returns the token balance of a specific account.

### State Interaction

* **Reads:** `_balances[account]`
* **Writes:** None

### Preconditions

* None
* Zero address queries are allowed (returns 0)

### Postconditions

* Returns stored balance for the account

### Invariant Relation

* Used to verify **balance correctness**
* Supports conservation of value checks

---

## 3. `allowance(address owner, address spender)`

### Function Signature

```solidity
function allowance(address owner, address spender) public view returns (uint256)
```

### Purpose

Returns remaining number of tokens `spender` is allowed to transfer on behalf of `owner`.

### State Interaction

* **Reads:** `_allowances[owner][spender]`
* **Writes:** None

### Preconditions

* None

### Postconditions

* Returns current allowance value

### Invariant Relation

* Allowances must never be negative
* Allowance decreases only via `transferFrom`

---

## 4. `transfer(address to, uint256 amount)`

### Function Signature

```solidity
function transfer(address to, uint256 amount) public returns (bool)
```

### Purpose

Moves tokens from `msg.sender` to recipient.

### State Interaction

* **Reads:** `_balances[msg.sender]`
* **Writes:**

  * `_balances[msg.sender] -= amount`
  * `_balances[to] += amount`

### Preconditions

* `to != address(0)`
* Sender balance ≥ `amount`

### Postconditions

* Sender balance reduced by `amount`
* Recipient balance increased by `amount`
* `totalSupply` unchanged
* `Transfer` event emitted

### Invariant Relation

* **Value conservation invariant**
* Tokens are neither created nor destroyed

---

## 5. `approve(address spender, uint256 amount)`

### Function Signature

```solidity
function approve(address spender, uint256 amount) public returns (bool)
```

### Purpose

Sets allowance for `spender` to spend caller’s tokens.

### State Interaction

* **Reads:** `msg.sender`
* **Writes:** `_allowances[owner][spender] = amount`

### Preconditions

* `spender != address(0)`

### Postconditions

* Allowance overwritten to `amount`
* `Approval` event emitted

### Invariant Relation

* **Explicit delegation invariant**
* Spending power must be explicitly granted

### Notes (Security-Relevant)

* Subject to known ERC20 allowance race condition
* Standard-compliant behavior

---

## 6. `transferFrom(address from, address to, uint256 amount)`

### Function Signature

```solidity
function transferFrom(address from, address to, uint256 amount) public returns (bool)
```

### Purpose

Allows a spender to transfer tokens on behalf of another account.

### State Interaction

* **Reads:**

  * `_balances[from]`
  * `_allowances[from][msg.sender]`
* **Writes:**

  * `_balances[from] -= amount`
  * `_balances[to] += amount`
  * `_allowances[from][msg.sender] -= amount`

### Preconditions

* `to != address(0)`
* `from` balance ≥ `amount`
* Allowance ≥ `amount`

### Postconditions

* Balance transferred from `from` to `to`
* Allowance reduced by `amount`
* `totalSupply` unchanged
* `Transfer` event emitted

### Invariant Relation

* **Delegated transfer invariant**
* Allowance and balances remain consistent

---

## 7. Constructor (Initial Mint)

### Function Signature

```solidity
constructor(uint256 initialSupply)
```

### Purpose

Mints initial supply to deployer.

### State Interaction

* **Writes:**

  * `_totalSupply`
  * `_balances[msg.sender]`

### Preconditions

* None

### Postconditions

* `_totalSupply` initialized
* Deployer receives full supply
* `Transfer(address(0), deployer, supply)` emitted

### Invariant Relation

* **Supply initialization invariant**
* Minting must increase `totalSupply`
* Minting must emit `Transfer` from zero address

---

## Summary Assessment

### ✅ What Is Correct

* ERC20 interface compliance
* State updates follow ERC20 rules
* Events emitted correctly
* Invariants preserved
* Constructor mint is correct

### ⚠️ What Is Not Implemented (by design)

* No public `mint` function
* No `burn` function
* No access control (owner, roles)

This is acceptable for:

* Learning
* Mini-audit
* Test-driven reasoning

---

## Next Logical Step (Reference)

**Do NOT add features yet.**

Next steps should be:

1. Write tests that assert postconditions
2. Write revert tests for failed preconditions
3. Verify invariants through testing

---
      
**/
}
