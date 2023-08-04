// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/*
      __ ______  ____  ____        __  __  
     / //_/ __ \/ __ \/ __ \ ___  / /_/ /_ 
    / ,< / / / / / / / /_/ // _ \/ __/ __ \
   / /| / /_/ / /_/ / _, _//  __/ /_/ / / /
  /_/ |_\____/_____/_/ |_(_)___/\__/_/ /_/ 
  
  Donations: kodr.eth
*/

/// @custom:security-contact kodr@codemucho.com
    contract PixEvolutions is ERC721, Ownable, ReentrancyGuard {
    using Counters for Counters.Counter;
    using Strings for uint256;

    Counters.Counter private _tokenIdCounter;

    uint256 public constant MAX_TOKENS = 5000;
    uint256 public constant MINIMUM_INTERVAL = 1 minutes; // Rate limit for minting

    string internal _baseTokenURI;

    mapping(address => uint256) public totalMinted;
    mapping(address => uint256) private lastMintedTime; // Rate limiting

    event Minted(address indexed to, uint256 quantity);

    constructor(string memory baseuri) ERC721("PixEvolutions", "PXO") {
        _baseTokenURI = baseuri;
        _tokenIdCounter.increment(); // start at 1
    }

    function safeMint(uint256 amount) external payable {
        require(totalMinted[msg.sender] + amount <= 5, "PixEvolutions: Max 5 tokens per address");
        require(msg.value == amount * 0.014 ether, "PixEvolutions: 0.014 ether per token");
        require(_tokenIdCounter.current() + amount <= MAX_TOKENS, "PixEvolutions: Max tokens reached");
        require(block.timestamp >= lastMintedTime[msg.sender] + MINIMUM_INTERVAL, "PixEvolutions: Minting too fast");

        lastMintedTime[msg.sender] = block.timestamp;

        for (uint256 i = 0; i < amount; i++) {
            uint256 tokenId = _tokenIdCounter.current();
            _tokenIdCounter.increment();
            _safeMint(msg.sender, tokenId);
        }
        totalMinted[msg.sender] += amount;
        emit Minted(msg.sender, amount);
    }

    function _baseURI() internal view override returns (string memory) {
        return _baseTokenURI;
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    // so owner and only owner can withdraw the funds
    function withdraw() external onlyOwner nonReentrant {
        payable(msg.sender).transfer(address(this).balance);
    }

    // Define a function to update the base URI
    function setBaseURI(string memory baseURI) external onlyOwner {
        _baseTokenURI = baseURI;
    }

    // Override the tokenURI function to concatenate the base URI with the token ID
    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        return string(abi.encodePacked(_baseTokenURI, tokenId.toString()));
    }

    // Override the _burn function to allow burning from contract
    // approved can burn other people's tokens but that's no different from transferring to 0xdeaD
    function burn(uint256 tokenId) external {
        require(_isApprovedOrOwner(msg.sender, tokenId), "PixEvolutions: caller is not owner nor approved");
        _burn(tokenId);
    }
}
