const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("BattleModule", (m) => {
  const battle = m.contract("Battle", []);

  return { battle };
});