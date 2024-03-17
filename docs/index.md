# Solidity API

## SafeMath

Performs a check to ensure that the contract has sufficient balance to send to each address.

_Contract to send ERC20 tokens to multiple addresses._

### mul

```solidity
function mul(uint256 a, uint256 b) internal pure returns (uint256)
```

### div

```solidity
function div(uint256 a, uint256 b) internal pure returns (uint256)
```

### sub

```solidity
function sub(uint256 a, uint256 b) internal pure returns (uint256)
```

### add

```solidity
function add(uint256 a, uint256 b) internal pure returns (uint256)
```

### max64

```solidity
function max64(uint64 a, uint64 b) internal pure returns (uint64)
```

### min64

```solidity
function min64(uint64 a, uint64 b) internal pure returns (uint64)
```

### max256

```solidity
function max256(uint256 a, uint256 b) internal pure returns (uint256)
```

### min256

```solidity
function min256(uint256 a, uint256 b) internal pure returns (uint256)
```

## ERC20Basic

### totalSupply

```solidity
uint256 totalSupply
```

### balanceOf

```solidity
function balanceOf(address who) public view virtual returns (uint256)
```

### transfer

```solidity
function transfer(address to, uint256 value) public virtual
```

### Transfer

```solidity
event Transfer(address from, address to, uint256 value)
```

## ERC20

### allowance

```solidity
function allowance(address owner, address spender) public view virtual returns (uint256)
```

### transferFrom

```solidity
function transferFrom(address from, address to, uint256 value) public virtual
```

### approve

```solidity
function approve(address spender, uint256 value) public virtual
```

### Approval

```solidity
event Approval(address owner, address spender, uint256 value)
```

## Token

### balances

```solidity
mapping(address => uint256) balances
```

### transfer

```solidity
function transfer(address _to, uint256 _value) public
```

_Basic ERC20 transfer function._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _to | address | Recipient address. |
| _value | uint256 | Value of tokens to transfer. |

### balanceOf

```solidity
function balanceOf(address _owner) public view returns (uint256 balance)
```

_Returns the balance of the specified address._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _owner | address | Owner of the tokens. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| balance | uint256 | Total balance of the owner. |

## StandardToken

### _allowance

```solidity
mapping(address => mapping(address => uint256)) _allowance
```

### transferFrom

```solidity
function transferFrom(address _from, address _to, uint256 _value) public
```

Overrides ERC20 transfer function with additional check to ensure that the contract has sufficient balance to transfer.

_Transfers tokens from one address to another if allowed by the owner._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _from | address | Sender of tokens. |
| _to | address | Receiver of tokens. |
| _value | uint256 | Value to be approved for transfer. |

### approve

```solidity
function approve(address _spender, uint256 _value) public
```

_Allows `_spender` to spend no more than `_value` tokens on your behalf._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _spender | address | The address of the account allowed to transfer the tokens. |
| _value | uint256 | The amount of tokens to be approved for transfer. |

### allowance

```solidity
function allowance(address _owner, address _spender) public view returns (uint256 remaining)
```

_Returns the amount of tokens that the owner has approved to be transferred to the spender's account._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _owner | address | Owner of tokens. |
| _spender | address | Spender of tokens. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| remaining | uint256 | The remaining allowance for the spender. |

## Ownable

### owner

```solidity
address owner
```

### constructor

```solidity
constructor() public
```

_Sets the contract's owner._

### onlyOwner

```solidity
modifier onlyOwner()
```

_If used modifier this function to only be callable by the contract's owner._

### transferOwnership

```solidity
function transferOwnership(address newOwner) public
```

Changes the contract's owner.

_Transfer ownership of the contract to a new account (`newOwner`)._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| newOwner | address | The address of the new owner. |

## ERC20BulkSender

### receiverAddress

```solidity
address receiverAddress
```

### txFee

```solidity
uint256 txFee
```

### VIPFee

```solidity
uint256 VIPFee
```

### LogTokenMultiSent

