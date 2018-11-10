pragma solidity ^0.4.24;

import "zeppelin-solidity/contracts/token/ERC20/ERC20.sol";
import "zeppelin-solidity/contracts/math/SafeMath.sol";
import "zeppelin-solidity/contracts/ownership/Ownable.sol";

/**
 * Co2Coin contract
 */
contract Co2Coin is ERC20, Ownable {

	using SafeMath for uint256;

	string public name = "CO2COIN";
	string public symbol = "CO2";
	uint8 public decimals = 18;
	uint256 public totalSupply;
	mapping (address => mapping (address => uint256)) internal allowed;

	mapping(address => uint256) internal lockupBalances;
	mapping(address => uint256) internal normalBalances;

	uint256 public lockupSupply;
	uint256 public normalSupply;
	uint256 public lockupTimestamp;

	constructor() public {
		/**
		 * initialize
		 */
		uint256  _lockupSupply = 682544900 * (10 ** uint256(decimals));
		uint256 _normalSupply = 1317455100 * (10 ** uint256(decimals));
		// Lock up for half a year
		uint256 _lockupTimestamp = block.timestamp + (365 days / 2);

		lockupSupply = _lockupSupply;
		normalSupply = _normalSupply;
		totalSupply = lockupSupply.add(normalSupply);
		lockupBalances[msg.sender] = lockupSupply;
		normalBalances[msg.sender] = normalSupply;
		lockupTimestamp = _lockupTimestamp;
		emit Transfer(0x0, msg.sender, totalSupply);
	}

	function transferLockupToken(address _to, uint256 _value) public onlyOwner returns (bool) {
		require(_value <= lockupBalances[msg.sender]);
		require(_to != address(0));
		lockupBalances[msg.sender] = lockupBalances[msg.sender].sub(_value);
		lockupBalances[_to] = lockupBalances[_to].add(_value);
		emit Transfer(msg.sender, _to, _value);
		return true;
	}

	function transferNormalToken(address _to, uint256 _value) public onlyOwner returns (bool) {
		require(_value <= normalBalances[msg.sender]);
		require(_to != address(0));
		normalBalances[msg.sender] = normalBalances[msg.sender].sub(_value);
		normalBalances[_to] = normalBalances[_to].add(_value);
		emit Transfer(msg.sender, _to, _value);
		return true;
	}

	function balanceOfLockupToken(address _who) public view returns (uint256) {
		return lockupBalances[_who];
	}

	function balanceOfNormalToken(address _who) public view returns (uint256) {
		return normalBalances[_who];
	}

	function releaseLockup(address _who) private returns (bool) {
		if(lockupBalances[_who] == 0) {
			return true;
		}
		if(block.timestamp > lockupTimestamp) {
			normalBalances[_who] = normalBalances[_who].add(lockupBalances[_who]);
			lockupBalances[_who] = 0;
			return true;
		}
		return false;
	}

	function transferOwnership(address _newOwner) public onlyOwner {
		normalBalances[_newOwner] = normalBalances[_newOwner].add(normalBalances[owner]);
		normalBalances[owner] = 0;
		lockupBalances[_newOwner] = lockupBalances[_newOwner].add(lockupBalances[owner]);
		lockupBalances[owner] = 0;
		super.transferOwnership(_newOwner);
	}

	function totalSupply() public view returns (uint256) {
		return totalSupply;
	}

	function balanceOf(address _who) public view returns (uint256) {
		uint256 balance;
		balance = lockupBalances[_who].add(normalBalances[_who]);
		return balance;
	}

	function transfer(address _to, uint256 _value) public returns (bool) {
		releaseLockup(msg.sender);
		require(_value <= normalBalances[msg.sender]);
		require(_to != address(0));
		normalBalances[msg.sender] = normalBalances[msg.sender].sub(_value);
		normalBalances[_to] = normalBalances[_to].add(_value);
		emit Transfer(msg.sender, _to, _value);
		return true;
	}

	function allowance(address _owner, address _spender) public view returns (uint256) {
		return allowed[_owner][_spender];
	}

	function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
		releaseLockup(_from);
		require(_value <= normalBalances[_from]);
		require(_value <= allowed[_from][msg.sender]);
		require(_to != address(0));

		normalBalances[_from] = normalBalances[_from].sub(_value);
		normalBalances[_to] = normalBalances[_to].add(_value);
		allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
		emit Transfer(_from, _to, _value);
		return true;
	}

	function approve(address _spender, uint256 _value) public returns (bool) {
		allowed[msg.sender][_spender] = _value;
		emit Approval(msg.sender, _spender, _value);
		return true;
	}
}