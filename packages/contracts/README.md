# Quantum Lottery - Smart Contracts

Smart contracts for the Quantum Lottery system built with Foundry, OpenZeppelin, and Chainlink.

## Prerequisites

- [Foundry](https://getfoundry.sh/) installed
- Node.js 18+ and npm 9+
- Base Sepolia testnet wallet with ETH

## Installation

```bash
# Install Foundry dependencies
forge install OpenZeppelin/openzeppelin-contracts
forge install smartcontractkit/chainlink-brownie-contracts

# Install npm dependencies
npm install
```

## Environment Setup

1. Copy environment template:
```bash
cp .env.example .env
```

2. Configure your environment variables in `.env`

## Development Commands

```bash
# Build contracts
forge build

# Run tests
forge test

# Run tests with coverage
forge coverage

# Format code
forge fmt

# Lint code
npm run lint
```

## Testing Commands

```bash
# Run all tests
npm run test

# Run specific test
forge test --match-test testPurchaseStandardTicket

# Run with gas reporting
npm run test:gas
```

## Fork Testing Commands

```bash
# Fork Base Sepolia for testing
forge test --fork-url $BASE_SEPOLIA_RPC_URL

# Fork with specific block
forge test --fork-url $BASE_SEPOLIA_RPC_URL --fork-block-number 12345678
```

## Deployment Commands

### Base Sepolia (Testnet)

```bash
# Deploy to Base Sepolia
npm run deploy:base-sepolia

# Verify contract on Etherscan
npm run verify
```

### Base Mainnet

```bash
# Deploy to Base mainnet
npm run deploy:base
```

## Contract Architecture

- **QuantumLottery.sol**: Main lottery contract with VRF and automation
- **IQuantumLottery.sol**: Contract interface
- **LotteryMath.sol**: Mathematical utilities library

## Security

- OpenZeppelin battle-tested contracts
- Reentrancy protection
- Access control with Ownable
- Comprehensive testing suite
