.data
ROWS: .word 8
COLS: .word 8
gameBoard: .space 64
projectTitle:  .asciiz "MIPS Assembly Project Version 1 - Gameboard\n"
diceRoll:  .asciiz "Dice rolled: %d. It's Player %c's turn.\n"
piecePlacement: .asciiz "Player %c, enter a column number to display your piece: "
invalidColumn:  .asciiz "Error, try a different column number\n"
fullColumn: .asciiz "Column is full. Please try a different column number.\n"
winCondition: .asciiz "Player %c is the winner.\n"
drawCondition: .asciiz "Game is a Draw.\n"

.text

# Initialize variables
li      $t0, 0              # Row index (unused)
li      $t1, 0              # Column index (unused)
la      $a0, gameBoard      # Load address of gameBoard

# Set initial player to Player 1
li      $t7, 1              # Player 1 starts

# Create the board
createBoard:
    lw      $t2, ROWS        # Load number of rows
    lw      $t3, COLS        # Load number of columns

outer_loop:
    beq     $t0, $t2, printTitle  # If row index equals ROWS, print title
    li      $t1, 0              # Reset column index for new row

inner_loop:
    beq     $t1, $t3, createBoard_next_row  # If column index equals COLS, go to next row
    li      $t4, ' '             # Set character to space
    sb      $t4, 0($a0)          # Store space in gameBoard
    addi    $a0, $a0, 1          # Move to the next byte in gameBoard
    addi    $t1, $t1, 1          # Increment column index
    j       inner_loop           # Repeat inner loop

createBoard_next_row:
    addi    $t0, $t0, 1          # Increment row index
    j       outer_loop           # Repeat outer loop

printTitle:
    li      $v0, 4              # Print string syscall
    la      $a0, projectTitle    # Load project title
    syscall

# Print the board
    la      $a0, gameBoard      # Load address of gameBoard
    jal     printBoard           # Call printBoard

# Print board function
printBoard:
    li      $t0, 0              # Row index
    lw      $t2, ROWS           # Load number of rows
    lw      $t3, COLS           # Load number of columns
    la      $a1, gameBoard      # Load address of gameBoard

print_outer_loop:
    beq     $t0, $t2, print_numbers  # If row index equals ROWS, print column numbers
    li      $t1, 0                  # Column index

print_inner_loop:
    beq     $t1, $t3, print_newline  # If column index equals COLS, print newline
    lb      $t4, 0($a1)              # Load character from gameBoard
    beq     $t4, ' ', print_dot       # If character is space, print dot
    li      $v0, 11                   # Print character syscall
    move    $a0, $t4                  # Move character to $a0
    syscall
    j       print_space

print_dot:
    li      $v0, 11                   # Print dot
    li      $a0, '.'                  # ASCII for dot
    syscall

print_space:
    li      $v0, 11                   # Print space
    li      $a0, ' '                  # ASCII for space
    syscall
    addi    $a1, $a1, 1               # Move to the next character in gameBoard
    addi    $t1, $t1, 1               # Increment column index
    j       print_inner_loop           # Repeat inner loop
    
print_newline:
    li      $v0, 11                   # Print newline
    li      $a0, 10                   # ASCII for newline
    syscall
    addi    $t0, $t0, 1               # Increment row index
    j       print_outer_loop           # Repeat outer loop

# Prints the Row of Column Numbers
print_numbers:
    li      $t0, 1                    # Start column number
    lw      $t2, COLS                  # Load maximum columns

print_col:
    ble     $t0, $t2, print_number     # If column number <= maximum columns

print_number:
    li      $v0, 1                    # Print integer syscall
    move    $a0, $t0                  # Move column number to $a0
    syscall
    li      $v0, 11                   # Print space
    li      $a0, ' '                  # ASCII for space
    syscall
    addi    $t0, $t0, 1               # Increment column number
    ble     $t0, $t2, print_col       # If still in range, print next column

    # After printing the column numbers, add a newline
    li      $v0, 11
    li      $a0, 10                   # ASCII newline character
    syscall

    j       ask_for_input             # Ask for input from the player

