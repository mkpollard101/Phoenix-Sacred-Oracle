// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract RealWorldBridge is Ownable {
    struct PhysicalJob {
        string jobType;
        uint256 revenueGenerated;
        bool isVerified;
        uint256 timestamp;
    }
    mapping(uint256 => PhysicalJob) public jobHistory;
    uint256 public jobCounter;
    event WorkVerified(uint256 indexed jobId, string jobType, uint256 revenue);

    constructor() Ownable(msg.sender) {}

    function recordRealWorldRevenue(string memory _jobType, uint256 _revenue) external onlyOwner {
        jobCounter++;
        jobHistory[jobCounter] = PhysicalJob(_jobType, _revenue, true, block.timestamp);
        emit WorkVerified(jobCounter, _jobType, _revenue);
    }
}
