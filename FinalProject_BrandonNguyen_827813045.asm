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

#PART 1 - MAIN LOOPS
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
    j       innerLoop            

createBoardRows:
    addi    $t0, $t0, 1          # Increment row counter $t0.
    j       outerLoop            

printTitle:
    li      $v0, 4               
    la      $a0, projectTitle    
    syscall                      

# Print the board
    la      $a0, gameBoard       # Reload the address of the game board into $a0.
    jal     printBoard           

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
    j       spacePrint              

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
    j       innerLoopPrint          

newlinePrint:
    li      $v0, 11                 # Set syscall for printing a character.
    li      $a0, 10                 # Load newline character into $a0.
    syscall                         # Print newline.
    addi    $t0, $t0, 1             # Increment row counter $t0.
    j       outerLoopPrint          

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
    li      $a0, 10                 
    syscall                         

# Main logic: Call functions for board checks
    jal     VerticalBoardCheck      
    jal     HorizontalBoardCheck    
    jal     DiagonalCheckBackward   
    jal     DiagonalCheckForward    
    jal     checkDraw               
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


# PART 2 - PIECE PLACEMENT

inputAndTurn: # Checks which player's turn it is
    li      $v0, 4                # Set syscall for printing a string.
    beq     $t7, 1, p1turn        # If $t7 is 1 (Player 1's turn), jump to p1turn.
    j       p2turn                # Otherwise, jump to p2turn.

p1turn:
   la       $a0, playerOneTurn    # Load the address of the Player 1's turn message.
   syscall                        # Print the Player 1's turn message.
   j       mainLoop               

p2turn:
   la       $a0, playerTwoTurn    # Load the address of the Player 2's turn message.
   syscall                        # Print the Player 2's turn message.
   j       mainLoop               

# Reads Column Number Input
mainLoop:
    li      $v0, 5                # Set syscall for reading an integer input.
    syscall                       # Read user input and store it in $v0.
    move    $t0, $v0              # Move the input value to $t0 for processing.

    li      $t1, 1                # Load the minimum column number (1) into $t1.
    bge     $t0, $t1, maxColCheck # If the input is >= 1, jump to maxColCheck.
    j       invalidColumnMessage  

maxColCheck:
    lw      $t1, COLS             # Load the maximum column number into $t1.
    ble     $t0, $t1, placePiece  # If the input is <= max column, jump to placePiece.
    j       invalidColumnMessage  

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
  
                    # SOUND 1 - PLAYER 1 PIECE PLACEMENT SOUND

    li $v0, 31 # Sound
    la $t0, 60 # Pitch
    la $t1, 100 # Duration
    la $t2, 4 # Insturment Type
    la $t3, 127 # Volume
    move $a0, $t0 
    move $a1, $t1 
    move $a2, $t2
    move $a3, $t3 
    syscall 
    
    li      $t7, 2                # Set the turn to Player 2.
    j       printAndLoop          


PlayerTwoPlace: # Player 2 places a piece
    li      $t6, '2'              # Load '2' (Player 2's piece) into $t6.
    sb      $t6, 0($t3)           # Store the piece at the calculated cell address.
    
            # SOUND 2 - PLAYER 2 PIECE PLACEMENT SOUND
    li $v0, 31 # Sound
    la $t0, 69 # Pitch
    la $t1, 100 # Duration
    la $t2, 58 #Instrument Type
    la $t3, 127 #Volume
    move $a0, $t0 
    move $a1, $t1 
    move $a2, $t2
    move $a3, $t3 
    syscall 
    
    li      $t7, 1                # Set the turn to Player 1.
    j       printAndLoop         

placePieceNextRow:
    addi    $t2, $t2, -1          # Move to the row above.
    bgez    $t2, placePieceLoop   # If the row index is >= 0, repeat the loop.
    j       fullColumnMessage     # If all rows are full, jump to fullColumnMessage.

# Full Column Logic Check
fullColumnMessage:
    li      $v0, 4                
    la      $a0, fullColumn       
    syscall                       
    j       inputAndTurn          

