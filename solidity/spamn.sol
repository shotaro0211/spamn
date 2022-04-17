//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract SPAMN2233 is ERC721Enumerable, Ownable, ReentrancyGuard {

    struct Question {
        string title;
        string[] choices;
        uint256 answer;
        string description;
        address owner;
        uint256 value;
    }
    Question[] private _questions;

    string private _imageUrl;
    uint256 private _nextMintId;

    function getQuestion(uint256 tokenId) public view onlyOwner returns (Question memory) {
        return _questions[tokenId];
    }

    function getQuestionTitle(uint256 tokenId) public view returns (string memory) {
        return _questions[tokenId].title;
    }

    function getQuestionChoices(uint256 tokenId) public view returns (string[] memory) {
        return _questions[tokenId].choices;
    }

    function getQuestionValue(uint256 tokenId) public view returns (uint256) {
        return _questions[tokenId].value;
    }

    function setAnswer(uint256 tokenId, uint256 answer) public {
        require(msg.sender == ownerOf(tokenId), "owner invalid");

        Question memory question = getQuestion(tokenId);

        if (answer == question.answer) {
            payable(msg.sender).transfer(question.value);
            _burn(tokenId);
        } else {
            payable(question.owner).transfer(question.value);
        }
    }

    function mint(string memory title, string[] memory choices, uint256 answer, string memory description, address owner) public onlyOwner nonReentrant payable {
        _addQuestions(title, choices, answer, description, msg.sender, msg.value);
        _safeMint(owner, _nextMintId);
        _nextMintId += 1;
    }

    function _addQuestions(string memory title, string[] memory choices, uint256 answer, string memory description, address owner, uint256 value) internal {
        _questions.push(
            Question(
                title,
                choices,
                answer,
                description,
                owner,
                value
            )
        );
    }

    function tokenURI(uint256 tokenId) override public view returns (string memory) {
        Question memory question = getQuestion(tokenId);
        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "', question.title, '", "description": "https://spamn.com", "image": "', _imageUrl, '"}'))));
        string memory output = string(abi.encodePacked('data:application/json;base64,', json));
        return output;
    }

    constructor(string memory imageUrl) ERC721("SPAMN2233", "SPAM2233") Ownable() {
        _imageUrl = imageUrl;
        _nextMintId = 1;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal pure override {
        require(from == address(0));
    }

    function toString(uint256 value) internal pure returns (string memory) {
        // Inspired by OraclizeAPI's implementation - MIT license
        // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol

        if (value == 0) {
            return "0";
        }
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
}

/// [MIT License]
/// @title Base64
/// @notice Provides a function for encoding some bytes in base64
/// @author Brecht Devos <brecht@loopring.org>
library Base64 {
    bytes internal constant TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";

    /// @notice Encodes some bytes to the base64 representation
    function encode(bytes memory data) internal pure returns (string memory) {
        uint256 len = data.length;
        if (len == 0) return "";

        // multiply by 4/3 rounded up
        uint256 encodedLen = 4 * ((len + 2) / 3);

        // Add some extra buffer at the end
        bytes memory result = new bytes(encodedLen + 32);

        bytes memory table = TABLE;

        assembly {
            let tablePtr := add(table, 1)
            let resultPtr := add(result, 32)

            for {
                let i := 0
            } lt(i, len) {

            } {
                i := add(i, 3)
                let input := and(mload(add(data, i)), 0xffffff)

                let out := mload(add(tablePtr, and(shr(18, input), 0x3F)))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(12, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(shr(6, input), 0x3F))), 0xFF))
                out := shl(8, out)
                out := add(out, and(mload(add(tablePtr, and(input, 0x3F))), 0xFF))
                out := shl(224, out)

                mstore(resultPtr, out)

                resultPtr := add(resultPtr, 4)
            }

            switch mod(len, 3)
            case 1 {
                mstore(sub(resultPtr, 2), shl(240, 0x3d3d))
            }
            case 2 {
                mstore(sub(resultPtr, 1), shl(248, 0x3d))
            }

            mstore(result, encodedLen)
        }

        return string(result);
    }
}