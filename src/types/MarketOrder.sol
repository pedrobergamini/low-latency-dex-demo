// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

library MarketOrder {
    struct Payload {
        uint128 marketId;
        int128 initialMarginDelta;
        int128 sizeDelta;
        uint128 acceptablePrice;
    }

    struct Data {
        Payload payload;
        uint120 settlementTimestamp;
        bool isActive;
    }
}
