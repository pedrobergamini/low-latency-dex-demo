// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import { DecentralizedExchange, MarketOrder } from "src/DecentralizedExchange.sol";
import { BaseScript } from "./Base.s.sol";

contract Trade is BaseScript {
    uint128 internal constant ETH_USD_MARKET_ID = 1;

    function run() public broadcaster returns (MarketOrder.Payload memory) {
        DecentralizedExchange dexProxy = DecentralizedExchange(payable(vm.envAddress("DEX_PROXY")));

        uint128 initialMargin = 1000e18;
        int128 sizeDelta = 10_000e18;

        MarketOrder.Payload memory payload =
            MarketOrder.Payload({ marketId: ETH_USD_MARKET_ID, newInitialMargin: initialMargin, sizeDelta: sizeDelta });
        dexProxy.createOrder(payload);

        return payload;
    }
}
