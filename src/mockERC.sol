//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract MockERC {
    function transferFrom(
        address from,
        address to,
        uint256 amount
    ) public view returns (bool) {
        // Assume successful transfer
        return true;
    }
}
