// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.19 <=0.9.0;


import { ERC1967Proxy } from "@openzeppelin-upgradeable/proxy/ERC1967/ERC1967Proxy.sol";
import { DecentralizedExchange } from "src/DecentralizedExchange.sol";
import { BaseScript } from "./Base.s.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract Deploy is BaseScript {
    function run() public broadcast returns (Foo foo) {
        DecentralizedExchange decentralizedExchange = new DecentralizedExchange();
        ERC1967Proxy dexProxy = new ERC1967Proxy(address(decentralizedExchange), bytes(""));

    }
}