# Print Updated Gameboard
printAndLoop:
    jal     printBoard            # Call the function to print the updated game board.
    j       inputAndTurn          # Restart the turn.
                        

# PART 3 - WIN/DRAW CONDITION LOGIC


# VERTICAL WIN CHECK
# Check Board 
VerticalBoardCheck:
    li      $t0, 0              # Initialize column counter ($t0) to 0.
    lw      $t1, COLS           # Load the total number of columns
    la      $t2, gameBoard      # Load the base address of the game board into $t2.

checkNextColumn:
    beq     $t0, $t1, verticalCheckDone
    li      $t3, 7              # Start from the bottom row (row index 7).
    li      $t4, 0              # Initialize Player 1's consecutive counter ($t4) to 0.
    li      $t5, 0              # Initialize Player 2's consecutive counter ($t5) to 0.

checkNextRow:
    mul     $t6, $t3, 8         # Calculate row offset: row index * 8 (8 columns per row).
    add     $t6, $t6, $t0       # Add column offset to calculate cell index.
    add     $t6, $t6, $t2       # Add base address of the game board to get cell's absolute address.
    lb      $t7, 0($t6)         # Load the value at the current cell into $t7.

    # Check for Player 1
    li      $t8, '1'            # Load Player 1's piece ('1') into $t8.
    beq     $t7, $t8, incrementP1
    li      $t4, 0              # Otherwise, reset Player 1's consecutive counter to 0.
    j       checkP2             # Jump to check Player 2's pieces.

incrementP1:
    addi    $t4, $t4, 1         # Increment Player 1's consecutive counter.
    beq     $t4, 4, playerOneWins 

checkP2:
    # Check for Player 2
    li      $t8, '2'            # Load Player 2's piece ('2') into $t8.
    beq     $t7, $t8, incrementP2 
    li      $t5, 0              # Otherwise, reset Player 2's consecutive counter to 0.
    j       nextRow             

incrementP2:
    addi    $t5, $t5, 1         # Increment Player 2's consecutive counter.
    beq     $t5, 4, playerTwoWins

nextRow:
    addi    $t3, $t3, -1        # Move to the row above by decrementing row index ($t3).
    bgez    $t3, checkNextRow   # If the row index is >= 0, continue checking rows in this column.
    addi    $t0, $t0, 1         # Move to the next column by incrementing column counter ($t0).
    j       checkNextColumn     

#Storing $ra to the stack
verticalCheckDone:
    addi    $sp, $sp, -4        
    sw      $ra, 0($sp)         

    # CHILD (VERTICAL) TO GRANDCHILD (HORIZONTAL)
    jal     HorizontalBoardCheck # Call the next function to check horizontal connections.

    lw      $ra, 0($sp)         
    addi    $sp, $sp, 4         
    jr      $ra                 
  

#HORIZONTAL WIN CHECK
HorizontalBoardCheck:
    li      $t0, 7              # Initialize row counter ($t0) to start from the bottom row (index 7).
    lw      $t1, ROWS           # Load the total number of rows into $t1.
    la      $t2, gameBoard      # Load the base address of the game board into $t2.

checkNextRowHorizontal:
    bltz    $t0, horizontalCheckDone 
    li      $t3, 0              # Initialize column counter ($t3) to 0.
    li      $t4, 0              # Reset Player 1's consecutive counter ($t4) to 0.
    li      $t5, 0              # Reset Player 2's consecutive counter ($t5) to 0.

checkNextColumnHorizontal:
    lw      $t6, COLS           # Load the total number of columns into $t6.
    beq     $t3, $t6, nextRowHorizontal
    mul     $t7, $t0, 8         # Calculate the row offset: row index * 8 (8 columns per row).
    add     $t7, $t7, $t3       # Add column offset to calculate cell index.
    add     $t7, $t7, $t2       # Add base address of the game board to get the absolute address of the cell.
    lb      $t8, 0($t7)         # Load the value at the current cell into $t8.

    # Check for Player 1
    li      $t9, '1'            # Load Player 1's piece ('1') into $t9.
    beq     $t8, $t9, incrementHorizontalP1 
    li      $t4, 0              # Otherwise, reset Player 1's consecutive counter to 0.
    j       checkHorizontalP2   

