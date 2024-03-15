// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "@openzeppelin/contracts/utils/cryptography/MerkleProof.sol";

import {
    ISuperfluid, ISuperToken, ISuperfluidPool, PoolConfig
} from "@superfluid-finance/ethereum-contracts/contracts/interfaces/superfluid/ISuperfluid.sol";
import { SuperTokenV1Library } from "@superfluid-finance/ethereum-contracts/contracts/apps/SuperTokenV1Library.sol";

using SuperTokenV1Library for ISuperToken;

contract MerkleStreamDistributor {
    error InvalidProof();

    ISuperfluidPool public immutable pool;
    ISuperToken public immutable superToken;
    bytes32 public immutable merkleRoot;

    constructor(ISuperToken superToken_, bytes32 merkleRoot_) {
        superToken = superToken_;
        merkleRoot = merkleRoot_;
        pool = superToken.createPool(
            address(this), // pool admin
            PoolConfig({
                transferabilityForUnitsOwner: false,
                distributionFromAnyAddress: true
            })
        );
    }

    // TODO: allow claim only once, so we can set transferabilityForUnitsOwner to true
    function claimDistribution(address account, uint128 units, bytes32[] calldata merkleProof) external {
        bytes32 leaf = keccak256(bytes.concat(keccak256(abi.encode(account, units))));
        if (! MerkleProof.verify(merkleProof, merkleRoot, leaf)) revert InvalidProof();

        pool.updateMemberUnits(account, units);
    }
}