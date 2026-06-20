# Author: Brandon Nguyen, 827813045
# Final Project - Connect 4 w/Turn Based Dice Roll
# COMPE 271


.data
ROWS: .word 8
COLS: .word 8
gameBoard: .space 64
projectTitle:  .asciiz	"MIPS Assembly Project - Connect 4\n"
diceRoll:  .asciiz "Dice rolled: " 
playerOneTurn:	.asciiz	"\nPlayer 1, enter a column number to display your piece: "
playerTwoTurn:	.asciiz	"\nPlayer 2, enter a column number to display your piece: "
invalidColumn:	.asciiz	"Error, try a different column number "
fullColumn:	.asciiz	"Column is full. Please try a different column number: "
winCondition1:	.asciiz	"Player 1 is the winner." 
winCondition2:	.asciiz	"Player 2 is the winner."
drawCondition:	.asciiz	"Game is a Draw."


.text


#Part 1 - MAIN LOOPS
# MAIN
# Initialize variables
li      $t0, 0               # Initialize $t0 (row counter) to 0.
li      $t1, 0               # Initialize $t1 (column counter) to 0.
la      $a0, gameBoard       # Load the address of the game board into $a0.
li      $t7, 1               # Initialize $t7 to 1, representing Player 1's turn.

# Create the board
createBoard:
    lw      $t2, ROWS           # Load the number of rows into $t2.
    lw      $t3, COLS           # Load the number of columns into $t3.

outerLoop:
    beq     $t0, $t2, printTitle  # If all rows are processed, jump to printTitle.
    li      $t1, 0               # Reset column counter $t1 to 0.

innerLoop:
    beq     $t1, $t3, createBoardRows # If all columns in the current row are processed, jump to createBoardRows.
    li      $t4, ' '             # Load a space character into $t4.
    sb      $t4, 0($a0)          # Store the space character at the current address of $a0.
    addi    $a0, $a0, 1          # Move to the next memory address in the game board.
    addi    $t1, $t1, 1          # Increment column counter $t1.
    j       innerLoop            # Repeat the inner loop.

createBoardRows:
    addi    $t0, $t0, 1          # Increment row counter $t0.
    j       outerLoop            # Repeat the outer loop.

printTitle:
    li      $v0, 4               # Set syscall for printing a string.
    la      $a0, projectTitle    # Load the address of the project title string.
    syscall                      # Print the project title.

# Print the board
    la      $a0, gameBoard       # Reload the address of the game board into $a0.
    jal     printBoard           # Jump to the printBoard function.

# Print board function
printBoard:
    li      $t0, 0               # Initialize row counter $t0 to 0.
    lw      $t2, ROWS            # Load the number of rows into $t2.
    lw      $t3, COLS            # Load the number of columns into $t3.
    la      $a1, gameBoard       # Load the address of the game board into $a1.

outerLoopPrint:
    beq     $t0, $t2, numbersPrint # If all rows are printed, jump to numbersPrint.
    li      $t1, 0                  # Reset column counter $t1 to 0.

innerLoopPrint:
    beq     $t1, $t3, newlinePrint  # If all columns in the current row are printed, jump to newlinePrint.
    lb      $t4, 0($a1)             # Load the current cell's value into $t4.
    beq     $t4, ' ', dotPrint      # If the cell is empty (space), jump to dotPrint.
    li      $v0, 11                 # Set syscall for printing a character.
    move    $a0, $t4                # Move the cell's value to $a0.
    syscall                         # Print the cell's value.
    j       spacePrint              # Jump to spacePrint.

dotPrint:
    li      $v0, 11                 # Set syscall for printing a character.
    li      $a0, '.'                # Load '.' into $a0.
    syscall                         # Print '.'.

spacePrint:
    li      $v0, 11                 # Set syscall for printing a character.
    li      $a0, ' '                # Load a space into $a0.
    syscall                         # Print the space.
    addi    $a1, $a1, 1             # Move to the next cell in the game board.
    addi    $t1, $t1, 1             # Increment column counter $t1.
    j       innerLoopPrint          # Repeat the inner loop.

newlinePrint:
    li      $v0, 11                 # Set syscall for printing a character.
    li      $a0, 10                 # Load newline character into $a0.
    syscall                         # Print newline.
    addi    $t0, $t0, 1             # Increment row counter $t0.
    j       outerLoopPrint          # Repeat the outer loop.

