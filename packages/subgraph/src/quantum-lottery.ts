import { BigInt, Address } from "@graphprotocol/graph-ts"
import {
  TicketPurchased,
  RandomnessRequested,
  DrawCompleted,
  TreasuryAddressUpdated,
  MultisigAddressUpdated,
  VRFParametersUpdated,
  AutomationUpkeepIdUpdated,
  EmergencyWithdraw
} from "../generated/QuantumLottery/QuantumLottery"
import { Ticket, Draw, User, Purchase, LotteryStats } from "../generated/schema"

export function handleTicketPurchased(event: TicketPurchased): void {
  let ticketId = event.params.ticketId
  let userId = event.params.buyer.toHexString()
  let drawId = event.params.ticketId
  
  let user = User.load(userId)
  if (!user) {
    user = new User(userId)
    user.address = event.params.buyer
    user.totalTicketsPurchased = BigInt.fromI32(0)
    user.totalSpent = BigInt.fromI32(0)
    user.firstPurchaseAt = event.block.timestamp
  }
  
  user.totalTicketsPurchased = user.totalTicketsPurchased.plus(BigInt.fromI32(1))
  user.totalSpent = user.totalSpent.plus(event.params.price)
  user.lastPurchaseAt = event.block.timestamp
  user.save()
  
  let ticket = new Ticket(ticketId.toString())
  ticket.ticketId = ticketId
  ticket.drawId = drawId
  ticket.holder = userId
  ticket.ticketType = event.params.ticketType == 0 ? "Standard" : "Quantum"
  ticket.price = event.params.price
  ticket.feeAmount = event.params.feeAmount
  ticket.timestamp = event.block.timestamp
  ticket.blockNumber = event.block.number
  ticket.transactionHash = event.transaction.hash.toHexString()
  ticket.save()
  
  let purchase = new Purchase(event.transaction.hash.toHexString())
  purchase.user = userId
  purchase.ticket = ticketId.toString()
  purchase.timestamp = event.block.timestamp
  purchase.blockNumber = event.block.number
  purchase.transactionHash = event.transaction.hash.toHexString()
  purchase.save()
  
  updateLotteryStats()
}

export function handleRandomnessRequested(event: RandomnessRequested): void {
  let drawId = event.params.requestId
  let draw = Draw.load(drawId.toString())
  if (!draw) {
    draw = new Draw(drawId.toString())
    draw.drawId = drawId
    draw.status = "Pending"
    draw.timestamp = event.block.timestamp
    draw.totalTickets = BigInt.fromI32(0)
    draw.totalPrize = BigInt.fromI32(0)
    draw.randomnessRequested = true
  }
  draw.randomnessRequested = true
  draw.save()
}

export function handleDrawCompleted(event: DrawCompleted): void {
  let drawId = event.params.requestId
  let draw = Draw.load(drawId.toString())
  if (draw) {
    draw.status = "Completed"
    draw.winningTicket = event.params.winningTicket
    draw.winner = event.params.winner.toHexString()
    draw.randomWord = event.params.randomWord
    draw.completedAt = event.block.timestamp
    draw.totalPrize = event.params.prizeAmount
    draw.save()
  }
  
  updateLotteryStats()
}

export function handleTreasuryAddressUpdated(event: TreasuryAddressUpdated): void {
  // Handle treasury address update
}

export function handleMultisigAddressUpdated(event: MultisigAddressUpdated): void {
  // Handle multisig address update
}

export function handleVRFParametersUpdated(event: VRFParametersUpdated): void {
  // Handle VRF parameters update
}

export function handleAutomationUpkeepIdUpdated(event: AutomationUpkeepIdUpdated): void {
  // Handle automation upkeep ID update
}

export function handleEmergencyWithdraw(event: EmergencyWithdraw): void {
  // Handle emergency withdraw
}

function updateLotteryStats(): void {
  let stats = LotteryStats.load("1")
  if (!stats) {
    stats = new LotteryStats("1")
    stats.totalTicketsSold = BigInt.fromI32(0)
    stats.totalFeesCollected = BigInt.fromI32(0)
    stats.totalDraws = BigInt.fromI32(0)
    stats.totalWinners = BigInt.fromI32(0)
    stats.totalPrizePool = BigInt.fromI32(0)
  }
  
  stats.lastUpdated = BigInt.fromI32(0) // Current timestamp
  stats.save()
}
