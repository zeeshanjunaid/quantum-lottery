# Quantum Lottery

A decentralized lottery system built on Base (EVM) with Chainlink VRF for provably fair randomness and Chainlink Automation for automated operations.

[![GitHub](https://img.shields.io/badge/GitHub-Repository-blue?style=for-the-badge&logo=github)](https://github.com/zeeshanjunaid/quantum-lottery)
[![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
[![Solidity](https://img.shields.io/badge/Solidity-0.8.20-blue?style=for-the-badge&logo=solidity)](https://soliditylang.org/)
[![Base](https://img.shields.io/badge/Base-EVM-blue?style=for-the-badge&logo=ethereum)](https://base.org/)

## Architecture

The project consists of three main packages:

### 📜 Contracts Package
- **Smart Contracts**: Core lottery logic, VRF integration, and automation
- **Technology Stack**: Solidity + Foundry, OpenZeppelin, Chainlink VRF v2.5 + Automation
- **Features**: 
  - Standard tickets (10 USDC) and Quantum tickets (30 USDC)
  - 8% fee collection to treasury
  - Provably fair randomness via Chainlink VRF
  - Automated operations via Chainlink Automation

### 🕸️ Subgraph Package
- **Purpose**: Index blockchain events for efficient frontend data retrieval
- **Technology**: The Graph Protocol
- **Data**: Lottery draws, ticket purchases, winner announcements, treasury operations

### 🎨 Frontend Package
- **Purpose**: User interface for lottery participation and management
- **Technology**: React/Next.js with Web3 integration
- **Features**: Ticket purchase, draw viewing, winner history, treasury transparency

## Lottery Mechanics

- **Standard Ticket**: 10 USDC - Regular lottery entry
- **Quantum Ticket**: 30 USDC - Enhanced odds and bonus rewards
- **Fee Structure**: 8% of all ticket sales go to treasury
- **Currency**: Native USDC on Base (6 decimals)
- **Randomness**: Chainlink VRF v2.5 ensures provably fair results
- **Automation**: Chainlink Automation handles draw scheduling and execution

## Environment Configuration

The system supports both Base Sepolia (testnet) and Base Mainnet with configurable:

### Root Environment Variables
```bash
BASE_SEPOLIA_RPC=https://sepolia.base.org
BASE_MAINNET_RPC=https://mainnet.base.org
PRIVATE_KEY=your_private_key_here
TREASURY=your_treasury_address_here
MULTISIG=your_multisig_address_here
NETWORK=base-sepolia
CHAIN_ID=84532
```

### Contracts Environment Variables
```bash
USDC=0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913
VRF_KEY_HASH=0x0000000000000000000000000000000000000000000000000000000000000000
VRF_SUBSCRIPTION_ID=0
VRF_CALLBACK_GAS=500000
AUTOMATION_UPKEEP_HOURLY=0
AUTOMATION_UPKEEP_DAILY=0
```

### Frontend Environment Variables
```bash
NEXT_PUBLIC_CHAIN_ID=84532
NEXT_PUBLIC_RPC_URL=https://sepolia.base.org
NEXT_PUBLIC_CONTRACT_ADDRESS=0x0000000000000000000000000000000000000000
NEXT_PUBLIC_SUBGRAPH_URL=https://api.studio.thegraph.com/query/0/quantum-lottery/v0.0.1
```

### Subgraph Environment Variables
```bash
NETWORK=base-sepolia
RPC_URL=https://sepolia.base.org
CONTRACT_ADDRESS=0x0000000000000000000000000000000000000000
```

## Getting Started

1. **Clone Repository**: `git clone https://github.com/zeeshanjunaid/quantum-lottery.git`
2. **Install Dependencies**: `npm install`
3. **Configure Environment**: Set up `.env` files for each package using the variables above
4. **Deploy Contracts**: `npm run contracts:deploy:sepolia`
5. **Deploy Subgraph**: `npm run subgraph:deploy`
6. **Start Frontend**: `npm run frontend:dev`

## Security Features

- OpenZeppelin contracts for battle-tested security
- Chainlink VRF for tamper-proof randomness
- Multisig treasury management
- Automated operations with Chainlink Automation
- Comprehensive testing and auditing

## Contributing

We welcome contributions! Please read our contributing guidelines and submit pull requests.

## License

MIT License - see [LICENSE](LICENSE) file for details.

## Links

- **GitHub Repository**: https://github.com/zeeshanjunaid/quantum-lottery
- **Base Network**: https://base.org/
- **Chainlink VRF**: https://docs.chain.link/vrf
- **Chainlink Automation**: https://docs.chain.link/automation
- **The Graph**: https://thegraph.com/
