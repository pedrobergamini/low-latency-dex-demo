// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

// Open Zeppelin Upgradeable dependencies
import { OwnableUpgradeable } from "@openzeppelin-upgradeable/access/OwnableUpgradeable.sol";
import { UUPSUpgradeable } from "@openzeppelin-upgradeable/proxy/utils/UUPSUpgradeable.sol";

// Project dependencies
import { ILogAutomation, Log } from "./chainlink/interfaces/ILogAutomation.sol";
import { IStreamsLookupCompatible } from "./chainlink/interfaces/IStreamsLookupCompatible.sol";
import { IVerifierProxy } from "./chainlink/interfaces/IVerifierProxy.sol";

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

contract DecentralizedExchange is UUPSUpgradeable, OwnableUpgradeable, ILogAutomation, IStreamsLookupCompatible {
    event LogCreateOrder(address indexed account, uint256 indexed marketId, uint256 orderId);

    address public constant FEE_ADDRESS = 0xe39Ab88f8A4777030A534146A9Ca3B52bd5D43A3;
    IVerifierProxy public constant verifier = IVerifierProxy(0xea9B98Be000FBEA7f6e88D08ebe70EbaAD10224c);
    string public constant STRING_DATASTREAMS_FEEDLABEL = "feedIDs";
    string public constant STRING_DATASTREAMS_QUERYLABEL = "timestamp";
    string[] public feedsHex = ["0x00023496426b520583ae20a66d80484e0fc18544866a5b0bfee15ec771963274"];

    receive() external payable { }

    function initialize() external initializer {
        __Ownable_init();
    }

    function checkLog(
        Log calldata log,
        bytes memory
    )
        external
        view
        returns (bool upkeepNeeded, bytes memory performData)
    {
        revert StreamsLookup(STRING_DATASTREAMS_FEEDLABEL, feedsHex, STRING_DATASTREAMS_QUERYLABEL, log.timestamp, "");
    }

    function checkCallback(
        bytes[] calldata values,
        bytes calldata extraData
    )
        external
        pure
        returns (bool, bytes memory)
    {
        return (true, abi.encode(values, extraData));
    }

    function performUpkeep(bytes calldata performData) external override {
        (bytes[] memory signedReports, bytes memory extraData) = abi.decode(performData, (bytes[], bytes));

        bytes memory report = signedReports[0];

        // Add quote to the report and retrieve data
        bytes memory bundledReport = _bundleReport(report);
        BasicReport memory unverifiedReport = _getReportData(report);

        // Verify the report
        bytes memory verifiedReportData = verifier.verify{ value: unverifiedReport.nativeFee }(bundledReport);

        // Decode verified report data into BasicReport struct
        BasicReport memory verifiedReport = abi.decode(verifiedReportData, (BasicReport));

        // order.settle();
    }

    function _bundleReport(bytes memory report) internal view returns (bytes memory) {
        Quote memory quote;
        quote.quoteAddress = FEE_ADDRESS;
        (
            bytes32[3] memory reportContext,
            bytes memory reportData,
            bytes32[] memory rs,
            bytes32[] memory ss,
            bytes32 raw
        ) = abi.decode(report, (bytes32[3], bytes, bytes32[], bytes32[], bytes32));
        bytes memory bundledReport = abi.encode(reportContext, reportData, rs, ss, raw, abi.encode(quote));
        return bundledReport;
    }

    function _getReportData(bytes memory signedReport) internal pure returns (BasicReport memory) {
        (, bytes memory reportData,,,) = abi.decode(signedReport, (bytes32[3], bytes, bytes32[], bytes32[], bytes32));

        BasicReport memory report = abi.decode(reportData, (BasicReport));
        return report;
    }

    function _authorizeUpgrade(address) internal override onlyOwner { }
}
