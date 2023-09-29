// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

library MarketOrder {
    struct Payload {
        uint128 marketId;
        uint128 newInitialMargin;
        int128 sizeDelta;
    }

    struct Data {
        Payload payload;
        uint120 settlementTimestamp;
        bool isActive;
    }

    function fulfill(Data storage self) internal {
        self.isActive = false;
    }
}
