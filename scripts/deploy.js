async function main() {
    const Cryptodz = await ethers.getContractFactory("Cryptodz");
 
    // Start deployment, returning a promise that resolves to a contract object
    const tokenPrice = ethers.utils.parseEther("0.0000098"); // Set the token price to 0.01 Ether (adjust as needed)
    const cryptodz = await Cryptodz.deploy("Cryptodz", "CTZ", 18, 1000000000000, tokenPrice); // Pass the token price as an additional argument
    console.log("Contract deployed to address:", cryptodz.address);

    // Mint tokens
    const [owner] = await ethers.getSigners();
    const totalSupply = ethers.utils.parseEther("1000000000000"); // Total supply of tokens
    await cryptodz.mint(owner.address, totalSupply);

    console.log("Tokens minted successfully");
}
 
main()
   .then(() => process.exit(0))
   .catch(error => {
     console.error(error);
     process.exit(1);
   });
