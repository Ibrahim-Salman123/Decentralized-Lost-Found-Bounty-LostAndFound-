A trustless escrow protocol for lost item recovery rewards built on Ethereum using Solidity. It uses cryptographic proofs to secure cash bounties, preventing fraudulent claims and ensuring finders are fairly compensated.

📌 Overview
The LostAndFound smart contract provides a decentralized framework to coordinate recovery rewards for lost items (such as valuable devices, keys, or wallets). Traditional reward systems suffer from mutual distrust: finders worry owners won't pay them upon return, while owners worry that public rewards attract scammers making fake ownership claims. This contract resolves these issues by letting owners hide a secret passphrase on their physical property and register its one-way SHA3-keccak256 hash on-chain along with a locked crypto bounty. Finders can instantly withdraw the reward by submitting the correct plaintext passphrase, with no admin approval required.

🛠 Features
Escrow-Backed Payout Assurances: Gives finders absolute mathematical proof that the owner's reward money is fully backed and locked by immutable code.

Cryptographic Fraud Prevention: Rejects malicious claims from bad actors guessing item descriptions; only the person holding the physical asset can read the hidden secret phrase.

Intermediary-Free Processing: Operates autonomously 24/7, eliminating the need for third-party platforms, administrative paperwork, or manual claims processing.

📄 Smart Contract Architecture
Data Structures
Item (Struct)
Tracks individual recovery parameters:

owner: The wallet address of the individual who lost the asset and funded the compensation pool.

itemDescription: Public text containing item descriptions or instructions for returning it.

secretHash: The pre-calculated keccak256 commitment hash of the unique private phrase hidden on the object.

bounty: The total financial value in Wei locked securely under contract stewardship.

isFound: A boolean flag used to freeze duplicate claims once a recovery is complete.

State Variables
itemCount: A public tracking counter incremented to assign unique index IDs to every newly reported lost item.

items: A public tracking registry map linking numerical item IDs (uint256 => Item) to their structural configurations.

⚙️ Core Functions
1. registerLostItem(string memory _description, bytes32 _secretHash)
Permission: Public Payable

Description: Creates a recovery instance. The owner supplies the item details and its cryptographic hash payload, while attaching the crypto reward funds directly to the transaction.

2. claimBounty(uint256 _itemId, string memory _secretPhrase)
Permission: Public

Description: Compares the claimant's plaintext input against the stored secretHash using keccak256(abi.encodePacked(_secretPhrase)). On a successful match, it marks the item as found, clears the bounty balance to zero to prevent reentrancy, and instantly sends the reward to the finder.

🔔 Events
ItemRegistered(uint256 indexed itemId, string description, uint256 bounty): Emitted to broadcast item loss and notify recovery networks about the reward incentives.

ItemClaimed(uint256 indexed itemId, address indexed finder, uint256 reward): Emitted the exact second a finder successfully satisfies the validation criteria and withdraws the bounty.

🚀 Tech Stack & Setup
Language: Solidity ^0.8.20

Tools: Remix IDE / Hardhat / Foundry

Standard Deploy Instructions: Compute a hash of your item's secret string off-chain (e.g., using online tools or web3 utilities). Call registerLostItem, paste the hash value, fill out the descriptions, and attach your reward funds before sending the transaction
