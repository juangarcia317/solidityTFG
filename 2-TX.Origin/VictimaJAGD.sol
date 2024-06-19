// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract VictimaJAGD {
    address public owner;

    constructor() payable {
        owner = msg.sender;
    }

    function deposit() public payable {}

    function transfer(address payable _to, uint _amount) public {
        require(tx.origin == owner, "No eres el propietario");
        (bool sent, ) = _to.call{value: _amount}("");
        require(sent, "Transferencia fallida");
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
        
    }

}
