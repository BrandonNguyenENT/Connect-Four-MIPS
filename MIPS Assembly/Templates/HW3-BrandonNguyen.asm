# Description:	Homework #3: Find 2D array content by row/col

.data
askrow:	.asciiz	"Enter row in the range [0..2]: "
askcol:	.asciiz	"\nEnter column in the range [0..4]: "
print:	.asciiz	"\narray[row][col] = "

array:
	.word	  1, 2, 3, 4, 5
	.word	  6, 7, 8, 9,10
	.word	  11,12,13,14,15

.text

    li $v0, 4                    
    la $a0, askrow            
    syscall
    
    li $v0, 5                    
    syscall
    move $t0, $v0
    
    li $v0, 4                    
    la $a0, askcol           
    syscall

    li $v0, 5                    
    syscall
    move $t1, $v0  
   
    li $v0, 4                    
    la $a0, print            
    syscall
           
    
    li $t2, 5                    
    la $a3, array                
    move $a0, $t0                
    move $a1, $t1                
    move $a2, $t2
jal arrayAddress

          
    lw $a0, 0($v0)               	

    li $v0, 1                                    
    syscall

    li $v0, 10
    syscall
    
           
arrayAddress:

 sll $t3, $a0, 2              
 mul $t4, $a2, $t3       
    
 sll $t5, $a1, 2              
 add $t6, $t4, $t5            
    
add $v0, $a3, $t6            

jr $ra
   
