// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

// Definición del NFT
struct NFT {
    uint256 id; // Identificador único del NFT
    string nombre; // Nombre del NFT
}

// Definición de la puja
struct Puja {
    address licitador; // Dirección del usuario que puja
    uint256 cantidad; // Cantidad de la puja
}

contract SistemaDePujasJAGD {
    // NFT que se está subastando
    NFT public nft;

    // Puja actual más alta
    Puja public pujaActual;

    // Mapeo para registrar las pujas de cada usuario
    mapping(address => Puja) public pujasPorUsuario;

    // Evento para notificar un cambio en la puja ganadora
    event PujaGanadora(address licitador, uint256 cantidad);

    // Evento para notificar un intento de devolución de fondos fallido
    event DevolucionFallida(address licitadorAnterior, uint256 cantidad);

    constructor(uint256 _id, string memory _nombre) {
        nft = NFT(_id, _nombre);
    }

    // Función para pujar por el NFT
    function pujar(uint256 _cantidad) public payable {
        require(_cantidad > pujaActual.cantidad, "La puja debe ser mayor que la actual");

        // Actualizar la puja actual
        pujaActual = Puja(msg.sender, _cantidad);

        // Registrar la puja del usuario
        pujasPorUsuario[msg.sender] = pujaActual;

        // Si hay un licitador anterior, intentar devolver sus fondos
        if (pujaActual.licitador != address(0)) {
            address licitadorAnterior = pujaActual.licitador;
            uint256 cantidadAnterior = pujasPorUsuario[licitadorAnterior].cantidad;

            // Enviar la devolución de fondos
            (bool success,) = licitadorAnterior.call{value: cantidadAnterior}("");

            // Si la devolución falla, emitir un evento
            if (!success) {
                emit DevolucionFallida(licitadorAnterior, cantidadAnterior);
            }
        }

        // Emitir un evento para notificar el cambio de ganador
        emit PujaGanadora(msg.sender, _cantidad);
    }

    // Función para obtener información del NFT
    function getNFT() public view returns (uint256, string memory) {
        return (nft.id, nft.nombre);
    }

    // Función para obtener la puja actual
    function getPujaActual() public view returns (address, uint256) {
        return (pujaActual.licitador, pujaActual.cantidad);
    }

    // Función para obtener la puja de un usuario
    function getPujaDeUsuario(address _usuario) public view returns (uint256) {
        return pujasPorUsuario[_usuario].cantidad;
    }
}