# Print the row of column numbers
numbersPrint:
    li      $t0, 1                  # Initialize column number to 1.
    lw      $t2, COLS               # Load the number of columns into $t2.

ColPrint:
    ble     $t0, $t2, printNumber   # If $t0 is less than or equal to the column count, jump to printNumber.

printNumber:
    li      $v0, 1                  # Set syscall for printing an integer.
    move    $a0, $t0                # Move the column number to $a0.
    syscall                         # Print the column number.
    li      $v0, 11                 # Set syscall for printing a character.
    li      $a0, ' '                # Load a space into $a0.
    syscall                         # Print the space.
    addi    $t0, $t0, 1             # Increment the column number.
    ble     $t0, $t2, ColPrint      # Repeat if there are more columns to print.

# Print a newline
    li      $v0, 11
    li      $a0, 10                 # Load newline character into $a0.
    syscall                         # Print newline.

# Main logic: Call functions for board checks
    jal     checkDraw               # Check if the game is a draw.
# Parent (Main Loops) to Children


# DICE ROLL FUNCTION
printdiceRoll: #Parent

    li      $v0, 4                
    la      $a0, diceRoll
    syscall

    # Generate a random number from 1 to 6
    li      $a1, 6               # Set the maximum random number (6)
    li      $v0, 42              # RANDOM NUMBER GENERATOR FUNCTION
    syscall
    addi    $a0, $a0, 1          
    
    # Print the random number
    li      $v0, 1               
    move    $a0, $a0             
    syscall

 # Check if the random number is odd or even - turn based dependent feature
    andi    $t0, $a0, 1          # $t0 = random number AND 1
    beq     $t0, 0, setPlayerTwoTurn  # If even, go to Player 2's turn
    j       setPlayerOneTurn           # If odd, go to Player 1's turn

setPlayerOneTurn:
    li      $t7, 1               # Set $t7 to 1 (Player 1's turn)
    j       inputAndTurn        

setPlayerTwoTurn:
    li      $t7, 2               # Set $t7 to 2 (Player 2's turn)
    j       inputAndTurn        


# Part 2 - Piece Placement


inputAndTurn: # Checks which player's turn it is
    li      $v0, 4                # Set syscall for printing a string.
    beq     $t7, 1, p1turn        # If $t7 is 1 (Player 1's turn), jump to p1turn.
    j       p2turn                # Otherwise, jump to p2turn.

p1turn:
   la       $a0, playerOneTurn    # Load the address of the Player 1's turn message.
   syscall                        # Print the Player 1's turn message.
   j       mainLoop               # Jump to the main game loop.

p2turn:
   la       $a0, playerTwoTurn    # Load the address of the Player 2's turn message.
   syscall                        # Print the Player 2's turn message.
   j       mainLoop               # Jump to the main game loop.

# Reads Column Number Input
mainLoop:
    li      $v0, 5                # Set syscall for reading an integer input.
    syscall                       # Read user input and store it in $v0.
    move    $t0, $v0              # Move the input value to $t0 for processing.

    li      $t1, 1                # Load the minimum column number (1) into $t1.
    bge     $t0, $t1, maxColCheck # If the input is >= 1, jump to maxColCheck.
    j       invalidColumnMessage  # Otherwise, jump to invalidColumnMessage.

maxColCheck:
    lw      $t1, COLS             # Load the maximum column number into $t1.
    ble     $t0, $t1, placePiece  # If the input is <= max column, jump to placePiece.
    j       invalidColumnMessage  # Otherwise, jump to invalidColumnMessage.

# Invalid Column Logic Check
invalidColumnMessage:
    li      $v0, 4                # Set syscall for printing a string.
    la      $a0, invalidColumn    # Load the address of the invalid column message.
    syscall                       # Print the invalid column message.
    j       inputAndTurn          # Restart the turn.

# Placing a Piece
placePiece:
    addi    $t0, $t0, -1          # Convert the column number to a zero-based index.
    la      $t1, gameBoard        # Load the address of the game board into $t1.
    li      $t2, 7                # Set the row index to the bottom row (7).

placePieceLoop:
    mul     $t3, $t2, 8           # Calculate the row's base address (row index * 8 columns).
    add     $t3, $t3, $t0         # Add the column offset to get the cell's address.
    add     $t3, $t1, $t3         # Add the base game board address to get the absolute address.
    lb      $t4, 0($t3)           # Load the value at the calculated cell address.

    li      $t5, ' '              # Load a space character into $t5.
    bne     $t4, $t5, placePieceNextRow # If the cell is not empty, jump to placePieceNextRow.
    beq     $t7, 1, PlayerOnePlace # If it's Player 1's turn, jump to PlayerOnePlace.
    j       PlayerTwoPlace        # Otherwise, jump to PlayerTwoPlace.

