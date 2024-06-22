# Specifications
- ✅ Proxy pattern is a pattern that has two contract (but only generate the first one):
  - A proxy contract that delegates all calls to the implementation contract.
  - An implementation contract that contains the logic of the contract.
- ✅ In the constructor of the proxy contract, the implementation contract is set.
- ✅ The implementation can be upgraded through a function in the proxy contract. This function should be restricted to the owner of the proxy contract by using a modifier.
- 🌗 The operation that set the implementation contract used in constructor and the upgrade function should be a private function in the proxy contract. => **Only used in the upgrade function**.
- ✅ Contract has to have a external payable fallback function for delegating the function calls to the implementation contract.
  - In this function, the contract should use an assembly block to delegate the call to the implementation contract.
  - The delegation is made by using the `delegatecall` opcode and its return value is checked.
  - If the call is successful, the return value is returned to the caller. If the call is not successful, the transaction is reverted.
 
# Beyond the scope
- Optimize the code by only calling the `returndatacopy` when the result is true.
