// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { DecentralizedExchange } from "src/DecentralizedExchange.sol";
import { BaseScript } from "./Base.s.sol";

contract Upgrade is BaseScript {
    function run() public broadcaster returns (DecentralizedExchange, DecentralizedExchange) {
        DecentralizedExchange dexImplementation = new DecentralizedExchange();

        bytes memory initializeData = abi.encodeWithSelector(dexImplementation.initialize.selector);
        (bool success,) = address(dexImplementation).call(initializeData);
        require(success, "dexImplementation.initialize failed");

        DecentralizedExchange dexProxy = DecentralizedExchange(payable(vm.envAddress("DEX_PROXY")));
        dexProxy.upgradeTo(address(dexImplementation));

        return (dexImplementation, dexProxy);
    }
}
