// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";

contract MyNFT is ERC721, Ownable, IERC2981 {
    using Counters for Counters.Counter;

    Counters.Counter private _tokenIds;

    string public baseURI;
    uint256 public constant MAX_SUPPLY = 10000; 
    uint256 public royaltyFeeNumerator = 200; 

    address public royaltyRecipient; 

    bool public isMintEnabled = true; 


    event NFTMinted(address indexed minter, uint256 tokenId);

    
    constructor(string memory _name, string memory _symbol, address _royaltyRecipient) ERC721(_name, _symbol) {
        royaltyRecipient = _royaltyRecipient;
    }

   
    function setBaseURI(string memory _baseURI) public onlyOwner {
        baseURI = _baseURI;
    }

    
    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory currentBaseURI = baseURI;
        return string(abi.encodePacked(currentBaseURI, Strings.toString(tokenId), ".json"));
    }

    
    function mintNFT(address _to) public {
        require(isMintEnabled, "Minting is not enabled"); 
        require(_tokenIds.current() < MAX_SUPPLY, "Maximum supply reached"); 

        _tokenIds.increment();

        uint256 newItemId = _tokenIds.current();
        _mint(_to, newItemId);

        emit NFTMinted(_to, newItemId); 
    }

    
    function setIsMintEnabled(bool _enabled) public onlyOwner {
        isMintEnabled = _enabled;
    }

    
    function setRoyaltyInfo(address _royaltyRecipient, uint96 _royaltyFeeNumerator) public onlyOwner {
        royaltyRecipient = _royaltyRecipient;
        royaltyFeeNumerator = _royaltyFeeNumerator;
    }

   
    function royaltyInfo(uint256 _tokenId, uint256 _salePrice) external view override returns (address receiver, uint256 royaltyAmount) {
        royaltyAmount = (_salePrice * royaltyFeeNumerator) / 10000;
        receiver = royaltyRecipient;
    }

    
    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, IERC165) returns (bool) {
        return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
    }

    
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Contract balance is zero");
        (bool success, ) = owner().call{value: balance}("");
        require(success, "Withdrawal failed");
    }
}