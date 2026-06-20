# Project Draft 1 - MIPS Assembly (Gameboard)


.data
ROWS: .word 8
COLS: .word 8
gameBoard: .space 64
projectTitle:  .asciiz	"MIPS Assembly Project Version 1 - Gameboard\n"
diceRoll:  .asciiz "Dice rolled: %c. It's Player %c's turn."
piecePlacement:	.asciiz	"Player %c, enter a column number to display your piece: "
invalidColumn:	.asciiz	"Error, try a different column number"
fullColumn:	.asciiz	"Column is full. Please try a different column number."
winCondition:	.asciiz	"Player %c is the winner."
drawCondition:	.asciiz	"Game is a Draw."


.text


# Initialize variables
    li      $t0, 0              
    li      $t1, 0                
    la      $a0, gameBoard       


# Create the board
createBoard:
    lw      $t2, ROWS           
    lw      $t3, COLS             

outer_loop:
    beq     $t0, $t2, printTitle  
    li      $t1, 0               

inner_loop:
    beq     $t1, $t3, next_row    
    li      $t4, ' '              
    sb      $t4, 0($a0)           
    addi    $a0, $a0, 1           
    addi    $t1, $t1, 1           
    j       inner_loop            

next_row:
    addi    $t0, $t0, 1           
    j       outer_loop           

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

print_outer_loop:
    beq     $t0, $t2, print_numbers  
    li      $t1, 0                   

print_inner_loop:
    beq     $t1, $t3, print_newline  
    lb      $t4, 0($a1)               
    beq     $t4, ' ', print_dot       
    li      $v0, 11                   
    move    $a0, $t4                  
    syscall
    j       print_space

print_dot:
    li      $v0, 11                  
    li      $a0, '.'                  
    syscall

print_space:
    li      $v0, 11                  
    li      $a0, ' '                  
    syscall
    addi    $a1, $a1, 1               
    addi    $t1, $t1, 1               
    j       print_inner_loop          
    
print_newline:
    li      $v0, 11                   
    li      $a0, 10                   
    syscall
    addi    $t0, $t0, 1               
    j       print_outer_loop          



# Prints the Row of Column Numbers
print_numbers:
    li      $t0, 1                    
    lw      $t2, COLS                 


print_col:
    ble     $t0, $t2, print_number    


print_number:
    li      $v0, 1                    
    move    $a0, $t0                  
    syscall
    li      $v0, 11                   
    li      $a0, ' '
    syscall
    addi    $t0, $t0, 1               
    ble     $t0, $t2, print_col       


# End Draft 1
    li      $v0, 10                   
    syscall


