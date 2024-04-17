// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/*
    The Dromedary Framework provides lifecycle management functions for an application-level contract
*/
contract CamelFramework {
    address owner;

    constructor() {
        owner = msg.sender;
    }

    // UTILITY METHODS
    function uintToString(uint _uint) public pure returns (string memory) {
        if (_uint == 0) {
            return "0";
        }
        uint j = _uint;
        uint length;
        while (j != 0) {
            length++;
            j /= 10;
        }
        bytes memory bstr = new bytes(length);
        uint k = length;
        while (_uint != 0) {
            k = k - 1;
            uint8 temp = (48 + uint8(_uint - _uint / 10 * 10));
            bytes1 b1 = bytes1(temp);
            bstr[k] = b1;
            _uint /= 10;
        }
        return string(bstr);
    }

    function concatenateStrings(string memory _a, string memory _b) public pure returns (string memory) {
        bytes memory _ba = bytes(_a);
        bytes memory _bb = bytes(_b);
        string memory ab = new string(_ba.length + _bb.length);
        bytes memory bab = bytes(ab);
        uint k = 0;
        for (uint i = 0; i < _ba.length; i++) bab[k++] = _ba[i];
        for (uint i = 0; i < _bb.length; i++) bab[k++] = _bb[i];
        return string(bab);
    }
}

