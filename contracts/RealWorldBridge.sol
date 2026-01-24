// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

// This Oracle is the "Truth Teller." It connects physical reality 
// (Drone work, Energy output) to the Digital Ledger.
contract RealWorldBridge is Ownable {

    // Define the structure of a Real World Event
    struct PhysicalJob {
        string jobType;      // e.g., "Drone Construction", "Book Sales"
        uint256 revenueGenerated; // Value in USDC
        bool isVerified;     // Has the work been proven?
        uint256 timestamp;
    }

    // A ledger of all physical jobs completed by the Unicorn
    mapping(uint256 => PhysicalJob) public jobHistory;
    uint256 public jobCounter;

    // EVENT: Screams to the blockchain that work was done!
    // The "Bank" (Vault) listens for this to unlock payments.
    event WorkVerified(uint256 indexed jobId, string jobType, uint256 revenue);

    constructor() Ownable(msg.sender) {}

    // THE BRIDGE FUNCTION
    // Only the "Sacred Key" (authorized IoT device or Admin) can call this.
    // It inputs real-world data into the blockchain.
    function recordRealWorldRevenue(string memory _jobType, uint256 _revenue) external onlyOwner {
        jobCounter++;
        
        jobHistory[jobCounter] = PhysicalJob({
            jobType: _jobType,
            revenueGenerated: _revenue,
            isVerified: true,
            timestamp: block.timestamp
        });

        emit WorkVerified(jobCounter, _jobType, _revenue);
    }

    // READ FUNCTION
    // Allows the Bank/Vault to check if a specific job was actually done.
    function verifyJob(uint256 _jobId) external view returns (bool, uint256) {
        PhysicalJob memory job = jobHistory[_jobId];
        return (job.isVerified, job.revenueGenerated);
    }
}
