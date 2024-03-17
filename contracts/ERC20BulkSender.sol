
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @author  Birds of Space
 * @title   ERC20BulkSender
 * @dev     Contract to send ERC20 tokens to multiple addresses.
 * @notice  Performs a check to ensure that the contract has sufficient balance to send to each address.
 */

library SafeMath {
    function mul(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a * b;
        require(a == 0 || c / a == b);
        return c;
    }

    function div(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b > 0);
        uint256 c = a / b;
        require(a == b * c + (a % b));
        return c;
    }

    function sub(uint256 a, uint256 b) internal pure returns (uint256) {
        require(b <= a);
        return a - b;
    }

    function add(uint256 a, uint256 b) internal pure returns (uint256) {
        uint256 c = a + b;
        require(c >= a);
        return c;
    }

    function max64(uint64 a, uint64 b) internal pure returns (uint64) {
        return a >= b ? a : b;
    }

    function min64(uint64 a, uint64 b) internal pure returns (uint64) {
        return a < b ? a : b;
    }

    function max256(uint256 a, uint256 b) internal pure returns (uint256) {
        return a >= b ? a : b;
    }

    function min256(uint256 a, uint256 b) internal pure returns (uint256) {
        return a < b ? a : b;
    }
}

abstract contract ERC20Basic {
    uint256 public totalSupply;

    function balanceOf(address who) public view virtual returns (uint256);

    function transfer(address to, uint256 value) public virtual;

    event Transfer(address indexed from, address indexed to, uint256 value);
}

abstract contract ERC20 is ERC20Basic {
    function allowance(address owner, address spender)
        public
        view
        virtual
        returns (uint256);

    function transferFrom(
        address from,
        address to,
        uint256 value
    ) public virtual;

    function approve(address spender, uint256 value) public virtual;

    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
}

contract Token is ERC20Basic {
    using SafeMath for uint256;

    mapping(address => uint256) balances;

    /**
     * @dev     Basic ERC20 transfer function.
     * @param   _to  Recipient address.
     * @param   _value  Value of tokens to transfer.
     */
    function transfer(address _to, uint256 _value) public override {
        balances[msg.sender] = balances[msg.sender].sub(_value);
        balances[_to] = balances[_to].add(_value);
        emit Transfer(msg.sender, _to, _value);
    }

    /**
     * @dev     Returns the balance of the specified address.
     * @param   _owner  Owner of the tokens.
     * @return  balance  Total balance of the owner.
     */
    function balanceOf(address _owner)
        public
        view
        override
        returns (uint256 balance)
    {
        return balances[_owner];
    }
}

contract StandardToken is Token, ERC20 {
    using SafeMath for uint256;

    mapping(address => mapping(address => uint256)) _allowance;

    /**
     * @notice  Overrides ERC20 transfer function with additional check to ensure that the contract has sufficient balance to transfer.
     * @dev     Transfers tokens from one address to another if allowed by the owner.
     * @param   _from  Sender of tokens.
     * @param   _to  Receiver of tokens.
     * @param   _value  Value to be approved for transfer.
     */
    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public override {
        balances[_to] = balances[_to].add(_value);
        balances[_from] = balances[_from].sub(_value);
        _allowance[_from][msg.sender] = _allowance[_from][msg.sender].sub(
            _value
        );
        emit Transfer(_from, _to, _value);
    }
    
    /**
     * @dev     Allows `_spender` to spend no more than `_value` tokens on your behalf.
     * @param   _spender  The address of the account allowed to transfer the tokens.
     * @param   _value  The amount of tokens to be approved for transfer.
     */
    function approve(address _spender, uint256 _value) public override {
        require((_value == 0) || (_allowance[msg.sender][_spender] == 0));
        _allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
    }

    /**
     * @dev    Returns the amount of tokens that the owner has approved to be transferred to the spender's account.
     * @param   _owner  Owner of tokens.
     * @param   _spender  Spender of tokens.
     * @return  remaining The remaining allowance for the spender.
     */
    function allowance(address _owner, address _spender)
        public
        view
        override
        returns (uint256 remaining)
    {
        return _allowance[_owner][_spender];
    }
}

