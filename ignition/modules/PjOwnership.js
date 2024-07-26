const { buildModule } = require("@nomicfoundation/hardhat-ignition/modules");

module.exports = buildModule("PjOwnershipModule", (m) => {
  const storage = m.contract("PjOwnership", []);

  return { storage };
});