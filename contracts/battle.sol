// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "./pjhelper.sol";
import "./pjownership.sol";

contract Battle is PjHelper, PjOwnership {
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
                    // Pj1 Won Battle
                    pj2Hp = 0;
                    _wonBattle(pj1_id);
                } else {
                    pj2Hp -= damage;
                }
            } else {
                // Pj2 attacks Pj1
                uint128 damage = _calculateDamage(pj2, pj1);
                if (damage >= pj1Hp) {
                    // Pj1 Won Battle
                    pj1Hp = 0;
                    _wonBattle(pj2_id);
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
        uint hit_chance = ((_attacker.agilityPoints * 1000) /
            (_attacker.agilityPoints + _defender.attackPoints));
        int128 damage = 0;
        if (_randomNumber() <= hit_chance) {
            damage =
                int128(_attacker.attackPoints) -
                int128(_defender.defensePoints);
            if (damage < 0) {
                damage = 1;
            }
        }
        return uint128(damage);
    }

    function _wonBattle(uint _pj_id) private {
        Pj memory pj = pjs[_pj_id];
        pj.level++;
        if (
            keccak256(abi.encodePacked((pj.class))) ==
            keccak256(abi.encodePacked(("Attack")))
        ) {
            pj.hp = pj.hp + 3;
            pj.attackPoints = pj.attackPoints + 3;
            pj.defensePoints = pj.defensePoints + 2;
            pj.agilityPoints = pj.agilityPoints + 1;
        } else if (
            keccak256(abi.encodePacked((pj.class))) ==
            keccak256(abi.encodePacked(("Defense")))
        ) {
            pj.hp = pj.hp + 2;
            pj.attackPoints = pj.attackPoints + 2;
            pj.defensePoints = pj.defensePoints + 3;
            pj.agilityPoints = pj.agilityPoints + 1;
        } else {
            pj.hp = pj.hp + 5;
            pj.attackPoints = pj.attackPoints + 2;
            pj.defensePoints = pj.defensePoints + 1;
            pj.agilityPoints = pj.agilityPoints + 3;
        }

        pjs[_pj_id] = pj;
    }
}
