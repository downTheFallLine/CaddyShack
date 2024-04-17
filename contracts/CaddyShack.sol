// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import "./CamelFramework.sol";
import "./CourseManager.sol";

contract CaddyShack is CamelFramework, CourseManager {

    event auditMessage(address indexed sender, string message);

    struct Player {
        string firstName;
        string lastName;
        uint handicap;
    }
    
    struct Round {
        string courseName;
        uint timePlayed;
        uint[] score;
        address attestedBy;
    }

    mapping(address => Player) private players;
    mapping (address => Round) private rounds;

    modifier handicapMustBeValid (uint _handicap) {
        require (isHandicapValid(_handicap),"handicap must be 54 or less in golf");
        _;
    }

    function joinClub(string calldata _firstName, string calldata _lastName, uint  _handicap) public handicapMustBeValid(_handicap)  {
        players[msg.sender] = Player({firstName : _firstName, lastName : _lastName, handicap : _handicap});
        emit auditMessage(msg.sender,"joined the club");
    }

    function getMyHandicap() public view returns (uint){ 
        return players[msg.sender].handicap ;
    }

    function getMyData() public view returns (Player memory) {
        return players[msg.sender];
    }

    function setMyHandicap(uint _handicap) public handicapMustBeValid(_handicap) {
        players[msg.sender].handicap = _handicap ;
    }

    function playRound(string calldata _courseName, uint[] calldata _scores) public golfCourseMustBeRegistered(_courseName) {
        // record the round being played

        address  _k;
        Round memory _round =  Round({courseName: _courseName, score: _scores, attestedBy: _k, timePlayed: 0});
        rounds[msg.sender] = _round;

        // look for amazing holes (par, birdie, etc) and create event
        for (uint i=0; i< golfCourses[_courseName].pars.length; i++) {
            int  _overUnder = int(_scores[i]) - int(golfCourses[_courseName].pars[i]);
            if (_overUnder == 0) { //
                // scored a par at COURSE on hole X
                string memory logMessage = concatenateStrings("scored a par at ", _courseName);
                logMessage = concatenateStrings(logMessage," on hole ");
                logMessage = concatenateStrings(logMessage, uintToString(i+1));
                emit auditMessage(msg.sender, logMessage);
            }
            if (_overUnder == 1) { //
                // scored a bogey at COURSE on hole X
                string memory logMessage = concatenateStrings("scored a bogey at ", _courseName);
                logMessage = concatenateStrings(logMessage," on hole ");
                logMessage = concatenateStrings(logMessage, uintToString(i+1));
                emit auditMessage(msg.sender, logMessage);
            }
             if (_overUnder == 2) { //
                // scored a double bogey at COURSE on hole X
                string memory logMessage = concatenateStrings("scored a double bogey at ", _courseName);
                logMessage = concatenateStrings(logMessage," on hole ");
                logMessage = concatenateStrings(logMessage, uintToString(i+1));
                emit auditMessage(msg.sender, logMessage);
            }
            if (_overUnder == -1) { //
                // scored a birdie at COURSE on hole X
                string memory logMessage = concatenateStrings("scored a birdie at ", _courseName);
                logMessage = concatenateStrings(logMessage," on hole ");
                logMessage = concatenateStrings(logMessage, uintToString(i+1));
                emit auditMessage(msg.sender, logMessage);
            }
            if (_overUnder == -2) { //
                // scored a eagle at COURSE on hole X
                string memory logMessage = concatenateStrings("scored an eagle at ", _courseName);
                logMessage = concatenateStrings(logMessage," on hole ");
                logMessage = concatenateStrings(logMessage, uintToString(i+1));
                emit auditMessage(msg.sender, logMessage);
            }
            if (_scores[i] == 1) { //
                // scored a part at COURSE on hole X
                string memory logMessage = concatenateStrings("WOW a hole in one at ", _courseName);
                logMessage = concatenateStrings(logMessage," on hole ");
                logMessage = concatenateStrings(logMessage, uintToString(i+1));
                emit auditMessage(msg.sender, logMessage);
            }
        
        }
    }

/*
    Privates (internal in solidity) go here
*/
    // tests to see if a proposed handicap is valid - in golf, you cannot have a handicap more than 54
    function isHandicapValid (uint _x) internal pure returns (bool) {
        if (_x > 54) {
            return false;
        } else {
            return true;
        }
    }
}