// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Vm} from "forge-std/Vm.sol";

contract MockOracle {
    uint256[] oracleData;
    uint256 public lastData;
    uint256 public currentTimestamp;
    uint256 currentIdx;

    Vm constant vm =
        Vm(address(bytes20(uint160(uint256(keccak256("hevm cheat code"))))));

    constructor(
        string memory pathToRequestJS,
        string memory assetToFecth,
        string memory fileName
    ) {
        fetchData(pathToRequestJS, assetToFecth);
        loadData(fileName);
        lastData = oracleData[currentIdx];
        currentTimestamp = 1;
    }

    function getOracleData() external view returns (uint256[] memory) {
        return oracleData;
    }

    function updateState() external {
        currentIdx += 1;
        lastData = oracleData[currentIdx];
        currentTimestamp += 1;
    }

    function updateState(uint256 nJump) external {
        currentIdx += nJump;
        lastData = oracleData[currentIdx];
        currentTimestamp += currentIdx;
    }

    function fetchData(
        string memory pathToRequestJS,
        string memory assetToFecth
    ) internal {
        string[] memory cmds = new string[](3);
        cmds[0] = "node";
        cmds[1] = pathToRequestJS;
        cmds[2] = assetToFecth;
        vm.ffi(cmds);
    }

    function loadData(string memory fileName) internal {
        string[] memory cmds = new string[](2);
        cmds[0] = "cat";
        cmds[1] = fileName;
        bytes memory result = vm.ffi(cmds);
        oracleData = abi.decode(result, (uint256[]));
    }
}
