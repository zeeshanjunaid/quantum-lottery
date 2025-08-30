# Quantum Lottery - Deployment Guide

## Overview
This guide covers the deployment process for all three packages: smart contracts, subgraph, and frontend.

## Prerequisites

### Required Tools
- Node.js 18+ and npm 9+
- Foundry (for smart contracts)
- The Graph CLI (for subgraph)
- Git and GitHub account

### Required Accounts & Services
- Base Sepolia testnet wallet with ETH
- Base mainnet wallet with ETH
- Chainlink VRF subscription
- Chainlink Automation upkeep
- The Graph Studio account
- WalletConnect project ID

## 1. Smart Contracts Deployment

### Environment Setup
1. Copy environment template:
```bash
cd packages/contracts
cp .env.example .env
```

2. Configure environment variables:
```bash
# Base Network RPC URLs
BASE_RPC_URL=https://mainnet.base.org
BASE_SEPOLIA_RPC_URL=https://sepolia.base.org

# Etherscan API Key
ETHERSCAN_API_KEY=your_etherscan_api_key

# Private Key (use environment variable in production)
PRIVATE_KEY=your_private_key

# USDC Contract Addresses
USDC_BASE=0x833589fCD6eDb6E08f4c7C32D4f71b54bdA02913
USDC_BASE_SEPOLIA=0x036CbD53842c5426634e7929541eC2318f3dCF7c8

# Chainlink VRF Configuration
VRF_COORDINATOR_BASE=0x41034678D6C633D8a95c75e1138A360a28bA5c1E6
VRF_COORDINATOR_BASE_SEPOLIA=0x50AE5Ea397634d94A5Bd6B5c41cD4C4C27D2B013
VRF_KEYHASH_BASE=your_keyhash_here
VRF_KEYHASH_BASE_SEPOLIA=your_keyhash_here
VRF_SUBSCRIPTION_ID=your_subscription_id
VRF_CALLBACK_GAS_LIMIT=500000

# Chainlink Automation Configuration
AUTOMATION_REGISTRY_BASE=0x220B71671b649c03714dA45c4dc1202fE3B20B0E
AUTOMATION_REGISTRY_BASE_SEPOLIA=0xEa053F04F400E1D6E1a8b6fAc4C59358a5067C8a
AUTOMATION_UPKEEP_ID=your_upkeep_id

# Treasury and Multisig Addresses
TREASURY_ADDRESS=your_treasury_address
MULTISIG_ADDRESS=your_multisig_address
```

### Dependencies Installation
```bash
# Install Foundry dependencies
forge install OpenZeppelin/openzeppelin-contracts
forge install smartcontractkit/chainlink-brownie-contracts
```

### Testnet Deployment (Base Sepolia)
```bash
# Build contracts
forge build

# Run tests
forge test

# Deploy to Base Sepolia
npm run deploy:base-sepolia
```

### Mainnet Deployment (Base)
```bash
# Deploy to Base mainnet
npm run deploy:base
```

### Contract Verification
```bash
# Verify on Etherscan
forge verify-contract \
  --chain-id 8453 \
  --compiler-version 0.8.20 \
  --constructor-args $(cast abi-encode "constructor(address,address,address,address,bytes32,uint64,uint32)" \
    "USDC_ADDRESS" \
    "VRF_COORDINATOR" \
    "TREASURY_ADDRESS" \
    "MULTISIG_ADDRESS" \
    "KEYHASH" \
    "SUBSCRIPTION_ID" \
    "CALLBACK_GAS_LIMIT") \
  "DEPLOYED_CONTRACT_ADDRESS" \
  "src/QuantumLottery.sol:QuantumLottery"
```

## 2. Subgraph Deployment

### Environment Setup
1. Install The Graph CLI:
```bash
npm install -g @graphprotocol/graph-cli
```

2. Authenticate with The Graph:
```bash
graph auth --studio
```

### Subgraph Configuration
1. Update `subgraph.yaml`:
```yaml
dataSources:
  - kind: ethereum
    name: QuantumLottery
    network: base-sepolia  # or base for mainnet
    source:
      address: "DEPLOYED_CONTRACT_ADDRESS"
      abi: QuantumLottery
      startBlock: DEPLOYMENT_BLOCK
```

2. Update contract ABI:
```bash
# Copy ABI from Foundry build
cp packages/contracts/out/QuantumLottery.sol/QuantumLottery.json packages/subgraph/abis/
```

### Testnet Deployment
```bash
cd packages/subgraph

# Generate types
npm run codegen

# Build subgraph
npm run build

# Deploy to testnet
npm run deploy:base-sepolia
```

### Mainnet Deployment
```bash
# Deploy to mainnet
npm run deploy:base
```

## 3. Frontend Deployment

### Environment Setup
1. Copy environment template:
```bash
cd packages/frontend
cp .env.example .env.local
```

