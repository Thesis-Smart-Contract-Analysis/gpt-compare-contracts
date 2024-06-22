- ✅ The contract is named with "Vendor" and it will be used as a vending machine for selling and buying an ERC20 token. 
- ✅ That token is a token with "Gold" as a name and "GLD" as a symbol. Contract of token should be named as "YourToken" Also, the token will inherit the ERC20 interface of OpenZeppelin.
- ✅ The constructor of the token will mint 2000 * 10 ** 18 tokens for the deployer.
- ✅ Vendor contract should inherit Ownable contract from OpenZeppelin to have the ability to change the owner of the contract. It must pass the address of the deployer to the Ownable constructor.
- ✅ Constructor of Vendor contract should initialize the token address and assign it to the token variable.
- ✅ In the contract, declare the price as 100 token per 1 ether.
- ✅ Contract should have a public payable function for users to buy tokens. This function should take the sent ETH and multiply it by the price to calculate the amount of tokens to send to the user. After that, send the tokens to the user and emit a event with the user address, the sent ETH, and the amount of tokens sent.
- ✅ Contract also have a public function for users to sell tokens with a specific amount as an argument. This function will transfer tokens from the user to the contract first. Then, it should calculate the amount of ETH that will be sent to the user by dividing the specified amount by number of tokens per ether. Finally, send the ETH to the user and emit a event with the user address, the amount of tokens sold, and the amount of ETH sent.
- ✅ Finally, contract should have a withdraw function for withdrawing the ETH from the contract by the owner.

Beyond the expectation:
- Has `require` statements for validation of the input arguments.

Limitation:
- Missing passing the address of the deployer to the Ownable constructor.