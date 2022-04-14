// SPDX-License-Identifier: MIT

pragma solidity 0.8;


// ************************************* \\
contract Helper {
    // senat multiuser address
    function getRoleHash(address _senat) pure external returns (bytes4 value) {
        value = bytes4(keccak256(abi.encodePacked(_senat)));
    }
}

// ************************************* \\
// logic have not any checker from resurec
contract Logics {}

// ************************************* \\
contract Election {

    // variables --------------------------------------------------

    struct Candidate {
        uint id;
        uint totalVotes;
        address candid;
    }
    Candidate candidate;
    Candidate[] candids;
    uint private candidateId;

    mapping(address => bool) private _voter; // who -> vote or not

    uint[] private _election;
    uint private _electionId = 0;

    address private SENATDAO; // dao address of senat - user who run/deploy contract like admin
    address private HelperAddress;

    uint immutable private _endDate = 30; // {60 * 60 * 24} = 86400 = 1 day
    uint256 private _endElectionTime;
    bool private _start = false; // strat + end
    bool private _end = false;

    // events --------------------------------------------------
    event NewCandidate(address indexed candid, uint id, uint date);
    event Vote();

    // modifier --------------------------------------------------

    modifier isVoted(address voter) {
        require(msg.sender != voter, "youre vote counted");
        _;
    }

    modifier isStart() {
        require(_start == true, "need to start election");
        _;
    }

    modifier isFinish() {
        require(_start == false && _end == true , "need to start election");
        _;
    }

    modifier isSenat() {
        require(msg.sender == SENATDAO, "only SENAT approve to run this function");
        _;
    }

    // init --------------------------------------------------

    constructor(address _helper) {
        SENATDAO = msg.sender;
        candidateId = 0;
        HelperAddress = _helper;
    }


    // logic --------------------------------------------------

    function startElection() public isSenat returns (uint) {
        _endElectionTime = block.timestamp + _endDate;
        _start = true;
        _electionId += 1;
        _election.push(_electionId);
        return _electionId;
    }

    // add candidate
    function newCandid(address _candid) public isSenat returns (bytes4 tx_) {
        candidateId += 1;
        candids.push(Candidate({
             id: candidateId,
             totalVotes: 0,
             candid: _candid
        }));
        emit NewCandidate(_candid, candidateId, block.timestamp);
        tx_ = __theCandid(_candid);
    }

    function __senat() public view returns(bytes4 xyz){
        xyz = Helper(HelperAddress).getRoleHash(SENATDAO);
    }

    function __theCandid(address theCandidator) public view returns(bytes4 xyz){
        xyz = Helper(HelperAddress).getRoleHash(theCandidator);
    }

    // candidate votes
    function who(uint _id) public view isFinish returns (uint) {
        return candids[_id].totalVotes; // -1: to see in array currect position
    }

    // vote by id
    function voteById(uint _id) public isStart isVoted(msg.sender) {
        require(msg.sender != SENATDAO, "senat dao account can't voting");
        candids[_id].totalVotes += 1;
        _voter[msg.sender] = true;
        emit Vote();
    }

    // vote by address
    function voteByAddress(address _addr) public isStart isVoted(msg.sender) {
        require(msg.sender != SENATDAO, "senat dao account can't voting");
        require(exist(_addr), "not candidate found");
        uint val = find(_addr); // if return 0 = voted nobody, but we checked if exist
        candids[val-1].totalVotes += 1; // val-1 = position in array
        emit Vote();
    }

    // find candid
    function find(address _who) public view returns (uint){
        for(uint i = 0; i<= candidateId; i++){
            if(candids[i].candid == _who) return candids[i].id;
        }
        return 0; // id 0 not exist, check this variable -> \candidateId\ -> on function -> \newCandid\
    }

    // existed candid
    function exist(address _who) public view returns (bool){
        for(uint i = 0; i <= candidateId; i++){
            if(candids[i].candid == _who) return true;
        }
        return false;
    }

    // lock election (same as -> isFinish())
    function lock() public view returns (bool) {
        if(block.timestamp > _endElectionTime) {
            return true;
        }
        return false;
    }

}

// 15-04-2022 friday live course
// ver 2 - part 1
