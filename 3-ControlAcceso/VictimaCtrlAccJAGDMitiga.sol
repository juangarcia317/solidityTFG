// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract VictimaCtrlAccJAGDMitiga {

    address public owner; // Dirección del propietario del contrato

    mapping(address => bool) public isAuthorized; // Mapeo que almacena direcciones autorizadas

    constructor() {
        owner = msg.sender; // El propietario del contrato es quien despliega el contrato
    }

    function retirarFondos(uint256 amount) public {
        require(msg.sender == owner || isAuthorized[msg.sender], "No autorizado para retirar fondos");
        // Retirar fondos a la dirección del remitente si es el propietario o está autorizado
        payable(msg.sender).transfer(amount);
    }

    function authorizeAddress(address addr) public {
        require(msg.sender == owner && addr != owner, "Solo el propietario puede autorizar direcciones y no se puede autorizar a si mismo");
        isAuthorized[addr] = true; // Agregar dirección al mapeo de direcciones autorizadas
    }
     //Función para enviar Ether (fondos) al contrato durante la llamada a la función
    function deposit() public payable {}
    
    //Obtener el balance actual
    function getBalance() public view returns(uint) {
        return address(this).balance;        
    }
}