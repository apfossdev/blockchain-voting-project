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

/**
 * @title Blockchain Voting Smart Contract
 * @author Annamalai Prabu 
 * @dev This contract allows admins to create elections and users to vote.
 *      Admins can create elections with candidates
 */

contract BlockchainVotingContract {
    // ----- Type Declarations -----
    struct Candidate {
        string name; //name of the candidate
        uint256 votes; //number of votes the candidate has received
    }

    struct Election {
        string name; //name of the election
        uint256 endTime; //timestamp of the election end
        mapping(uint256 => Candidate) candidates; //candidates named mapping of candidate IDs to candidates
        uint256 candidatesCount; //number of candidates in the election
        bool resultsAnnounced; //whether the results have been announced
        bool exists; //whether the election exists or not
    }

     // ----- State Variables -----
    address public admin; //address of the admin
    uint256 public electionsCount; //number of elections created
    mapping(uint256 => Election) public elections; //elections mapping of election IDs to elections
    mapping(uint256 => mapping(address => bool)) public hasVoted; //mapping of voters which tracks whether an address has voted or not

    // ----- Events -----
    event ElectionCreated(uint256 indexed electionId, string electionName, uint256 endTime);
    event Voted(uint256 indexed electionId, address voter, uint256 indexed candidateId);
    event CandidateAdded(uint256 indexed electionId, uint256 indexed candidateId, string name);    
    event ResultsAnnounced(uint256 indexed electionId, string winnerName, uint256 winnerVotes);

    // ----- Custom Errors -----
    // They are much more gas efficient than require statements
    error UnauthorizedAccess();
    error ElectionNotFound();
    error ElectionEnded();
    error ElectionNotEnded();
    error AlreadyVoted();
    error InvalidCandidate();
    error ResultsAlreadyAnnounced();
    error InvalidElectionSetup();

     // ----- Modifiers -----
     // Modifier to restrict access to the admin
     modifier onlyAdmin() {
        if(msg.sender != admin) revert UnauthorizedAccess();
        _;
    }

    // Modifier to ensure election exists
    modifier electionExists(uint256 _electionId){
        if(!elections[_electionId].exists) revert ElectionNotFound();
        _;
    }

    // Modifier to ensure the election is still ongoing
    modifier electionOngoing(uint256 _electionId) {
        if(elections[_electionId].endTime <= block.timestamp) revert ElectionEnded();
        _;
    }

    //Modifier to ensure the election has ended
    modifier electionEnded(uint256 _electionId) {
        if(elections[_electionId].endTime > block.timestamp) revert ElectionNotEnded();
        _;
    }

    // ----- Constructor -----
    constructor() {
        admin = msg.sender; // set the admin to the deployer of the contract (msg.sender is the address of the deployer)
    }

    // ----- Functions -----
    // Function to create an election
    function createElection(
        string memory _electionName, // Election name
        uint256 _duration, //Duration of the election in seconds
        string[] memory _candidateNames //An array of candidate names
    )
        public
        onlyAdmin // only allow the admin to call this function
    {
        if(_candidateNames.length == 0) {
            revert InvalidElectionSetup();
        } //prevent election from happening if the array length is 0

        electionsCount++; // increment the election count (every new election gets a new ID then)
        Election storage newElection = elections[electionsCount]; // create a new election, here elections count is used as the ID and elections is a mapping where each election ID (a unique number) maps to an election (a struct with candidate names, votes, etc.).
        // the above line just references the election struct in the mapping so that we can modify it here as done below
        newElection.name = _electionName; // set the election name
        newElection.endTime = block.timestamp + _duration; // set the election end time (current time + duration)
        newElection.exists = true; // set the election to exist

        //Loop through all the candidates and add them to the election
        for (uint256 i = 0; i < _candidateNames.length; i++) {
            newElection.candidates[i] = Candidate({
                name: _candidateNames[i],
                votes: 0
            }); //here we are creating a new candidate and adding it to the election
            newElection.candidatesCount++; //increment the number of candidates by 1 in each iteration in the election
            emit CandidateAdded(electionsCount, i, _candidateNames[i]); //emit an event while each candidate is created
        }

        // Emit an event to indicate that the election has been created
        emit ElectionCreated(electionsCount, _electionName, _duration);
    }

    // Function to allow a user to vote in an election
    function vote(
        uint256 _electionId, // Election ID
        uint256 _candidateId // Candidate ID
    )
        public 
        electionExists(_electionId) // only allow the user to vote if the election exists
        electionOngoing(_electionId) // only allow the user to vote if the election is still ongoing
    {
        // Ensure the user has not already voted
        if(hasVoted[_electionId][msg.sender])   revert AlreadyVoted();

        Election storage election = elections[_electionId]; // get the election struct by id
        if(_candidateId > election.candidatesCount) revert InvalidCandidate();

        // Increment the candidate's vote count
        election.candidates[_candidateId].votes++;

        // Mark the user as having voted
        hasVoted[_electionId][msg.sender] = true;

        // Emit an event to indicate that the user has voted
        emit Voted(_electionId, msg.sender, _candidateId);
    }

    // Function to view the results of an election after it has ended
    // it gives the winner's name and the number of votes they received once the election is over
    function viewResults(uint256 _electionId)
    public
    view
    electionExists(_electionId) // ensures the election exists
    electionEnded(_electionId) // ensures the election has ended
    returns (string memory winnerName, uint256 winnerVotes) {
        Election storage election = elections[_electionId]; // get the election struct by id
        if(election.resultsAnnounced) revert ResultsAlreadyAnnounced(); // ensure the results have not already been announced  

        uint256 winnerCandidateId = 0; // initialize the winner candidate ID to 0
        uint256 winnerVoteCount = 0;

        // Loop through all candidates to find the one with the most votes
        for(uint256 i = 0; i < election.candidatesCount; i++) {
            if(election.candidates[i].votes > winnerVoteCount) { // if the candidate's votes are greater than the winner's votes
                winnerCandidateId = i; // set the winner candidate ID to the current candidate ID
                winnerVoteCount = election.candidates[i].votes; // set the winner votes to the current candidate's votes
            }
        }

        return(
            election.candidates[winnerCandidateId].name, // return the winner's name
            winnerVoteCount // return the winner's votes
        );
    }   

     // New view functions for testing and verification
    function getCandidateInfo(uint256 _electionId, uint256 _candidateId) 
        public 
        view 
        electionExists(_electionId)
        returns (string memory name, uint256 votes) 
    {
        if (_candidateId >= elections[_electionId].candidatesCount) revert InvalidCandidate();
        Candidate storage candidate = elections[_electionId].candidates[_candidateId];
        return (candidate.name, candidate.votes);
    }

    function getElectionInfo(uint256 _electionId)
        public
        view
        electionExists(_electionId)
        returns (
            string memory name,
            uint256 endTime,
            uint256 candidatesCount,
            bool resultsAnnounced
        )
    {
        Election storage election = elections[_electionId];
        return (
            election.name,
            election.endTime,
            election.candidatesCount,
            election.resultsAnnounced
        );
    }
}