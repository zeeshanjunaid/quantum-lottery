// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

library LotteryMath {
    uint256 public constant PRECISION = 1e18;
    uint256 public constant PERCENTAGE_DENOMINATOR = 100;

    function calculateFee(uint256 amount, uint256 feePercentage) internal pure returns (uint256) {
        return (amount * feePercentage) / PERCENTAGE_DENOMINATOR;
    }

    function calculatePrizePool(uint256 totalAmount, uint256 feePercentage) internal pure returns (uint256) {
        return totalAmount - calculateFee(totalAmount, feePercentage);
    }

    function calculateOdds(uint256 userTickets, uint256 totalTickets) internal pure returns (uint256) {
        if (totalTickets == 0) return 0;
        return (userTickets * PRECISION) / totalTickets;
    }

    function calculateTimeUntilNextDraw(uint256 lastDrawTime, uint256 drawInterval) internal view returns (uint256) {
        uint256 nextDrawTime = lastDrawTime + drawInterval;
        if (block.timestamp >= nextDrawTime) return 0;
        return nextDrawTime - block.timestamp;
    }

    function isDrawReady(uint256 lastDrawTime, uint256 drawInterval, uint256 totalTickets, uint256 minTickets) internal view returns (bool) {
        return (block.timestamp >= lastDrawTime + drawInterval) && (totalTickets >= minTickets);
    }

    function validateTicketPrice(uint256 price, uint256 expectedPrice) internal pure returns (bool) {
        return price == expectedPrice;
    }

    function calculateTicketValue(uint256 basePrice, uint256 multiplier) internal pure returns (uint256) {
        return basePrice * multiplier;
    }
}
