// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;
//import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
contract PjFactory {
    uint idDigits = 5;
    uint idModulus = 10 ** idDigits;

    struct Pj {
        uint id;
        string rol;
        string name;
        uint128 hp;
        uint128 level;
        uint128 attackPoints;
        uint128 defensePoints;
        uint128 agilityPoints;
    }
    Pj[] public pjs;

    mapping(uint => address) public pjToOwner;
    mapping(address => uint) ownerPjCount;

    modifier validClass(string calldata _class) {
        require(
            keccak256(abi.encodePacked((_class))) ==
                keccak256(abi.encodePacked(("Defense"))) ||
                keccak256(abi.encodePacked((_class))) ==
                keccak256(abi.encodePacked(("Attack"))) ||
                keccak256(abi.encodePacked((_class))) ==
                keccak256(abi.encodePacked(("Agile"))),
            "Given Class not found"
        );
        _;
    }

    function _generateRandomId(
        string calldata _str
    ) private view returns (uint) {
        uint rand = uint(keccak256(abi.encodePacked(_str)));
        return rand % idModulus;
    }

    function _createNewPj(
        string calldata _name,
        uint _id,
        string calldata _class
    ) private {
        (
            uint128 _hp,
            uint128 _attackPoints,
            uint128 _defensePoints,
            uint128 _agilePoints
        ) = _calculateBasePjValues(_class);
        Pj memory myPj = Pj(
            _id,
            _class,
            _name,
            _hp,
            1,
            _attackPoints,
            _defensePoints,
            _agilePoints
        );
        pjs.push(myPj);
        pjToOwner[pjs.length - 1] = msg.sender;
        ownerPjCount[msg.sender]++;
        //emit NewZombie(id, _name, _dna);
    }

    function _calculateBasePjValues(
        string calldata _class
    ) private pure returns (uint128, uint128, uint128, uint128) {
        uint128 hp;
        uint128 attackPoints;
        uint128 defensePoints;
        uint128 agilePoints;

        if (
            keccak256(abi.encodePacked((_class))) ==
            keccak256(abi.encodePacked(("Defense")))
        ) {
            hp = 50;
            attackPoints = 5;
            defensePoints = 10;
            agilePoints = 7;
        } else if (
            keccak256(abi.encodePacked((_class))) ==
            keccak256(abi.encodePacked(("Attack")))
        ) {
            hp = 42;
            attackPoints = 10;
            defensePoints = 7;
            agilePoints = 5;
        } else {
            hp = 60;
            attackPoints = 7;
            defensePoints = 8;
            agilePoints = 14;
        }

        return (hp, attackPoints, defensePoints, agilePoints);
    }

    function createPj(
        string calldata _name,
        string calldata _class
    ) external validClass(_class) {
        //require(ownerZombieCount[msg.sender] == 0);
        uint randId = _generateRandomId(_name);
        randId = randId - (randId % 100);
        _createNewPj(_name, randId, _class);
    }

    function getZombiesByOwner() external view returns (Pj[] memory) {
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