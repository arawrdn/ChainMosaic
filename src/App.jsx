import { useState, useEffect } from "react";
import { ethers } from "ethers";
import MosaicViewer from "./components/MosaicViewer";

const CONTRACT_ADDRESS = "0xB69cecE5DcEe1f8339ed248B9e9fb933e975096b";
const ABI = [
  "function mintMosaic() external",
  "function hasMinted(address) view returns (bool)",
  "function tokenOf(address) view returns (uint256)",
  "function tokenURI(uint256) view returns (string)"
];

function App() {
  const [wallet, setWallet] = useState(null);
  const [status, setStatus] = useState("");
  const [tokenURI, setTokenURI] = useState("");
  const [minted, setMinted] = useState(false);

  async function connectWallet() {
    if (!window.ethereum) {
      alert("MetaMask not found!");
      return;
    }
    const provider = new ethers.BrowserProvider(window.ethereum);
    const accounts = await provider.send("eth_requestAccounts", []);
    setWallet(accounts[0]);
    checkMintStatus(accounts[0], provider);
  }

  async function checkMintStatus(address, provider) {
    const contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, provider);
    const minted = await contract.hasMinted(address);
    setMinted(minted);
    if (minted) {
      const tokenId = await contract.tokenOf(address);
      const uri = await contract.tokenURI(tokenId);
      setTokenURI(uri);
    }
  }

  async function mintMosaic() {
    try {
      setStatus("Minting your mosaic...");
      const provider = new ethers.BrowserProvider(window.ethereum);
      const signer = await provider.getSigner();
      const contract = new ethers.Contract(CONTRACT_ADDRESS, ABI, signer);
      const tx = await contract.mintMosaic();
      await tx.wait();
      setStatus("Mint successful!");
      checkMintStatus(wallet, provider);
    } catch (err) {
      console.error(err);
      setStatus("Transaction failed or cancelled.");
    }
  }

  return (
    <div className="min-h-screen bg-gray-950 text-gray-100 flex flex-col items-center justify-center p-6">
      <h1 className="text-3xl font-bold mb-4">ChainMosaic</h1>
      <p className="text-gray-400 mb-6">Your wallet's cryptographic identity art.</p>

      {!wallet ? (
        <button
          onClick={connectWallet}
          className="px-6 py-2 bg-blue-600 rounded hover:bg-blue-700"
        >
          Connect Wallet
        </button>
      ) : minted ? (
        <div className="flex flex-col items-center">
          <p className="mb-2 text-green-400">Mosaic already minted.</p>
          <MosaicViewer tokenURI={tokenURI} />
        </div>
      ) : (
        <button
          onClick={mintMosaic}
          className="px-6 py-2 bg-green-600 rounded hover:bg-green-700"
        >
          Mint Your Mosaic
        </button>
      )}

      <p className="mt-4 text-sm text-gray-400">{status}</p>
    </div>
  );
}

export default App;
