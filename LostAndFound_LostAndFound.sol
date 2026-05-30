// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title LostAndFound
 * @notice Facilitates anonymous, cryptographically secured bounty payouts for lost items.
 */
contract LostAndFound {
    struct Item {
        address owner;
        string itemDescription;
        bytes32 secretHash; // Keccak256 hash of a unique serial number or secret string hidden on the item
        uint256 bounty;
        bool isFound;
    }

    uint256 public itemCount;
    mapping(uint256 => Item) public items;

    event ItemRegistered(uint256 indexed itemId, string description, uint256 bounty);
    event ItemClaimed(uint256 indexed itemId, address indexed finder, uint256 reward);

    /**
     * @notice Register a lost item by locking a reward and setting a cryptographic verification secret.
     * @param _description Visual descriptors or return instructions for the item.
     * @param _secretHash The pre-calculated keccak256 hash of the verification passphrase.
     */
    function registerLostItem(string memory _description, bytes32 _secretHash) external payable {
        require(msg.value > 0, "Bounty reward must be greater than zero");

        itemCount++;
        items[itemCount] = Item({
            owner: msg.sender,
            itemDescription: _description,
            secretHash: _secretHash,
            bounty: msg.value,
            isFound: false
        });

        emit ItemRegistered(itemCount, _description, msg.value);
    }

    /**
     * @notice Allows a finder to input the plaintext phrase to instantly claim the locked bounty.
     * @param _itemId The unique index identifier of the registered item.
     * @param _secretPhrase The plaintext string that matches the registered hash.
     */
    function claimBounty(uint256 _itemId, string memory _secretPhrase) external {
        Item storage item = items[_itemId];
        require(!item.isFound, "Bounty has already been claimed for this item");
        require(keccak256(abi.encodePacked(_secretPhrase)) == item.secretHash, "Invalid secret phrase provided");

        item.isFound = true;
        uint256 reward = item.bounty;
        item.bounty = 0;

        payable(msg.sender).transfer(reward);

        emit ItemClaimed(_itemId, msg.sender, reward);
    }
}