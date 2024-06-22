pragma solidity ^0.5.0;

contract Proxy {
    address public proxyOwner;
    address public implementation;

    constructor(address _implementation) public {
        proxyOwner = msg.sender;
        _setImplementation(_implementation);
    }

    modifier onlyProxyOwner() {
        require(msg.sender == proxyOwner);
        _;
    }

    function upgrade(address _implementation) external onlyProxyOwner {
        _setImplementation(_implementation);
    }

    function _setImplementation(address imp) private {
        implementation = imp;
    }

    function() external payable {
        address impl = implementation;

        assembly {
            calldatacopy(0, 0, calldatasize)
            let result := delegatecall(gas, impl, 0, calldatasize, 0, 0)
            returndatacopy(0, 0, returndatasize)

            switch result
            case 0 {
                revert(0, returndatasize)
            }
            default {
                return(0, returndatasize)
            }
        }
    }
}
