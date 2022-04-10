// SPDX-License-Identifier: MIT

pragma solidity 0.8;

// import "@openzeppelin/contracts/governance/utils/Votes.sol";
// ["0xdD870fA1b7C4700F2BD7f44238821C26f7392148","0x583031D1113aD414F02576BD6afaBfb302140225"]
// role senatdao: 0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2 = 0x999bf575

contract VotePlatform {
    // variables --------------------------------------------------
    address private admin; // user who run/deploy contract
    address private SENATDAO; // dao address of senat

    mapping(uint256 => address) private _candidate; // candid id -> who
    mapping(address => bool) private _voter; // who -> vote or not
    mapping(address => uint256) private _candidateVotes; // who (same as _candidate) -> number of votes

    uint256 private _totalCandids; // same as _candidate uint totaly
    uint256 private _totalVotes; // same as _voter totaly

    uint256 immutable private _endDate = 100; // {60 * 60 * 24} = 86400 = 1 day
    uint256 private _endElectionTime;
    bool private _start = false; // strat + end

    // events --------------------------------------------------
    event finishTime();

    // modifiers --------------------------------------------------
    modifier isSenat(address caller) {
        require(bytes4(
            keccak256(abi.encodePacked(caller)
            )) == 0x999bf575, "just the senat dao address can run this function");
        _;
    }

    modifier isNotFinish() {
        require(_start == true, "not finished yet");
        _;
    }

    // init --------------------------------------------------
    constructor(
        address[] memory _candids,
        address _senatDao
        ) {
            // calculate & set candidates
            uint256 x = _candids.length;
            for(uint256 i = 0; i > x; i++){
                _candidate[i] = _candids[i];
            }
            _totalCandids = x;
            
            // role admin
            admin = msg.sender;
            SENATDAO = _senatDao;
    }

    // exacutions --------------------------------------------------

    function startElection() external returns (bool success) {
        success = start();
        _endElectionTime = block.timestamp + _endDate;
        _finalize(_endElectionTime);
    }

    function keepVoting(uint256 candidId) external {
        require(_start == true, "required election time");
        require(block.timestamp < _endElectionTime, "time end");
        vote(candidId) ;
    }

    // logics --------------------------------------------------

    function start() internal isSenat(msg.sender) returns (bool) { // userRole(senat)
        // start voting
        if(_start == false){
            _start = true;
            return true;
        }
        return false;
    }

    function _finalize(uint256 date) internal {
        if(block.timestamp > date){
            _start = false;
        }
    }

    function getCandidates() internal view returns (uint256) {
        return _totalCandids;
    }

    function getTotalVotes() internal view returns (uint256) {
        return _totalVotes;
    }

    function _getFinalVoting(address account) internal view virtual returns (uint256) {
        return _candidateVotes[account];
    }

    function vote(uint256 candidId) internal {
        require(_voter[msg.sender] == false,"youre vote was calculated");
        _candidateVotes[_candidate[candidId]] += 1;
        _voter[msg.sender] = true;
    }

    function finish() internal { // sort by vote
        
    }

    // uint256 chainId the EIP-155 chain id. The user-agent should refuse signing if it does not match the currently active chain.
    function getChainId() external view returns (uint256) {
        return block.chainid;
    }
}


contract Helper {
    
    // senat multiuser address
    function getRoleHash(address _senat) pure external returns (bytes4 value) {
        value = bytes4(keccak256(abi.encodePacked(_senat)));
    }
}
