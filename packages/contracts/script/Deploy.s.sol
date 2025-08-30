// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/QuantumLottery.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        address usdcToken = vm.envAddress("USDC_ADDRESS");
        address vrfCoordinator = vm.envAddress("VRF_COORDINATOR");
        address treasuryAddress = vm.envAddress("TREASURY_ADDRESS");
        address multisigAddress = vm.envAddress("MULTISIG_ADDRESS");
        bytes32 keyHash = vm.envBytes32("VRF_KEYHASH");
        uint64 subscriptionId = vm.envUint64("VRF_SUBSCRIPTION_ID");
        uint32 callbackGasLimit = vm.envUint32("VRF_CALLBACK_GAS_LIMIT");

        vm.startBroadcast(deployerPrivateKey);

        QuantumLottery lottery = new QuantumLottery(
            usdcToken,
            vrfCoordinator,
            treasuryAddress,
            multisigAddress,
            keyHash,
            subscriptionId,
            callbackGasLimit
        );

        vm.stopBroadcast();

        console.log("QuantumLottery deployed at:", address(lottery));
        console.log("USDC Token:", usdcToken);
        console.log("VRF Coordinator:", vrfCoordinator);
        console.log("Treasury Address:", treasuryAddress);
        console.log("Multisig Address:", multisigAddress);
        console.log("Key Hash:", vm.toString(keyHash));
        console.log("Subscription ID:", subscriptionId);
        console.log("Callback Gas Limit:", callbackGasLimit);
    }
}
