
.data			

			
nameandID:	.asciiz "Brandon Nguyen, 827813045" 

prompt: .asciiz "\nEnter number from keyboard: "
output: .asciiz "\nLeft shift by 3: "


.text              	
	
	# Name and RedID
	li   $v0, 4	    
	la   $a0, nameandID	
	syscall		    
	
	
	# Left Shift by 3
	li   $v0, 4	    
	la   $a0, prompt
	syscall
	
	li   $v0, 5	    
	syscall
	
	move $t0, $v0
	
	# MIPS Assembly Left Shift Operator
	sll $t1, $t0, 3
	
	li   $v0, 4	    
	la   $a0, output
	syscall
	
	li $v0, 1
	move $a0, $t1
	syscall
	
	li   $v0, 10	
	syscall		    