PlayerOnePlace: # Player 1 places a piece
    li      $t6, '1'              # Load '1' (Player 1's piece) into $t6.
    sb      $t6, 0($t3)           # Store the piece at the calculated cell address.
  
                    # Play Player 1's sound - SOUND 1

li $v0, 31 
la $t0, 60
la $t1, 100
la $t2, 4
la $t3, 127
move $a0, $t0 
move $a1, $t1 
move $a2, $t2
move $a3, $t3 
syscall 
    
    
    li      $t7, 2                # Set the turn to Player 2.
    j       printAndLoop          # Jump to printAndLoop.


PlayerTwoPlace: # Player 2 places a piece
    li      $t6, '2'              # Load '2' (Player 2's piece) into $t6.
    sb      $t6, 0($t3)           # Store the piece at the calculated cell address.
    
            # Play Player 2's sound - SOUND 2
li $v0, 31 
la $t0, 69
la $t1, 100
la $t2, 58
la $t3, 127
move $a0, $t0 
move $a1, $t1 
move $a2, $t2
move $a3, $t3 
syscall 
    
    li      $t7, 1                # Set the turn to Player 1.
    j       printAndLoop          # Jump to printAndLoop.

placePieceNextRow:
    addi    $t2, $t2, -1          # Move to the row above.
    bgez    $t2, placePieceLoop   # If the row index is >= 0, repeat the loop.
    j       fullColumnMessage     # If all rows are full, jump to fullColumnMessage.

# Full Column Logic Check
fullColumnMessage:
    li      $v0, 4                # Set syscall for printing a string.
    la      $a0, fullColumn       # Load the address of the full column message.
    syscall                       # Print the full column message.
    j       inputAndTurn          # Restart the turn.

# Print Updated Gameboard
printAndLoop:
    jal     printBoard            # Call the function to print the updated game board.
    j       inputAndTurn          # Restart the turn.
                        

# Part 3 - Win/Draw Condition Logic

#Draw Condition - FIX/DEBUG if Necessary
checkDraw:
    la      $t0, gameBoard       
    lw      $t1, ROWS           
    lw      $t2, COLS           
    mul     $t1, $t1, $t2       
    li      $t3, 0              

drawCheckLoop:
    lb      $t4, 0($t0)         
    li      $t5, ' '            
    beq     $t4, $t5, notDraw   
    addi    $t3, $t3, 1         
    addi    $t0, $t0, 1         
    blt     $t3, $t1, drawCheckLoop 

    # Print String -  Consider Moving Down
    li      $v0, 4
    la      $a0, drawCondition
    syscall
    j       gameEnd

notDraw:
    jr      $ra
    

# WIN CONDITION MESSAGES
playerOneWins:         # Win String Player 1 Print
    li      $v0, 4              
    la      $a0, winCondition1  # Load Player 1 win message
    syscall
    li      $t8, 1              # Indicate Player 1 won
    j       gameEnd

playerTwoWins:         # Win String Player 2 Print
    li      $v0, 4              
    la      $a0, winCondition2  # Load Player 2 win message
    syscall
    li      $t8, 2              # Indicate Player 2 won
    j       gameEnd

# End of Game with Sound
gameEnd:
    beq     $t8, 1, playPlayerOneSound  # If Player 1 won, play their sound
    beq     $t8, 2, playPlayerTwoSound  # If Player 2 won, play their sound
    j       exitGame                    # Skip to exit if no valid winner

playPlayerOneSound:
    # MIDI sound for Player 1
    li      $v0, 31                  # Syscall for MIDI playback
    la      $a0, 67           # Address of pitch data
    la      $a1, 100         # Address of duration data
    la      $a2, 56      # Address of instrument for Player 1
    la      $a3, 127          # Address of volume data
    syscall
    j       exitGame

playPlayerTwoSound:
    # MIDI sound for Player 2
    li      $v0, 31                  # Syscall for MIDI playback
    la      $a0, 60            # Address of pitch data
    la      $a1, 100         # Address of duration data
    la      $a2, 19      # Address of instrument for Player 2
    la      $a3, 127           # Address of volume data
    syscall
    j       exitGame

exitGame:
    li      $v0, 10                  # Exit syscall
    syscall

