// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

contract DiceGame {
    address payable public player1;
    address payable public player2;
    uint public player1Stake;
    uint public player2Stake;
    uint public player1Roll;
    uint public player2Roll;
    bool public gameStarted;

    // Event declaration for logging
    event GameResult(address winner, uint amount);

    // Modifier to check if the sender is one of the players
    modifier isPlayer() {
        require(msg.sender == player1 || msg.sender == player2, "Not a player");
        _;
    }

    // Function for players to join the game by sending Ether
    function joinGame() external payable {
        require(!gameStarted, "Game already started");
        if (player1 == address(0)) {
            player1 = payable(msg.sender);
            player1Stake = msg.value;
        } else if (player2 == address(0)) {
            require(msg.value == player1Stake, "Stake must be equal");
            player2 = payable(msg.sender);
            player2Stake = msg.value;
            gameStarted = true; // Start the game when both players have joined
        } else {
            revert("Game already has two players");
        }
    }

    // Function to simulate dice roll
    // WARNING: This is not secure and is for demonstration purposes only
    function rollDice() external isPlayer {
        require(gameStarted, "Game has not started");
        if (msg.sender == player1 && player1Roll == 0) {
            player1Roll =
                (uint(
                    keccak256(abi.encodePacked(block.timestamp, msg.sender))
                ) % 6) +
                1;
        } else if (msg.sender == player2 && player2Roll == 0) {
            player2Roll =
                (uint(
                    keccak256(abi.encodePacked(block.timestamp, msg.sender))
                ) % 6) +
                1;
        }
        // Check if both players have rolled
        if (player1Roll != 0 && player2Roll != 0) {
            determineWinner();
        }
    }

    // Internal function to determine the winner and transfer stakes
    function determineWinner() internal {
        address payable winner;
        uint winningAmount = player1Stake + player2Stake;
        if (player1Roll > player2Roll) {
            winner = player1;
        } else if (player2Roll > player1Roll) {
            winner = player2;
        } else {
            // Handle draw scenario - returning stakes to both players
            player1.transfer(player1Stake);
            player2.transfer(player2Stake);
            emit GameResult(address(0), 0); // No winner
            return;
        }
        winner.transfer(winningAmount);
        emit GameResult(winner, winningAmount);
        // Reset game state
        resetGame();
    }

    // Function to reset the game for the next round
    function resetGame() internal {
        player1 = payable(address(0));
        player2 = payable(address(0));
        player1Stake = 0;
        player2Stake = 0;
        player1Roll = 0;
        player2Roll = 0;
        gameStarted = false;
    }
}
