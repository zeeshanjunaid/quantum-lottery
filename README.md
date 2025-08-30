# Quantum Lottery

A decentralized lottery system built on Base (EVM) with Chainlink VRF for provably fair randomness and Chainlink Automation for automated operations.

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
- USDC contract addresses
- Chainlink VRF parameters (keyHash, subscriptionId, callbackGas)
- Chainlink Automation upkeep IDs
- Treasury and multisig addresses

## Getting Started

1. **Install Dependencies**: `npm install`
2. **Configure Environment**: Set up `.env` files for each package
3. **Deploy Contracts**: `npm run deploy`
4. **Deploy Subgraph**: `npm run subgraph:deploy`
5. **Start Frontend**: `npm run frontend:dev`

## Security Features

- OpenZeppelin contracts for battle-tested security
- Chainlink VRF for tamper-proof randomness
- Multisig treasury management
- Automated operations with Chainlink Automation
- Comprehensive testing and auditing

## License

MIT License
