// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

library Errors {
    error DuplicateOrder(address account);
    error MarketNotSupported(address account, uint128 marketId);
}
