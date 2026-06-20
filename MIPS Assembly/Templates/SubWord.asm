# Author:	Eric Walkingshaw
# Date:		Jan 25, 2013
# Description:	Examples of addressing sub-word data in memory.

.data

date:	.byte	7	# month
	.byte	4	# day
	.half	1776	# year
	
event:	.asciiz	"Declaration of Independence"

.text
	
	# load some values into registers
	lbu	$t0, date	# 0x07
	lbu	$t1, date + 1	# 0x04
	lhu	$t2, date + 2	# 0x06F0

	lbu	$t3, event	# 0x44  'D'
	lbu	$t4, event + 1	# 0x65  'e'
	lbu	$t5, event + 2	# 0x63  'c'
	lbu	$t6, event + 4	# 0x61  'a'
	
	# exit
	li 	$v0, 10		# set up exit syscall
	syscall
