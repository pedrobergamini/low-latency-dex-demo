// SPDX-License-Identifier: MIT
pragma solidity >=0.8.19;

import { OwnableUpgradeable } from "@openzeppelin-upgradeable/access/OwnableUpgradeable.sol";
import { UUPSUpgradeable } from "@openzeppelin-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract DecentralizedExchange is UUPSUpgradeable, OwnableUpgradeable {
    function foo() external pure returns (uint256 bar) {
        bar = 4;
    }

    function _authorizeUpgrade(address) internal override onlyOwner { }
}
