// SPDX-License-Identifier: MIT
pragma solidity ^0.8.8;

//Imports
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./Admin.sol";


error Institutes__NoInstitutesAvailable();
error Institutes__Not_Owner();

//Contract

/**@title Colleges/Institutes Smart Contract
 *@notice This contract is accessable by Institutes registered with Admin and can be used to mint Digital Documents
 *@dev It interracts with the Admin Smart Contract Interface to use add Insititutes functionality
 */
contract Institutes is ERC721URIStorage, Ownable {
    address private s_creator;
    uint256 private s_instituteID;
    bool public isMintEnabled;
    uint256 public totalSupply;


    modifier tokenExist(uint256 _tokenId) {
        require(_exists(_tokenId), "Token Doesn't exist!");
        _;
    }

    address immutable i_adminAddress;
    InterfaceAdmin immutable i_admin;

    constructor(
        uint256 _instituteID,
        address instituteOwnerAddress,
        string memory _instituteName,
        string memory _instituteEmailAddress,
        address adminAddress
    ) ERC721("Product", "PRD") {
        totalSupply = 0;

        i_adminAddress = adminAddress;
        s_instituteID = _instituteID;
        s_creator = msg.sender;

        i_admin = InterfaceAdmin(i_adminAddress);

        i_admin.addInstitute(
            _instituteID,
            instituteOwnerAddress,
            _instituteName,
            _instituteEmailAddress,
            address(this)
        );
    }

    //*****************************************************************************************/
    //                               SETTER FUNCTIONS
    //*************************************************************************************** */

    // ISSUING THE SBT - ONLY ALLOsWED BY OWNER

    function issueSBT(
        string memory _tokenURI, 
        address student
    ) public {

        require(s_creator != msg.sender, "Caller is not the owner");
        uint256 tokenId = totalSupply;

        _safeMint(student, tokenId);
        _setTokenURI(tokenId, _tokenURI);

        totalSupply++;
    }
    //CHECKS IF THE CURRENT ACCOUNT IS OWNER OF THE GIVEN NFT OR NOT

    function isOwner(uint256 _tokenId) public view tokenExist(_tokenId) returns (bool) {
        if (msg.sender == ownerOf(_tokenId)) {
            return true;
        } else {
            return false;
        }
    }

    // RETURNS THE TOKEN URI OF THE TOKEN

    function viewTokenURI(uint256 _tokenId)
        public
        view
        tokenExist(_tokenId)
        returns (string memory)
    {
        return tokenURI(_tokenId);
    }

    // RETURNS THE TOTAL TOKENS THAT HAVE BEEN MINTED

    function getTotalySupply() public view returns (uint256) {
        return totalSupply;
    }

    function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory data) public pure override {
        revert("Transfer function is not applicable");
    }

    function safeTransferFrom(address from, address to, uint256 tokenId) public pure override {
        revert("Transfer function is not applicable");
    }

    function transferFrom(address from, address to, uint256 tokenId) public pure override {
        revert("Transfer function is not applicable");
    }

}

error instituteFactory__Not_Admin();

/**@title institute Factory Smart Contract
 *@notice This contract deploys the smart contract used by institutes
 *@dev It uses the new keyword to deploy the contract with passing parameters to the institutes constructor
 */

contract instituteFactory {

    //State Variables
    address private s_instituteOwnerAddress;
    string private s_instituteName;
    string private s_instituteEmailAddress;
    uint256 private s_instituteID;
    address immutable i_adminAddress;
    InterfaceAdmin immutable i_admin;

    event instituteCreated(Institutes indexed instituteSmartContAddress);

    modifier onlyAdmin() {
        if (msg.sender != i_adminAddress) revert instituteFactory__Not_Admin();
        _;
    }

    //Constructor

    constructor(address adminAddress) {
        i_adminAddress = adminAddress;
        i_admin = InterfaceAdmin(i_adminAddress);
    }

    function deploynInstituteContract(
        uint256 _instituteID,
        address _instituteOwnerAddress,
        string calldata _instituteName,
        string calldata _instituteEmailAddress
    ) public {

        Institutes instituteSmartContAddress = new Institutes(
            _instituteID,
            _instituteOwnerAddress,
            _instituteName,
            _instituteEmailAddress,
            i_adminAddress
        );
        emit instituteCreated(instituteSmartContAddress);
    }

    function getInstituteID(address instituteAddress) public view returns (uint256) {
        return i_admin.getInstituteID(instituteAddress);
    }

}