# New Section: Ask for Player Input
ask_for_input:
    li      $v0, 4                   # Print prompt message
    la      $a0, piecePlacement
    syscall

    # Display the current player (1 or 2)
    move    $a0, $t7                 # Move current player to $a0
    li      $v0, 11                   # Print character syscall
    syscall

    # Read player input for column
    li      $v0, 5                   # Read integer syscall
    syscall
    move    $t0, $v0                 # Store column input into $t0

    # Validate the column input
    li      $t1, 1                   # Minimum column (1)
    bge     $t0, $t1, check_max_col  # If column >= 1, check upper bound
    j       invalid_column_label

check_max_col:
    lw      $t1, COLS                # Load maximum column (COLS)
    ble     $t0, $t1, place_piece     # If column <= COLS, place piece
    j       invalid_column_label

# Handle invalid column input
invalid_column_label:
    li      $v0, 4                   # Print error message
    la      $a0, invalidColumn
    syscall
    j       main_loop                 # Restart input loop

# Place piece logic
place_piece:
    addi    $t0, $t0, -1              # Adjust column input (0-based index)
    la      $t1, gameBoard            # Load base address of gameBoard
    li      $t2, 7                    # Start at the bottom row (ROWS - 1)

place_piece_loop:
    mul     $t3, $t2, 8                # t3 = row index * COLS
    add     $t3, $t3, $t0              # t3 = (row * COLS) + column
    add     $t3, $t1, $t3              # Address of gameBoard[row][column]
    lb      $t4, 0($t3)                # Load current value in the cell

    li      $t5, ' '                   # ASCII for space
    bne     $t4, $t5, place_piece_next_row  # If not empty, check the next row

    # Choose piece based on the player
    beq     $t7, 1, player1_piece      # If player is 1, place 'X'
    li      $t6, 'O'                   # Player 2 gets 'O'
    j       place_piece_done

player1_piece:
    li      $t6, 'X'                   # Player 1 gets 'X'

place_piece_done:
    sb      $t6, 0($t3)                # Place the piece
    j       print_and_loop              # Go to print board

place_piece_next_row:                   # Renamed label to avoid conflict
    addi    $t2, $t2, -1               # Move to the row above
    bge     $t2, 0, place_piece_loop   # If not at the top row, continue loop

    li      $v0, 4                     # Print full column message
    la      $a0, fullColumn
    syscall
    j       main_loop                   # Restart input loop

print_and_loop:
    # Print the board after placing the piece
    la      $a0, gameBoard
    jal     printBoard

    # Alternate player turns
    beq     $t7, 1, set_player2       # If current player is 1, switch to 2
    li      $t7, 1                    # Else switch to player 1
    j       main_loop

set_player2:
    li      $t7, 2                    # Set to player 2
    j       main_loop

main_loop: 
    j       ask_for_input              # Go back to ask for player input

# End Draft 1
    li      $v0, 10                    # Exit program
    syscall

# NEXT SECTION

.data
ROWS: .word 8
COLS: .word 8
gameBoard: .space 64
projectTitle: .asciiz "MIPS Assembly Project Version 2 - Piece Placement\n"
diceRoll: .asciiz "Dice rolled: %d. It's Player %d's turn.\n"
playerOneTurn: .asciiz "Player 1, enter a column number to place your piece: "
playerTwoTurn: .asciiz "Player 2, enter a column number to place your piece: "
invalidColumn: .asciiz "Error, try a different column number "
fullColumn: .asciiz "Column is full. Please try a different column number: "
winCondition: .asciiz "Player %d is the winner.\n"
drawCondition: .asciiz "Game is a Draw.\n"

.text

# Initialize the game board with empty spaces
initializeBoard:
    li      $t0, 0
    la      $a0, gameBoard
    lw      $t1, ROWS
    lw      $t2, COLS

fillBoard:
    beq     $t0, $t1, printTitle
    li      $t3, 0

fillRow:
    beq     $t3, $t2, nextRow
    li      $t4, ' '
    sb      $t4, 0($a0)
    addi    $a0, $a0, 1
    addi    $t3, $t3, 1
    j       fillRow

nextRow:
    addi    $t0, $t0, 1
    j       fillBoard

printTitle:
    li      $v0, 4
    la      $a0, projectTitle
    syscall
    jal     printBoard
    j       mainGameLoop

# Function to print the board
printBoard:
    li      $t0, 0
    lw      $t1, ROWS
    lw      $t2, COLS
    la      $a1, gameBoard

printRows:
    beq     $t0, $t1, printColNumbers
    li      $t3, 0

printRowElements:
    beq     $t3, $t2, printNewline
    lb      $t4, 0($a1)
    li      $v0, 11
    beq     $t4, ' ', printDot
    move    $a0, $t4
    syscall
    j       printSpace

