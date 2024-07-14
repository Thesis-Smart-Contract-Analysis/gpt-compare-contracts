// https://chatgpt.com/share/5895b8a0-76f1-4444-89a7-4ba36b55dce1

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Proxy {
    address private implementation;
    address private owner;

    event ImplementationUpgraded(address indexed newImplementation);

    modifier onlyOwner() {
        require(msg.sender == owner, "Proxy: Not the owner");
        _;
    }

    constructor(address _implementation) {
        owner = msg.sender;
        _setImplementation(_implementation);
    }

    function upgradeImplementation(
        address _newImplementation
    ) external onlyOwner {
        _setImplementation(_newImplementation);
    }

    function _setImplementation(address _newImplementation) private {
        implementation = _newImplementation;
        emit ImplementationUpgraded(_newImplementation);
    }

    fallback() external payable {
        _delegate();
    }

    function _delegate() private {
        address impl = implementation;
        require(impl != address(0), "Proxy: Implementation address not set");

        assembly {
            // Copy calldata to memory
            calldatacopy(0, 0, calldatasize())

            // Delegate call to the implementation contract
            let result := delegatecall(gas(), impl, 0, calldatasize(), 0, 0)

            // Copy the returned data to memory
            returndatacopy(0, 0, returndatasize())

            switch result
            case 0 {
                revert(0, returndatasize())
            }
            default {
                return(0, returndatasize())
            }
        }
    }
}
