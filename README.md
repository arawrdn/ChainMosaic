# ChainMosaic

**ChainMosaic** is a generative art protocol on the Base network.  
Each wallet address can mint a unique on-chain mosaic NFT derived from its transaction DNA.  
The art pattern is generated fully on-chain using hashed address data, ensuring uniqueness, permanence, and verifiable identity.

---

## Features

1. **Unique DNA per Wallet**  
   Each address produces a deterministic visual pattern based on its hash.

2. **Fully On-Chain SVG Art**  
   No IPFS or external rendering — all SVG data is generated in the smart contract.

3. **One Mint per Wallet**  
   Each wallet can mint only once, ensuring every ChainMosaic is singular.

4. **Identity Reflection**  
   The NFT acts as a symbolic representation of the wallet's digital existence.

5. **Base Network Deployment**  
   Optimized for Base Mainnet and easy verification on BaseScan.

---

## Contract Details

- **Name:** ChainMosaic  
- **Symbol:** CMOSAIC  
- **Standard:** ERC721 (on-chain SVG)  
- **Network:** Base Mainnet  
- **Solidity Version:** 0.8.31  
- **License:** MIT  

---

## Minting Logic

- Users call `mintMosaic()` once per wallet.  
- Contract derives a unique color palette and grid layout from the wallet’s address hash.  
- The generated pattern is encoded as SVG and stored on-chain in `tokenURI`.

---

## Example Output

Each NFT shows a mosaic grid of colored squares representing the hash of the wallet.  
No external dependencies or randomness — pure cryptographic determinism.

---

## Roadmap

1. **Phase 1 – Core Launch**  
   - Deploy and verify contract on Base Mainnet  
   - Mint limit enforcement and SVG generation  

2. **Phase 2 – Frontend Integration**  
   - Web app for minting and viewing mosaics  
   - WalletConnect and Base integration  

3. **Phase 3 – Community Layer**  
   - Mosaic explorer and leaderboard  
   - Metadata indexer for public viewing  

---

## License

MIT License.  
Developed for the Base network as an open generative art experiment.