printDot:
    li      $a0, '.'
    syscall

printSpace:
    li      $a0, ' '
    syscall
    addi    $a1, $a1, 1
    addi    $t3, $t3, 1
    j       printRowElements

printNewline:
    li      $a0, 10
    syscall
    addi    $t0, $t0, 1
    j       printRows

printColNumbers:
    li      $t0, 1
    lw      $t1, COLS

printColumnNum:
    ble     $t0, $t1, outputNumber

outputNumber:
    li      $v0, 1
    move    $a0, $t0
    syscall
    li      $v0, 11
    li      $a0, ' '
    syscall
    addi    $t0, $t0, 1
    ble     $t0, $t1, printColumnNum

    # Newline after column numbers
    li      $a0, 10
    syscall
    jr      $ra

# Begin Main Game Loop with Dice Roll
mainGameLoop:
    jal     rollDice
    jal     inputAndTurn
    j       mainLoop

# Random Dice Roll for Turn Assignment
rollDice:
    li      $v0, 42                  # Syscall for generating a random integer
    li      $a0, 6                   # Generate random number from 0 to 5
    syscall
    addi    $v0, $v0, 1              # Adjust result to range from 1 to 6
    move    $t6, $v0                 # Store the random number (dice roll) in $t6

    # Determine player based on odd/even value of dice roll
    andi    $t7, $t6, 1              # Check if odd or even
    beq     $t7, 0, setPlayerTwo     # Even roll -> Player 2
    li      $t7, 1                   # Odd roll -> Player 1
    j       printDiceRoll

setPlayerTwo:
    li      $t7, 2                   # Set $t7 to 2 for Player 2

printDiceRoll:
    # Print the dice roll and player turn
    li      $v0, 4
    la      $a0, diceRoll
    syscall
    li      $v0, 1
    move    $a0, $t6                 # Display dice roll number
    syscall
    li      $v0, 1
    move    $a0, $t7                 # Display current player number
    syscall
    jr      $ra

# Player Turn and Input
inputAndTurn:
    beq     $t7, 1, playerOnePrompt
    beq     $t7, 2, playerTwoPrompt
    j       mainLoop

playerOnePrompt:
    li      $v0, 4
    la      $a0, playerOneTurn
    syscall
    jr      $ra

playerTwoPrompt:
    li      $v0, 4
    la      $a0, playerTwoTurn
    syscall
    jr      $ra

# Reads Column Number Input
mainLoop:
    li      $v0, 5
    syscall
    move    $t0, $v0

    # Check if input is within bounds
    li      $t1, 1
    bge     $t0, $t1, maxColCheck
    j       invalidColumnMessage

maxColCheck:
    lw      $t1, COLS
    ble     $t0, $t1, placePiece
    j       invalidColumnMessage

invalidColumnMessage:
    li      $v0, 4
    la      $a0, invalidColumn
    syscall
    j       mainLoop

# Place Piece Logic
placePiece:
    addi    $t0, $t0, -1             # Adjust column for 0-indexed array
    la      $t1, gameBoard
    li      $t2, 7                   # Start at the bottom row

placePieceLoop:
    mul     $t3, $t2, 8              # Calculate row offset
    add     $t3, $t3, $t0            # Add column offset
    add     $t3, $t1, $t3            # Address of selected cell
    lb      $t4, 0($t3)

    li      $t5, ' '                 # Check if cell is empty
    bne     $t4, $t5, placePieceNextRow

    # Place 'X' for Player 1, 'O' for Player 2
    li      $t6, 'X'
    beq     $t7, 2, placeO
    sb      $t6, 0($t3)
    j       switchTurn

placeO:
    li      $t6, 'O'
    sb      $t6, 0($t3)
    j       switchTurn

placePieceNextRow:
    addi    $t2, $t2, -1             # Move up to the next row
    bgez    $t2, placePieceLoop      # Repeat if not at the top row
    j       fullColumnMessage

fullColumnMessage:
    li      $v0, 4
    la      $a0, fullColumn
    syscall
    j       mainLoop

# Print Updated Gameboard and Switch Turn
switchTurn:
    jal     printBoard
    xor     $t7, $t7, 3              # Toggle $t7 between 1 and 2 for the next player
    j       mainGameLoop

# End of Program
endProgram:
    li      $v0, 10
    syscall