// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

/// @notice Basic feed report struct
/// @param feedId The feed ID the report has data for
/// @param lowerTimestamp Lower timestamp for validity of report
/// @param observationsTimestamp The time the median value was observed on
/// @param nativeFee Base ETH/WETH fee to verify report
/// @param linkFee Base LINK fee to verify report
/// @param upperTimestamp Upper timestamp for validity of report
/// @param benchmark The median value agreed in an OCR round
struct BasicReport {
    bytes32 feedId;
    uint32 lowerTimestamp;
    uint32 observationsTimestamp;
    uint192 nativeFee;
    uint192 linkFee;
    uint64 upperTimestamp;
    int192 benchmark;
}

struct Quote {
    address quoteAddress;
}

interface IStreamsLookupCompatible {
    error StreamsLookup(string feedParamKey, string[] feeds, string timeParamKey, uint256 time, bytes extraData);

    function checkCallback(
        bytes[] memory values,
        bytes memory extraData
    )
        external
        view
        returns (bool upkeepNeeded, bytes memory performData);
}
