// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol";

import "./Stone.sol";
import "./Wood.sol";

contract SklMiner is ERC1155, Ownable, ERC1155Burnable, ERC1155Supply{

    // Define a mapping to track the balance of each ERC1155 token ID for your contract
    mapping(uint256 => uint256) public tokenBalances;


    struct Miner {
        uint256 id;
        string name;
        uint256 hashRate;
        uint256 powerConsumption;
        uint256 profitability;
    }

    mapping(address => mapping(uint256 => uint256)) public minerProfitability;

    IERC1155 public wood;
    IERC1155 public stone;
    IERC20 public prospect;

    Miner public sklMiner;
    // required materials to mint a miner
    mapping (uint256 => uint256) public requiredMaterials;

    constructor(IERC1155 _wood, IERC1155 _stone, IERC20 _prospect) ERC1155("") {
        wood = IERC1155(_wood);
        stone = IERC1155(_stone);
        prospect = IERC20(_prospect);
        uint256 profitability = 1;
        // Define miner stats
        sklMiner = Miner(1, "SklMiner", 100, 1000, profitability);
        // Define required materials
        requiredMaterials[1] = 100; // 100 wood
        requiredMaterials[2] = 50; // 50 stone
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        public
    {
        // Check that the user has the required materials to mint a new SKLMiner token
        require(wood.balanceOf(msg.sender, 1) >= requiredMaterials[1], "Insufficient Wood");
        require(stone.balanceOf(msg.sender, 2) >= requiredMaterials[2], "Insufficient Stone");

        // Check that the user has enough PROSPECT tokens to craft a miner
        uint256 prospectRequired = 1 ether;
        require(prospect.balanceOf(msg.sender) >= prospectRequired, "Insufficient PROSPECT tokens");

        // Receive the required materials from the user's account
        wood.safeTransferFrom(msg.sender, address(this), 1, requiredMaterials[1], "");
        stone.safeTransferFrom(msg.sender, address(this), 2, requiredMaterials[2], "");

        prospect.transferFrom(msg.sender, address(this), prospectRequired);

        _mint(account, id, amount, data);
        minerProfitability[account][id] = sklMiner.profitability;
    }

    function setMinerProfitability(uint256 minerId, uint256 profitability) public onlyOwner {
        minerProfitability[msg.sender][minerId] = profitability;
    }

    function getMinerProfitability(uint256 minerId) public view returns (uint256) {
        return minerProfitability[msg.sender][minerId];
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    // Define a function to update the token balance mapping
    function updateTokenBalance(uint256 tokenId, uint256 amount) internal {
        tokenBalances[tokenId] += amount;
    }

    function withdrawResources() external onlyOwner {
        uint256 woodBalance = tokenBalances[1];
        if (woodBalance > 0) {
        wood.safeTransferFrom(address(this), msg.sender, 1, woodBalance, "");
        tokenBalances[1] -= woodBalance;
        }
    
        uint256 stoneBalance = tokenBalances[2];
        if (stoneBalance > 0) {
        stone.safeTransferFrom(address(this), msg.sender, 2, stoneBalance, "");
        tokenBalances[2] -= stoneBalance;
        }
    }
    
    function withdrawProspect(uint256 amount) external onlyOwner {
        require(prospect.balanceOf(address(this)) >= amount, "Insufficient PROSPECT balance");
        prospect.transfer(msg.sender, amount);
    }


    function onERC1155Received(address, address, uint256 id, uint256 value, bytes memory)
        external
        returns(bytes4)
    {
        require(msg.sender == address(stone) || msg.sender == address(wood), "Unsupported token");

        updateTokenBalance(id, value);

        return this.onERC1155Received.selector;
    }

    function getTokenBalance(uint256 tokenId) public view returns (uint256) {
        return tokenBalances[tokenId];
    }    

    // The following functions are overrides required by Solidity.

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}