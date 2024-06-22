// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Proxy {
    address private implementation;
    address private owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can call this function");
        _;
    }

    constructor(address _implementation) {
        implementation = _implementation;
        owner = msg.sender;
    }

    function upgradeImplementation(
        address _newImplementation
    ) external onlyOwner {
        _setImplementation(_newImplementation);
    }

    function _setImplementation(address _newImplementation) private {
        implementation = _newImplementation;
    }

    fallback() external payable {
        address _impl = implementation;

        assembly {
            let ptr := mload(0x40)
            calldatacopy(ptr, 0, calldatasize())

            let result := delegatecall(gas(), _impl, ptr, calldatasize(), 0, 0)

            switch result
            case 0 {
                revert(0, 0)
            }
            default {
                let size := returndatasize()
                returndatacopy(ptr, 0, size)
                return(ptr, size)
            }
        }
    }
}
