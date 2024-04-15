// SPDX-License-Identifier: MIT
pragma solidity >=0.4.16 <0.9.0;

import "./IERC20.sol";
import "./SafeMath.sol";

contract Cryptodz is IERC20 {
    using SafeMath for uint256;

    string public name;
    string public symbol;
    uint8 public decimals;
    uint256 public totalSupply;
    uint256 public tokenPrice; // Price of the token in wei

    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    constructor(string memory _name, string memory _symbol, uint8 _decimals, uint256 _initialSupply, uint256 _tokenPrice) {
        name = _name;
        symbol = _symbol;
        decimals = _decimals;
        totalSupply = _initialSupply * 10 ** uint256(decimals);
        balanceOf[msg.sender] = totalSupply;
        tokenPrice = _tokenPrice;
    }

    // Function to mint tokens
    function mint(address account, uint256 amount) public {
        require(account != address(0), "ERC20: mint to the zero address");

        totalSupply = totalSupply.add(amount);
        balanceOf[account] = balanceOf[account].add(amount);
        emit Transfer(address(0), account, amount);
    }

    // Function to buy tokens with Ether
    function buyTokens() public payable {
        require(msg.value > 0, "Value must be greater than 0");

        uint256 amount = msg.value * 10 ** uint256(decimals) / tokenPrice; // Calculate the amount of tokens based on the sent Ether and token price
        require(balanceOf[address(this)] >= amount, "Insufficient tokens in contract");

        balanceOf[msg.sender] += amount;
        balanceOf[address(this)] -= amount;

        emit Transfer(address(this), msg.sender, amount);
    }

    // Function to sell tokens for Ether
    function sellTokens(uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");
        require(balanceOf[msg.sender] >= amount, "Insufficient balance");

        uint256 etherAmount = amount * tokenPrice / 10 ** uint256(decimals); // Calculate the amount of Ether to send based on the token amount and token price
        require(address(this).balance >= etherAmount, "Contract has insufficient balance");

        balanceOf[msg.sender] -= amount;
        balanceOf[address(this)] += amount;

        payable(msg.sender).transfer(etherAmount);

        emit Transfer(msg.sender, address(this), amount);
    }

    // ERC-20 functions

    function transfer(address recipient, uint256 amount) public override returns (bool) {
        _transfer(msg.sender, recipient, amount);
        return true;
    }

    function approve(address spender, uint256 amount) public override returns (bool) {
        allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);
        return true;
    }

    function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
        require(allowance[sender][msg.sender] >= amount, "ERC20: insufficient allowance");
        _transfer(sender, recipient, amount);
        allowance[sender][msg.sender] -= amount;
        return true;
    }

    function _transfer(address sender, address recipient, uint256 amount) internal {
        require(sender != address(0), "ERC20: transfer from the zero address");
        require(recipient != address(0), "ERC20: transfer to the zero address");
        require(balanceOf[sender] >= amount, "ERC20: insufficient balance");

        balanceOf[sender] -= amount;
        balanceOf[recipient] += amount;
        emit Transfer(sender, recipient, amount);
    }

    // Function to set token price
    function setTokenPrice(uint256 _price) public {
        tokenPrice = _price;
    }

    // Function to get token price
    function getTokenPrice() public view returns (uint256) {
        return tokenPrice;
    }
}
