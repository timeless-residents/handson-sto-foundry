// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/SecurityToken.sol";
import "../src/STOCrowdsale.sol";

contract DeployScript is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);
        vm.startBroadcast(deployerPrivateKey);

        // トークンのデプロイ
        SecurityToken token = new SecurityToken(
            "Security Token",
            "SEC",
            1000000e18
        );

        // クラウドセールのデプロイ
        STOCrowdsale crowdsale = new STOCrowdsale(
            100,
            0.1 ether,
            10 ether,
            7 days,
            address(token)
        );

        // クラウドセールコントラクトをホワイトリストに追加
        token.addToWhitelist(address(crowdsale));
        // オーナー（deployer）もホワイトリストに追加
        token.addToWhitelist(deployer);
        // クラウドセールコントラクトにトークンを移転
        token.transfer(address(crowdsale), 500000e18);

        vm.stopBroadcast();
    }
}
