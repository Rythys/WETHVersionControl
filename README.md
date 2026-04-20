# 🔄 Upgradable WETH (UUPS) via Foundry

![Solidity](https://img.shields.io/badge/Solidity-^0.8.33-e6e6e6?style=flat-square&logo=solidity)
![Foundry](https://img.shields.io/badge/Built_with-Foundry-FF0000?style=flat-square)
![OpenZeppelin](https://img.shields.io/badge/OpenZeppelin-v5.0-4E5EE4?style=flat-square)

This repository demonstrates a production-ready implementation of an upgradeable smart contract system using the **UUPS (Universal Upgradeable Proxy Standard)** pattern. It features a Wrapped Ether (WETH) logic contract that is upgraded from V1 to V2 with Flash Loans.

## 🌟 Key Features

- **UUPS Proxy Architecture:** Uses `ERC1967Proxy` for gas-efficient and secure upgrades.
- **OpenZeppelin V5:** Implements the latest secure standard for initializable and upgradeable contracts.
- **Double-Initialization Protection:** Utilizes `reinitializer(2)` to safely manage state variables across version upgrades.
- **Automated Deployments:** Includes Foundry scripts for 1-click deployments and upgrades directly to live testnets.
- **Full Test Coverage:** Comprehensive test suite ensuring state retention, correct authorization (`_authorizeUpgrade`), and upgrade functionality.

---

## 📂 Project Structure

```text
├── src/
│   ├── WETH_v1.sol         # Initial Logic Contract (V1)
│   └── WETH_v2.sol         # Upgraded Logic Contract (V2)
├── script/
│   └── UpdWETHScript.sol   # Deployment and Upgrade Scripts
├── test/
│   └── WETHUUPSTest.t.sol  # Unit tests for UUPS logic
└── foundry.toml            # Foundry configuration
```

---

## 📍 Deployed Addresses (Sepolia Testnet)

*You can verify these contracts on [Sepolia Etherscan](https://sepolia.etherscan.io/).*

| Contract | Address |
|---|---|
| **ERC1967 Proxy** (Main) | [`0x840B39B100a15376126d21D5D9ee2B8D4a26427c`](https://sepolia.etherscan.io/address/0x840b39b100a15376126d21d5d9ee2b8d4a26427c) |
| **WETH V1** (Implementation) | [`0x28B085EFd9c452dDBaA4f30Cb517B2bdd5B1D686`](https://sepolia.etherscan.io/address/0x28b085efd9c452ddbaa4f30cb517b2bdd5b1d686) |
| **WETH V2** (Implementation) | [`0x4e7bfED836D30b0774d732E3f31C29e700a6012a`](https://sepolia.etherscan.io/address/0x4e7bfed836d30b0774d732e3f31c29e700a6012a) |

---

## How to improve
1. Make storage of versions
2. Make versions revert

## 🛡️ Security
This project uses the UUPS pattern instead of Transparent Proxy. In UUPS, the upgrade logic resides in the implementation contract, meaning if you deploy a V2 that forgets to inherit `UUPSUpgradeable` or omits `_authorizeUpgrade`, the contract cannot be upgraded to V3. The provided `WETH_v2.sol` safely inherits from `WETH_v1` to prevent this.
