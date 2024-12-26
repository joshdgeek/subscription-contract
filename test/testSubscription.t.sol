//SPDX-License-Identifier:Unlicensed
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {SubscriptionService} from "../src/subscription.sol";
import {MockERC} from "../src/mockERC.sol";

contract TestScript is Test {
    SubscriptionService subscriptionService;
    address admin;
    address dummySubscriber;
    address secondDummySubscriber;

    function setUp() external {
        admin = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        dummySubscriber = 0x70997970C51812dc3A010C7d01b50e0d17dc79C8;
        secondDummySubscriber = 0x90F79bf6EB2c4f870365E785982E1f101E93b906;

        vm.startPrank(admin);
        subscriptionService = new SubscriptionService();
        vm.stopPrank();
    }

    function testaddSubPlans() public {
        vm.prank(admin);
        subscriptionService.addPlan(1, 20, 2592000);
        (uint amount, uint duration) = subscriptionService.subPlans(1);

        emit log_named_uint("Plan Amount", amount);
        emit log_named_uint("Plan Duration", duration);
        assertEq(amount, 20, "wrong amount");
        assertEq(duration, 2592000, "wrong date");
    }

    function testgetSubscribers() public {
        address mockERC = address(new MockERC());
        emit log("testgetSubscribers called");
        testaddSubPlans();
        vm.prank(dummySubscriber);
        vm.deal(dummySubscriber, 200 ether);
        subscriptionService.subscribe(1, mockERC);
        (
            uint sub_id,
            uint timeofSubscription,
            uint expiry_duration
        ) = subscriptionService.getSubscribers(dummySubscriber);

        emit log_named_uint("sub date", timeofSubscription);
        emit log_named_uint("expiry date", expiry_duration);

        assertEq(sub_id, 1, "id not accurate");
        assertEq(
            expiry_duration,
            timeofSubscription + 2592000,
            "duration mismatch"
        );
    }

    function testUnSubscription() public {
        //testgetSubscribers();
        subscriptionService.unsuscribe(dummySubscriber);
        (
            uint sub_Id,
            uint timeStampofSubscription,
            uint expiry_duration
        ) = subscriptionService.getSubscriber(dummySubscriber);
        assertEq(sub_Id, 0, "user has active subscriptiion");
    }

    function testUserActivity() public {
        vm.prank(dummySubscriber);
        bool isUserActive = subscriptionService.isActive(dummySubscriber);
        assertEq(isUserActive, false, "user is not active");
    }
}
