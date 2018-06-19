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
    Vote[] votes;
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
  Candidate[] private candidates;

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

  // this function lets the owner to input candidates into the eldction database
  function insert_candidate(string name, uint8 number, string party, string vice) public {

    // any function in the contract only is executed if the election is on
    require(_isOn == true, 'This election is closed by the owner, sorry');

    // the candidate parameters must be unique
    Candidate memory current;
    uint count = candidates.length;
    for (uint8 i = 0; i < count; i++) {
      current = candidates[i];
      require(!_isEqualStrings(current.name, name) && current.number != number && _isEqualStrings(current.party, party) && _isEqualStrings(current.vice, vice), 'Some parameters are repeated, each candidate must be unique');
    }

    // the election must be inside the supported deadlines
    require(now <= insertLimit, 'The deadline to insert candidates is over');

    // adding the candidate to the election's database
    Candidate c;
    c.name = name;
    c.number = number;
    c.party = party;
    c.vice = vice;
    candidates.push(c); // this line is the problem
  }

  // internal functions

  function _isEqualStrings(string a, string b) internal pure returns (bool) {
    bytes memory _a = bytes(a);
    bytes memory _b = bytes(b);

    uint counta = _a.length;
    uint countb = _b.length;

    if (counta != countb) {
      return false;
    } else {
      for(uint i = 0; i < counta; i++) {
        if(_a[i] != _b[i]) {
          return false;
        }
      }
      return true;
    }
  }

}
