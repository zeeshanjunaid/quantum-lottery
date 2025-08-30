// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/utils/SafeERC20.sol";
import "@chainlink/contracts/src/v0.8/vrf/VRFConsumerBaseV2.sol";
import "@chainlink/contracts/src/v0.8/automation/AutomationCompatible.sol";
import "./interfaces/IQuantumLottery.sol";
import "./libraries/LotteryMath.sol";

contract QuantumLottery is 
    IQuantumLottery, 
    VRFConsumerBaseV2, 
    AutomationCompatibleInterface,
    Ownable,
    ReentrancyGuard 
{
    using SafeERC20 for IERC20;

    // Constants
    uint256 public constant STANDARD_TICKET_PRICE = 10 * 10**6; // 10 USDC (6 decimals)
    uint256 public constant QUANTUM_TICKET_PRICE = 30 * 10**6; // 30 USDC (6 decimals)
    uint256 public constant TREASURY_FEE_PERCENTAGE = 8; // 8%
    uint256 public constant MINIMUM_TICKETS_FOR_DRAW = 10;
    uint256 public constant DRAW_INTERVAL = 1 days;

    // State variables
    IERC20 public immutable usdcToken;
    address public treasuryAddress;
    address public multisigAddress;
    
    uint256 public currentDrawId;
    uint256 public lastDrawTime;
    uint256 public totalTicketsSold;
    uint256 public totalFeesCollected;
    
    mapping(uint256 => Draw) public draws;
    mapping(uint256 => mapping(address => uint256)) public userTickets;
    mapping(uint256 => mapping(uint256 => address)) public ticketHolders;
    mapping(address => uint256) public userTotalTickets;
    
    // VRF variables
    bytes32 public keyHash;
    uint64 public subscriptionId;
    uint32 public callbackGasLimit;
    
    // Automation variables
    uint256 public upkeepId;
    
    constructor(
        address _usdcToken,
        address _vrfCoordinator,
        address _treasuryAddress,
        address _multisigAddress,
        bytes32 _keyHash,
        uint64 _subscriptionId,
        uint32 _callbackGasLimit
    ) VRFConsumerBaseV2(_vrfCoordinator) Ownable(msg.sender) {
        usdcToken = IERC20(_usdcToken);
        treasuryAddress = _treasuryAddress;
        multisigAddress = _multisigAddress;
        keyHash = _keyHash;
        subscriptionId = _subscriptionId;
        callbackGasLimit = _callbackGasLimit;
        lastDrawTime = block.timestamp;
    }

    function purchaseStandardTicket() external nonReentrant {
        _purchaseTicket(TicketType.Standard);
    }

    function purchaseQuantumTicket() external nonReentrant {
        _purchaseTicket(TicketType.Quantum);
    }

    function _purchaseTicket(TicketType ticketType) internal {
        uint256 ticketPrice = ticketType == TicketType.Standard ? 
            STANDARD_TICKET_PRICE : QUANTUM_TICKET_PRICE;
        
        require(usdcToken.balanceOf(msg.sender) >= ticketPrice, "Insufficient USDC balance");
        require(usdcToken.allowance(msg.sender, address(this)) >= ticketPrice, "Insufficient USDC allowance");
        
        usdcToken.safeTransferFrom(msg.sender, address(this), ticketPrice);
        
        uint256 ticketId = totalTicketsSold;
        ticketHolders[currentDrawId][ticketId] = msg.sender;
        userTickets[currentDrawId][msg.sender]++;
        userTotalTickets[msg.sender]++;
        totalTicketsSold++;
        
        uint256 feeAmount = (ticketPrice * TREASURY_FEE_PERCENTAGE) / 100;
        totalFeesCollected += feeAmount;
        
        usdcToken.safeTransfer(treasuryAddress, feeAmount);
        
        emit TicketPurchased(msg.sender, ticketType, ticketId, ticketPrice, feeAmount);
    }

    function requestRandomness() external onlyOwner {
        require(block.timestamp >= lastDrawTime + DRAW_INTERVAL, "Draw interval not met");
        require(totalTicketsSold >= MINIMUM_TICKETS_FOR_DRAW, "Insufficient tickets for draw");
        
        require(LINK.balanceOf(address(this)) >= 0, "Insufficient LINK balance");
        
        uint256 requestId = COORDINATOR.requestRandomWords(
            keyHash,
            subscriptionId,
            REQUEST_CONFIRMATIONS,
            callbackGasLimit,
            NUM_WORDS
        );
        
        emit RandomnessRequested(requestId);
    }

    function fulfillRandomWords(uint256 requestId, uint256[] memory randomWords) internal override {
        require(draws[requestId].status == DrawStatus.Pending, "Invalid request ID");
        
        uint256 winningTicket = randomWords[0] % totalTicketsSold;
        address winner = ticketHolders[currentDrawId][winningTicket];
        
        draws[requestId].status = DrawStatus.Completed;
        draws[requestId].winningTicket = winningTicket;
        draws[requestId].winner = winner;
        draws[requestId].randomWord = randomWords[0];
        
        uint256 prizeAmount = usdcToken.balanceOf(address(this));
        if (prizeAmount > 0) {
            usdcToken.safeTransfer(winner, prizeAmount);
        }
        
        emit DrawCompleted(requestId, winningTicket, winner, prizeAmount, randomWords[0]);
        
        currentDrawId++;
        lastDrawTime = block.timestamp;
        totalTicketsSold = 0;
    }

    function checkUpkeep(bytes calldata) external view override returns (bool upkeepNeeded, bytes memory performData) {
        upkeepNeeded = (block.timestamp >= lastDrawTime + DRAW_INTERVAL) && 
                       (totalTicketsSold >= MINIMUM_TICKETS_FOR_DRAW);
        performData = "";
    }

    function performUpkeep(bytes calldata) external override {
        (bool upkeepNeeded,) = this.checkUpkeep("");
        require(upkeepNeeded, "Upkeep not needed");
        
        this.requestRandomness();
    }

    function setTreasuryAddress(address _treasuryAddress) external onlyOwner {
        require(_treasuryAddress != address(0), "Invalid treasury address");
        treasuryAddress = _treasuryAddress;
        emit TreasuryAddressUpdated(_treasuryAddress);
    }

    function setMultisigAddress(address _multisigAddress) external onlyOwner {
        require(_multisigAddress != address(0), "Invalid multisig address");
        multisigAddress = _multisigAddress;
        emit MultisigAddressUpdated(_multisigAddress);
    }

    function setVRFParameters(bytes32 _keyHash, uint64 _subscriptionId, uint32 _callbackGasLimit) external onlyOwner {
        keyHash = _keyHash;
        subscriptionId = _subscriptionId;
        callbackGasLimit = _callbackGasLimit;
        emit VRFParametersUpdated(_keyHash, _subscriptionId, _callbackGasLimit);
    }

    function setAutomationUpkeepId(uint256 _upkeepId) external onlyOwner {
        upkeepId = _upkeepId;
        emit AutomationUpkeepIdUpdated(_upkeepId);
    }

    function emergencyWithdraw() external onlyOwner {
        uint256 balance = usdcToken.balanceOf(address(this));
        if (balance > 0) {
            usdcToken.safeTransfer(owner(), balance);
        }
        
        uint256 linkBalance = LINK.balanceOf(address(this));
        if (linkBalance > 0) {
            LINK.transfer(owner(), linkBalance);
        }
        
        emit EmergencyWithdraw(owner(), balance, linkBalance);
    }

    function getDrawInfo(uint256 drawId) external view returns (Draw memory) {
        return draws[drawId];
    }

    function getUserTickets(address user, uint256 drawId) external view returns (uint256) {
        return userTickets[drawId][user];
    }

    function getTicketHolder(uint256 drawId, uint256 ticketId) external view returns (address) {
        return ticketHolders[drawId][ticketId];
    }

    function getCurrentDrawStats() external view returns (
        uint256 drawId,
        uint256 ticketsSold,
        uint256 timeUntilNextDraw,
        bool canDraw
    ) {
        drawId = currentDrawId;
        ticketsSold = totalTicketsSold;
        timeUntilNextDraw = lastDrawTime + DRAW_INTERVAL > block.timestamp ? 
            lastDrawTime + DRAW_INTERVAL - block.timestamp : 0;
        canDraw = (block.timestamp >= lastDrawTime + DRAW_INTERVAL) && 
                  (totalTicketsSold >= MINIMUM_TICKETS_FOR_DRAW);
    }
}
