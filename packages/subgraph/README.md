# Quantum Lottery - Subgraph

The Graph subgraph for indexing Quantum Lottery blockchain events and providing efficient data access.

## Prerequisites

- Node.js 18+ and npm 9+
- The Graph CLI installed: `npm install -g @graphprotocol/graph-cli`
- The Graph Studio account
- Deployed smart contracts

## Installation

```bash
# Install dependencies
npm install
```

## Environment Setup

1. Copy environment template:
```bash
cp .env.example .env
```

2. Configure your environment variables in `.env`

3. Authenticate with The Graph:
```bash
graph auth --studio
```

## Development Steps

### Codegen

```bash
# Generate types from schema
npm run codegen
```

### Build

```bash
# Build subgraph
npm run build
```

## Deployment Steps

### The Graph Studio (Recommended)

1. Create subgraph:
```bash
npm run create:base-sepolia
```

2. Deploy to testnet:
```bash
npm run deploy:base-sepolia
```

3. Deploy to mainnet:
```bash
npm run deploy:base
```

### Self-Hosted

```bash
# Deploy to your Graph Node
graph deploy --node <YOUR_NODE_URL> --ipfs <YOUR_IPFS_URL> quantum-lottery
```

## Configuration

### subgraph.yaml

- **Network**: Set to `base-sepolia` for testnet
- **Contract Address**: Update with deployed contract address
- **Start Block**: Set to deployment block number

### schema.graphql

- **Entities**: Define data structures for indexing
- **Relationships**: Set up entity relationships
- **Fields**: Configure indexed and queryable fields

## Architecture

- **Event Handlers**: Process blockchain events
- **Entity Mapping**: Transform events to entities
- **Data Storage**: Efficient GraphQL querying
- **Real-time Updates**: Live data synchronization

## Data Indexed

- Ticket purchases and types
- Draw events and winners
- User statistics and history
- Treasury operations
- VRF and automation events

## Querying

Once deployed, query your subgraph:

```graphql
{
  tickets(first: 10) {
    id
    ticketType
    holder {
      address
    }
    price
  }
}
```

## Monitoring

- Monitor indexing status in The Graph Studio
- Check sync status and health
- Review query performance metrics
