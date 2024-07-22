// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./pjfactory.sol";

contract PjHelper is PjFactory {
    uint randNonce = 0;

    function getPjByOwner() external view returns (Pj[] memory) {
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

    function _randomNumber() internal returns (uint) {
        randNonce++;
        return
            uint(
                keccak256(
                    abi.encodePacked(block.timestamp, msg.sender, randNonce)
                )
            ) % 100;
    }
}
