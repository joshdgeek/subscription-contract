//SPDX-License-Identifier:Unlicensed
pragma solidity ^0.8.18;

import {Script} from "forge-std/Script.sol";
import {MockERC} from "../src/mockERC.sol";
import {SubscriptionService} from "../src/subscription.sol";

contract DeployMain is Script {
    SubscriptionService public subscriptionService;
    MockERC public mockERC;

    function setUp() public {}

    function run() public {
        vm.startBroadcast();

        mockERC = new MockERC();
        subscriptionService = new SubscriptionService(address(mockERC));

        vm.stopBroadcast();
    }
}
