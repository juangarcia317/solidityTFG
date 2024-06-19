// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract DCVictimaJAGD {
    // Mapeo para almacenar el balance de cada usuario
    mapping(address => uint256) public balances;

    // Función para retirar fondos
    function withdraw(address _recipient, uint256 _amount) public {
        require(balances[msg.sender] >= _amount, "Saldo insuficiente");

        // Actualizar el balance del remitente
        balances[msg.sender] -= _amount;

        // Enviar fondos al destinatario
        payable(_recipient).transfer(_amount); 
    }

    //Función para enviar Ether (fondos) al contrato durante la llamada a la función
    function deposit() public payable {}   

    //Obtener el balance actual
    function getBalance() public view returns(uint) {
        return address(this).balance;        
    }
}