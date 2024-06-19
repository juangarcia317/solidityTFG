// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

contract transferJAGD{
    
    /*ejemplo en Solidiy de transferencia entre varias cuentas de Juan Antonio Garcia.
    Tener en cuenta que las direcciones cuando van a recibir o transferir ether deben ser de tipo payable */
    function transferEntreCuentas (address payable addr ) public payable {
        /*variable global*/
        addr.transfer(msg.value);
    }

    function revisarBalance (address addr) public view returns (uint256) {
        uint256 balance = addr.balance;
        return (balance);
    }

    /*Cambio 27/05/2024 contrato vulnerable a Reentrancy*/
    mapping (address => uint256 ) public balances;

    function retirarFondos(uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Insufficient funds");
        balances[msg.sender] -= _amount;
        payable(msg.sender).transfer(_amount);
    }

    /*Fin cambio 27/05/2024 */
}