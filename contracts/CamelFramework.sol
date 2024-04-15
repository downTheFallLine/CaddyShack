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
}

