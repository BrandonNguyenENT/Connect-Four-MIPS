# Project Draft 2 - MIPS Assembly (Piece Placement)


.data
ROWS: .word 8
COLS: .word 8
gameBoard: .space 64
projectTitle:  .asciiz	"MIPS Assembly Project Version 2 - Piece Placement\n"
diceRoll:  .asciiz "Dice rolled: %c. It's Player %c's turn." # Implement
piecePlacement:	.asciiz	"Player 1, enter a column number to display your piece: "
invalidColumn:	.asciiz	"Error, try a different column number "
fullColumn:	.asciiz	"Column is full. Please try a different column number: "
winCondition:	.asciiz	"Player %c is the winner." # Implement
drawCondition:	.asciiz	"Game is a Draw." # Implement

.text

# Initialize variables
li      $t0, 0              
li      $t1, 0                
la      $a0, gameBoard       

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


#CONTINUE
#Newline
    li      $v0, 11
    li      $a0, 10   
    syscall
    j inputAndTurn


# Part 2 - Piece Placement
# Prints Piece Placement/Player Turn - Fix
inputAndTurn:
    li      $v0, 4                   
    la      $a0, piecePlacement
    syscall

    j       mainLoop


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
    j       mainLoop                

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

    li      $t6, '1'                 
    sb      $t6, 0($t3)              
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
    j       mainLoop                

# Print Updated Gameboard
 printAndLoop:
    jal     printBoard               
    j       mainLoop                


# End of Draft 2
    li      $v0, 10                   
    syscall
