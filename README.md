# arbTON Protocol

Smart contracts and scripts for the arbTON token ecosystem on TON blockchain.

## 📌 Overview
This repository contains:
- **LiquidityLocker**: lock LP tokens from arbTON/TON and arbTON/USDT pools (DeDust, STON.fi).
- **LiquidityManager**: receives TON/USDT + arbTON, adds liquidity, forwards LP to the Locker.
- **BuyRouter**: main entrypoint for users; when a user buys arbTON with TON/USDT, 
  - 100% of funds are sent to LiquidityManager for LP,
  - 100% arbTON is delivered to user,
  - LP tokens are locked.
- **Treasury (optional)**: emission control with daily caps and TWAP pricing.

Built with:
- [Tact](https://github.com/tact-lang/tact) for smart contracts
- [TypeScript](https://www.typescriptlang.org/) for deploy/test scripts

---

## ⚙️ Structure
```
contracts/
  LiquidityLocker.tact
  LiquidityManager.tact
  BuyRouter.tact
  Treasury.tact (optional, to be added later)

scripts/
  deploy-utils.ts
  deploy-locker.ts
  deploy-manager.ts
  deploy-buyrouter.ts
  call-buy-with-ton.ts
```

---

## 🚀 Getting Started

### 1. Install dependencies
```bash
npm init -y
npm i -D typescript ts-node @types/node
npm i @tact-lang/cli @ton/core @ton/ton @ton/crypto dotenv cross-fetch
npx tsc --init
```

### 2. Environment variables
Create `.env` file:
```
MNEMONIC="your 24 words here"
RPC_ENDPOINT="https://toncenter.com/api/v2/jsonRPC"
WORKCHAIN=0
ARBTON_MASTER="EQBzKTc6bTscoGFnMv7Qh_9AbwvqFz4gVEPprTU_WC0ryfye"
USDT_MASTER="EQ...USDT..."
```

### 3. Compile contracts
```bash
npx tact compile contracts/*.tact --out build
```

### 4. Deploy
```bash
npx ts-node scripts/deploy-locker.ts
npx ts-node scripts/deploy-manager.ts
npx ts-node scripts/deploy-buyrouter.ts
```

### 5. Test buy with TON
```bash
npx ts-node scripts/call-buy-with-ton.ts
```

---

## 🔗 LP tokens whitelist (DeDust pools)
- LP ARBt/TON: `EQBD4BEXPq-iFUXlh8ENTOVUiayMgI71cIfaZ-tinIIdMb5V`
- LP ARBt/USDT: `EQBL62pubQGwt-MYCiyHjTbSjG_D98wR-l7LB66yvJKPfdyN`

---

## 🛡️ Roadmap
- [x] Create arbTON Jetton
- [x] Create DeDust pools (arbTON/TON, arbTON/USDT)
- [ ] Deploy LiquidityLocker
- [ ] Deploy LiquidityManager
- [ ] Deploy BuyRouter
- [ ] Add Treasury with emission caps
- [ ] Integrate STON.fi pools
- [ ] Dashboard (TVL, LP locked, volume)

---

## 📖 Notes
- First version uses manual pricing (set via `updatePrice()`).
- Later, integrate TWAP oracles and dual-DEX routing.
- LP tokens are locked for 60–90 days (configurable in LiquidityLocker).
- This repo is **experimental** and under development.

---

## 👥 Community
- Telegram announcements: [@arbTON_news](https://t.me/arbTON_OfficialChannel)
- Telegram community: [@arbTON](https://t.me/arbTON_OG)
