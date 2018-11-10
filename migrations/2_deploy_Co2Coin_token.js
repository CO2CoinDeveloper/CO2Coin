var Co2Coin = artifacts.require('./Co2Coin.sol');

module.exports = function(deployer) {
	deployer.deploy(Co2Coin, {
		gas: 5000000
	})
}