const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("ChainMosaic", function () {
  it("Should allow one mint per wallet", async function () {
    const [owner, addr1] = await ethers.getSigners();
    const CM = await ethers.getContractFactory("ChainMosaic");
    const contract = await CM.deploy();

    await contract.connect(addr1).mintMosaic();
    await expect(contract.connect(addr1).mintMosaic()).to.be.revertedWith("Already minted");
  });
});
