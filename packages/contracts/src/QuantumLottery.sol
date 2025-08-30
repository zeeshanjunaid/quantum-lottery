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

    // TODO: Implement contract logic
}
