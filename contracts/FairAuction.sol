// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract FairAuction {
    address public owner;
    uint public highestBid;
    address public highestBidder;
    bool public isAuctionActive;

    mapping(address => uint) public bids;

    constructor() {
        owner = msg.sender;
        isAuctionActive = true;
    }

    // Function to place a bid
    function placeBid() public payable {
        require(isAuctionActive, "Auction is closed!");
        require(msg.value > highestBid, "Your bid must be higher than current highest bid!");

        // Refund the previous highest bidder
        if (highestBid > 0) {
            payable(highestBidder).transfer(highestBid);
        }

        highestBid = msg.value;
        highestBidder = msg.sender;
        bids[msg.sender] = msg.value;
    }

    // End the auction
    function endAuction() public {
        require(msg.sender == owner, "Only owner can end auction.");
        isAuctionActive = false;
        payable(owner).transfer(highestBid);
    }

    // View current highest bid
    function getHighestBid() public view returns (uint) {
        return highestBid;
    }

    // View highest bidder
    function getHighestBidder() public view returns (address) {
        return highestBidder;
    }
}
