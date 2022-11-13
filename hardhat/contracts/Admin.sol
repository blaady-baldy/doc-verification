//SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;


error Admin__Not_Admin();
error Admin__NoInstituteAvailable();

//Interface

contract InterfaceAdmin {
    function addInstitute(
        uint256 _instituteID,
        address _instituteAdd,
        string memory _instituteName,
        string memory _instituteEmailAddress,
        address _smartContractAddress
    ) external {}

    function getInstituteID(address instituteAdd) external view returns (uint256) {}
}

//Contract

/**@title Admin Smart Contract
 *@dev It interracts with the institute Smart Contract to add their details in institutes array
 */
contract Admin {
    //Type Declaration
    struct institute {
        uint256 instituteID;
        address instituteAddress;
        string instituteName;
        string instituteEmailAddress;
        address smartContractAddress;
    }

    //State Variables
    address private immutable i_owner;
    institute[] private s_institutes;
    uint256 private s_currentTimeStamp;
    mapping(address => uint256) private s_addressToInstituteIndex;
    mapping(address => uint256) private s_addressToInstituteId;
    mapping(uint256 => uint256) private s_idToIndex;

    //Events
    event instituteAdded(address indexed instituteAdd);
    event instituteArrayModified();

    //Modifiers
    modifier onlyAdmin() {
        if (msg.sender != i_owner) revert Admin__Not_Admin();
        _;
    }

    //Constructor
    constructor() {
        i_owner = msg.sender;
    }

    ////External

    function addinstitute(
        uint256 _instituteID,
        address _instituteAdd,
        string memory _instituteName,
        string memory _instituteEmailAddress,
        address _smartContractAddress
    ) external {
        s_addressToInstituteIndex[_instituteAdd] = s_institutes.length;
        s_addressToInstituteId[_instituteAdd] = _instituteID;
        s_idToIndex[_instituteID] = s_addressToInstituteIndex[_instituteAdd];
        s_institutes.push(
            institute(
                _instituteID,
                _instituteAdd,
                _instituteName,
                _instituteEmailAddress,
                _smartContractAddress
            )
        );
        emit instituteAdded(_instituteAdd);
    }

    //View or Pure Functions

    function getOwner() public view returns (address) {
        return i_owner;
    }

    function getNumberOfinstitutes() public view returns (uint256) {
        return s_institutes.length;
    }

    function getInstituteAddress(uint256 index) public view returns (address) {
        return s_institutes[index].instituteAddress;
    }

    function getInstituteName(uint256 index) public view returns (string memory) {
        return s_institutes[index].instituteName;
    }

    function getInstituteEmailAddress(uint256 index) public view returns (string memory) {
        return s_institutes[index].instituteEmailAddress;
    }

    function getInstituteSmartContractAddress(uint256 index) public view returns (address) {
        return s_institutes[index].smartContractAddress;
    }

    function getInstituteIndex(address instituteAdd) public view returns (uint256) {
        return s_addressToInstituteIndex[instituteAdd];
    }

    function getInstituteID(address instituteAdd) public view returns (uint256) {
        return s_addressToInstituteId[instituteAdd];
    }

    function getInstituteData(uint256 index) public view returns (institute memory) {
        return s_institutes[index];
    }

    function getInstituteArrays() public view returns (institute[] memory) {
        return s_institutes;
    }

    function getInstituteIndexFromID(uint256 id) public view returns (uint256) {
        return s_idToIndex[id];
    }
}
