// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/SecurityToken.sol";
import "../src/STOCrowdsale.sol";

contract STOTest is Test {
    SecurityToken public token;
    STOCrowdsale public crowdsale;
    address public owner;
    address public investor1;
    address public investor2;

    function setUp() public {
        owner = address(this);
        investor1 = address(0x1);
        investor2 = address(0x2);
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address deployer = vm.addr(deployerPrivateKey);

        // トークンのデプロイ
        token = new SecurityToken("Security Token", "SEC", 1000000e18);

        // クラウドセールのデプロイ
        crowdsale = new STOCrowdsale(
            100, // レート
            0.1 ether, // 最小投資額
            10 ether, // 最大投資額
            7 days, // 期間
            address(token)
        );

        // クラウドセールコントラクトをホワイトリストに追加
        token.addToWhitelist(address(crowdsale));
        // オーナー（deployer）もホワイトリストに追加
        token.addToWhitelist(deployer);
        // クラウドセールコントラクトにトークンを移転
        token.transfer(address(crowdsale), 500000e18);
    }

    function testInvestment() public {
        // 投資家をホワイトリストに追加
        token.addToWhitelist(investor1);

        // 投資のシミュレーション
        vm.deal(investor1, 1 ether);
        vm.prank(investor1);
        crowdsale.invest{value: 1 ether}();

        // 検証
        assertEq(token.balanceOf(investor1), 100 * 1 ether);
    }
}
