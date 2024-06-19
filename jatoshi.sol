// SPDX-License-Identifier: MIT
pragma solidity >=0.8.2 <0.9.0;

/*
El nombre del contrato es homenaje al creador de Bitcoin, Satoshi Nakamoto, con el JA por JuanAntonio
* Ejemplo de: https://www.elladodelmal.com/2021/12/blockchain-smartcontrats-primer-smart.html
* https://github.com/chgara/introasmartcontracts
*/
contract Jatoshi {
    address public owner;
    string public ownerName="jatoshi";
    uint256 public ownerAge=26;
    string[] public posts;

    constructor(address _firstOwner) {
        owner=_firstOwner;
    }

    //Los modificadores sirven para romper el flujo de ejecución de una función en caso de que ciertas condiciones no se cumplan.
    modifier onlyOwner() {
        //msg.sender: La direccion de eth de quién llamo la funcion.
        require(msg.sender == owner, "Error, no eres el propietario");
        _;
    }
   
    modifier existsUrl(string memory _url) {
         require(_existsUrl(_url), "La url NO existe");
         _;
    }
    modifier notExistsUrl(string memory _url) {
         require(!_existsUrl(_url), "La url YA existe");
         _;
    }
    //Fin de los modificadores

    //en la función le pasamos el modificador para que haga la comprobación
    function setOwnerSate( address _newOner, string memory _ownerName, uint256 _age) public onlyOwner {
        owner = _newOner;
        ownerName = _ownerName;
        ownerAge = _age;
    }

    function addPostUrl (string memory _url) public  onlyOwner notExistsUrl(_url) {      
        posts.push(_url);
    }

    function deletePostUrl(string memory _url) public onlyOwner existsUrl(_url) {        
        for (uint i=0; i<posts.length;i++) {
            if (keccak256(abi.encodePacked(posts[i])) == keccak256(abi.encodePacked(_url))) {
                delete posts[i];
            }
        }
    }
    
    function getPosts() public view returns (string[] memory) {
        return posts;
    }
    
    function _existsUrl (string memory _url) private view returns (bool) {
         for (uint256 i = 0; i < posts.length; i++) {
            if (keccak256(abi.encodePacked(posts[i])) == keccak256(abi.encodePacked(_url))) {
                return true;
            }
        }
        return false;
    }

    


    

}