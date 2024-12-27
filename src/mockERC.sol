//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract MockERC {
    function transferFrom(
        address,
        address,
        uint256
    ) public pure returns (bool) {
        // Assume successful transfer
        return true;
    }
}
