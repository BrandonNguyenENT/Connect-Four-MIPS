.data
ROWS: .word 8
COLS: .word 8
gameBoard: .space 64               # 8x8 game board
projectTitle: .asciiz "MIPS Assembly Project - Connect 4 Game\n"
playerOneTurn: .asciiz "Player 1 (X), enter a column number (1-8): "
playerTwoTurn: .asciiz "Player 2 (O), enter a column number (1-8): "
invalidColumn: .asciiz "Invalid column. Try a different column number: "
fullColumn: .asciiz "Column is full. Try a different column number: "
winCondition: .asciiz "Player %c is the winner!\n"
drawCondition: .asciiz "The game is a draw.\n"
debugMessage: .asciiz "Game loop is running...\n"

.text

main:
    # Print game title and initialize board
    li $v0, 4
    la $a0, projectTitle
    syscall
    
    la $a0, gameBoard       # Initialize game board
    jal createBoard         # Call to create board function

    li $t0, 1               # Set current player to 1 (Player 1)
    
game_loop:
    # Debug: print to confirm game loop
    li $v0, 4
    la $a0, debugMessage
    syscall
    
    # Print the board
    la $a0, gameBoard
    jal printBoard

    # Display player prompt
    beq $t0, 1, player1_prompt
    beq $t0, 2, player2_prompt

player1_prompt:
    li $v0, 4
    la $a0, playerOneTurn
    syscall
    j get_input

player2_prompt:
    li $v0, 4
    la $a0, playerTwoTurn
    syscall

get_input:
    li $v0, 5            # Syscall to read integer input
    syscall
    move $t1, $v0        # Store column input

    # Validate column input
    li $t2, 1            # Minimum column number
    lw $t3, COLS         # Maximum column number (8)
    blt $t1, $t2, invalid_column_message
    bgt $t1, $t3, invalid_column_message

    # Adjust for zero-indexed column
    addi $t1, $t1, -1    # Convert to 0-7 for internal indexing

    # Place piece on the board
    jal placePiece
    beq $v0, -1, full_column_message   # If column is full, prompt again

    # Check for a win condition
    jal checkWin
    bne $v0, 0, win_found               # If non-zero, player has won

    # Check for a draw
    jal checkDraw
    bne $v0, 0, draw_game               # If non-zero, game is a draw

    # Switch players
    xori $t0, $t0, 3    # Toggle between 1 (Player 1) and 2 (Player 2)
    j game_loop

invalid_column_message:
    li $v0, 4
    la $a0, invalidColumn
    syscall
    j get_input

full_column_message:
    li $v0, 4
    la $a0, fullColumn
    syscall
    j get_input

win_found:
    # Print winning message for the current player
    li $v0, 4
    la $a0, winCondition
    move $a1, $t0
    syscall
    j exit

draw_game:
    # Print draw message
    li $v0, 4
    la $a0, drawCondition
    syscall
    j exit

exit:
    # Exit the program
    li $v0, 10
    syscall

# Create and initialize the game board with empty spaces
createBoard:
    lw $t2, ROWS        # Number of rows
    lw $t3, COLS        # Number of columns
    li $t4, 0           # Offset index for board array

outerLoop:
    beq $t4, 64, doneCreating   # Stop after filling 8x8 grid
    li $t5, ' '                 # Empty space character
    sb $t5, gameBoard($t4)      # Store empty space in board
    addi $t4, $t4, 1            # Move to next cell
    j outerLoop

doneCreating:
    jr $ra

# Print the game board
printBoard:
    li $t0, 0
    lw $t2, ROWS
    lw $t3, COLS
    la $a1, gameBoard

printRow:
    beq $t0, $t2, printColNumbers  # Go to column numbers after rows
    li $t1, 0                      # Reset column counter

printColumn:
    beq $t1, $t3, newlinePrint
    lb $t4, 0($a1)                 # Load cell from board
    beqz $t4, emptySpace           # If cell is 0, print '.'
    
    # Print player piece
    li $v0, 11
    move $a0, $t4
    syscall
    j printSpace

emptySpace:
    li $v0, 11
    li $a0, '.'
    syscall

printSpace:
    li $v0, 11
    li $a0, ' '
    syscall
    addi $a1, $a1, 1
    addi $t1, $t1, 1
    j printColumn

newlinePrint:
    li $v0, 11
    li $a0, 10
    syscall
    addi $t0, $t0, 1
    j printRow

printColNumbers:
    li $t0, 1
    lw $t2, COLS

printNumber:
    ble $t0, $t2, numberLoop

numberLoop:
    li $v0, 1
    move $a0, $t0
    syscall
    li $v0, 11
    li $a0, ' '
    syscall
    addi $t0, $t0, 1
    ble $t0, $t2, numberLoop

# Newline after column numbers
    li $v0, 11
    li $a0, 10
    syscall
    jr $ra

# Place piece in the chosen column
placePiece:
    la $t1, gameBoard
    li $t2, 7                       # Start from bottom row

placeLoop:
    mul $t3, $t2, 8                 # Calculate row offset
    add $t3, $t3, $t1               # Get address in gameBoard
    add $t3, $t3, $t0               # Add column offset
    lb $t4, 0($t3)                  # Load current cell

    li $t5, ' '                     # Check if empty
    bne $t4, $t5, nextRow

    # Place piece for current player
    li $t6, 'X'
    bne $t0, 1, playerTwoPiece
    sb $t6, 0($t3)
    li $v0, 0
    jr $ra

playerTwoPiece:
    li $t6, 'O'
    sb $t6, 0($t3)
    li $v0, 0
    jr $ra

nextRow:
    addi $t2, $t2, -1
    bgez $t2, placeLoop
    li $v0, -1          # Column is full
    jr $ra

checkWin:
    # Check horizontal, vertical, and diagonal for a win condition
    li $t2, -3                # Offset for horizontal check (3 columns left)
    li $t3, 3                 # Offset for horizontal check (3 columns right)
    jal checkDirectionHorizontal

    # Check vertical (top-down)
    li $t2, -3                # Offset for vertical check (3 rows up)
    li $t3, 3                 # Offset for vertical check (3 rows down)
    jal checkDirectionVertical

    # Check diagonal (top-left to bottom-right)
    li $t2, -3                # Offset for diagonal check (-3 cells up-left)
    li $t3, 3                 # Offset for diagonal check (3 cells down-right)
    jal checkDirectionDiagonal1

    # Check diagonal (top-right to bottom-left)
    li $t2, -3                # Offset for diagonal check (-3 cells up-right)
    li $t3, 3                 # Offset for diagonal check (3 cells down-left)
    jal checkDirectionDiagonal2

    # If no win, return false
    li $v0, 0
    jr $ra

# Placeholders for checking directions (implement your logic here)
checkDirectionHorizontal:
    jr $ra

checkDirectionVertical:
    jr $ra

checkDirectionDiagonal1:
    jr $ra

checkDirectionDiagonal2:
    jr $ra

checkDraw:
    la $t1, gameBoard
    li $t2, 0
    li $t3, 64             # Size of the game board

drawLoop:
    lb $t4, 0($t1)        # Check for empty spaces
    beqz $t4, notDraw      # If there's an empty space, it's not a draw
    addi $t1, $t1, 1
    addi $t2, $t2, 1
    bne $t2, $t3, drawLoop

notDraw:
    li $v0, 0
    jr $ra




