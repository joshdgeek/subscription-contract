// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

interface IERC20 {
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) external returns (bool);
}

contract SubscriptionService {
    address owner_;

    constructor() {
        owner_ = msg.sender;
    }

    struct subscriptionDetails {
        //subID will point to this
        uint amount;
        uint subDuration; // this will be in seconds
    }

    struct subscribers {
        //address will point to this
        //subscriber / user plan and duration
        uint sub_Id;
        uint timeStampofSubscription;
        uint expiry_duration;
    }

    mapping(uint => subscriptionDetails) public subPlans;
    mapping(address => subscribers) public getSubscribers;

    uint[] public subIDArray;
    uint[] public trackSubID;
    uint public monthlyTimeStamp = 2592000;

    modifier onlyOwner() {
        //modifier to restrict access to some functions
        require(owner_ == msg.sender, "not authorized");
        _;
    }

    //Access checker
    modifier checkExpiryStatus() {
        //check if a user has subscribed in the past
        require(
            getSubscribers[msg.sender].expiry_duration != 0,
            "not a valid subscriber"
        );

        //confirm the subscription status
        require(
            block.timestamp < getSubscribers[msg.sender].expiry_duration,
            "your subscription has expired"
        );
        _;
    }

    //admin only function to add subscription plans
    function addPlan(uint _subID, uint amount, uint duration) public onlyOwner {
        subPlans[_subID] = subscriptionDetails(amount, duration);
    }

    function getSubscriber(
        address userID
    ) public view returns (uint, uint, uint) {
        subscribers memory getUser = getSubscribers[userID];
        return (
            getUser.sub_Id,
            getUser.timeStampofSubscription,
            getUser.expiry_duration
        );
    }

    //function to subscribe
    function subscribe(uint _subid, address tokenAddress) public {
        //set time stamp for the function
        uint time = block.timestamp;
        subscriptionDetails memory plan = subPlans[_subid];
        require(plan.amount > 0, "not enough to cover subscription");
        require(
            IERC20(tokenAddress).transferFrom(
                msg.sender,
                address(this),
                plan.amount
            ),
            "payment failed"
        );

        getSubscribers[msg.sender] = subscribers(_subid, time, time + 30 days);
    }

    function unsuscribe(address user) public {
        //subscribers memory findUser = getSubscribers[user];
        subscribers storage findUser = getSubscribers[user];
        findUser.sub_Id = 0;
        findUser.timeStampofSubscription = 0;
        findUser.expiry_duration = 0;
    }

    ///check if a user has a active suibscription
    function isActive(address _userid) public view returns (bool) {
        return block.timestamp < getSubscribers[_userid].expiry_duration;
    }
}
