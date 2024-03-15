// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "./MerkleStreamDistributor.sol";

contract MerkleStreamDistributorFactory {
    event Created(MerkleStreamDistributor indexed distributor);

    function create(
        ISuperToken superToken,
        bytes32 merkleRoot
    )
        external
        returns (MerkleStreamDistributor distributor)
    {
        distributor = new MerkleStreamDistributor(superToken, merkleRoot);
        emit Created(distributor);
    }
}