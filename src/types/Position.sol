// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Project dependencies
import { BasicReport } from "../chainlink/interfaces/IStreamsLookupCompatible.sol";
import { MarketOrder } from "./MarketOrder.sol";

library Position {
    struct Data {
        int128 size;
        uint128 initialMargin;
        uint256 lastPrice;
    }

    function settleOrder(Data storage self, MarketOrder.Data storage order, BasicReport memory report) internal { }
}
