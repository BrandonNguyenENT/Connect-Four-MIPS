
#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define ROWS 8
#define COLS 8

void createBoard(char gameBoard[ROWS][COLS]);
void printBoard(char gameBoard[ROWS][COLS]);
int displayPiece(char gameBoard[ROWS][COLS], int column, char player);
int winCondition(char gameBoard[ROWS][COLS], char player);
int drawCondition(char gameBoard[ROWS][COLS]);
int rollDice();

int main() {
    char gameBoard[ROWS][COLS];
    int column, piecePlace, winner, diceRoll;
    char turnPlayer;
    
    // Initialize random seed for dice rolls
    srand(time(0));

    createBoard(gameBoard);

    printf("Connect 4 Fully Functioning C Program - Dice Roll Mechanic Added\n");
    printBoard(gameBoard);

    while (1) {
        // Roll the dice to decide which player goes
        diceRoll = rollDice();
        if (diceRoll % 2 == 1) {
            turnPlayer = '1';  // Player 1 gets odd dice rolls
        } else {
            turnPlayer = '2';  // Player 2 gets even dice rolls
        }
        
        printf("Dice rolled: %d. It's Player %c's turn.\n", diceRoll, turnPlayer);

        // Get the column choice from the player
        printf("Player %c, enter a column number to display your piece: ", turnPlayer);
        scanf("%d", &column);

        // Check if column is valid
        if (column < 1 || column > COLS) {
            printf("Error, try a different column number\n");
            continue;
        }

        // Try to place the piece
        piecePlace = displayPiece(gameBoard, column - 1, turnPlayer);
        if (piecePlace == 0) {
            printf("Column is full. Please try a different column number.\n");
            continue;
        }

        // Display the board after the move
        printBoard(gameBoard);

        // Check for a win
        winner = winCondition(gameBoard, turnPlayer);
        if (winner) {
            printf("Player %c is the winner.\n", turnPlayer);
            break;
        }

        // Check for a draw
        if (drawCondition(gameBoard)) {
            printf("Game is a draw.\n");
            break;
        }
    }

    return 0;
}

// Create the game board
void createBoard(char gameBoard[ROWS][COLS]) {
    int i, j;
    for (i = 0; i < ROWS; i++) {
        for (j = 0; j < COLS; j++) {
            gameBoard[i][j] = ' ';
        }
    }
}

// Print the game board
void printBoard(char gameBoard[ROWS][COLS]) {
    int i, j;
    for (i = 0; i < ROWS; i++) {
        for (j = 0; j < COLS; j++) {
            if (gameBoard[i][j] == ' ') {
                printf(". ");
            } else {
                printf("%c ", gameBoard[i][j]);
            }
        }
        printf("\n");
    }

    for (j = 0; j < COLS; j++) {
        printf("--");
    }
    printf("\n");

    for (j = 1; j <= COLS; j++) {
        printf("%d ", j);
    }

    printf("\n\n");
}

// Place the piece in the selected column
int displayPiece(char gameBoard[ROWS][COLS], int column, char player) {
    for (int i = ROWS - 1; i >= 0; i--) {
        if (gameBoard[i][column] == ' ') {
            gameBoard[i][column] = player;
            return 1;
        }
    }
    return 0;
}

// Check win condition
int winCondition(char gameBoard[ROWS][COLS], char player) {
    for (int i = 0; i < ROWS; i++) {
        for (int j = 0; j < COLS; j++) {
            if (j <= COLS - 4 && gameBoard[i][j] == player && gameBoard[i][j + 1] == player &&
                gameBoard[i][j + 2] == player && gameBoard[i][j + 3] == player)
                return 1;
            if (i <= ROWS - 4 && gameBoard[i][j] == player && gameBoard[i + 1][j] == player &&
                gameBoard[i + 2][j] == player && gameBoard[i + 3][j] == player)
                return 1;
            if (i <= ROWS - 4 && j <= COLS - 4 && gameBoard[i][j] == player &&
                gameBoard[i + 1][j + 1] == player && gameBoard[i + 2][j + 2] == player &&
                gameBoard[i + 3][j + 3] == player)
                return 1;
            if (i >= 3 && j <= COLS - 4 && gameBoard[i][j] == player &&
                gameBoard[i - 1][j + 1] == player && gameBoard[i - 2][j + 2] == player &&
                gameBoard[i - 3][j + 3] == player)
                return 1;
        }
    }
    return 0;
}

// Check for a draw
int drawCondition(char gameBoard[ROWS][COLS]) {
    for (int j = 0; j < COLS; j++) {
        if (gameBoard[0][j] == ' ')
            return 0;
    }
    return 1;
}

// Simulate a dice roll (1-6)
int rollDice() {
    return rand() % 6 + 1;  // Returns a random number between 1 and 6
}