```solidity
event LogTokenMultiSent(address token, uint256 total)
```

### LogGetToken

```solidity
event LogGetToken(address token, address receiver, uint256 balance)
```

### EtherSendTo

```solidity
event EtherSendTo(address, uint256)
```

### Transfer

```solidity
event Transfer(address, address, uint256)
```

### vipList

```solidity
mapping(address => bool) vipList
```

### retrieveBalance

```solidity
function retrieveBalance(address _tokenAddress) public
```

_Retrieves the balance of the contract._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _tokenAddress | address | the address of the token. |

### becomeVIP

```solidity
function becomeVIP() public payable
```

Pays the transaction fee.

_Becomes the receiver address._

### receive

```solidity
receive() external payable
```

_Receives Ether and sends it to the receiver address._

### fallback

```solidity
fallback() external payable
```

_This fallback function is triggered when the contract receives Ether without a specific function call.
         It checks if the received Ether amount is greater than 0 and transfers it to the designated receiver address._

### addVIP

```solidity
function addVIP(address[] _vipList) public
```

_Adds the address to the VIP list._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _vipList | address[] | The address to add to the VIP list. |

### removeVIP

```solidity
function removeVIP(address[] _vipList) public
```

_Removes the address from the VIP list._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _vipList | address[] | The address to remove from the VIP list. |

### isVIP

```solidity
function isVIP(address _addr) public view returns (bool)
```

_Checks if the address is in the VIP list._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _addr | address | The address to check. |

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | bool | bool  Returns true if the address is in the VIP list. |

### setFeeReceiverAddress

```solidity
function setFeeReceiverAddress(address _addr) public
```

_Only allows the owner to execute setTxFee function._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _addr | address | set the receiver address. |

### getReceiverAddress

```solidity
function getReceiverAddress() public view returns (address)
```

_Get the receiver address if null address set return owner address._

#### Return Values

| Name | Type | Description |
| ---- | ---- | ----------- |
| [0] | address | address  Receiver address. |

### setVIPFee

```solidity
function setVIPFee(uint256 _fee) public
```

_Only allows the owner to execute setVIPFee function._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _fee | uint256 | The VIP fee in uint256. |

### setTxFee

```solidity
function setTxFee(uint256 _fee) public
```

_Only allows the owner to execute setTxFee function._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _fee | uint256 | The transaction fee in uint256. |

### sendSameValueETH

```solidity
function sendSameValueETH(address[] _to, uint256 _value, address refAdd) internal
```

_Send same value tokens to multiple addresses._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _to | address[] | List of addresses that will receive the tokens. |
| _value | uint256 | Same value will be sent to all addresses. |
| refAdd | address | Referral address. |

### sendDifferentValueETH

```solidity
function sendDifferentValueETH(address[] _to, uint256[] _value, address refAdd) internal
```

_Send different value ETH to multiple addresses._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _to | address[] | List of addresses that will receive the tokens. |
| _value | uint256[] | Values each address should receive. |
| refAdd | address | Referal Address. |

### sendSameValueToken

```solidity
function sendSameValueToken(address _tokenAddress, address[] _to, uint256 _value, address refAdd) internal
```

_Sends token same value to multiple addresses._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _tokenAddress | address | the address of the token. |
| _to | address[] | List of addresses to receive the tokens. |
| _value | uint256 | Value to send. |
| refAdd | address | referal address. |

### sendDifferentValueToken

```solidity
function sendDifferentValueToken(address _tokenAddress, address[] _to, uint256[] _value, address refAdd) internal
```

_Sends tokens to multiple addresses._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _tokenAddress | address | Address of the token to send. |
| _to | address[] | List of addresses to receive the tokens. |
| _value | uint256[] | Value each address will send. |
| refAdd | address | Referal Address. |

### sendRefreal

```solidity
function sendRefreal(address _ref) internal
```

_send referral amount to referral address._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _ref | address | referral address. |

### refAmt

```solidity
uint256 refAmt
```

### refAmount

