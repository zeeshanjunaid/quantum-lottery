# Quantum Lottery - Frontend

Modern, responsive frontend for the Quantum Lottery system built with Next.js, React, and Web3 technologies.

## Prerequisites

- Node.js 18+ and npm 9+
- WalletConnect project ID
- Deployed smart contracts
- Deployed subgraph

## Installation

```bash
# Install dependencies
npm install
```

## Environment Setup

1. Copy environment template:
```bash
cp .env.example .env.local
```

2. Configure your environment variables in `.env.local`:
   - Contract addresses
   - Network configuration
   - Subgraph URL
   - WalletConnect project ID

## Development

```bash
# Start development server
npm run dev

# Open http://localhost:3000
```

## Building

```bash
# Build for production
npm run build

# Start production server
npm run start

# Export static files
npm run export
```

## Technology Stack

- **Framework**: Next.js 14 with App Router
- **UI**: React 18 with TypeScript
- **Styling**: Tailwind CSS
- **Web3**: Wagmi + RainbowKit
- **State Management**: TanStack Query

## Features

- Wallet connection via RainbowKit
- Ticket purchase interface
- Real-time lottery statistics
- Winner history display
- Responsive design

## Project Structure

```
src/
├── app/                    # Next.js App Router
│   ├── layout.tsx         # Root layout
│   ├── page.tsx           # Main page
│   ├── providers.tsx      # Web3 providers
│   └── globals.css        # Global styles
└── config/                # Configuration files
    └── wagmi.ts           # Wagmi configuration
```

## Deployment

### Vercel (Recommended)

1. Connect GitHub repository to Vercel
2. Configure environment variables in Vercel dashboard
3. Deploy automatically on push to main branch

### Self-Hosted

```bash
npm run build
npm run export
# Deploy 'out' directory to your server
```
