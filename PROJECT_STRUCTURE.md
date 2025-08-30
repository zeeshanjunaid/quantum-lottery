# Quantum Lottery - Project Structure

## Overview
This document outlines the complete monorepo structure for the Quantum Lottery project, including all packages, files, and their purposes.

## Root Structure
```
quantum-lottery/
├── package.json                 # Root monorepo configuration
├── README.md                    # Main project documentation
├── PROJECT_STRUCTURE.md         # This file - detailed structure
├── .gitignore                   # Root gitignore
└── packages/                    # All project packages
```

## Packages

### 1. Contracts Package (`packages/contracts/`)
**Purpose**: Smart contracts for the lottery system with VRF and automation integration.

**Technology Stack**:
- Solidity 0.8.20
- Foundry for development, testing, and deployment
- OpenZeppelin contracts for security
- Chainlink VRF v2.5 for randomness
- Chainlink Automation for upkeep

**Key Files**:
```
packages/contracts/
├── foundry.toml                 # Foundry configuration
├── package.json                 # Package dependencies
├── .env.example                 # Environment variables template
├── remappings.txt               # Import remappings
├── .gitignore                   # Package-specific gitignore
├── tsconfig.json                # TypeScript configuration
├── src/                         # Source code
│   ├── QuantumLottery.sol      # Main lottery contract
│   ├── interfaces/              # Contract interfaces
│   │   └── IQuantumLottery.sol # Main interface
│   └── libraries/               # Utility libraries
│       └── LotteryMath.sol     # Mathematical utilities
├── test/                        # Test files
│   └── QuantumLottery.t.sol    # Main test suite
└── script/                      # Deployment scripts
    └── Deploy.s.sol            # Main deployment script
```

**Contract Features**:
- Standard tickets (10 USDC) and Quantum tickets (30 USDC)
- 8% treasury fee collection
- Provably fair randomness via Chainlink VRF
- Automated operations via Chainlink Automation
- Emergency withdrawal and admin functions
- Comprehensive event logging

### 2. Subgraph Package (`packages/subgraph/`)
**Purpose**: Blockchain event indexing for efficient frontend data retrieval.

**Technology Stack**:
- The Graph Protocol
- AssemblyScript for mappings
- GraphQL schema definition

**Key Files**:
```
packages/subgraph/
├── package.json                 # Graph dependencies
├── subgraph.yaml               # Subgraph configuration
├── schema.graphql              # GraphQL schema
├── .gitignore                  # Package-specific gitignore
├── tsconfig.json               # TypeScript configuration
└── src/                        # Mapping files
    └── quantum-lottery.ts      # Event handlers
```

**Indexed Data**:
- Ticket purchases and types
- Draw events and winners
- User statistics and history
- Treasury operations
- VRF and automation events

### 3. Frontend Package (`packages/frontend/`)
**Purpose**: User interface for lottery participation and management.

**Technology Stack**:
- Next.js 14 with App Router
- React 18 with TypeScript
- Tailwind CSS for styling
- Wagmi + RainbowKit for Web3
- TanStack Query for data fetching

**Key Files**:
```
packages/frontend/
├── package.json                 # Frontend dependencies
├── next.config.js              # Next.js configuration
├── tailwind.config.js          # Tailwind CSS configuration
├── postcss.config.js           # PostCSS configuration
├── .env.example                # Environment variables template
├── .gitignore                  # Package-specific gitignore
├── tsconfig.json               # TypeScript configuration
└── src/                        # Source code
    ├── app/                    # Next.js App Router
    │   ├── layout.tsx          # Root layout
    │   ├── page.tsx            # Main page
    │   ├── providers.tsx       # Web3 providers
    │   └── globals.css         # Global styles
    └── config/                 # Configuration files
        └── wagmi.ts            # Wagmi configuration
```

**Frontend Features**:
- Wallet connection via RainbowKit
- Ticket purchase interface
- Real-time lottery statistics
- Winner history display
- Responsive design with Tailwind CSS

## Environment Configuration

### Contracts Package
- **Base Network RPC URLs**: Mainnet and Sepolia endpoints
- **USDC Addresses**: Contract addresses for both networks
- **Chainlink VRF**: Coordinator, keyHash, subscriptionId, callbackGas
- **Chainlink Automation**: Registry addresses and upkeep IDs
- **Treasury & Multisig**: Admin addresses for fee collection
- **Lottery Constants**: Ticket prices and fee percentages

### Frontend Package
- **Contract Addresses**: Deployed lottery and USDC contracts
- **Network Configuration**: Chain IDs, RPC URLs, explorer URLs
- **Subgraph URLs**: GraphQL endpoints for data
- **WalletConnect**: Project ID for wallet connections

## Constants & Configuration

### Lottery Mechanics
- **Standard Ticket**: 10 USDC (6 decimals = 10,000,000)
- **Quantum Ticket**: 30 USDC (6 decimals = 30,000,000)
- **Treasury Fee**: 8% of all ticket sales
- **Draw Interval**: 24 hours (1 day)
- **Minimum Tickets**: 10 tickets required for draw

### Network Support
- **Base Mainnet**: Production deployment
- **Base Sepolia**: Testnet deployment
- **USDC**: Native 6-decimal USDC on Base
- **VRF**: Chainlink VRF v2.5 on Base
- **Automation**: Chainlink Automation on Base

## Development Workflow

### 1. Setup
```bash
npm install                    # Install all dependencies
cd packages/contracts         # Navigate to contracts
forge install                 # Install Foundry dependencies
```

### 2. Development
```bash
# Contracts
forge build                   # Build contracts
forge test                    # Run tests
forge coverage                # Test coverage

# Subgraph
npm run codegen              # Generate types
npm run build                # Build subgraph

# Frontend
npm run dev                  # Start development server
npm run build                # Build for production
```

### 3. Deployment
```bash
# Contracts
npm run deploy:base-sepolia  # Deploy to testnet
npm run deploy:base          # Deploy to mainnet

# Subgraph
npm run deploy:base-sepolia  # Deploy to testnet
npm run deploy:base          # Deploy to mainnet

# Frontend
npm run build                # Build and deploy
```

## Security Features

### Smart Contracts
- OpenZeppelin battle-tested contracts
- Reentrancy protection
- Access control with Ownable
- Emergency withdrawal functions
- Comprehensive event logging

### Frontend
- Wallet signature verification
- Secure Web3 integration
- Environment variable protection
- Type-safe development

### Infrastructure
- Chainlink VRF for tamper-proof randomness
- Chainlink Automation for reliable operations
- Multisig treasury management
- Comprehensive testing suite

## Testing Strategy

### Contract Testing
- Unit tests for all functions
- Integration tests for VRF and automation
- Fuzz testing for edge cases
- Gas optimization testing
- Security vulnerability testing

### Frontend Testing
- Component unit tests
- Integration tests with Web3
- E2E testing for user flows
- Accessibility testing
- Performance testing

## Monitoring & Analytics

### On-Chain
- Event emission for all operations
- Treasury fee tracking
- User participation metrics
- Draw completion statistics

### Off-Chain
- Subgraph indexing for fast queries
- Frontend analytics for user behavior
- Error tracking and logging
- Performance monitoring

## Future Enhancements

### Planned Features
- Multiple lottery types
- NFT ticket representations
- Governance token integration
- Advanced automation rules
- Mobile application
- API for third-party integrations

### Scalability
- Layer 2 solutions
- Cross-chain functionality
- Advanced caching strategies
- Microservices architecture
