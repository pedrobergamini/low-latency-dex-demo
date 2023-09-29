// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import { ERC1967Proxy } from "@openzeppelin/proxy/ERC1967/ERC1967Proxy.sol";
import { DecentralizedExchange } from "src/DecentralizedExchange.sol";
import { BaseScript } from "./Base.s.sol";

contract Deploy is BaseScript {
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
