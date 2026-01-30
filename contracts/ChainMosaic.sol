// SPDX-License-Identifier: MIT
pragma solidity 0.8.31;

/// @title ChainMosaic - On-chain generative identity art based on wallet DNA
/// @author
/// @notice Each wallet can mint exactly one on-chain mosaic NFT based on its address hash.
/// @dev Fully on-chain ERC721 with SVG generation.

contract ChainMosaic {
    /*//////////////////////////////////////////////////////////////
                             METADATA
    //////////////////////////////////////////////////////////////*/
    string public name = "ChainMosaic";
    string public symbol = "CMOSAIC";
    uint256 public totalSupply;

    address public owner;

    mapping(uint256 => address) public ownerOf;
    mapping(address => uint256) public tokenOf;
    mapping(address => bool) public hasMinted;

    event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
    event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /*//////////////////////////////////////////////////////////////
                              MINT LOGIC
    //////////////////////////////////////////////////////////////*/
    function mintMosaic() external {
        require(!hasMinted[msg.sender], "Already minted");
        uint256 tokenId = totalSupply + 1;

        hasMinted[msg.sender] = true;
        ownerOf[tokenId] = msg.sender;
        tokenOf[msg.sender] = tokenId;
        totalSupply += 1;

        emit Transfer(address(0), msg.sender, tokenId);
    }

    /*//////////////////////////////////////////////////////////////
                             OWNERSHIP TRANSFER
    //////////////////////////////////////////////////////////////*/
    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Zero address");
        emit OwnershipTransferred(owner, newOwner);
        owner = newOwner;
    }

    /*//////////////////////////////////////////////////////////////
                           BASIC ERC721 FUNCTIONS
    //////////////////////////////////////////////////////////////*/
    function balanceOf(address account) external view returns (uint256) {
        return hasMinted[account] ? 1 : 0;
    }

    function tokenURI(uint256 tokenId) external view returns (string memory) {
        require(tokenId > 0 && tokenId <= totalSupply, "Invalid tokenId");

        address wallet = ownerOf[tokenId];
        bytes32 hash = keccak256(abi.encodePacked(wallet));

        string memory svg = _generateSVG(hash);
        string memory json = string(
            abi.encodePacked(
                '{"name":"ChainMosaic #',
                _uintToString(tokenId),
                '","description":"On-chain generative art from wallet DNA.","image":"data:image/svg+xml;base64,',
                _base64(bytes(svg)),
                '"}'
            )
        );

        return string(abi.encodePacked("data:application/json;base64,", _base64(bytes(json))));
    }

    /*//////////////////////////////////////////////////////////////
                             SVG GENERATION
    //////////////////////////////////////////////////////////////*/
    function _generateSVG(bytes32 hash) internal pure returns (string memory) {
        string memory svg = '<svg xmlns="http://www.w3.org/2000/svg" width="300" height="300">';
        uint256 grid = 5;
        uint256 size = 60;

        for (uint256 i = 0; i < 25; i++) {
            uint8 r = uint8(hash[i % 32]);
            uint8 g = uint8(hash[(i + 8) % 32]);
            uint8 b = uint8(hash[(i + 16) % 32]);

            uint256 x = (i % grid) * size;
            uint256 y = (i / grid) * size;

            svg = string(
                abi.encodePacked(
                    svg,
                    '<rect x="',
                    _uintToString(x),
                    '" y="',
                    _uintToString(y),
                    '" width="',
                    _uintToString(size),
                    '" height="',
                    _uintToString(size),
                    '" fill="rgb(',
                    _uintToString(r),
                    ',',
                    _uintToString(g),
                    ',',
                    _uintToString(b),
                    ')"/>'
                )
            );
        }

        svg = string(abi.encodePacked(svg, "</svg>"));
        return svg;
    }

    /*//////////////////////////////////////////////////////////////
                              HELPERS
    //////////////////////////////////////////////////////////////*/
    function _uintToString(uint256 value) internal pure returns (string memory) {
        if (value == 0) return "0";
        uint256 temp = value;
        uint256 digits;
        while (temp != 0) {
            digits++;
            temp /= 10;
        }
        bytes memory buffer = new bytes(digits);
        while (value != 0) {
            digits -= 1;
            buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
            value /= 10;
        }
        return string(buffer);
    }

    string internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    function _base64(bytes memory data) internal pure returns (string memory) {
        if (data.length == 0) return "";
        string memory table = TABLE;
        uint256 encodedLen = 4 * ((data.length + 2) / 3);
        string memory result = new string(encodedLen + 32);
        assembly {
            mstore(result, encodedLen)
            let tablePtr := add(table, 1)
            let dataPtr := data
            let endPtr := add(data, mload(data))
            let resultPtr := add(result, 32)
            for {

            } lt(dataPtr, endPtr) {

            } {
                dataPtr := add(dataPtr, 3)
                let input := mload(sub(dataPtr, 2))
                mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
                resultPtr := add(resultPtr, 1)
                mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
                resultPtr := add(resultPtr, 1)
                mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
                resultPtr := add(resultPtr, 1)
                mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
                resultPtr := add(resultPtr, 1)
            }
            switch mod(mload(data), 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }
        }
        return result;
    }
}
