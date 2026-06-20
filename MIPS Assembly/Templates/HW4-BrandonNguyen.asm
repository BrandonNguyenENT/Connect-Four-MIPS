.data                
Seed:   .word 0x55AAFF00

.text

li $t0, 0


While1:
        bge $t0, 10, After1
        li $t1, 0     
        jal lfsr32         

       
        move $a0, $v0            
        li $v0, 1                
        syscall                  

        addi $t0, $t0, 1        
        j While1   
        
                                  
After1:
        li $v0, 10     
        syscall                   
        
        
lfsr32:
        lw $t2, Seed  
        bne $t1, $zero, lfsr
        li $t3, 0            
	
While2:
        bge $t3, 32, After3     
        srl $t4, $t2, 31         
        srl $t5, $t2, 21          
        xor $t4, $t4, $t5         
        srl $t5, $t2, 1           
        xor $t4, $t4, $t5         
        xor $t4, $t4, $t2         
        andi $t4, $t4, 1          

        srl $t2, $t2, 1          
        sll $t5, $t4, 31          
        or $t2, $t2, $t5          

        addi $t3, $t3, 1          
        j While2                  
        
        
lfsr:
        sw $t1, Seed              
        j After3                 

After3:
        sw $t2, Seed              
        move $v0, $t2             
        jr $ra     
           
