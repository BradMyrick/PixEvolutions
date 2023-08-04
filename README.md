# Guide to Using the PixEvolutions Contract
## Introduction

The PixEvolutions contract is an ERC721 compliant contract that allows for the minting, management, and transfer of unique non-fungible tokens (NFTs). Here's how you can interact with the contract:
1. Minting Tokens

Minting refers to the process of creating new tokens within the contract.

    Function: safeMint(uint256 amount)
    Parameters: amount (uint256) - The number of tokens you want to mint.
    Requirements: You can mint a maximum of 5 tokens per address, and the minting fee is 0.014 ether per token.
    Rate Limiting: You must wait a minimum of 1 minute between consecutive minting actions from the same address.
    Note: Make sure to send the exact required ether with the transaction.

2. Viewing Minted Tokens

You can see the total number of tokens minted by a particular address.

    Function: totalMinted(address userAddress)
    Parameters: userAddress (address) - The address you want to check.
    Returns: The total number of tokens minted by the given address.

3. Managing Your NFTs

You can view the URI associated with a token, and if you are the owner or have approval, you can burn the token.

    Viewing Token URI: tokenURI(uint256 tokenId)
    Burning a Token: burn(uint256 tokenId)

4. Owner Functions

If you are the contract owner, you have additional functions available:

    Withdraw Funds: withdraw() - Transfers the contract's balance to the owner's address.
    Set Base URI: setBaseURI(string memory baseURI) - Updates the base URI for all tokens. ie: https://pixevolutions.com/oldtokenuri/token/ -> https://pixevolutions.com/newtokenuri/token/
    // Note: The token ID will be appended to the end of the base URI.

5. Donations

For those who wish to support the development, donations can be sent to the following ENS address: kodr.eth.


Please reach out to the security contact at kodr@codemucho.com if you encounter any issues or have further questions.