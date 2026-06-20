#include <stdio.h>
#include <stdlib.h>

#define ROWS 8
#define COLS 8

void createBoard(char gameBoard[ROWS][COLS]);
void printBoard(char gameBoard[ROWS][COLS]);
int displayPiece(char gameBoard[ROWS][COLS], int column, char player);

int main() {
    char gameBoard[ROWS][COLS];
    int column, piecePlace;
    char turnPlayer = '1';


    createBoard(gameBoard);

    printf("Connect 4 C Program Second Version\n");
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