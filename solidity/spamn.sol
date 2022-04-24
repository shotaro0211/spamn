//SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

contract SPAMN is ERC721Enumerable, Ownable, ReentrancyGuard {

    struct Question {
        string title;
        string[] choices;
        uint256 answer;
        string description;
        address owner;
        uint256 value;
        bool answered;
        bool corrected;
    }
    Question[] private _questions;

    string private _imageUrl;
    uint256 private _nextMintId;
    string private _title;
    address[] private _watches;
    string private _baseUrl = "https://spamn.app/";

    function getQuestion(uint256 tokenId) public view onlyOwner returns (Question memory) {
        return _questions[tokenId - 1];
    }

    function getQuestionTitle(uint256 tokenId) public view returns (string memory) {
        return _questions[tokenId - 1].title;
    }

    function getQuestionChoices(uint256 tokenId) public view returns (string[] memory) {
        return _questions[tokenId - 1].choices;
    }

    function getQuestionValue(uint256 tokenId) public view returns (uint256) {
        return _questions[tokenId - 1].value;
    }

    function setAnswer(uint256 tokenId, uint256 answer) public nonReentrant {
        require(msg.sender == ownerOf(tokenId), "owner invalid");

        Question memory question = _questions[tokenId -1];

        require(question.answered == false, "already answerd");

        _questions[tokenId -1].answered = true;

        if (answer == question.answer) {
            _questions[tokenId -1].corrected = true;
            _burn(tokenId);
            payable(msg.sender).transfer(question.value);
        } else {
            _questions[tokenId -1].corrected = false;
            payable(question.owner).transfer(question.value);
        }
    }

    function getImageUrl() public view returns (string memory) {
        return _imageUrl;
    }

    function getTitle() public view returns (string memory) {
        return _title;
    }

    function watched() public view returns (bool) {
        for(uint256 i = 0; i < _watches.length; i++) {
            if (_watches[i] == msg.sender) {
                return true;
            }
        }
        return false;
    }

    function addWatch() public nonReentrant {
        _watches.push(msg.sender);
    }

    function getTotalWatchCount() public view returns (uint256) {
        return _watches.length;
    }

    // function setBaseUrl(string memory baseUrl) public nonReentrant onlyOwner {
    //     _baseUrl = baseUrl;
    // }

    function watchMint(string memory title, string[] memory choices, uint256 answer, string memory description) public nonReentrant payable {
        _listMint(title, choices, answer, description, _watches);
    }

    function _listMint(string memory title, string[] memory choices, uint256 answer, string memory description, address[] memory owners) internal {
        for (uint256 i = 0; i < owners.length; i++) {
            _claim(title, choices, answer, description, owners[i], msg.value / owners.length);
        }
    }

    function mint(string memory title, string[] memory choices, uint256 answer, string memory description, address owner) public nonReentrant payable {
        _claim(title, choices, answer, description, owner, msg.value);
    }

    function _claim(string memory title, string[] memory choices, uint256 answer, string memory description, address owner, uint256 value) internal {
        _addQuestions(title, choices, answer, description, msg.sender, value);
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
                value,
                false,
                false
            )
        );
    }

    function _attributes(uint256 value, string[] memory choices, bool answered, bool corrected) internal pure returns (string memory) {
        string memory att = string(abi.encodePacked('"attributes": [{"trait_type": "Value", "value": "', toString(value), '"}, {"trait_type": "Choices", "value": "', toString(choices.length), '"}, {"trait_type": "Answered", "value": "', answered ? "true" : "false", '"}, {"trait_type": "Corrected", "value": "', corrected ? "true" : "false", '"}]'));
        return att;
    } 

    function tokenURI(uint256 tokenId) override public view returns (string memory) {
        uint256 value = getQuestionValue(tokenId);
        string[] memory choices = getQuestionChoices(tokenId);
        bool answered = _questions[tokenId - 1].answered;
        bool corrected = _questions[tokenId - 1].corrected;
        string memory att = _attributes(value, choices, answered, corrected);
        string memory json = Base64.encode(bytes(string(abi.encodePacked('{"name": "', _title, '", "description": "', _baseUrl, toAsciiString(address(this)), '/', toString(tokenId), '", "image": "', _imageUrl, '", ', att, '}'))));
        string memory output = string(abi.encodePacked('data:application/json;base64,', json));
        return output;
    }

    constructor(string memory imageUrl, string memory tokenName, string memory title) ERC721(tokenName, "SPAMN") Ownable() {
        _title = title;
        _imageUrl = imageUrl;
        _nextMintId = 1;
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

    function toAsciiString(address x) internal pure returns (string memory) {
        bytes memory s = new bytes(40);
        for (uint i = 0; i < 20; i++) {
            bytes1 b = bytes1(uint8(uint(uint160(x)) / (2**(8*(19 - i)))));
            bytes1 hi = bytes1(uint8(b) / 16);
            bytes1 lo = bytes1(uint8(b) - 16 * uint8(hi));
            s[2*i] = char(hi);
            s[2*i+1] = char(lo);            
        }
        return string(s);
    }

    function char(bytes1 b) internal pure returns (bytes1 c) {
        if (uint8(b) < 10) return bytes1(uint8(b) + 0x30);
        else return bytes1(uint8(b) + 0x57);
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