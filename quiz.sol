// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

contract QuizContract {
    struct Question {
        string questionText;
        bool isActive;
    }

    address public owner;

    // Store questions and answers
    mapping(uint => Question) public questions;
    mapping(uint => string) public correctAnswers;

    uint public questionCount;

    // Event for correct answers
    event CorrectAnswer(address participant, uint reward);

    constructor() {
        owner = msg.sender;
    }

    // Function to add a new question
    function addQuestion(string memory _questionText, string memory _correctAnswer) public {
        require(msg.sender == owner, "Only the owner can add questions");
        questionCount++;
        questions[questionCount] = Question({
            questionText: _questionText,
            isActive: true
        });
        correctAnswers[questionCount] = _correctAnswer;
    }

    // Function to activate a question
    function activateQuestion(uint _questionIndex) public {
        require(msg.sender == owner, "Only the owner can activate questions");
        require(_questionIndex > 0 && _questionIndex <= questionCount, "Invalid question index");
        questions[_questionIndex].isActive = true;
    }

    // Function to deactivate a question
    function deactivateQuestion(uint _questionIndex) public {
        require(msg.sender == owner, "Only the owner can deactivate questions");
        require(_questionIndex > 0 && _questionIndex <= questionCount, "Invalid question index");
        questions[_questionIndex].isActive = false;
    }

    // Function to update the correct answer for a question
    function updateCorrectAnswer(uint _questionIndex, string memory _newCorrectAnswer) public {
        require(msg.sender == owner, "Only the owner can update the correct answer");
        require(_questionIndex > 0 && _questionIndex <= questionCount, "Invalid question index");
        correctAnswers[_questionIndex] = _newCorrectAnswer;
    }

    // Function to answer a question
    function answerQuiz(uint _questionIndex, string memory _answer) public {
        require(_questionIndex > 0 && _questionIndex <= questionCount, "Invalid question index");
        require(questions[_questionIndex].isActive, "This question is not active");

        // Check the provided answer
        if (keccak256(abi.encodePacked(_answer)) == keccak256(abi.encodePacked(correctAnswers[_questionIndex]))) {
            uint reward = 0.01 ether;
            require(address(this).balance >= reward, "Insufficient funds in the contract");
            payable(msg.sender).transfer(reward);
            emit CorrectAnswer(msg.sender, reward);
        }
    }

    // Function to fund the contract
    function fundContract() public payable {}

    // Function to withdraw funds from the contract
    function withdraw(uint _amount) public {
        require(msg.sender == owner, "Only the owner can withdraw");
        require(address(this).balance >= _amount, "Insufficient balance in the contract");
        payable(owner).transfer(_amount);
    }

    // Function to get the total number of questions
    function getTotalQuestions() public view returns (uint) {
        return questionCount;
    }

    // Function to get the current balance of the contract
    function getCurrentBalance() public view returns (uint) {
        return address(this).balance;
    }
}
