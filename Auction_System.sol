// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Decentralized Auction System
 */
contract DecentralizedAuction {
    struct Auction {
        address seller;
        string item;
        uint highestBid;
        address highestBidder;
        bool ended;
    }
    
    mapping(uint => Auction) public auctions;
    uint public auctionCount;
    
    function createAuction(string memory _item) public {
        auctionCount++;
        auctions[auctionCount] = Auction(msg.sender, _item, 0, address(0), false);
    }
    
    function placeBid(uint _auctionId) public payable {
        Auction storage auction = auctions[_auctionId];
        require(msg.value > auction.highestBid, "Bid must be higher");
        auction.highestBid = msg.value;
        auction.highestBidder = msg.sender;
    }
    
    function endAuction(uint _auctionId) public {
        Auction storage auction = auctions[_auctionId];
        require(msg.sender == auction.seller, "Only seller can end");
        require(!auction.ended, "Auction already ended");
        auction.ended = true;
        payable(auction.seller).transfer(auction.highestBid);
    }
}
