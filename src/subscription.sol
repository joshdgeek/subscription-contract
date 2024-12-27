// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.18;

interface IERC20 {
    function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
}

contract SubscriptionService {
    address owner_;

    constructor() {
        owner_ = msg.sender;
    }

    struct subscriptionDetails {
        //subID will point to this
        uint256 amount;
        uint256 subDuration; // this will be in seconds
    }

    struct subscribers {
        //address will point to this
        //subscriber / user plan and duration
        uint256 sub_Id;
        uint256 timeStampofSubscription;
        uint256 expiry_duration;
    }

    mapping(uint256 => subscriptionDetails) public subPlans;
    mapping(address => subscribers) public getSubscribers;

    uint256[] public subIDArray;
    uint256[] public trackSubID;
    uint256 public monthlyTimeStamp = 2592000;

    modifier onlyOwner() {
        //modifier to restrict access to some functions
        require(owner_ == msg.sender, "not authorized");
        _;
    }

    //Access checker
    modifier checkExpiryStatus() {
        //check if a user has subscribed in the past
        require(getSubscribers[msg.sender].expiry_duration != 0, "not a valid subscriber");

        //confirm the subscription status
        require(block.timestamp < getSubscribers[msg.sender].expiry_duration, "your subscription has expired");
        _;
    }

    //admin only function to add subscription plans
    function addPlan(uint256 _subID, uint256 amount, uint256 duration) public onlyOwner {
        subPlans[_subID] = subscriptionDetails(amount, duration);
    }

    function getSubscriber(address userID) public view returns (uint256, uint256, uint256) {
        subscribers memory getUser = getSubscribers[userID];
        return (getUser.sub_Id, getUser.timeStampofSubscription, getUser.expiry_duration);
    }

    //function to subscribe
    function subscribe(uint256 _subid, address tokenAddress) public {
        //set time stamp for the function
        uint256 time = block.timestamp;
        subscriptionDetails memory plan = subPlans[_subid];
        require(plan.amount > 0, "not enough to cover subscription");
        require(IERC20(tokenAddress).transferFrom(msg.sender, address(this), plan.amount), "payment failed");

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
