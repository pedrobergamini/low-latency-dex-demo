// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { UUPSUpgradeable } from "@openzeppelin-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract DecentralizedExchange is UUPSUpgradeable {
    function foo() external view returns (uint256 bar) {
        bar = 4;
    }
}
