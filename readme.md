# deploy contract
npx hardhat compile
npx hardhat run scripts/deploy.js --network your-network

# deploy the nft site
after deploy you can get contract address,change web/script.js YOUR_CONTRACT_ADDRESS,Put the files in the web directory into the web server

