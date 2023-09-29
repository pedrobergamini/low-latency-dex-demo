// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

library MarketOrder {
    struct Payload {
        address account;
        uint128 marketId;
        int128 initialMarginDelta;
        int128 sizeDelta;
        uint128 acceptablePrice;
    }

    struct Data {
        Payload payload;
        uint128 id;
        uint128 settlementTimestamp;
    }

    function reset(Data storage self) internal {
        self.payload.account = address(0);
        self.payload.marketId = 0;
        self.payload.initialMarginDelta = 0;
        self.payload.sizeDelta = 0;
        self.payload.acceptablePrice = 0;
        self.settlementTimestamp = 0;
    }
}
