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
winCondition1:	.asciiz	"Player 1 is the winner." # Implement
winCondition2:	.asciiz	"Player 2 is the winner." # Implement
drawCondition:	.asciiz	"Game is a Draw." # Implement

.text

# Initialize variables
li      $t0, 0              
li      $t1, 0                
la      $a0, gameBoard
li      $t7, 1 #t7 holds player turn, initially is set to players 1s turn.   

# Create the board
createBoard:
    lw      $t2, ROWS           
    lw      $t3, COLS             

outerLoop:
    beq     $t0, $t2, printTitle  
    li      $t1, 0               

innerLoop:
    beq     $t1, $t3, createBoardRows    
    li      $t4, ' '              
    sb      $t4, 0($a0)           
    addi    $a0, $a0, 1           
    addi    $t1, $t1, 1           
    j       innerLoop            

createBoardRows:
    addi    $t0, $t0, 1           
    j       outerLoop           

printTitle:
    li      $v0, 4                
    la      $a0, projectTitle
    syscall

# Print the board
    la      $a0, gameBoard        
    jal     printBoard           

# Print board function
printBoard:
    li      $t0, 0                
    lw      $t2, ROWS             
    lw      $t3, COLS             
    la      $a1, gameBoard        

outerLoopPrint:
    beq     $t0, $t2, numbersPrint 
    li      $t1, 0                   

innerLoopPrint:
    beq     $t1, $t3, newlinePrint  
    lb      $t4, 0($a1)               
    beq     $t4, ' ', dotPrint       
    li      $v0, 11                   
    move    $a0, $t4                  
    syscall
    j       spacePrint

dotPrint:
    li      $v0, 11                  
    li      $a0, '.'                  
    syscall

spacePrint:
    li      $v0, 11                  
    li      $a0, ' '                  
    syscall
    addi    $a1, $a1, 1               
    addi    $t1, $t1, 1               
    j       innerLoopPrint         
    
newlinePrint:
    li      $v0, 11                   
    li      $a0, 10                   
    syscall
    addi    $t0, $t0, 1               
    j       outerLoopPrint          

# Prints the Row of Column Numbers
numbersPrint:
    li      $t0, 1                    
    lw      $t2, COLS                 

ColPrint:
    ble     $t0, $t2, printNumber     

printNumber:
    li      $v0, 1                    
    move    $a0, $t0                  
    syscall
    li      $v0, 11                   
    li      $a0, ' '
    syscall
    addi    $t0, $t0, 1               
    ble     $t0, $t2, ColPrint       

#Newline
    li      $v0, 11
    li      $a0, 10   
    syscall

# Print the diceRoll message followed by a random number
printdiceRoll:
    jal	    VerticalBoardCheck
    jal	    HorizontalBoardCheck
    jal     DiagonalCheckBackward
    jal     DiagonalCheckForward
    jal     checkDraw
    
    
    # Print "Dice rolled: "
    li      $v0, 4                
    la      $a0, diceRoll
    syscall

    # Generate a random number from 1 to 6
    li      $a1, 6               # Set the maximum random number (6)
    li      $v0, 42              # System call for random integer
    syscall
    addi    $a0, $a0, 1          # Shift result to 1-6 (since random returns 0-5)
    
    # Print the random number
    li      $v0, 1               # Print integer syscall
    move    $a0, $a0             # Move the random number to $a0 for printing
    syscall

 # Check if the random number is odd or even
    andi    $t0, $a0, 1          # $t0 = random number AND 1
    beq     $t0, 0, setPlayerTwoTurn  # If even, go to Player 2's turn
    j       setPlayerOneTurn           # If odd, go to Player 1's turn

setPlayerOneTurn:
    li      $t7, 1               # Set $t7 to 1 (Player 1's turn)
    j       inputAndTurn         # Jump to input and turn processing

setPlayerTwoTurn:
    li      $t7, 2               # Set $t7 to 2 (Player 2's turn)
    j       inputAndTurn         # Jump to input and turn processing


# Part 2 - Piece Placement

inputAndTurn: #Checks which player is going and follows accordingly.
    li      $v0, 4
    beq     $t7, 1, p1turn #If it's player 1s turn goes to p1 turn
    j       p2turn #else goes to p2 turn                   

p1turn:
   la       $a0, playerOneTurn #Broadcts that it's player 1s turn.
   syscall
   j mainLoop #Jumps to the main loop

p2turn:
   la       $a0, playerTwoTurn #Broadcasts that it's player 2s turn.
   syscall
   j mainLoop

# Reads Column Number Input
mainLoop:
    li      $v0, 5                   
    syscall
    move    $t0, $v0                


    li      $t1, 1                   
    bge     $t0, $t1, maxColCheck  
    j       invalidColumnMessage

maxColCheck:
    lw      $t1, COLS                
    ble     $t0, $t1, placePiece    
    j       invalidColumnMessage

