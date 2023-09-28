// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console2 } from "forge-std/console2.sol";
import { StdCheats } from "forge-std/StdCheats.sol";

import { ERC1967Proxy } from "@openzeppelin/proxy/ERC1967/ERC1967Proxy.sol";

import { DecentralizedExchange } from "src/DecentralizedExchange.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
}

contract DecentralizedExchangeTest is PRBTest, StdCheats {
    DecentralizedExchange dexImplementation;
    DecentralizedExchange dexProxy;

    /// @dev A function invoked before each test case is run.
    function setUp() public virtual {
        // Instantiate the contract-under-test.
        dexImplementation = new DecentralizedExchange();

        DecentralizedExchange dexImplementation = new DecentralizedExchange();
        bytes memory proxyCallData = abi.encodeWithSelector(dexImplementation.initialize.selector);
        dexProxy = DecentralizedExchange(address(new ERC1967Proxy(address(dexImplementation), proxyCallData)));
    }

    /// @dev Basic test. Run it with `forge test -vvv` to see the console log.
    function test_Example() external {
        console2.log("Hello World");
        // uint256 x = 42;
        // assertEq(foo.id(x), x, "value mismatch");
    }

    function testFuzz_Example(uint256 x) external {
        // vm.assume(x != 0); // or x = bound(x, 1, 100)
        // assertEq(foo.id(x), x, "value mismatch");
    }

    function testFork_Example() external {
        // // Silently pass this test if there is no API key.
        // string memory alchemyApiKey = vm.envOr("API_KEY_ALCHEMY", string(""));
        // if (bytes(alchemyApiKey).length == 0) {
        //     return;
        // }

        // // Otherwise, run the test against the mainnet fork.
        // vm.createSelectFork({ urlOrAlias: "mainnet", blockNumber: 16_428_000 });
        // address usdc = 0xA0b86991c6218b36c1d19D4a2e9Eb0cE3606eB48;
        // address holder = 0x7713974908Be4BEd47172370115e8b1219F4A5f0;
        // uint256 actualBalance = IERC20(usdc).balanceOf(holder);
        // uint256 expectedBalance = 196_307_713.810457e6;
        // assertEq(actualBalance, expectedBalance);
    }
}
