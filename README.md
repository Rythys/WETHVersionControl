# 🔄 Upgradable WETH (UUPS) via Foundry

![Solidity](https://img.shields.io/badge/Solidity-^0.8.33-e6e6e6?style=flat-square&logo=solidity)
![Foundry](https://img.shields.io/badge/Built_with-Foundry-FF0000?style=flat-square)
![OpenZeppelin](https://img.shields.io/badge/OpenZeppelin-v5.0-4E5EE4?style=flat-square)

This repository demonstrates a production-ready implementation of an upgradeable smart contract system using the **UUPS (Universal Upgradeable Proxy Standard)** pattern. It features a Wrapped Ether (WETH) logic contract that is upgraded from V1 to V2 without losing state or user balances.

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

## 🚀 Getting Started

### Prerequisites

You need to have [Foundry](https://getfoundry.sh/) installed.

```bash
curl -L https://foundry.paradigm.xyz | bash
foundryup
```

### Installation

Clone the repository and install dependencies:

```bash
git clone https://github.com/Rythys/WETHVersionControl.git
cd WETHVersionControl
forge install
```

---

## 🧪 Testing

The test suite validates proxy initialization, prevents unauthorized upgrades, and ensures variables remain intact after swapping the implementation.

```bash
forge test -vvv
```

---

## 🌐 Deployment & Upgrades (Sepolia)

### 1. Environment Setup
Create a `.env` file in the root directory:
```env
PRIVATE_KEY=your_wallet_private_key
ETHERSCAN_API_KEY=your_etherscan_api_key
PROXY_ADDRESS=leave_blank_until_deployed
```

### 2. Deploy V1 + Proxy
Deploys the `WETH_v1` logic, an `ERC1967Proxy`, and initializes it.
```bash
source .env
forge script script/UpdWETHScript.sol:UpdWETHScript --sig "deploy()" --rpc-url https://sepolia.infura.io/v3/YOUR_INFURA_KEY --broadcast --verify
```
*After deployment, copy the Proxy Address and add it to your `.env` file as `PROXY_ADDRESS`.*

### 3. Upgrade to V2
Deploys the `WETH_v2` logic and calls `upgradeToAndCall` on the existing proxy.
```bash
source .env
forge script script/UpdWETHScript.sol:UpdWETHScript --sig "upgrade()" --rpc-url https://sepolia.infura.io/v3/YOUR_INFURA_KEY --broadcast --verify
```

---

## 📍 Deployed Addresses (Sepolia Testnet)

*You can verify these contracts on [Sepolia Etherscan](https://sepolia.etherscan.io/).*

| Contract | Address |
|---|---|
| **ERC1967 Proxy** (Main) | `0x840B39B100a15376126d21D5D9ee2B8D4a26427c` |
| **WETH V1** (Implementation) | `0x28B085EFd9c452dDBaA4f30Cb517B2bdd5B1D686` |
| **WETH V2** (Implementation) | `0x4e7bfED836D30b0774d732E3f31C29e700a6012a` |

---

## 🛡️ Security
This project uses the UUPS pattern instead of Transparent Proxy. In UUPS, the upgrade logic resides in the implementation contract, meaning if you deploy a V2 that forgets to inherit `UUPSUpgradeable` or omits `_authorizeUpgrade`, the contract cannot be upgraded to V3. The provided `WETH_v2.sol` safely inherits from `WETH_v1` to prevent this.

## 📝 License
UNLICENSED
