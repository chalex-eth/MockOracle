// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "./DataFecther.sol";

contract MockOracle is DataFecther {
    uint256 public lastPrice;
    uint256 public currentTimestamp;
    uint256 currentIdx;

    constructor(string memory pathToRequestJS, string memory assetToFecth)
        DataFecther(pathToRequestJS, assetToFecth)
    {
        lastPrice = data[currentIdx];
        currentTimestamp = 1;
    }

    ///@notice Returns the array of the fetched data
    function getOracleData() external view returns (uint256[] memory) {
        return data;
    }

    ///@notice Move into the next price and the next timestamp
    function updateState() external {
        currentIdx += 1;
        lastPrice = data[currentIdx];
        currentTimestamp += 1;
    }

    ///@notice Move into the n price and n timestamp
    ///@param nJump how many step we advance in the data
    function updateState(uint256 nJump) external {
        currentIdx += nJump;
        lastPrice = data[currentIdx];
        currentTimestamp += currentIdx;
    }
}