incrementHorizontalP1:
    addi    $t4, $t4, 1         # Increment Player 1's consecutive counter.
    beq     $t4, 4, playerOneWins 
    j       nextColumnHorizontal # Otherwise, move to the next column.

checkHorizontalP2:
    # Check for Player 2
    li      $t9, '2'            # Load Player 2's piece ('2') into $t9.
    beq     $t8, $t9, incrementHorizontalP2
    li      $t5, 0              # Otherwise, reset Player 2's consecutive counter to 0.
    j       nextColumnHorizontal # Jump to the next column.

incrementHorizontalP2:
    addi    $t5, $t5, 1         # Increment Player 2's consecutive counter.
    beq     $t5, 4, playerTwoWins 

nextColumnHorizontal:
    addi    $t3, $t3, 1         # Move to the next column by incrementing the column counter ($t3).
    j       checkNextColumnHorizontal # Repeat the column-checking process.

nextRowHorizontal:
    addi    $t0, $t0, -1        # Move to the row above by decrementing the row index ($t0).
    j       checkNextRowHorizontal # Repeat the row-checking process.

#Storing $ra to the stack
horizontalCheckDone:
    addi    $sp, $sp, -4        
    sw      $ra, 0($sp)         

    jal     DiagonalCheckForward # Nested call to DiaonalCheckForwaward

    lw      $ra, 0($sp)         
    addi    $sp, $sp, 4         
    jr      $ra                 


# DIAGONAL WIN CHECK (Forward)
DiagonalCheckForward:
    li      $t0, 7              # Start from the bottom row (index 7).
forwardRowLoop:
    bltz    $t0, forwardDone    
    li      $t1, 0              

forwardColLoop:
    lw      $t2, COLS           # Load the number of columns.
    sub     $t2, $t2, 4         
    bge     $t1, $t2, nextForwardRow  

    li      $t3, 0              # Reset Player 1's piece counter.
    li      $t4, 0              # Reset Player 2's piece counter.
    move    $t5, $t0            # Set the starting row index for diagonal traversal.
    move    $t6, $t1            # Set the starting column index for diagonal traversal.

forwardDiagonalLoop:
    mul     $t7, $t5, 8         # Calculate the row's base offset: row_index * 8 columns.
    add     $t7, $t7, $t6       
    la      $t8, gameBoard      
    add     $t7, $t7, $t8       # Compute the absolute memory address of the current cell.
    lb      $t9, 0($t7)         

    # Check for Player 1
    li      $s0, '1'            # Load '1' to represent Player 1's pieces.
    beq     $t9, $s0, incrementForwardP1 
    li      $t3, 0              # Otherwise, reset Player 1's counter.
    j       checkForwardP2      

incrementForwardP1:
    addi    $t3, $t3, 1         # Increment Player 1's consecutive piece counter.
    beq     $t3, 4, playerOneWins  
    j       nextForwardDiagonal # Continue checking the next diagonal cell.

checkForwardP2:
    # Check for Player 2
    li      $s0, '2'            # Load '2' to represent Player 2's pieces.
    beq     $t9, $s0, incrementForwardP2 
    li      $t4, 0              # Otherwise, reset Player 2's counter.
    j       nextForwardDiagonal 

incrementForwardP2:
    addi    $t4, $t4, 1         # Increment Player 2's consecutive piece counter.
    beq     $t4, 4, playerTwoWins  

nextForwardDiagonal:
    addi    $t5, $t5, -1        # Move diagonally up (row index decreases).
    addi    $t6, $t6, 1         # Move diagonally to the right (column index increases).
    bgez    $t5, forwardDiagonalLoop 
    blt     $t6, $t2, forwardDiagonalLoop 

    addi    $t1, $t1, 1         
    j       forwardColLoop      

nextForwardRow:
    addi    $t0, $t0, -1        # Move to the next starting row (one row up).
    j       forwardRowLoop      