2. Configure environment variables:
```bash
# Contract Addresses
NEXT_PUBLIC_CONTRACT_ADDRESS=deployed_lottery_address
NEXT_PUBLIC_USDC_ADDRESS=usdc_contract_address

# Network Configuration
NEXT_PUBLIC_CHAIN_ID=8453
NEXT_PUBLIC_RPC_URL=https://mainnet.base.org
NEXT_PUBLIC_EXPLORER_URL=https://basescan.org

# Subgraph Configuration
NEXT_PUBLIC_SUBGRAPH_URL=deployed_subgraph_url

# WalletConnect Configuration
NEXT_PUBLIC_WALLET_CONNECT_PROJECT_ID=your_project_id
```

### Development
```bash
# Install dependencies
npm install

# Start development server
npm run dev
```

### Production Build
```bash
# Build for production
npm run build

# Start production server
npm run start
```

### Deployment Options

#### Vercel (Recommended)
1. Connect GitHub repository to Vercel
2. Configure environment variables in Vercel dashboard
3. Deploy automatically on push to main branch

#### Netlify
1. Connect GitHub repository to Netlify
2. Set build command: `npm run build`
3. Set publish directory: `out`
4. Configure environment variables

#### Self-Hosted
```bash
# Build static export
npm run build
npm run export

# Deploy to your server
rsync -avz out/ user@server:/var/www/quantum-lottery/
```

## 4. Post-Deployment Setup

### Chainlink VRF Configuration
1. Fund VRF subscription with LINK tokens
2. Add consumer contract to subscription
3. Set gas limit and callback gas limit

### Chainlink Automation Setup
1. Create automation upkeep
2. Configure trigger conditions
3. Fund upkeep with LINK tokens

### Treasury Configuration
1. Set up multisig wallet
2. Configure treasury address
3. Test fee collection

### Monitoring Setup
1. Set up event monitoring
2. Configure alerts for critical events
3. Monitor gas usage and costs

## 5. Testing & Verification

### Contract Testing
```bash
# Run all tests
forge test

# Run with coverage
forge coverage

# Run specific test
forge test --match-test testPurchaseStandardTicket
```

### Frontend Testing
```bash
# Run linting
npm run lint

# Type checking
npm run type-check

# Build verification
npm run build
```

### Integration Testing
1. Test ticket purchase flow
2. Verify VRF randomness
3. Test automation triggers
4. Verify fee collection

## 6. Security Checklist

### Smart Contracts
- [ ] All tests passing
- [ ] Security audit completed
- [ ] Access controls verified
- [ ] Emergency functions tested
- [ ] Gas optimization verified

### Frontend
- [ ] Environment variables secured
- [ ] Web3 integration tested
- [ ] Error handling implemented
- [ ] Input validation verified

### Infrastructure
- [ ] VRF subscription funded
- [ ] Automation upkeep configured
- [ ] Treasury addresses verified
- [ ] Monitoring alerts active

## 7. Troubleshooting

### Common Issues

#### Contract Deployment Fails
- Verify RPC URL and network
- Check private key and balance
- Verify constructor parameters
- Check gas limits

#### VRF Not Working
- Verify subscription funding
- Check coordinator address
- Verify keyHash and subscriptionId
- Check callback gas limit

#### Frontend Connection Issues
- Verify contract addresses
- Check network configuration
- Verify RPC endpoints
- Check wallet connection

### Support Resources
- Base documentation: https://docs.base.org/
- Chainlink VRF docs: https://docs.chain.link/vrf
- The Graph docs: https://thegraph.com/docs/
- Foundry book: https://book.getfoundry.sh/

## 8. Maintenance

### Regular Tasks
- Monitor VRF subscription balance
- Check automation upkeep funding
- Review treasury fee collection
- Monitor gas usage trends
- Update dependencies

### Emergency Procedures
- Emergency withdrawal if needed
- Pause lottery operations
- Update critical parameters
- Contact security team

## 9. Cost Estimation

### Base Network
- Contract deployment: ~0.01-0.05 ETH
- VRF requests: ~0.001 LINK per request
- Automation upkeep: ~0.1 LINK per month
- Transaction fees: ~$0.01-0.10 per tx

### The Graph
- Subgraph deployment: Free (Studio)
- Query costs: Free tier available
- Premium features: Pay-per-use

### Frontend Hosting
- Vercel: Free tier available
- Netlify: Free tier available
- Self-hosted: Server costs

## 10. Next Steps

### Immediate Actions
1. Deploy to Base Sepolia testnet
2. Test all functionality
3. Deploy subgraph
4. Deploy frontend
5. Conduct security review

### Future Enhancements
1. Add more lottery types
2. Implement governance
3. Add analytics dashboard
4. Mobile application
5. Cross-chain functionality
