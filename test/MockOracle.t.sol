// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/MockOracle.sol";

contract TestMockOracle is Test {
    MockOracle oracle;

    function setUp() public {
        oracle = new MockOracle("dataRequest.js", "ethereum");
    }

    function testSetUp() public {
        uint256[] memory oracleData = oracle.getOracleData();
        assertEq(oracle.lastPrice(), oracleData[0]);
        assertEq(oracle.currentTimestamp(), 1);
    }

    function testUpdateState() public {
        uint256[] memory oracleData = oracle.getOracleData();
        oracle.updateState();
        assertEq(oracle.lastPrice(), oracleData[1]);
        assertEq(oracle.currentTimestamp(), 2);
    }

    function testUpdateState(uint256 nJump) public {
        vm.assume(nJump > 1);
        vm.assume(nJump < 350);
        uint256[] memory oracleData = oracle.getOracleData();
        oracle.updateState(nJump);
        assertEq(oracle.lastPrice(), oracleData[nJump]);
        assertEq(oracle.currentTimestamp(), nJump + 1);
    }
}
