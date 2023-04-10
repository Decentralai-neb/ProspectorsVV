// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Supply.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/utils/ERC1155Receiver.sol";
import "./Iron.sol";

contract MetalBar is ERC1155, Ownable, Pausable, ERC1155Burnable, ERC1155Supply {

    IERC1155 public iron;
    IERC20 public prospect;
    // required materials to mint a metalbar
    mapping (uint256 => uint256) public requiredMaterials;


    constructor(IERC1155 _iron, IERC20 _prospect)
        ERC1155("https://pickaxecrypto.mypinata.cloud/ipfs/QmbFAYVr2SD33qVy7xVSu7WJne8sBsnpucaajexHHVU4VJ/")
    {
        iron = IERC1155(_iron);
        prospect = IERC20(_prospect);
        requiredMaterials[1] = 3; // 3 Raw Metal
    }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address account, uint256 id, uint256 amount, bytes memory data)
        public
    {
         // Check that the user has the required materials to mint a new SKLMiner token
        require(iron.balanceOf(msg.sender, 4) >= requiredMaterials[1], "Insufficient MetalBars");
        // Check that the user has enough PROSPECT tokens to mint a gold bar
        uint256 prospectRequired = 0.35 ether;
        require(prospect.balanceOf(msg.sender) >= prospectRequired, "Insufficient PROSPECT tokens");
        // Receive the required materials from the user's account
        //rawgold.burn(msg.sender, address(this), 3, requiredMaterials[1], "");
        ERC1155Burnable(address(iron)).burn(msg.sender, 3, requiredMaterials[1]);

        _mint(account, id, amount, data);
    }

    function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        public
        onlyOwner
    {
        _mintBatch(to, ids, amounts, data);
    }

    function _beforeTokenTransfer(address operator, address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data)
        internal
        whenNotPaused
        override(ERC1155, ERC1155Supply)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}