#Storing $ra to the stack
forwardDone:
    addi    $sp, $sp, -4        
    sw      $ra, 0($sp)        

    jal     DiagonalCheckBackward   # Nested call to Diagonal CheckBackward

    lw      $ra, 0($sp)         
    addi    $sp, $sp, 4         
    jr      $ra                 
    

    
# DIAGONAL WIN CHECK (BACKWARD)
DiagonalCheckBackward:
    li      $t0, 7              # Start from the bottom row
backwardRowLoop:
    bltz    $t0, backwardDone   
    lw      $t1, COLS           
    subi    $t1, $t1, 1         

backwardColLoop:
    bltz    $t1, nextBackwardRow # If all valid columns are checked, move to next row

   
    li      $t3, 0              
    li      $t4, 0              
    move    $t5, $t0            
    move    $t6, $t1            

backwardDiagonalLoop:
    mul     $t7, $t5, 8         # Row offset = row_index * 8
    add     $t7, $t7, $t6       
    la      $t8, gameBoard      
    add     $t7, $t7, $t8      
    lb      $t9, 0($t7)        

    # Check for Player 1
    li      $s0, '1'
    beq     $t9, $s0, incrementBackwardP1
    li      $t3, 0              # Reset Player 1 counter
    j       checkBackwardP2

incrementBackwardP1:
    addi    $t3, $t3, 1
    beq     $t3, 4, playerOneWins
    j       nextBackwardDiagonal

checkBackwardP2:
    # Check for Player 2
    li      $s0, '2'
    beq     $t9, $s0, incrementBackwardP2
    li      $t4, 0              # Reset Player 2 counter
    j       nextBackwardDiagonal

incrementBackwardP2:
    addi    $t4, $t4, 1
    beq     $t4, 4, playerTwoWins

nextBackwardDiagonal:
    addi    $t5, $t5, -1        # Move to the next diagonal cell (up a row)
    addi    $t6, $t6, -1        # Move to the next diagonal cell (left a column)
    bgez    $t5, backwardDiagonalLoop
    bgez    $t6, backwardDiagonalLoop

    addi    $t1, $t1, -1        # Move to the next column in the starting row
    j       backwardColLoop

nextBackwardRow:
    addi    $t0, $t0, -1        # Move to the next starting row (up)
    j       backwardRowLoop

#Storing $ra to the stack
backwardDone:
    addi    $sp, $sp, -4
    sw      $ra, 0($sp)

    jal     checkDraw   # Nested call to checkDraw

 
    lw      $ra, 0($sp)
    addi    $sp, $sp, 4
    jr      $ra  


#DRAW CONDITION
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

    # Draw Message String
    li      $v0, 4
    la      $a0, drawCondition
    syscall
    j       gameEnd

notDraw:
    jr      $ra
    

# WIN CONDITION MESSAGES
playerOneWins:         # Win String Player 1 Print
    li      $v0, 4              
    la      $a0, winCondition1  
    syscall
    li      $t8, 1              
    j       gameEnd

playerTwoWins:         # Win String Player 2 Print
    li      $v0, 4              
    la      $a0, winCondition2  
    syscall
    li      $t8, 2              
    j       gameEnd

# End of Game with Sound
gameEnd:
    beq     $t8, 1, playPlayerOneSound  # If Player 1 won, play their sound
    beq     $t8, 2, playPlayerTwoSound  # If Player 2 won, play their sound
    j       exitGame                    

playPlayerOneSound:
    # MIDI sound for Player 1
    li      $v0, 31                  # Sound Syscalll
    la      $a0, 67           # Pitch
    la      $a1, 100         # Duration
    la      $a2, 56      # Instrument Type
    la      $a3, 127          # Volume
    syscall
    j       exitGame

playPlayerTwoSound:
    # Player 2 Win Sound
    li      $v0, 31                  # Sound Syscalll
    la      $a0, 60            # Pitch
    la      $a1, 100         # Duration
    la      $a2, 19      # Instrument Type
    la      $a3, 127           # Volume
    syscall
    j       exitGame

#Exit Syscall to End Game/Program
exitGame:
    li      $v0, 10                 
    syscall
