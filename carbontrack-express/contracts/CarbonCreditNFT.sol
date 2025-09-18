// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/interfaces/IERC2981.sol";

contract CarbonCreditNFT is ERC721, Ownable, IERC2981 {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdCounter;

    struct CarbonCredit {
        address issuer;
        string projectId;
        string location;
        uint256 tonnesCO2;
        uint256 issuanceDate;
        uint256 retirementDate;
        bool isActive;
    }

    mapping(uint256 => CarbonCredit) private _credits;
    mapping(uint256 => string) private _tokenURIs;
    mapping(address => bool) public authorizedIssuers;

    address public royaltyReceiver;
    uint96 public royaltyBps;

    event CreditIssued(uint256 indexed tokenId, address indexed issuer, address indexed owner, uint256 tonnesCO2);
    event CreditRetired(uint256 indexed tokenId, address indexed owner, uint256 retirementDate);

    constructor() ERC721("CarbonCreditNFT", "CCN") {
        _grantRole(msg.sender);
        royaltyReceiver = msg.sender;
        royaltyBps = 500;
    }

    modifier onlyAuthorizedIssuer() {
        require(authorizedIssuers[msg.sender], "Não autorizado");
        _;
    }

    modifier onlyCreditOwner(uint256 tokenId) {
        require(ownerOf(tokenId) == msg.sender, "Não é dono");
        require(_credits[tokenId].isActive, "Inativo");
        _;
    }

    function addAuthorizedIssuer(address issuer) external onlyOwner {
        require(issuer != address(0), "Inválido");
        authorizedIssuers[issuer] = true;
    }

    function setRoyalty(address receiver, uint96 bps) external onlyOwner {
        require(receiver != address(0), "Receiver inválido");
        require(bps <= 10000, "Máx 100%");
        royaltyReceiver = receiver;
        royaltyBps = bps;
    }

    function issueCredit(
        address to,
        string memory projectId,
        string memory location,
        uint256 tonnesCO2
    ) external onlyAuthorizedIssuer returns (uint256) {
        require(to != address(0), "Destinatário inválido");
        require(bytes(projectId).length > 0, "Projeto obrigatório");
        require(tonnesCO2 > 0, "Quantidade > 0");

        _tokenIdCounter.increment();
        uint256 tokenId = _tokenIdCounter.current();

        _safeMint(to, tokenId);

        _credits[tokenId] = CarbonCredit({
            issuer: msg.sender,
            projectId: projectId,
            location: location,
            tonnesCO2: tonnesCO2,
            issuanceDate: block.timestamp,
            retirementDate: 0,
            isActive: true
        });

        emit CreditIssued(tokenId, msg.sender, to, tonnesCO2);
        return tokenId;
    }

    function retireCredit(uint256 tokenId) external onlyCreditOwner(tokenId) {
        _credits[tokenId].isActive = false;
        _credits[tokenId].retirementDate = block.timestamp;
        emit CreditRetired(tokenId, msg.sender, block.timestamp);
    }

    function setTokenURI(uint256 tokenId, string memory ipfsUri) external onlyOwner {
        require(_exists(tokenId), "Token não existe");
        _tokenURIs[tokenId] = ipfsUri;
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        require(_exists(tokenId), "Token não existe");
        string memory uri = _tokenURIs[tokenId];
        return bytes(uri).length > 0 ? uri : "https://ipfs.io/ipfs/Qm...";
    }

    function royaltyInfo(uint256, uint256 salePrice)
        external
        view
        override
        returns (address receiver, uint256 royaltyAmount)
    {
        return (royaltyReceiver, (salePrice * royaltyBps) / 10000);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, IERC165)
        returns (bool)
    {
        return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
    }

    function _grantRole(address account) internal {
        authorizedIssuers[account] = true;
    }
}
