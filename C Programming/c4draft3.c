#include <stdio.h>
#include <stdlib.h>

#define ROWS 8
#define COLS 8

void createBoard(char gameBoard[ROWS][COLS]);
void printBoard(char gameBoard[ROWS][COLS]);
int displayPiece(char gameBoard[ROWS][COLS], int column, char player);
int winCondition(char gameBoard[ROWS][COLS], char player);
int drawCondition(char gameBoard[ROWS][COLS]);


int main() {
    char gameBoard[ROWS][COLS];
    int column, piecePlace, winner;
    char turnPlayer = '1';


    createBoard(gameBoard);

    printf("Connect 4 Fully Functioning C Program - Third Draft\n");
    printBoard(gameBoard);


        
        while (1) {
        
        printf("Player %c, enter a column number to display your piece: ", turnPlayer, COLS);
        scanf("%d", &column);
        

        if (column < 1 || column > COLS) {
            printf("Error, try a different column number\n");
            continue;
        }


        piecePlace = displayPiece(gameBoard, column - 1, turnPlayer);
        if (piecePlace == 0) {
            printf("Column is full. Please try a different column number.\n");
            continue;
        }


        printBoard(gameBoard);


        winner = winCondition(gameBoard, turnPlayer);
        if (winner) {
            printf("Player %c is the winner.\n", turnPlayer);
            break;
        }

        if (drawCondition(gameBoard)) {
            printf("Game is a Draw.\n");
            break;
        }

        if (turnPlayer == '1') {
                turnPlayer = '2';
        }
            else {
            turnPlayer = '1';
        }

    }

    return 0;
}


void createBoard(char gameBoard[ROWS][COLS]) {
    int i, j;
    for (i = 0; i < ROWS; i++) {
        for (j = 0; j < COLS; j++) {
            gameBoard[i][j] = ' ';
        }
    }
}

void printBoard(char gameBoard[ROWS][COLS]) {
    int i, j;
    for (i = 0; i < ROWS; i++) {
        for ( j = 0; j < COLS; j++) {
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


int displayPiece(char gameBoard[ROWS][COLS], int column, char player) {
    for (int i = ROWS - 1; i >= 0; i--) {
        if (gameBoard[i][column] == ' ') {
            gameBoard[i][column] = player;
            return 1;
        }
    }
    return 0;

}

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

int drawCondition(char gameBoard[ROWS][COLS]) {
    for (int j = 0; j < COLS; j++) {
        if (gameBoard[0][j] == ' ')
            return 0;
    }
    return 1;

}