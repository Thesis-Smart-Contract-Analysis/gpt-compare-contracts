As a Senior Web3 Solidity Developer, please develop a smart contract for voting with the following specifications:

- The smart contract should be named "Ballot" and include a chairperson who deploys it.
- Each voter can vote only once for a single proposal from the list of proposals initialized during the contract deployment. The proposal list should contain only proposal names.
- Voters can delegate their vote to another voter. After delegation, the delegator will no longer be able to vote. The delegatee can then vote once for a single proposal on behalf of both themselves and the delegator, effectively casting two votes. Example: When you delegate your vote to A, if A has already voted, your vote will be added to A's vote for that proposal. If A hasn't voted yet, A will cast a vote with the combined weight of two votes in the next voting session.
- A voter can only vote with the chairperson's approval.

Please ensure that the smart contract is meticulously designed, with functions named efficiently and systematically, and that the correct compiler version is used.
