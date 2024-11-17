// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// Import Foundry's Script utility
import "forge-std/Script.sol";

// Import your contract
import "../src/BlockchainVotingContract.sol";

/**
 * @dev Deployment script for BlockchainVotingContract
 */
contract Deploy is Script {
    function run() external {
        // Start the Foundry broadcast, enabling contract deployment
        vm.startBroadcast();

        // Deploy the BlockchainVotingContract
        BlockchainVotingContract votingContract = new BlockchainVotingContract();

        // Log the deployed contract address to the console
        console.log("BlockchainVotingContract deployed at:", address(votingContract));

        // Stop the broadcast
        vm.stopBroadcast();
    }
}
