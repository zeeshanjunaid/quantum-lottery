'use client'

import { useState } from 'react'
import { useAccount, useContractRead, useContractWrite, useWaitForTransaction } from 'wagmi'
import { ConnectButton } from '@rainbow-me/rainbowkit'
import { Ticket, Users, Trophy, Clock } from 'lucide-react'

export default function Home() {
  const { address, isConnected } = useAccount()
  const [ticketType, setTicketType] = useState<'standard' | 'quantum'>('standard')

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-900 via-blue-900 to-indigo-900">
      <div className="container mx-auto px-4 py-8">
        {/* Header */}
        <header className="flex justify-between items-center mb-12">
          <div>
            <h1 className="text-4xl font-bold text-white mb-2">Quantum Lottery</h1>
            <p className="text-blue-200">Provably fair randomness on Base</p>
          </div>
          <ConnectButton />
        </header>

        {/* Main Content */}
        <div className="grid grid-cols-1 lg:grid-cols-3 gap-8">
          {/* Lottery Stats */}
          <div className="lg:col-span-2">
            <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20">
              <h2 className="text-2xl font-semibold text-white mb-6">Current Draw</h2>
              
              <div className="grid grid-cols-2 md:grid-cols-4 gap-4 mb-8">
                <div className="text-center">
                  <div className="bg-blue-500/20 rounded-lg p-4">
                    <Ticket className="w-8 h-8 text-blue-400 mx-auto mb-2" />
                    <p className="text-white font-semibold">0</p>
                    <p className="text-blue-200 text-sm">Tickets Sold</p>
                  </div>
                </div>
                
                <div className="text-center">
                  <div className="bg-green-500/20 rounded-lg p-4">
                    <Users className="w-8 h-8 text-green-400 mx-auto mb-2" />
                    <p className="text-white font-semibold">0</p>
                    <p className="text-green-200 text-sm">Participants</p>
                  </div>
                </div>
                
                <div className="text-center">
                  <div className="bg-yellow-500/20 rounded-lg p-4">
                    <Trophy className="w-8 h-8 text-yellow-400 mx-auto mb-2" />
                    <p className="text-white font-semibold">0 USDC</p>
                    <p className="text-yellow-200 text-sm">Prize Pool</p>
                  </div>
                </div>
                
                <div className="text-center">
                  <div className="bg-purple-500/20 rounded-lg p-4">
                    <Clock className="w-8 h-8 text-purple-400 mx-auto mb-2" />
                    <p className="text-white font-semibold">24h</p>
                    <p className="text-purple-200 text-sm">Next Draw</p>
                  </div>
                </div>
              </div>

              {/* Ticket Purchase */}
              {isConnected ? (
                <div className="bg-white/5 rounded-xl p-6">
                  <h3 className="text-xl font-semibold text-white mb-4">Purchase Tickets</h3>
                  
                  <div className="flex gap-4 mb-6">
                    <button
                      onClick={() => setTicketType('standard')}
                      className={`flex-1 py-3 px-6 rounded-lg font-medium transition-all ${
                        ticketType === 'standard'
                          ? 'bg-blue-600 text-white'
                          : 'bg-white/10 text-blue-200 hover:bg-white/20'
                      }`}
                    >
                      Standard Ticket - 10 USDC
                    </button>
                    <button
                      onClick={() => setTicketType('quantum')}
                      className={`flex-1 py-3 px-6 rounded-lg font-medium transition-all ${
                        ticketType === 'quantum'
                          ? 'bg-purple-600 text-white'
                          : 'bg-white/10 text-purple-200 hover:bg-white/20'
                      }`}
                    >
                      Quantum Ticket - 30 USDC
                    </button>
                  </div>

                  <button className="w-full bg-gradient-to-r from-blue-600 to-purple-600 text-white py-4 px-6 rounded-lg font-semibold text-lg hover:from-blue-700 hover:to-purple-700 transition-all">
                    Purchase {ticketType === 'standard' ? 'Standard' : 'Quantum'} Ticket
                  </button>
                  
                  <p className="text-center text-blue-200 text-sm mt-3">
                    8% fee goes to treasury
                  </p>
                </div>
              ) : (
                <div className="text-center py-12">
                  <p className="text-blue-200 text-lg mb-4">Connect your wallet to participate</p>
                  <ConnectButton />
                </div>
              )}
            </div>
          </div>

          {/* Sidebar */}
          <div className="space-y-6">
            {/* Recent Winners */}
            <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20">
              <h3 className="text-xl font-semibold text-white mb-4">Recent Winners</h3>
              <div className="space-y-3">
                <p className="text-blue-200 text-sm">No draws completed yet</p>
              </div>
            </div>

            {/* Your Tickets */}
            {isConnected && (
              <div className="bg-white/10 backdrop-blur-lg rounded-2xl p-6 border border-white/20">
                <h3 className="text-xl font-semibold text-white mb-4">Your Tickets</h3>
                <div className="space-y-3">
                  <p className="text-blue-200 text-sm">No tickets purchased yet</p>
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  )
}