contract Ownable {
    address public owner;

    /**
     * @dev     Sets the contract's owner.
     */
    constructor() {
        owner = msg.sender;
    }

    /**
     * @dev     If used modifier this function to only be callable by the contract's owner.
     */
    modifier onlyOwner() {
        require(msg.sender == owner);
        _;
    }

    /**
     * @notice  Changes the contract's owner.
     * @dev     Transfer ownership of the contract to a new account (`newOwner`).
     * @param   newOwner  The address of the new owner.
     */
    function transferOwnership(address newOwner) public onlyOwner {
        if (newOwner != address(0)) {
            owner = newOwner;
        }
    }
}

contract ERC20BulkSender is Ownable {
    using SafeMath for uint256;

    address public receiverAddress;
    uint256 public txFee = 0.01 ether;
    uint256 public VIPFee = 0.001 ether;

    event LogTokenMultiSent(address token, uint256 total);
    event LogGetToken(address token, address receiver, uint256 balance);
    event EtherSendTo(address, uint256);
    event Transfer(address, address, uint256);

    mapping(address => bool) internal vipList;

    /**
     * @dev     Retrieves the balance of the contract.
     * @param   _tokenAddress  the address of the token.
     */
    function retrieveBalance(address _tokenAddress) public onlyOwner {
        address _receiverAddress = getReceiverAddress();
        if (_tokenAddress == address(0)) {
            require(
                payable(_receiverAddress).send(address(this).balance),
                "Can not send the ether value"
            );
            return;
        } else {
            StandardToken token = StandardToken(_tokenAddress);
            uint256 balance = token.balanceOf(address(this));
            token.transfer(_receiverAddress, balance);
            emit LogGetToken(_tokenAddress, _receiverAddress, balance);
        }
    }

    /**
     * @notice  Pays the transaction fee.
     * @dev     Becomes the receiver address.
     */
    function becomeVIP() public payable {
        require(msg.value >= VIPFee, "VIP Fees Does Not match!");
        address _receiverAddress = getReceiverAddress();
        require(payable(_receiverAddress).send(msg.value));
        vipList[msg.sender] = true;
    }

    
    /**
     * @dev     Receives Ether and sends it to the receiver address.
     */
    receive() external payable {
        payable(getReceiverAddress()).transfer(msg.value);
    }

    /**
     * @dev     This fallback function is triggered when the contract receives Ether without a specific function call.
     *          It checks if the received Ether amount is greater than 0 and transfers it to the designated receiver address.
     */
    fallback() external payable {
        if (msg.value > 0) payable(getReceiverAddress()).transfer(msg.value);
    }

    /**
     * @dev     Adds the address to the VIP list.
     * @param   _vipList  The address to add to the VIP list.
     */
    function addVIP(address[] memory _vipList) public onlyOwner {
        for (uint256 i = 0; i < _vipList.length; i++) {
            vipList[_vipList[i]] = true;
        }
    }

    /**
     * @dev     Removes the address from the VIP list.
     * @param   _vipList  The address to remove from the VIP list.
     */
    function removeVIP(address[] memory _vipList) public onlyOwner {
        for (uint256 i = 0; i < _vipList.length; i++) {
            vipList[_vipList[i]] = false;
        }
    }

    /**
     * @dev     Checks if the address is in the VIP list.
     * @param   _addr  The address to check.
     * @return  bool  Returns true if the address is in the VIP list.
     */
    function isVIP(address _addr) public view returns (bool) {
        return _addr == owner || vipList[_addr];
    }

    /**
     * @dev     Only allows the owner to execute setTxFee function.
     * @param   _addr  set the receiver address.
     */
    function setFeeReceiverAddress(address _addr) public onlyOwner {
        require(_addr != address(0));
        receiverAddress = _addr;
    }

    /**
     * @dev     Get the receiver address if null address set return owner address.
     * @return  address  Receiver address.
     */
    function getReceiverAddress() public view returns (address) {
        if (receiverAddress == address(0)) {
            return owner;
        }
        return receiverAddress;
    }


    /**
     * @dev     Only allows the owner to execute setVIPFee function.
     * @param   _fee  The VIP fee in uint256.
     */
    function setVIPFee(uint256 _fee) public onlyOwner {
        VIPFee = _fee;
    }

    /**
     * @dev     Only allows the owner to execute setTxFee function.
     * @param   _fee  The transaction fee in uint256.
     */
    function setTxFee(uint256 _fee) public onlyOwner {
        txFee = _fee;
    }

    /**
     * @dev     Send same value tokens to multiple addresses.
     * @param   _to  List of addresses that will receive the tokens.
     * @param   _value  Same value will be sent to all addresses.
     * @param   refAdd  Referral address.
     */
    function sendSameValueETH(address[] memory _to, uint256 _value, address refAdd) internal {
        uint256 sendAmount = _to.length.sub(1).mul(_value);
        uint256 remainingValue = msg.value;

        bool vip = isVIP(msg.sender);

        if (vip) {
            require(remainingValue == sendAmount, "Amount Does Not match!!");
        } else {
            require(remainingValue == sendAmount.add(txFee), "Fees Does Not match!");
            if (refAdd != address(0)) {
                sendRefreal(refAdd);
            }
        }

        require(_to.length <= 255);

        for (uint8 i = 1; i < _to.length; i++) {
            remainingValue = remainingValue.sub(_value);
            require(payable(_to[i]).send(_value));
            emit EtherSendTo(_to[i], _value);
        }

        emit LogTokenMultiSent(
            0x000000000000000000000000000000000000bEEF,
            msg.value
        );
    }

    /**
     * @dev     Send different value ETH to multiple addresses.
     * @param   _to  List of addresses that will receive the tokens.
     * @param   _value  Values each address should receive.
     * @param   refAdd  Referal Address.
     */
    function sendDifferentValueETH(
        address[] memory _to,
        uint256[] memory _value, 
        address refAdd
    ) internal {
        uint256 sendAmount = _value[0];
        uint256 remainingValue = msg.value;

        bool vip = isVIP(msg.sender);
        if (vip) {
            require(remainingValue == sendAmount, "Amount Does Not match!");
        } else {
            require(remainingValue == sendAmount.add(txFee), "Fees Does Not match!!");
            if (refAdd != address(0)) {
                sendRefreal(refAdd);
            }
        }

        require(_to.length == _value.length);
        require(_to.length <= 255);

        for (uint8 i = 1; i < _to.length; i++) {
            remainingValue = remainingValue.sub(_value[i]);
            require(payable(_to[i]).send(_value[i]));
            emit EtherSendTo(_to[i], _value[i]);
        }
        emit LogTokenMultiSent(
            0x000000000000000000000000000000000000bEEF,
            msg.value
        );
    }

    /**
     * @dev     Sends token same value to multiple addresses.
     * @param   _tokenAddress  the address of the token.
     * @param   _to  List of addresses to receive the tokens.
     * @param   _value  Value to send.
     * @param   refAdd  referal address.
     */
    function sendSameValueToken(
        address _tokenAddress,
        address[] memory _to,
        uint256 _value, 
        address refAdd
    ) internal {
        uint256 sendValue = msg.value;
        bool vip = isVIP(msg.sender);
        if (!vip) {
            require(sendValue == txFee, "Fees Does Not match!!!");
            if (refAdd != address(0)) {
                sendRefreal(refAdd);
            }
        } else {
            if (msg.value > 0) {
                payable(msg.sender).transfer(msg.value);
            }
        }
        require(_to.length <= 255);

        address from = msg.sender;
        uint256 sendAmount = _to.length.sub(1).mul(_value);

        StandardToken token = StandardToken(_tokenAddress);
        for (uint8 i = 1; i < _to.length; i++) {
            token.transferFrom(from, _to[i], _value);
            emit Transfer(from, _to[i], _value);
        }

        emit LogTokenMultiSent(_tokenAddress, sendAmount);
    }

    /**
     * @dev     Sends tokens to multiple addresses.
     * @param   _tokenAddress  Address of the token to send.
     * @param   _to  List of addresses to receive the tokens.
     * @param   _value  Value each address will send.
     * @param   refAdd  Referal Address.
     */
    function sendDifferentValueToken(
        address _tokenAddress,
        address[] memory _to,
        uint256[] memory _value, 
        address refAdd
    ) internal {
        uint256 sendValue = msg.value;
        bool vip = isVIP(msg.sender);
        if (!vip) {
            require(sendValue == txFee, "Fees Does Not match!!!!");
            if (refAdd != address(0)) {
                sendRefreal(refAdd);
            }
        } else {
            if (msg.value > 0) {
                payable(msg.sender).transfer(msg.value);
            }
        }

        require(_to.length == _value.length);
        require(_to.length <= 255);

        uint256 sendAmount = _value[0];
        StandardToken token = StandardToken(_tokenAddress);

        for (uint8 i = 1; i < _to.length; i++) {
            token.transferFrom(msg.sender, _to[i], _value[i]);
            emit Transfer(msg.sender, _to[i], _value[i]);
        }
        emit LogTokenMultiSent(_tokenAddress, sendAmount);
    }

    /**
     * @dev     send referral amount to referral address.
     * @param   _ref  referral address.
     */
    function sendRefreal(address _ref) internal {
        payable(_ref).transfer(refAmt);
    }

    uint256 refAmt = txFee / 100;

    /**
     * @dev     Owner can set referral amount.
     * @param   _refAmt  referral amount.
     */
    function refAmount(uint256 _refAmt) public onlyOwner {
        refAmt = _refAmt;
    }

    /**
     * @dev     Send ether with the same value by a explicit call method.
     * @param   _to  List receiving address.
     * @param   _value  Value of each address.
     * @param   refAdd  referral address.
     */
    function sendEth(address[] memory _to, uint256 _value, address refAdd) public payable {
        sendSameValueETH(_to, _value, refAdd);
    }

    /**
     * @notice  payable function, send ether with same value
     * @dev     Send ether with the same value by a implicit call method.
     * @param   _to  List receiving address.
     * @param   _value  Value of each address.
     * @param   refAdd  referral address.
     */
    function mutiSendETHWithSameValue(address[] memory _to, uint256 _value, address refAdd)
        public
        payable
    {
        sendSameValueETH(_to, _value, refAdd);
    }
    
    /**
     * @notice  payable function, send ether with different value
     * @dev     Send ether with the different value by a explicit call method.
     * @param   _to  List receiving address.
     * @param   _value  Value of each address.
     * @param   refAdd  referral address.
     */
    function multisend(address[] memory _to, uint256[] memory _value, address refAdd)
        public
        payable
    {
        sendDifferentValueETH(_to, _value, refAdd);
    }

    /**
     * @notice  payable function, send ether with different value
     * @dev     Send ether with the different value by a implicit call method.
     * @param   _to  List receiving address.
     * @param   _value  Value of each address.
     * @param   refAdd  referral address.
     */
    function mutiSendETHWithDifferentValue(
        address[] memory _to,
        uint256[] memory _value,
        address refAdd
    ) public payable {
        sendDifferentValueETH(_to, _value, refAdd);
    }

    /**
     * @notice  payable function, send coin with the same value by a implicit call method
     * @dev     Send coin with the same value by a implicit call method.
     * @param   _tokenAddress  ERC20 token address.
     * @param   _to  List receiving address.
     * @param   _value  Value of each address.
     * @param   refAdd  referral address.
     */
    function mutiSendCoinWithSameValue(
        address _tokenAddress,
        address[] memory _to,
        uint256 _value,
        address refAdd
    ) public payable {
        sendSameValueToken(_tokenAddress, _to, _value, refAdd);
    }

    /**
     * @notice  payable function, send coin with the same value by a explicit call method
     * @dev     Send coin with the same value by a explicit call method.
     * @param   _tokenAddress  ERC20 token address.
     * @param   _to  List receiving address.
     * @param   _value  Value of each address.
     * @param   refAdd  referral address.
     */
    function drop(
        address _tokenAddress,
        address[] memory _to,
        uint256 _value,
        address refAdd
    ) public payable {
        sendSameValueToken(_tokenAddress, _to, _value, refAdd);
    }

    /**
     * @notice  payable function, send coin with the different value by a implicit call method
     * @dev     Send coin with the different value by a implicit call method.
     * @param   _tokenAddress  ERC20 token address.
     * @param   _to  List receiving address.
     * @param   _value  Value of each address.
     * @param   refAdd  referral address.
     */
    function mutiSendCoinWithDifferentValue(
        address _tokenAddress,
        address[] memory _to,
        uint256[] memory _value,
        address refAdd
    ) public payable {
        sendDifferentValueToken(_tokenAddress, _to, _value, refAdd);
    }

  
    /**
     * @notice  payable function, send coin with the different value by a explicit call method
     * @dev     Send coin with the different value by a explicit call method
     * @param   _tokenAddress  ERC20 token address.
     * @param   _to  List receiving address.
     * @param   _value  Value of each address.
     * @param   refAdd  Referral address.
     */
    function multisendToken(
        address _tokenAddress,
        address[] memory _to,
        uint256[] memory _value,
        address refAdd
    ) public payable {
        sendDifferentValueToken(_tokenAddress, _to, _value, refAdd);
    }

}