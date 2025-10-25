// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {ITrap} from "./interfaces/ITrap.sol";

interface IERC20 {
    function allowance(address owner, address spender) external view returns (uint256);
}

contract ApprovalDrainTrap is ITrap {
    // === CONFIGURATION ===
    address public constant TOKEN = 0x0000000000000000000000000000000000000000; // replace with real token
    address public constant WATCHED_WALLET = 0x0000000000000000000000000000000000000000; // wallet to watch
    address public constant SPENDER = 0x0000000000000000000000000000000000000000; // spender to track

    uint256 public constant THRESHOLD = 10_000 * 1e18; // trigger if approval > threshold

    // === COLLECT (SAFE) ===
    function collect() external view override returns (bytes memory) {
        uint256 allowanceAmount = 0;
        uint256 codeSize;

        // Check if the token address is a contract
        assembly {
            codeSize := extcodesize(TOKEN)
        }

        if (codeSize > 0) {
            // try/catch to prevent revert if token misbehaves
            try IERC20(TOKEN).allowance(WATCHED_WALLET, SPENDER) returns (uint256 value) {
                allowanceAmount = value;
            } catch {
                // leave allowanceAmount = 0
            }
        }

        return abi.encode(TOKEN, WATCHED_WALLET, SPENDER, allowanceAmount, block.number, block.timestamp);
    }

    // === SHOULD RESPOND ===
    function shouldRespond(bytes[] calldata data)
        external
        pure
        override
        returns (bool, bytes memory)
    {
        if (data.length < 2) return (false, "");

        (address tokenNew, address ownerNew, address spenderNew, uint256 newAllowance,,) =
            abi.decode(data[0], (address, address, address, uint256, uint256, uint256));

        (, , , uint256 prevAllowance,,) =
            abi.decode(data[1], (address, address, address, uint256, uint256, uint256));

        if (newAllowance > prevAllowance && newAllowance >= THRESHOLD) {
            return (true, abi.encode(tokenNew, ownerNew, spenderNew, prevAllowance, newAllowance));
        }

        return (false, "");
    }
}
