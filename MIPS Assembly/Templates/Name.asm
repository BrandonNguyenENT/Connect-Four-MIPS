
.data			# data segment

			
name:	.asciiz "Hello, Brandon Nguyen!" # MIPS string/printf Statement

.text              	# text segment
	
	li   $v0, 4	    # print string syscall
	la   $a0, name	# argument to print string
	syscall		    # tell the OS to do the syscall
	li   $v0, 10	# set up exit syscall
	syscall		    # tell the OS to do the syscall
