// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

/*
    CourseManager provides all the core functions to manage a golf course inside the CaddyShack reporting
    system on Ethereum
*/
import "./CamelFramework.sol";
contract CourseManager is CamelFramework {

 
    struct GolfCourse {
        string name;
        string description;
        uint numberOfHoles;
        uint[] pars;
    }


    mapping(string => GolfCourse) golfCourses;
    string[] golfCourseKeys;

    
    modifier golfCourseMustBeRegistered  (string memory _course) {
        require (!isCourseExtant(_course),"you have to play on a registered course");
        _;
    }

    /*
        Used to create a new GolfCourse object  
    */
    function addGolfCourse(string calldata _name, string calldata _description, uint _numberOfHoles, uint[] calldata pars) public {
        golfCourses[_name].name=_name;
        golfCourses[_name].description=_description;
        golfCourses[_name].numberOfHoles=_numberOfHoles;
        for (uint256 i=0;i<pars.length;i++) {
            golfCourses[_name].pars.push(pars[i]);
        }
        golfCourseKeys.push(_name);
    }

     

    /*
        Returns a set of arrays which comprise all the courses' information.   Kind of hokey since compound objects
        are not well supported in Solidity.
    */
    function getGolfCourses() public view returns(string[] memory, string[] memory, uint[] memory) {
        string[] memory _keys = new string[](golfCourseKeys.length);
        string[] memory _names = new string[](golfCourseKeys.length);
        uint[] memory _holes = new uint[](golfCourseKeys.length);

        for (uint256 i=0; i< golfCourseKeys.length; i++) {
            _keys[i] = golfCourseKeys[i];
            GolfCourse memory x = golfCourses[golfCourseKeys[i]];
            _names[i] = x.description ;
            _holes[i] = x.numberOfHoles;
        }
        return (_keys,_names,_holes);
    }



    function deleteCourse(string calldata _courseName) public  {
       golfCourses[_courseName].name="";
       // update the key array
       for (uint i = 0; i < golfCourseKeys.length; i++) {
            if (keccak256(abi.encodePacked(golfCourseKeys[i])) == keccak256(abi.encodePacked(_courseName))) {
                // If the value matches, remove it by shifting the remaining elements
                for (uint j = i; j < golfCourseKeys.length - 1; j++) {
                    golfCourseKeys[j] = golfCourseKeys[j+1];
                }
                golfCourseKeys.pop(); // Remove the last element (duplicate of the one to be deleted)
                break;
            }
        }
    }
    
    function isCourseExtant(string memory _courseName) public view returns(bool) {
      GolfCourse storage x = golfCourses[_courseName];  

      /* 
      this is a fun around the elbow, due to solidity limitations:   First resolving a mapping 
      always returns an object even if the key is not really extant (you get a null object).  Second, you
      cant compare strings but you can compare hashs, so we hash the two strings!   
      */
      return keccak256(abi.encodePacked("")) == keccak256(abi.encodePacked(x.name));
    }
    

}
