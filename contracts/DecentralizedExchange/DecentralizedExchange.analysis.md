## Specifications
- ✅ Construct BAL token with 1000 pre-minted tokens for the deployer.
- 🌗 Store the total liquidity and a mapping between the user's address and their liquidity in the contract. Also implement a function to check the liquidity of the user. => **Missing but still work**.
- ✅ Constructor initialize the token.
- ✅ Initialize function that transfer a specific amount of tokens (specfied by the parameter) from the deployer to the contract. 
- ✅ Set the total liquidity to current balance of the contract and the deployer's liquidity to the total liquidity.
- Has a function to calculate the price of BAL in ETH. 
  - ✅ The price is calculated by the following formula: y = x * k / (x + a), where x is the input of a token (named it as X) and y is the output of another token (named it as Y). The k in the formula is the reserve of the token Y, and a is the reserve of the token X. 
  - ✅ Also, keep 0.3% of X as a fee by multiplying the X with 997 and divide it by 1000.
- ✅ Has a function to swap ETH for BAL: 
  - The function is payable. It will send to the user the amount of BAL that they will receive exchange for the amount of ETH sent.
  - The reserve of ETH will should be calculated by deducting the amount of ETH sent from the contract's balance. The reserve of BAL will be get from the token contract.
  - After that, it should calculate the amount of BAL that the user will receive by calling the price calculation function.
  - Transfer the amount of BAL through the token contract to the user.
  - Emit an event that logs the transaction sender, a string to identify the action, the amount of ETH sent, and the amount of BAL received.
  - Finally, return the amount of BAL that the user will receive.
- ✅ Similar, contract also have a function to swap BAL and ETH:
  - The function should take the amount of BAL as input and return the amount of ETH that the user will receive.
  - The reserve of BAL will be get from the token contract. The reserve of ETH is current balance of the contract.
  - Calculate the amount of ETH that the user will receive by calling the price calculation function.
  - Transfer BAL from the user to the contract.
  - Transfer ETH from the contract to the user.
  - Emit an event that logs the transaction sender, a string to identify the action, the amount of BAL sent, and the amount of ETH received.
  - Finally, return the amount of ETH that the user will receive.
- ✅ Moreover, the contract should have a function to deposit:
  - It should be payable.
  - It will calculate the liquidity of the ETH that user sent by multiplying the amount of sent ETH with the total liquidity and divide it by the balance of the contract before the deposit (deducting the amount of ETH sent).
  - Update liquidity of the user and the total liquidity.
  - Calculate the amount of BAL that the user will deposit by multiplying the amount of sent ETH with the reserve of BAL and divide it by the reserve of ETH. Also, plus 1 to this amount.
  - Emit an event that logs the transaction sender, the amount of liquidity, the amount of ETH sent, and the amount of BAL deposited.
  - Transfer the amount of BAL from the user to the contract.
  - Finally, return the amount of liquidity that the user will receive.
- ✅ Contract should have a function to withdraw liquidity:
  - The function should take the amount of liquidity that the user wants to withdraw as input.
  - Calculate the amount of ETH that the user will receive by multiplying the amount of liquidity with the balance of the contract and divide it by the total liquidity.
  - Calculate the amount of BAL that the user will receive by multiplying the amount of liquidity with the reserve of BAL and divide it by the total liquidity.
  - Update the liquidity of the user and the total liquidity.
  - Transfer the amount of ETH and BAL to the user.
  - Emit an event that logs the transaction sender, the amount of liquidity, the amount of ETH received, and the amount of BAL received.
  - Finally, return the amount of ETH and BAL that the user will receive.

## Beyond the expectation
- Know which arguments to pass to the functions. If the order of the parameters is mis-declared, the code still be able to pass the correct arguments.
- Know how to inherit from OpenZeppelin contracts.
- Contract merge two events in one, meaning that it can regconize the pattern.

## Limitation
- Missing `require` statements for input and calculation validations (sometimes).
- Have to be specify for each line of code => this will not suitable for generate code that does not have a detail specification.
- Missing constructor arguments for the Ownable contract.
- Some values used many places are not stored in a variable.

## Some common errors
- Do not calculate fee inside the price calculation function or missing calculation when calling the price calculation function.
- The term "reserve" used in the prompt many times but its value is not fixed. Sometimes, the contract hardcodes the reserve value based on its value at some places.