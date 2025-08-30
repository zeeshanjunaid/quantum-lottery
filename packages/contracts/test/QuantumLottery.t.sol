// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/QuantumLottery.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract MockUSDC is ERC20 {
    constructor() ERC20("Mock USDC", "USDC") {
        _mint(msg.sender, 1000000 * 10**6);
    }

    function decimals() public pure override returns (uint8) {
        return 6;
    }
}

contract QuantumLotteryTest is Test {
    QuantumLottery public lottery;
    MockUSDC public usdc;
    
    address public treasury = address(0x123);
    address public multisig = address(0x456);
    address public user = address(0x789);
    
    bytes32 public keyHash = bytes32(uint256(1));
    uint64 public subscriptionId = 1;
    uint32 public callbackGasLimit = 500000;

    function setUp() public {
        usdc = new MockUSDC();
        
        lottery = new QuantumLottery(
            address(usdc),
            address(0), // Mock VRF coordinator
            treasury,
            multisig,
            keyHash,
            subscriptionId,
            callbackGasLimit
        );
        
        usdc.transfer(user, 1000 * 10**6);
        vm.prank(user);
        usdc.approve(address(lottery), type(uint256).max);
    }

    function testPurchaseStandardTicket() public {
        vm.prank(user);
        lottery.purchaseStandardTicket();
        
        assertEq(lottery.totalTicketsSold(), 1);
        assertEq(lottery.userTickets(0, user), 1);
        assertEq(lottery.userTotalTickets(user), 1);
    }

    function testPurchaseQuantumTicket() public {
        vm.prank(user);
        lottery.purchaseQuantumTicket();
        
        assertEq(lottery.totalTicketsSold(), 1);
        assertEq(lottery.userTickets(0, user), 1);
        assertEq(lottery.userTotalTickets(user), 1);
    }

    function testTicketPrices() public {
        assertEq(lottery.STANDARD_TICKET_PRICE(), 10 * 10**6);
        assertEq(lottery.QUANTUM_TICKET_PRICE(), 30 * 10**6);
    }

    function testTreasuryFee() public {
        assertEq(lottery.TREASURY_FEE_PERCENTAGE(), 8);
    }

    function testConstants() public {
        assertEq(lottery.MINIMUM_TICKETS_FOR_DRAW(), 10);
        assertEq(lottery.DRAW_INTERVAL(), 1 days);
    }

    function testGetCurrentDrawStats() public {
        (uint256 drawId, uint256 ticketsSold, uint256 timeUntilNextDraw, bool canDraw) = lottery.getCurrentDrawStats();
        
        assertEq(drawId, 0);
        assertEq(ticketsSold, 0);
        assertEq(canDraw, false);
    }

    function testSetTreasuryAddress() public {
        address newTreasury = address(0x999);
        lottery.setTreasuryAddress(newTreasury);
        assertEq(lottery.treasuryAddress(), newTreasury);
    }

    function testSetMultisigAddress() public {
        address newMultisig = address(0x888);
        lottery.setMultisigAddress(newMultisig);
        assertEq(lottery.multisigAddress(), newMultisig);
    }

    function testSetVRFParameters() public {
        bytes32 newKeyHash = bytes32(uint256(2));
        uint64 newSubscriptionId = 2;
        uint32 newCallbackGasLimit = 600000;
        
        lottery.setVRFParameters(newKeyHash, newSubscriptionId, newCallbackGasLimit);
        
        assertEq(lottery.keyHash(), newKeyHash);
        assertEq(lottery.subscriptionId(), newSubscriptionId);
        assertEq(lottery.callbackGasLimit(), newCallbackGasLimit);
    }

    function testSetAutomationUpkeepId() public {
        uint256 newUpkeepId = 123;
        lottery.setAutomationUpkeepId(newUpkeepId);
        assertEq(lottery.upkeepId(), newUpkeepId);
    }
}
