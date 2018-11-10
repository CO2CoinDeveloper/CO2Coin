var Co2Coin = artifacts.require('./Co2Coin.sol')

contract('Co2Coin', function (accounts) {
	it('totalSupply test', function () {
		return Co2Coin.deployed().then(function (instance) {
			return instance.balanceOf.call(accounts[0])
		}).then(function (balance) {
			assert.equal(balance.valueOf(), 2000000000 * 10 ** 18, 'not 2000000000 * 10 ** 18')
		})
	})

	it('lockupTimestamp test', function () {
		return Co2Coin.deployed().then(function (instance) {
			return instance.lockupTimestamp.call()
		}).then(function (timestamp) {
			var nowTimestamp = Math.floor(new Date().getTime() / 1000)
			assert(timestamp.valueOf() > nowTimestamp, "It is not timestamp value of the future")
		})
	})

	it('owner test', function () {
		return Co2Coin.deployed().then(function (instance) {
			return instance.owner.call()
		}).then(function (ownerAddress) {
			assert.equal(ownerAddress, "0x627306090abab3a6e1400e9345bc60c78a8bef57")
		})
	})
})