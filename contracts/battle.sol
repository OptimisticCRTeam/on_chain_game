// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./pjhelper.sol";

contract Battle is PjHelper {
    function battle(uint pj1_id, uint pj2_id) external onlyOwnerOf(pj1_id) {
        //Get PJ's based on id
        Pj memory pj1 = pjs[pj1_id];
        Pj memory pj2 = pjs[pj2_id];

        // Initialize temporary HP values for both Pj's
        uint128 pj1Hp = pj1.hp;
        uint128 pj2Hp = pj2.hp;

        // Determine the first attacker based on agility points
        bool pj1Turn = pj1.agilityPoints >= pj2.agilityPoints;

        // Battle loop
        while (pj1Hp > 0 && pj2Hp > 0) {
            if (pj1Turn) {
                // Pj1 attacks Pj2
                uint128 damage = _calculateDamage(pj1, pj2);
                if (damage >= pj2Hp) {
                    pj2Hp = 0;
                } else {
                    pj2Hp -= damage;
                }
            } else {
                // Pj1 attacks Pj2
                uint128 damage = _calculateDamage(pj1, pj2);
                if (damage >= pj1Hp) {
                    pj1Hp = 0;
                } else {
                    pj1Hp -= damage;
                }
            }
            pj1Turn = !pj1Turn;
        }
    }

    function _calculateDamage(
        Pj memory _attacker,
        Pj memory _defender
    ) private returns (uint128) {
        uint hit_chance = (_attacker.agilityPoints /
            (_attacker.agilityPoints + _defender.attackPoints)) * 100; //We need here to do that division with float
        int128 damage = 0;
        if (_randomNumber() <= hit_chance) {
            damage = int128(_attacker.attackPoints - _defender.defensePoints);
            if (damage < 0) {
                damage = 1;
            }
        }
        return uint128(damage);
    }
}
