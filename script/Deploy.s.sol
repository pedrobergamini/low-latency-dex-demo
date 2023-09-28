// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import { ERC1967Proxy } from "@openzeppelin/proxy/ERC1967/ERC1967Proxy.sol";
import { DecentralizedExchange } from "src/DecentralizedExchange.sol";
import { BaseScript } from "./Base.s.sol";

import "forge-std/console.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract Deploy is BaseScript {
    function run() public broadcaster returns (DecentralizedExchange, DecentralizedExchange) {
        DecentralizedExchange dexImplementation = new DecentralizedExchange();
        bytes memory proxyCallData = abi.encodeWithSelector(dexImplementation.initialize.selector);
        DecentralizedExchange dexProxy =
            DecentralizedExchange(address(new ERC1967Proxy(address(dexImplementation), proxyCallData)));

        return (dexImplementation, dexProxy);
    }
}
