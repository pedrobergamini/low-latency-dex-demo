// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import { PRBTest } from "@prb/test/PRBTest.sol";
import { console2 } from "forge-std/console2.sol";
import { StdCheats } from "forge-std/StdCheats.sol";

import { ERC1967Proxy } from "@openzeppelin/proxy/ERC1967/ERC1967Proxy.sol";

import { DecentralizedExchange, MarketOrder } from "src/DecentralizedExchange.sol";
import { Errors } from "src/utils/Errors.sol";

contract DecentralizedExchangeTest is PRBTest, StdCheats {
    error DuplicateOrder(address account);
    error MarketNotSupported(address account, uint128 marketId);

    event LogCreateOrder(address indexed account, uint256 indexed marketId);

    uint128 internal constant ETH_USD_MARKET_ID = 1;

    address internal trader = makeAddr("trader");

    DecentralizedExchange dexImplementation;
    DecentralizedExchange dexProxy;

    /// @dev A function invoked before each test case is run.
    function setUp() public virtual {
        // Instantiate the contract-under-test.
        dexImplementation = new DecentralizedExchange();

        dexImplementation = new DecentralizedExchange();
        bytes memory proxyCallData = abi.encodeWithSelector(dexImplementation.initialize.selector);
        dexProxy = DecentralizedExchange(payable(address(new ERC1967Proxy(address(dexImplementation), proxyCallData))));

        vm.deal({ account: trader, newBalance: 100 ether });
        vm.startPrank(trader);
    }

    /// @dev Basic test. Run it with `forge test -vvv` to see the console log.
    function testFuzz_CreateOrder(int128 initialMarginDelta, int128 sizeDelta, uint128 acceptablePrice) external {
        vm.assume(initialMarginDelta != 0 && acceptablePrice != 0 && sizeDelta != 0);
        MarketOrder.Payload memory payload = MarketOrder.Payload({
            marketId: ETH_USD_MARKET_ID,
            initialMarginDelta: initialMarginDelta,
            sizeDelta: sizeDelta,
            acceptablePrice: acceptablePrice
        });

        vm.expectEmit(address(dexProxy));
        emit LogCreateOrder(trader, payload.marketId);

        dexProxy.createOrder(payload);
    }

    function testFuzz_RevertWhen_CreatesOrderWithActiveOrder(
        int128 initialMarginDelta,
        int128 sizeDelta,
        uint128 acceptablePrice
    )
        external
    {
        vm.assume(initialMarginDelta != 0 && acceptablePrice != 0 && sizeDelta != 0);
        MarketOrder.Payload memory payload = MarketOrder.Payload({
            marketId: ETH_USD_MARKET_ID,
            initialMarginDelta: initialMarginDelta,
            sizeDelta: sizeDelta,
            acceptablePrice: acceptablePrice
        });

        dexProxy.createOrder(payload);

        vm.expectRevert(abi.encodeWithSelector(Errors.DuplicateOrder.selector, trader));
        dexProxy.createOrder(payload);
    }

    function testFuzz_RevertWhen_CreatesOrderWithInvalidMarketId(
        int128 initialMarginDelta,
        int128 sizeDelta,
        uint128 acceptablePrice
    )
        external
    {
        vm.assume(initialMarginDelta != 0 && acceptablePrice != 0 && sizeDelta != 0);

        uint128 invalidMarketId = 2;
        MarketOrder.Payload memory payload = MarketOrder.Payload({
            marketId: invalidMarketId,
            initialMarginDelta: initialMarginDelta,
            sizeDelta: sizeDelta,
            acceptablePrice: acceptablePrice
        });

        vm.expectRevert(abi.encodeWithSelector(Errors.MarketNotSupported.selector, trader, invalidMarketId));
        dexProxy.createOrder(payload);
    }
}
