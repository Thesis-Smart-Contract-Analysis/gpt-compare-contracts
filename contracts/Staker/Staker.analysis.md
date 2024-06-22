# Specifications
- Collects ETH from numerous addresses using a payable stake function and keeps track of balances. After some deadline if it has at least some threshold of ETH, it sends it to an ExampleExternalContract and triggers the complete action sending the full balance. If not enough ETH is collected, allow users to withdraw.
- ✅ The contract should be named as Staker and its constructor should receive an address of an `ExampleExternalContract` for initializing the external contract instance.
- ✅ Also need to define a `ExampleExternalContract` contract that have a boolean variable that is set to false by default and can be set to true by calling a payable function. If it is true, it means the staking is over.
- ✅ Have a mapping that tracks balances of each address.
- ✅ The threshold is 1 ETH.
- ✅ The stake function is a payable function and update the balance of the sender. After that, it emits an event with the sender address and the amount of ETH sent.
- ✅ The deadline is a state variable in the contract that contains timestamp of the current block plus 72 hours.
- ✅ Has a boolean state variable set to false by default and set to true when contract allows users to withdraw.
- ✅ There is a modifier that call the complete function of the external contract and get a boolean state variable of it for checking whether the staking is completed.
- ✅ Contract should have a public function with the above modifer that triggers the complete action. Inside it, contract should check if the current timestamp is greater than the deadline. If it is, check the current balance of the contract to identify whether the threshold is satisied. If it is, call the complete function of the external contract for setting the boolean variable of it to true and send all of the balance of the contract to the external contract. If the threshold is not satisfied but the time is passed, set the boolean state variable to true for allowing users to withdraw.
- ✅ The function that allows users to withdraw should check the boolean state variable. If it is true, update the balance of user in mapping and send the balance to the user. If it is false, revert the transaction. This function also need to use the modifier that checks the completion of the staking.
- ✅ Contract also has a function to calculate the left time for the deadline. If the deadline is passed, it should return 0. Else, it should return the remaining time in seconds.
- ✅ Finally, the contract should have a receive function to accept ETH transfers. Essentially, it should call the stake function.

# Beyond the expectation
- Add `require` statement to validate inputs.

# Limitation:
- Sometimes duplicate the completed variable in the main contract.
- Have a eligible syntax error in the code.