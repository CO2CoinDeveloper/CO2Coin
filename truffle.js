/*
 * NB: since truffle-hdwallet-provider 0.0.5 you must wrap HDWallet providers in a 
 * function when declaring them. Failure to do so will cause commands to hang. ex:
 * ```
 * mainnet: {
 *     provider: function() { 
 *       return new HDWalletProvider(mnemonic, 'https://mainnet.infura.io/<infura-key>') 
 *     },
 *     network_id: '1',
 *     gas: 4500000,
 *     gasPrice: 10000000000,
 *   },
 */

require('dotenv').config()
var HDWalletProvider = require("truffle-hdwallet-provider")
var mnemonic = process.env.MNEMONIC
var accessToken = process.env.ACCESS_TOKEN

module.exports = {
	networks: {
		ganache: {
			host: '127.0.0.1',
			port: '7545',
			network_id: '5777'
		},
		development2: {
			host: 'localhost',
			port: '9545',
			network_id: '*'
		},
		ropsten: {
			provider: function () {
				return new HDWalletProvider(
					mnemonic,
					'https://ropsten.infura.io/' + accessToken
				)
			},
			network_id: 3
		},
		live: {
			provider: function () {
				return new HDWalletProvider(
					mnemonic,
					'https://mainnet.infura.io/' + accessToken
				)
			},
			network_id: 1,
			gas: 4700000
		}
	}
};

