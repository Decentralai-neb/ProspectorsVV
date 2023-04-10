const hre = require("hardhat");

const main = async () => {
  let owner, wood
  [owner] = await ethers.getSigners();

  const Wood = await ethers.getContractFactory('Wood');
  wood = await Wood.deploy();
  console.log(`Wood contract deployed to: ${wood.address}`);

  await Wood.deploy();


  const Stone = await ethers.getContractFactory('Stone');
  stone = await Stone.deploy();
  console.log(`Stone contract deployed to: ${stone.address}`);

  await Stone.deploy();

  const Prospect = await ethers.getContractFactory('Prospect');
  prospect = await Prospect.deploy();
  console.log(`Prospect contract deployed to: ${prospect.address}`);

  await Prospect.deploy();

  const SklMiner = await ethers.getContractFactory('SklMiner');
  sklMiner = await SklMiner.deploy(wood.address, stone.address, prospect.address);
  console.log(`SklMiner contract deployed to: ${sklMiner.address}`);

  // await hre.run("verify:verify", {
 //  address: contract.address,
 //   contructorArguments: [],
 // }); 
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
