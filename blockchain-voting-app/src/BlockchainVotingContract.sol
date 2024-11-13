// Layout of Contract:
// version
// imports
// errors
// interfaces, libraries, contracts
// Type declarations -> this includes structs
// State variables
// Events
// Modifiers
// Functions

// Layout of Functions:
// constructor
// receive function (if exists)
// fallback function (if exists)
// external
// public
// internal
// private
// view & pure functions


// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@anon-aadhaar/contracts/src/AnonAadhaar.sol"; // Anon Aadhaar Verification Library

/**
 * @title Blockchain Voting Smart Contract
 * @author Annamalai Prabu 
 * @dev This contract allows admins to create elections and users to vote using Anon Aadhaar verification.
 *      Admins can create elections with candidates and their IPFS-stored photos. 
 *      Users can vote after verification that they are over 18 using the Anon Aadhaar protocol.
 */

contract BlockchainVotingContract {
    // ----- Type Declarations -----
    struct Candidate {
        string name; //name of the candidate
        string photoHash; //IPFS hash of the photo of the candidate
        uint256 votes; //number of votes the candidate has received
    }

    struct Election {
        string name; //name of the election
        uint256 endTime; //timestamp of the election end
        mapping(uint256 => Candidate) candidates; //candidates named mapping of candidate IDs to candidates
        uint256 candidatesCount; //number of candidates in the election
        bool resultsAnnounced; //whether the results have been announced
    }

     // ----- State Variables -----
    address public admin; //address of the admin
    uint256 public electionsCount; //number of elections created
    mapping(uint256 => Election) public elections; //elections mapping of election IDs to elections
    mapping(uint256 => mapping(address => bool)) public hasVoted; //mapping of voters which tracks whether an address has voted or not

     // ----- Modifiers -----
     // Modifier to restrict access to the admin
     modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    // Modifier to ensure the election is still ongoing
    modifier electionOngoing(uint256 _electionId) {
        require(elections[_electionId].endTime > block.timestamp, "Election is over");
        _;
    }

    //Modifier to ensure the election has ended
    modifier electionEnded(uint256 _electionId) {
        require(elections[_electionId].endTime <= block.timestamp, "Election is not over");
        _;
    }

    // ----- Constructor -----
    constructor() {
        admin = msg.sender; // set the admin to the deployer of the contract (msg.sender is the address of the deployer)
    }

    // ----- Admin Functions -----
    // Function to create an election
    function createElection(
        string memory _electionName, // Election name
        uint256 _duration, //Duration of the election in seconds
        string[] memory _candidateNames, //An array of candidate names
        string[] memory _candidatePhotoHashes //An array of IPFS hashes of the candidate photos
    )
        public
        onlyAdmin // only allow the admin to call this function
    {
        require(_candidateNames.length == _candidatePhotoHashes.length, "Candidate names array and photos arrays lengths must match");
        electionsCount++; // increment the election count (every new election gets a new ID then)
        Election storage newElection = elections[electionsCount]; // create a new election, here elections count is used as the ID and elections is a mapping where each election ID (a unique number) maps to an election (a struct with candidate names, votes, etc.).
        // the above line just references the election struct in the mapping so that we can modify it here as done below
        newElection.name = _electionName; // set the election name
        newElection.endTime = block.timestamp + _duration; // set the election end time (current time + duration)

        //Loop through all the candidates and add them to the election
        for (uint256 i = 0; i < _candidateNames.length; i++) {
            newElection.candidates[i] = Candidate({
                name: _candidateNames[i],
                photoHash: _candidatePhotoHashes[i],
                votes: 0
            }); //here we are creating a new candidate and adding it to the election
            newElection.candidatesCount++; //increment the number of candidates by 1 in each iteration in the election
        }

    
    
    
    }
}