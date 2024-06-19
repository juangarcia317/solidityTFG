// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract DCAtacanteJAGD {
    // Función para retirar fondos de un contrato objetivo
    function withdrawFunds(address _targetContract, address _recipient, uint256 _amount) public {
        // Llamada delegada al contrato objetivo
        _targetContract.delegatecall(abi.encodeWithSignature("withdraw(address,uint256)", _recipient, _amount));
    }

    //Obtener el balance actual
    function getBalance() public view returns(uint) {
        return address(this).balance;        
    }
}