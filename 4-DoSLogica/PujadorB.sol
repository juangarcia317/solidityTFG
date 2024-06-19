// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

import "./SistemaDePujasJAGD.sol";

contract PujadorB {
    // Dirección del contrato de subasta
    address public sistemaDePujasAddress;

    // Constructor del contrato
    constructor(address _sistemaDePujasAddress) {
        sistemaDePujasAddress = _sistemaDePujasAddress;
    }

    // Función para pujar en la subasta
    function pujar(uint256 _cantidad) public payable {
        // Instancia del contrato de subasta
        SistemaDePujasJAGD sistemaDePujas = SistemaDePujasJAGD(sistemaDePujasAddress);

        // Validar la cantidad de la puja
        require(_cantidad > 0, "La cantidad de la puja debe ser mayor que cero");

        // Transferir la cantidad de la puja al contrato de subasta
        (bool success,) = address(sistemaDePujas).call{value: _cantidad}(abi.encodeWithSignature("pujar(uint256)", _cantidad));
        
        if (!success) {
            revert("La puja no se pudo realizar");
        }         
    }

    // Función para obtener información del NFT
    function getInformacionNFT() public view returns (uint256, string memory) {
        // Instancia del contrato de subasta
        SistemaDePujasJAGD sistemaDePujas = SistemaDePujasJAGD(sistemaDePujasAddress);

        // Obtener información del NFT
        return sistemaDePujas.getNFT();
    }

    // Función para obtener la puja actual
    function getPujaActual() public view returns (address, uint256) {
        // Instancia del contrato de subasta
        SistemaDePujasJAGD sistemaDePujas = SistemaDePujasJAGD(sistemaDePujasAddress);

        // Obtener la puja actual
        return sistemaDePujas.getPujaActual();
    }
  
    //Función para enviar Ether (fondos) al contrato durante la llamada a la función
    function deposit() public payable {}
}
