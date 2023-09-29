// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Project dependencies
import { BasicReport } from "../chainlink/interfaces/IStreamsLookupCompatible.sol";
import { MarketOrder } from "./MarketOrder.sol";

library Position {
    using MarketOrder for MarketOrder.Data;

    struct Data {
        int128 size;
        uint128 initialMargin;
        uint256 lastPrice;
    }

    function settleOrder(Data storage self, MarketOrder.Data storage order, BasicReport memory report) internal {
        self.size += order.payload.sizeDelta;
        self.initialMargin = order.payload.newInitialMargin;
        self.lastPrice = uint256(int256(report.benchmark));

        order.fulfill();
    }
}
