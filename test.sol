// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
//import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
//import "@openzeppelin/contracts/access/Ownable.sol";
contract PjFactory  {
    uint idDigits = 16;
    uint idModulus = 1000 ** idDigits;
    struct Pj{
        uint id;
        string rol;
        string name;
        uint128 hp;
        uint128 level;
        uint128 attackPoints;
        uint128 defensePoints;
    }
    Pj[] public pjs;

    mapping (uint => address) public pjToOwner;
    mapping (address => uint)  ownerPjCount;

    function _generateRandomId(string memory _str) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % idModulus;
    }
    function _createNewPj(string memory _name, uint _id,string memory _rol) internal {
        Pj memory myPj=Pj(_id, _rol, _name,50,1,20,30);
        pjs.push(myPj);
        pjToOwner[pjs.length-1] = msg.sender;
        ownerPjCount[msg.sender]++;
        //emit NewZombie(id, _name, _dna);
    }
    function createPj(string memory _name,string memory _rol) public{
        //require(ownerZombieCount[msg.sender] == 0);
        uint randId= _generateRandomId(_name);
        randId = randId - randId % 100;
         _createNewPj(_name, randId,_rol);
    }
    function getZombiesByOwner() external view returns(Pj[] memory) {
        Pj[] memory result = new Pj[](ownerPjCount[msg.sender]);
        uint counter = 0;
        for (uint i = 0; i < pjs.length; i++) {
        if (pjToOwner[i] == msg.sender) {
            result[counter] = pjs[i];
            counter++;
        }
        }
        return result;
    }

}