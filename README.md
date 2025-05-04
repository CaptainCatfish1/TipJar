# TipJar
Smart Contract for a public facing Tip Jar on Ethereum

# 🪙 TipJar — Ethereum Smart Contract for ETH & ERC-20 Tips

A lightweight, secure, and fully public smart contract to receive tips in ETH and ERC-20 tokens with messages. Built for creators, developers, and communities who want on-chain support from their peers or audience.

---

## 📍 Deployed on Ethereum Mainnet

- **Contract Address**: [`0x2eC4B6000B071B95674b137575b12a0b7eEA12CA`](https://etherscan.io/address/0x2eC4B6000B071B95674b137575b12a0b7eEA12CA)
- **Etherscan Verification**: ✅ Verified and public
- **License**: MIT

---

## ✨ Features

- ✅ Accept tips in **ETH**
- ✅ Accept tips in **any ERC-20 token** (e.g., USDC, DAI, WETH, PEPE)
- ✅ Supports **custom messages** and **ENS or social handles**
- ✅ Logs all tips publicly (on-chain `Tip[]`)
- ✅ Owner-only withdrawals (ETH & tokens)
- ✅ Fully auditable and minimalistic Solidity codebase
- ✅ Reentrancy protected

---

## 📜 Functions

### 🔹 Public Tip Functions
- `sendTipETH(string message, string handle)` — Send ETH with a message
- `sendTipToken(address token, uint256 amount, string message, string handle)` — Send ERC-20 token with message
- `receive()` / `fallback()` — Accept ETH directly (no message)

### 🔹 Owner-Only Admin
- `withdrawETH()` — Withdraw ETH to owner's wallet
- `withdrawToken(address token)` — Withdraw any token
- `transferOwnership(address newOwner)` — Change contract ownership

### 🔹 Public View
- `getAllTips()` — Returns all recorded tips
- `contractBalance(address token)` — Returns contract balance for ETH or a given token

---

## 🛡 Security Features

- Reentrancy protection using custom guard
- Access control (`onlyOwner`) for withdrawals and ownership changes
- Input validation on tip amounts and addresses
- Emits detailed `TipReceived`, `Withdrawn`, and `OwnershipTransferred` events

> 🔎 Fully reviewed with Etherscan Code Reader + manual audit checklist

---

## 📦 Sample Tip Event

```json
{
  "from": "0xUser...",
  "token": "0x0000000000000000000000000000000000000000", // ETH
  "amount": "0.01 ETH",
  "message": "Love your work!",
  "handle": "captain.eth",
  "timestamp": 1714760400
}

For developers or integrators: a test deployment is also available on Sepolia at 0xd2FE5bDA2d5bc5C291e0DD6919d6E13521ab1128

🛠️ Integration Ideas
💻 Add this contract to your personal website to collect on-chain support

💬 Build a tipping frontend or donation button

📊 Visualize tips in a public dashboard

🎁 Link to it in your GitHub profile, blog, or X profile

📖 License
This project is open-sourced under the MIT License.

🙌 Acknowledgments
Created by @Captain_Hayward
Security-checked via Etherscan AI + custom hardening
Deployed with ❤️ to Ethereum Mainnet
