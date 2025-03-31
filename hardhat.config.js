/** @type import('hardhat/config').HardhatUserConfig */
const privateKey = 'here is private key';
module.exports = {
  solidity: "0.8.28",
  defaultNetwork: "network name",
  networks: {
    inksepolia: {
      url: "rpc",
      accounts: [privateKey]
    },
  },
};
