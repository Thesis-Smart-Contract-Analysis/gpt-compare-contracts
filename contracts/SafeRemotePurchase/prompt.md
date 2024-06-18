As a Senior Web3 Solidity Developer, please create a smart contract for a safe remote purchase that meets the following requirements:

- Build a safe remote purchase smart contract.
- The seller initiates the process by deploying the smart contract, depositing twice the value of the item (2x funds). The seller becomes the owner of the contract upon creation, and the contract state is set to "Created."
- The buyer, upon deciding to purchase the item, enters into the smart contract and confirms the purchase by depositing twice the value of the item (2x funds). This action will set the contract state to "Locked", preventing the seller from withdrawing or making any modifications.
- At this time, the smart contract holds a total of four times the item's value (4x funds). The seller is then responsible for shipping the item to the buyer.
- Upon receiving the item, the buyer confirms receipt, the buyer's initial deposit (1x funds) will be returned. The smart contract state is then set to "Released."
- Once the contract is released, the seller can withdraw the funds. The remaining funds and the deposit (3x funds) are transferred to the seller, completing the transaction.
- The seller can also abort the contract if it remains in the "Created" state, allowing the seller to retrieve the balance of this contract.

Please ensure meticulous design of the smart contract, with functions named in an efficient and systematic manner and use correct compiler version.
