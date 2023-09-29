// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { DecentralizedExchange, MarketOrder } from "src/DecentralizedExchange.sol";
import { BaseScript } from "./Base.s.sol";

contract Trade is BaseScript {
    uint128 internal constant ETH_USD_MARKET_ID = 1;

    function run() public broadcaster {
        DecentralizedExchange dexProxy = DecentralizedExchange(payable(vm.envAddress("DEX_PROXY")));
        dexProxy.cancelOrder(ETH_USD_MARKET_ID);
    }
}
