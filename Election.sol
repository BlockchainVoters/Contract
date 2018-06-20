pragma solidity ^0.4.24;

contract Election {

  struct Vote {
    address from;
    string _hash;
    uint8 candidate;
  }

  struct Voter {
    address from;
    string _hash;
    bool voted;
  }

  struct Candidate {
    string name;
    uint8 number;
    string party;
    string vice;
  }

  // this variable holds the constracts creator, which is the election's administrator
  address private owner;

  // these variables hold the election's deadlines (descriptions below)
  uint256 private insertLimit; // must be given in seconds since the contract's creation
  uint256 private joinLimit;   // must be given in seconds since the contract's creation
  uint256 private voteLimit;   // must be given in seconds since the contract's creation

  // this variable defines if the contract is running or not
  bool private _isOn;

  // this variable holds the election's candidates
  mapping(uint8 => Candidate) private candidates;
  uint8[] private numberList;

  // this variable holds the election's votes
  mapping(address => Vote) private votesByAddress;
  mapping(string => Vote) private votesByHash;

  // this variable holds the election's voters (the structures are redundant to ensure the hash is unique)
  mapping(address => Voter) private votersByAddress;
  mapping(string => Voter) private votersByHash;

  // the constructor must receive the election's deadlines:
  // uint256 _insertLimit : the limit to the administrator to insert candidates (the edition limit goes until the first vote enters)
  // uint256 _joinLimit   : the limit to another external account to subscribe to the election
  // uint256 _voteLimit   : the limit to external accounts to insert their votes
  constructor(
    uint256 _insertLimit, // must be given in seconds since the contract's creation
    uint256 _joinLimit,   // must be given in seconds since the contract's creation
    uint256 _voteLimit    // must be given in seconds since the contract's creation
  ) public {
    owner = msg.sender;
    insertLimit = now + _insertLimit;
    joinLimit = now + _joinLimit;
    voteLimit = now + _voteLimit;
    _isOn = true;
  }

  // this function destroys the contract forever (only use in emergency case)
  function shut_down() public {

    // only the admin can perform this action
    require(msg.sender == owner, 'This action can be performed only by the account which created the contract');
    _isOn = false;
  }

  // this function lets the owner to input candidates into the election database
  function insert_candidate(string name, uint8 number, string party, string vice) public {

    // admin
    require(msg.sender == owner, 'You do not have permission to execute this route');

    // any function in the contract only is executed if the election is on
    require(_isOn == true, 'This election is closed by the owner, sorry');

    // deadlines
    require(now <= insertLimit, 'The insertion deadline is over');

    // doubles
    require(candidates[number].number == 0, 'This candidate has already been added. With you want to edit, delete and add again');

    // if the candidate's number already exists, it will be overwritten
    candidates[number].name = name;
    candidates[number].number = number;
    candidates[number].vice = vice;
    candidates[number].party = party;
    numberList.push(number);
  }

  // this function lets the owner to delete candidates
  function delete_candidate(uint8 number) public {

    // admin
    require(msg.sender == owner, 'You do not have permission to execute this route');

    // any function in the contract only is executed if the election is on
    require(_isOn == true, 'This election is closed by the owner, sorry');

    // deadlines
    require(now <= insertLimit, 'The deletion deadline is over');

    // deleting
    delete candidates[number];
  }

  // this function lets an external account to join as voter in the election
  function join_voter(string __hash) public {

    // not admin
    require(msg.sender != owner, 'Only voters have permission to execute this route');

    // any function in the contract only is executed if the election is on
    require(_isOn == true, 'This election is closed by the owner, sorry');

    // deadlines
    require(now <= joinLimit, 'The join deadline is over');

    // duplicates - an account has as unique id the address and the user hash together (the hash should be unique, like a password)
    require(votersByAddress[msg.sender].from == 0, 'This account has already joined as voter with this address');
    require(votersByHash[__hash].from == 0, 'An account has already joined as voter with this hash');

    // joining
    votersByAddress[msg.sender].from = msg.sender;
    votersByAddress[msg.sender]._hash = __hash;
    votersByAddress[msg.sender].voted = false;
    votersByHash[__hash].from = msg.sender;
    votersByHash[__hash]._hash = __hash;
    votersByHash[__hash].voted = false;
  }

  // internal functions

}
