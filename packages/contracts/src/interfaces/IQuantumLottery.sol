// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

interface IQuantumLottery {
    enum TicketType { Standard, Quantum }
    enum DrawStatus { Pending, Completed, Cancelled }

    struct Draw {
        uint256 drawId;
        DrawStatus status;
        uint256 winningTicket;
        address winner;
        uint256 randomWord;
        uint256 timestamp;
        uint256 totalTickets;
        uint256 totalPrize;
    }

    event TicketPurchased(
        address indexed buyer,
        TicketType ticketType,
        uint256 indexed ticketId,
        uint256 price,
        uint256 feeAmount
    );

    event RandomnessRequested(uint256 indexed requestId);
    
    event DrawCompleted(
        uint256 indexed requestId,
        uint256 indexed winningTicket,
        address indexed winner,
        uint256 prizeAmount,
        uint256 randomWord
    );

    event TreasuryAddressUpdated(address indexed newTreasuryAddress);
    event MultisigAddressUpdated(address indexed newMultisigAddress);
    event VRFParametersUpdated(bytes32 keyHash, uint64 subscriptionId, uint32 callbackGasLimit);
    event AutomationUpkeepIdUpdated(uint256 indexed upkeepId);
    event EmergencyWithdraw(address indexed owner, uint256 usdcAmount, uint256 linkAmount);

    function purchaseStandardTicket() external;
    function purchaseQuantumTicket() external;
    function requestRandomness() external;
    function setTreasuryAddress(address _treasuryAddress) external;
    function setMultisigAddress(address _multisigAddress) external;
    function setVRFParameters(bytes32 _keyHash, uint64 _subscriptionId, uint32 _callbackGasLimit) external;
    function setAutomationUpkeepId(uint256 _upkeepId) external;
    function emergencyWithdraw() external;
    function getDrawInfo(uint256 drawId) external view returns (Draw memory);
    function getUserTickets(address user, uint256 drawId) external view returns (uint256);
    function getTicketHolder(uint256 drawId, uint256 ticketId) external view returns (address);
    function getCurrentDrawStats() external view returns (
        uint256 drawId,
        uint256 ticketsSold,
        uint256 timeUntilNextDraw,
        bool canDraw
    );
}
