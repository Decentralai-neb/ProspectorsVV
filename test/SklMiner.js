const { expect } = require("chai");
const { ethers } = require("hardhat");

describe('SklMiner', function () {
  let sklMiner, prospect, wood, stone, owner;

  before(async () => {
    [owner] = await ethers.getSigners();
    const Wood = await ethers.getContractFactory('Wood');
    wood = await Wood.deploy();

    const Stone = await ethers.getContractFactory('Stone');
    stone = await Stone.deploy();

    const Prospect = await ethers.getContractFactory('Prospect');
    prospect = await Prospect.deploy();

    const SklMiner = await ethers.getContractFactory('SklMiner');
    sklMiner = await SklMiner.deploy(wood.address, stone.address, prospect.address);

    await prospect.approve(sklMiner.address, ethers.constants.MaxUint256);
    await wood.setApprovalForAll(sklMiner.address, true);
    await stone.setApprovalForAll(sklMiner.address, true);


  });

  it('Should return the Prospect balance of the owner', async function () {
    const ownerBalance = await prospect.balanceOf(owner.address);
    console.log('Owner address:', owner.address);
    console.log('Owner Prospect balance:', ownerBalance.toString());
  
    expect(ownerBalance.toString()).to.equal('21000000000000000000000000');
  });
  

  it('Should return the wood contract address', async function () {
    const tx1 = await sklMiner.wood();
    console.log(tx1);
    console.log('wood address:', wood.address);

    expect(tx1).to.be.eq(wood.address);
  });

  it('Should return the stone contract address', async function () {
    const tx1 = await sklMiner.stone();
    console.log(tx1);
    console.log('stone address:', stone.address);

    expect(tx1).to.be.eq(stone.address);
  });

  it('Should return the prospect contract address', async function () {
    const tx1 = await sklMiner.prospect();
    console.log(tx1);
    console.log('prospect address:', prospect.address);
    expect(tx1).to.be.eq(prospect.address);
  });

  it('Should mint wood tokens', async function () {
    const ownerBalanceBefore = await wood.balanceOf(owner.address, 1);
    console.log(ownerBalanceBefore);
    const mintAmount = 200;
    await wood.mint(owner.address, 1, mintAmount, []);
    const ownerBalanceAfter = await wood.balanceOf(owner.address, 1);
    console.log(ownerBalanceAfter);
    expect(ownerBalanceAfter).to.equal(ownerBalanceBefore.add(mintAmount));
  });

  it('Should mint stone tokens', async function () {
    const ownerBalanceBefore = await stone.balanceOf(owner.address, 2);
    console.log(ownerBalanceBefore);
    const mintAmount = 65;
    await stone.mint(owner.address, 2, mintAmount, []);
    const ownerBalanceAfter = await stone.balanceOf(owner.address, 2);
    console.log(ownerBalanceAfter);
    expect(ownerBalanceAfter).to.equal(ownerBalanceBefore.add(mintAmount));
  });

  it('Should mint sklMiner token', async function () {
    const ownerBalanceBefore = await sklMiner.balanceOf(owner.address, 50);
    console.log(ownerBalanceBefore);
    const mintAmount = 1;
    await sklMiner.mint(owner.address, 50, mintAmount, []);
    const ownerBalanceAfter = await sklMiner.balanceOf(owner.address, 50);
    console.log(ownerBalanceAfter);
    expect(ownerBalanceAfter).to.equal(ownerBalanceBefore.add(mintAmount));
  });

  it('Should return the correct token balance for each resource ID', async function () {
    const woodBalance = await sklMiner.tokenBalances(1);
    console.log(woodBalance);
    expect(woodBalance).to.equal(100);
  
    const stoneBalance = await sklMiner.tokenBalances(2);
    console.log(stoneBalance);
    expect(stoneBalance).to.equal(50);
  });

  it('Should return the sklMiner contract Prospect balance', async function () {
    const prospectBalance = await prospect.balanceOf(sklMiner.address);
    console.log(prospectBalance);
    const expectedBalance = ethers.BigNumber.from('1000000000000000000');
    expect(prospectBalance).to.equal(expectedBalance);
  });
  
  it('Should withdraw 1 Prospect token', async function () {
    const sklMinerBalanceBefore = await prospect.balanceOf(sklMiner.address);
    console.log('sklMiner Prospect balance before:', sklMinerBalanceBefore.toString());
    const amount = ethers.BigNumber.from('1000000000000000000');

    await sklMiner.withdrawProspect(amount);
    
    const sklMinerBalanceAfter = await prospect.balanceOf(sklMiner.address);
    console.log('sklMiner Prospect balance after:', sklMinerBalanceAfter.toString());
  
    expect(sklMinerBalanceAfter).to.equal(sklMinerBalanceBefore.sub(ethers.BigNumber.from('1000000000000000000')));
});



  
  

});