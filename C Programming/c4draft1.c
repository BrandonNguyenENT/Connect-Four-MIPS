#include <stdio.h>

#define ROWS 8
#define COLS 8

void createBoard(char board[ROWS][COLS]);
void printBoard(char board[ROWS][COLS]);

int main() {
    char board[ROWS][COLS];

    createBoard(board);

    printf("Connect 4 Board\n");
    printBoard(board);

    return 0;
}

void createBoard(char board[ROWS][COLS]) {
    int i, j;
    for (i = 0; i < ROWS; i++) {
        for (j = 0; j < COLS; j++) {
            board[i][j] = ' ';
        }
    }
}

void printBoard(char board[ROWS][COLS]) {
    int i, j;
    for (i = 0; i < ROWS; i++) {
        for ( j = 0; j < COLS; j++) {
            if (board[i][j] == ' ') {
                printf(". ");
            } else {
                printf("%c ", board[i][j]);
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

}