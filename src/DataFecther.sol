// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Vm} from "forge-std/Vm.sol";

///@notice This contract use a ffi cheatcode to fetch data (in a form of an encoded uint256[]) using
/// a JS script and is stored in a uint256[]

contract DataFecther {
    uint256[] public data;

    Vm constant vm =
        Vm(address(bytes20(uint160(uint256(keccak256("hevm cheat code"))))));

    constructor(string memory pathToRequestJS, string memory assetToFecth) {
        fetchData(pathToRequestJS, assetToFecth);
        loadData();
        deleteFile();
    }

    ///@notice Run the script
    ///@param pathToRequestJS path to the script to execute
    ///@param assetToFecth enter token name supported by coingecko
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

    ///@notice load the data from a temporary txt file
    function loadData() internal {
        string[] memory cmds = new string[](2);
        cmds[0] = "cat";
        cmds[1] = "data.txt";
        bytes memory result = vm.ffi(cmds);
        data = abi.decode(result, (uint256[]));
    }

    ///@notice delete the temporary file
    function deleteFile() internal {
        string[] memory cmds = new string[](2);
        cmds[0] = "rm";
        cmds[1] = "data.txt";
        vm.ffi(cmds);
    }
}