#Invalid Column Logic Check
invalidColumnMessage:
    li      $v0, 4                   
    la      $a0, invalidColumn
    syscall
    j       inputAndTurn                

# Placing a Piece
placePiece:
    addi    $t0, $t0, -1             
    la      $t1, gameBoard           
    li      $t2, 7                   

placePieceLoop:
    mul     $t3, $t2, 8              
    add     $t3, $t3, $t0            
    add     $t3, $t1, $t3            
    lb      $t4, 0($t3)              

    li      $t5, ' '                 
    bne     $t4, $t5, placePieceNextRow  
    beq     $t7, 1, PlayerOnePlace
    j PlayerTwoPlace
 
PlayerOnePlace:	 #player 1 places a piece
    li      $t6, '1'                
    sb      $t6, 0($t3)
    li      $t7, 2              
    j       printAndLoop
PlayerTwoPlace: #player 2 places a piece
    li      $t6, '2'
    sb      $t6, 0($t3)
    li      $t7, 1
    j       printAndLoop

placePieceNextRow:                 
    addi    $t2, $t2, -1             
    bgez    $t2, placePieceLoop    
    j       fullColumnMessage        

# Full Column Logic Check
fullColumnMessage:
    li      $v0, 4                   
    la      $a0, fullColumn
    syscall
    j       inputAndTurn                

# Print Updated Gameboard
 printAndLoop:
    jal     printBoard
    j       inputAndTurn                          

# VERTICAL WIN CHECK
# Check Board 
VerticalBoardCheck:
    li      $t0, 0              # Initialize column index to 0
    lw      $t1, COLS           # Load the number of columns
    la      $t2, gameBoard      # Load the base address of the gameBoard

checkNextColumn:
    beq     $t0, $t1, verticalCheckDone  # If all columns are checked, exit
    li      $t3, 7              # Start from the bottom row (index 7)
    li      $t4, 0              # Reset counter for Player 1
    li      $t5, 0              # Reset counter for Player 2

checkNextRow:
    mul     $t6, $t3, 8         # Row offset = row_index * 8
    add     $t6, $t6, $t0       # Add column offset
    add     $t6, $t6, $t2       # Calculate memory address
    lb      $t7, 0($t6)         # Load the value from the board

    # Check for Player 1
    li      $t8, '1'
    beq     $t7, $t8, incrementP1
    li      $t4, 0              # Reset Player 1 counter
    j       checkP2

incrementP1:
    addi    $t4, $t4, 1
    beq     $t4, 4, playerOneWins

checkP2:
    # Check for Player 2
    li      $t8, '2'
    beq     $t7, $t8, incrementP2
    li      $t5, 0              # Reset Player 2 counter
    j       nextRow

incrementP2:
    addi    $t5, $t5, 1
    beq     $t5, 4, playerTwoWins

nextRow:
    addi    $t3, $t3, -1        # Move to the next row (up)
    bgez    $t3, checkNextRow   # If row >= 0, continue checking
    addi    $t0, $t0, 1         # Move to the next column
    j       checkNextColumn

verticalCheckDone:
    jr      $ra                 # Return to the caller

#HORIZONTAL WIN CHECK
HorizontalBoardCheck:
    li      $t0, 7              # Start from the bottom row (index 7)
    lw      $t1, ROWS           # Load the number of rows (typically 6 for Connect 4)
    la      $t2, gameBoard      # Load the base address of the gameBoard

checkNextRowHorizontal:
    bltz    $t0, horizontalCheckDone  # If all rows are checked, exit
    li      $t3, 0              # Start from the first column (index 0)
    li      $t4, 0              # Reset counter for Player 1
    li      $t5, 0              # Reset counter for Player 2

checkNextColumnHorizontal:
    lw      $t6, COLS           # Load the number of columns
    beq     $t3, $t6, nextRowHorizontal # If all columns are checked, move to the next row
    mul     $t7, $t0, 8         # Row offset = row_index * 8
    add     $t7, $t7, $t3       # Add column offset
    add     $t7, $t7, $t2       # Calculate memory address
    lb      $t8, 0($t7)         # Load the value from the board

    # Check for Player 1
    li      $t9, '1'
    beq     $t8, $t9, incrementHorizontalP1
    li      $t4, 0              # Reset Player 1 counter
    j       checkHorizontalP2

incrementHorizontalP1:
    addi    $t4, $t4, 1
    beq     $t4, 4, playerOneWins
    j       nextColumnHorizontal

checkHorizontalP2:
    # Check for Player 2
    li      $t9, '2'
    beq     $t8, $t9, incrementHorizontalP2
    li      $t5, 0              # Reset Player 2 counter
    j       nextColumnHorizontal

incrementHorizontalP2:
    addi    $t5, $t5, 1
    beq     $t5, 4, playerTwoWins

nextColumnHorizontal:
    addi    $t3, $t3, 1         # Move to the next column
    j       checkNextColumnHorizontal

