// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import { ERC1820RegistryCompiled } from "@superfluid-finance/ethereum-contracts/contracts/libs/ERC1820RegistryCompiled.sol";
import { SuperfluidFrameworkDeployer } from "@superfluid-finance/ethereum-contracts/contracts/utils/SuperfluidFrameworkDeployer.sol";

import "../src/MerkleStreamDistributor.sol";

contract MerkleStreamDistributorTest is Test {
    struct ClaimData {
        address account;
        uint128 units;
        bytes32[] merkleProof;
    }


    /* solhint-disable const-name-snakecase */
    address internal constant alice  = address(0x41);
    address internal constant bob    = address(0x42);
    address internal constant dan    = address(0x43);

    SuperfluidFrameworkDeployer.Framework internal _sf;
    MerkleStreamDistributor internal _app;
    bytes32 constant internal _merkleRoot = 0x7d9d2b2d72a1d78b689173c49b7d9441c75498bc9f6dadb972f6db5fbb074bf9;

    function setUp() public {
        // deploy SF framework
        vm.etch(ERC1820RegistryCompiled.at, ERC1820RegistryCompiled.bin);
        SuperfluidFrameworkDeployer deployer = new SuperfluidFrameworkDeployer();
        deployer.deployTestFramework();
        _sf = deployer.getFramework();

        ISuperToken superToken = deployer.deployPureSuperToken("Token", "TOK", 2**200);

        // deploy app
        _app = new MerkleStreamDistributor(superToken, _merkleRoot);
    }

    // helpers

    function _getAliceClaimData() internal pure returns (ClaimData memory claimData) {
        claimData.account = alice;
        claimData.units = 400000000;
        claimData.merkleProof = new bytes32[](2);
        claimData.merkleProof[0] = 0xd8e8b40793d8889a6642e3cac0e5a132d0817de18ad462a741421c31447160da;
        claimData.merkleProof[1] = 0x7667aaf1c5ee582bb6cfc1b39c0be2675bed4c561abcede86c74aa95b352568c;
    }

    // tests

    function testClaimForAlice() public {
        console.log("alice", alice);
        ClaimData memory claimData = _getAliceClaimData();
        _app.claimDistribution(claimData.account, claimData.units, claimData.merkleProof);

        // check pool state
        assertEq(_app.pool().getUnits(alice), claimData.units, "alice units mismatch");
    }
}
