// SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.7.0 <0.9.0;

contract CrowdFunding {
	// Possible states of the fundraising campaign
    enum FundraisingState {
        Opened,
        Closed
    }

    // Structure representing a project
    struct Project {
        string id;
        string name;
        string description;
        address payable author;
        FundraisingState state;
        uint256 funds;
        uint256 fundraisingGoal;
    }

	// Instance of the project
    Project public project;

	// Events
    event ProjectFunded(string projectId, uint256 value);

    event ProjectStateChanged(string id, FundraisingState state);

	// Constructor
    constructor(
        string memory _id,
        string memory _name,
        string memory _description,
        uint256 _fundraisingGoal
    ) {
        project = Project(
            _id,
            _name,
            _description,
            payable(msg.sender),
            FundraisingState.Opened,
            0,
            _fundraisingGoal
        );
    }

	// Modifiers
    modifier isAuthor() {
        require(
            project.author == msg.sender,
            "You need to be the project author"
        );
        _;
    }

    modifier isNotAuthor() {
        require(
            project.author != msg.sender,
            "As author you can not fund your own project"
        );
        _;
    }

	modifier isFundraisingOpen() {
        require(
            project.state == FundraisingState.Opened,
            "The project is not open for funding"
        );
        _;
    }

	// Function to fund the project
    function fundProject() public payable isNotAuthor {
        require(
            project.state != FundraisingState.Closed,
            "The project can not receive funds"
        );
        require(msg.value > 0, "Fund value must be greater than 0");
        project.author.transfer(msg.value);
        project.funds += msg.value;
        emit ProjectFunded(project.id, msg.value);
    }

	// Function to change the project state
    function changeProjectState(FundraisingState newState) public isAuthor {
        require(project.state != newState, "New state must be different");
        project.state = newState;
        emit ProjectStateChanged(project.id, newState);
    }

	// Function to withdraw funds if the goal is not reached
	function withdrawFunds() public isAuthor {
        require(project.state == FundraisingState.Closed, "Project must be closed to withdraw funds");
        require(project.funds < project.fundraisingGoal, "Cannot withdraw funds, goal reached");
        
        uint256 amount = project.funds;
        project.funds = 0;
        project.author.transfer(amount);
    }
}