nextRowHorizontal:
    addi    $t0, $t0, -1        # Move to the next row (up)
    j       checkNextRowHorizontal

horizontalCheckDone:
    jr      $ra                 # Return to the caller


# DIAGONAL WIN CHECK (Forward)
DiagonalCheckForward:
    li      $t0, 7              # Start from the bottom row (index 7)
forwardRowLoop:
    bltz    $t0, forwardDone    # If all rows are checked, exit
    li      $t1, 0              # Start from the first column (index 0)

forwardColLoop:
    lw      $t2, COLS           # Load the number of columns
    sub     $t2, $t2, 4         # Limit to columns where a diagonal can fit
    bge     $t1, $t2, nextForwardRow # If all valid columns are checked, move to next row

    # Initialize counters for Player 1 and Player 2
    li      $t3, 0              # Counter for Player 1
    li      $t4, 0              # Counter for Player 2
    move    $t5, $t0            # Set starting row index
    move    $t6, $t1            # Set starting column index

forwardDiagonalLoop:
    mul     $t7, $t5, 8         # Row offset = row_index * 8
    add     $t7, $t7, $t6       # Add column offset
    la      $t8, gameBoard      # Load base address of the board
    add     $t7, $t7, $t8       # Calculate cell address
    lb      $t9, 0($t7)         # Load the cell value

    # Check for Player 1
    li      $s0, '1'
    beq     $t9, $s0, incrementForwardP1
    li      $t3, 0              # Reset Player 1 counter
    j       checkForwardP2

incrementForwardP1:
    addi    $t3, $t3, 1
    beq     $t3, 4, playerOneWins
    j       nextForwardDiagonal

checkForwardP2:
    # Check for Player 2
    li      $s0, '2'
    beq     $t9, $s0, incrementForwardP2
    li      $t4, 0              # Reset Player 2 counter
    j       nextForwardDiagonal

incrementForwardP2:
    addi    $t4, $t4, 1
    beq     $t4, 4, playerTwoWins

nextForwardDiagonal:
    addi    $t5, $t5, -1        # Move to the next diagonal cell (up a row)
    addi    $t6, $t6, 1         # Move to the next diagonal cell (right a column)
    bgez    $t5, forwardDiagonalLoop # Continue as long as we're within bounds
    blt     $t6, $t2, forwardDiagonalLoop

    addi    $t1, $t1, 1         # Move to the next column in the starting row
    j       forwardColLoop

nextForwardRow:
    addi    $t0, $t0, -1        # Move to the next starting row (up)
    j       forwardRowLoop

forwardDone:
    jr      $ra

    
# DIAGONAL WIN CHECK (BACKWARD)
DiagonalCheckBackward:
    li      $t0, 7              # Start from the bottom row
backwardRowLoop:
    bltz    $t0, backwardDone   # If all rows are checked, exit
    lw      $t1, COLS           # Load number of columns
    subi    $t1, $t1, 1         # Start from the last column

backwardColLoop:
    bltz    $t1, nextBackwardRow # If all valid columns are checked, move to next row

    # Initialize counters for Player 1 and Player 2
    li      $t3, 0              # Counter for Player 1
    li      $t4, 0              # Counter for Player 2
    move    $t5, $t0            # Set starting row index
    move    $t6, $t1            # Set starting column index

backwardDiagonalLoop:
    mul     $t7, $t5, 8         # Row offset = row_index * 8
    add     $t7, $t7, $t6       # Add column offset
    la      $t8, gameBoard      # Load base address of the board
    add     $t7, $t7, $t8       # Calculate cell address
    lb      $t9, 0($t7)         # Load the cell value

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

backwardDone:
    jr      $ra


#Draw Condition
checkDraw:
    la      $t0, gameBoard       # Start of the board
    lw      $t1, ROWS           # Number of rows
    lw      $t2, COLS           # Number of columns
    mul     $t1, $t1, $t2       # Total number of cells
    li      $t3, 0              # Counter for filled cells

drawCheckLoop:
    lb      $t4, 0($t0)         # Load cell value
    li      $t5, ' '            # Check for empty space
    beq     $t4, $t5, notDraw   # If empty space found, not a draw
    addi    $t3, $t3, 1         # Increment filled cell counter
    addi    $t0, $t0, 1         # Move to next cell
    blt     $t3, $t1, drawCheckLoop # Continue until all cells checked

    # If all cells filled, declare draw
    li      $v0, 4
    la      $a0, drawCondition
    syscall
    j       gameEnd

notDraw:
    jr      $ra


#WIN CONDITION MESSAGES
playerOneWins:
    li      $v0, 4              # Print string syscall
    la      $a0, winCondition1
    syscall
    j       gameEnd

playerTwoWins:
    li      $v0, 4              # Print string syscall
    la      $a0, winCondition2
    syscall
    j       gameEnd


gameEnd:
    li      $v0, 10             # Exit program
    syscall









