        .data                   # Data segment
Seed:   .word 0x55AAFF00       # Initial seed for the LFSR
format: .asciiz "%u\n"         # Format for printing

        .text                   # Code segment
        .globl main            # Declare main as global

main:   
        li $t0, 0              # Initialize loop counter i = 0

While1: 
        bge $t0, 10, After1     # While i < 10
        li $t1, 0                # n = 0 (for LFSR function call)
        jal lfsr32               # Call lfsr32 function

        # Prepare to print result
        move $a0, $v0            # Move the result from lfsr32 to $a0
        li $v0, 1                # Load syscall code for print_int
        syscall                   # Print the result

        addi $t0, $t0, 1         # Increment loop counter i
        j While1                 # Repeat loop

After1: 
        li $v0, 10               # Load exit syscall code
        syscall                   # Exit program

lfsr32:
        lw $t2, Seed              # Load the current LFSR value

        # Check if n != 0
        bne $t1, $zero, set_lfsr  # If n != 0, set lfsr

        # Else, we proceed to generate new LFSR value
        li $t3, 0                 # Initialize j = 0

While2:
        bge $t3, 32, After3      # If j >= 32, exit loop

        # Calculate the new bit
        srl $t4, $t2, 31          # Get bit at position 31
        srl $t5, $t2, 21          # Get bit at position 21
        xor $t4, $t4, $t5         # bit = (bit31 ^ bit21)
        srl $t5, $t2, 1           # Get bit at position 1
        xor $t4, $t4, $t5         # bit = (bit ^ bit1)
        xor $t4, $t4, $t2         # bit = (bit ^ lfsr)
        andi $t4, $t4, 1          # bit = (bit & 1)

        # Update LFSR value
        srl $t2, $t2, 1           # lfsr >> 1
        sll $t5, $t4, 31          # New bit << 31
        or $t2, $t2, $t5          # Update lfsr with new bit

        addi $t3, $t3, 1          # j++
        j While2                  # Repeat loop

set_lfsr:
        sw $t1, Seed              # Store the seed value n into Seed
        j After3                  # Skip to After3

After3:
        sw $t2, Seed              # Save updated lfsr value
        move $v0, $t2             # Return the updated lfsr value in $v0
        jr $ra                     # Return from function


