/** @type import('hardhat/config').HardhatUserConfig */
require('dotenv').config();
require("@nomiclabs/hardhat-ethers");
require("@nomiclabs/hardhat-etherscan");


const { API_URL, PRIVATE_KEY , ETHERSCAN_APIKEY } = process.env;

module.exports = {
  solidity: "0.8.24",
  defaultNetwork: "sepoila",
   networks: {
      hardhat: {},
      sepoila: {
         url: API_URL,
         accounts: [`0x${PRIVATE_KEY}`]
      }
   },
   etherscan: {
    // Your API key for Etherscan
    // Obtain one at https://etherscan.io/
    apiKey: ETHERSCAN_APIKEY //
   }
};