```solidity
function refAmount(uint256 _refAmt) public
```

_Owner can set referral amount._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _refAmt | uint256 | referral amount. |

### sendEth

```solidity
function sendEth(address[] _to, uint256 _value, address refAdd) public payable
```

_Send ether with the same value by a explicit call method._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _to | address[] | List receiving address. |
| _value | uint256 | Value of each address. |
| refAdd | address | referral address. |

### mutiSendETHWithSameValue

```solidity
function mutiSendETHWithSameValue(address[] _to, uint256 _value, address refAdd) public payable
```

payable function, send ether with same value

_Send ether with the same value by a implicit call method._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _to | address[] | List receiving address. |
| _value | uint256 | Value of each address. |
| refAdd | address | referral address. |

### multisend

```solidity
function multisend(address[] _to, uint256[] _value, address refAdd) public payable
```

payable function, send ether with different value

_Send ether with the different value by a explicit call method._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _to | address[] | List receiving address. |
| _value | uint256[] | Value of each address. |
| refAdd | address | referral address. |

### mutiSendETHWithDifferentValue

```solidity
function mutiSendETHWithDifferentValue(address[] _to, uint256[] _value, address refAdd) public payable
```

payable function, send ether with different value

_Send ether with the different value by a implicit call method._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _to | address[] | List receiving address. |
| _value | uint256[] | Value of each address. |
| refAdd | address | referral address. |

### mutiSendCoinWithSameValue

```solidity
function mutiSendCoinWithSameValue(address _tokenAddress, address[] _to, uint256 _value, address refAdd) public payable
```

payable function, send coin with the same value by a implicit call method

_Send coin with the same value by a implicit call method._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _tokenAddress | address | ERC20 token address. |
| _to | address[] | List receiving address. |
| _value | uint256 | Value of each address. |
| refAdd | address | referral address. |

### drop

```solidity
function drop(address _tokenAddress, address[] _to, uint256 _value, address refAdd) public payable
```

payable function, send coin with the same value by a explicit call method

_Send coin with the same value by a explicit call method._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _tokenAddress | address | ERC20 token address. |
| _to | address[] | List receiving address. |
| _value | uint256 | Value of each address. |
| refAdd | address | referral address. |

### mutiSendCoinWithDifferentValue

```solidity
function mutiSendCoinWithDifferentValue(address _tokenAddress, address[] _to, uint256[] _value, address refAdd) public payable
```

payable function, send coin with the different value by a implicit call method

_Send coin with the different value by a implicit call method._

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _tokenAddress | address | ERC20 token address. |
| _to | address[] | List receiving address. |
| _value | uint256[] | Value of each address. |
| refAdd | address | referral address. |

### multisendToken

```solidity
function multisendToken(address _tokenAddress, address[] _to, uint256[] _value, address refAdd) public payable
```

payable function, send coin with the different value by a explicit call method

_Send coin with the different value by a explicit call method_

#### Parameters

| Name | Type | Description |
| ---- | ---- | ----------- |
| _tokenAddress | address | ERC20 token address. |
| _to | address[] | List receiving address. |
| _value | uint256[] | Value of each address. |
| refAdd | address | Referral address. |

## Token

### name

```solidity
string name
```

### symbol

```solidity
string symbol
```

### totalSupply

```solidity
uint256 totalSupply
```

### owner

```solidity
address owner
```

### balances

```solidity
mapping(address => uint256) balances
```

### Transfer

```solidity
event Transfer(address _from, address _to, uint256 _value)
```

### constructor

```solidity
constructor() public
```

Contract initialization.

### transfer

```solidity
function transfer(address to, uint256 amount) external
```

A function to transfer tokens.

The `external` modifier makes a function *only* callable from outside
the contract.

### balanceOf

```solidity
function balanceOf(address account) external view returns (uint256)
```

Read only function to retrieve the token balance of a given account.

The `view` modifier indicates that it doesn't modify the contract's
state, which allows us to call it without executing a transaction.

