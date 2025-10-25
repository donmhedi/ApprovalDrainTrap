// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ApprovalDrainResponder {
    event SuspiciousApproval(
        address indexed token,
        address indexed owner,
        address indexed spender,
        uint256 previousAllowance,
        uint256 newAllowance
    );

    function respondToApprovalDrain(
        address token,
        address owner,
        address spender,
        uint256 prevAllowance,
        uint256 newAllowance
    ) external {
        emit SuspiciousApproval(token, owner, spender, prevAllowance, newAllowance);
    }
}
