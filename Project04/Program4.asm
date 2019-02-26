# Who:  Ocean Lu, Grant Okamoto
# What: Program 4
# Why:  1. create a priority queue using the stack with user inputs 
#		2. uses a binary search method to find if a value is in the stack or not
# When: Created 5/22/2018 due 5/25/2018
# How: s0: size of unchecked part of stack for search subroutine
#	   s1: stores user input for the number to search for in the stack
#	   s2: size of the stack
#	   s3: highest unchecked value in the stack
#	   s4: lowest unchecked value in the stack
#	   s7: location to restore sp to

	
.data
	prompt:	 	.asciiz "Enter the quantity of integers to store: "
	prompt2: 	.asciiz "Enter integer to store: "
	prompt3: 	.asciiz "Enter integer to search for: "
	trueMsg:	.asciiz	"The value was found"
	falseMsg:	.asciiz "The value was not found"
	space: 	 	.asciiz " "
	newLine: 	.asciiz "\n"
	

.text
main:							# program entry
	li $t1, 0					# initializing loop counter	
	li $s0, 0					# initialiizing stack counter
	
	la $fp, 0($sp)				# save position of stack pointer to frame pointer

	li $v0, 4					# prompt user for number of values to store
	la $a0, prompt
	syscall			

	li $v0, 5 					# store user input
	syscall

	move $t0, $v0				# copy user input to t0

loop:			    				# loop taking n inputs from user
	bge $t1, $t0, printValue		# branch to printValue if completed entering integers
	li $v0, 4						# prompt user for value to store
	la $a0, prompt2				
	syscall				
	li $v0, 5 						# read user input
	syscall	
	move $a0, $v0					# store user input to a0
	jal storeValue		    		# jump to subroutine to add integer in sorted stack
	addi $t1, $t1, 1				# increment loop counter
	j loop							# jump to loop

printValue:
	li $v0, 4						# prompt user for value to search for
	la $a0, prompt3
	syscall

	li $v0, 5						# read user input
	syscall

	move $s1, $v0					# move user input into s1
	jal searchSetup					# jump to searchSetup	
	bne $a0, $0, found				# if a0 = 1, the values exists on the stack, branch to found

	li $v0, 4					    # print false message
	la $a0, falseMsg
	syscall
	j	exit						# jump to exit

found:
	li $v0, 4					    # print true message
	la $a0, trueMsg
	syscall	

exit:
	li $v0, 10						# terminate the program
	syscall

storeValue:							# stores a value onto the stack
	addi $sp, $sp, -4				# make space in stack 
	sw $a0, 0($sp)					# save number at address of the bottom of the stack
	la $s7, 0($sp)					# save sp address to restore later
	addi $s2, $s2, 1				# increment stack counter

sortStack:							# sort stack
	beq $fp, $sp, return			# branch if at top of stack to return
	lw $t2, 0($sp)					# compare top two elements
	lw $t3, 4($sp)			
	
	bge $t2, $t3, return			# stop sorting if new element is in the right spot
	
	sw $t3, 0($sp)					# swap if t2 < t3
	sw $t2, 4($sp)		
	addi $sp, $sp, 4				# restore stack pointer
	j sortStack						# jump to sortStack

searchSetup:						# prepares s registers for search
	move $s3, $sp					# s3 is the high value
	move $s4, $fp					# s4 is the low value
	move $s0, $s2					# size of unchecked stack

search:								# searches for a specific value
	beq $s0, $0, false				# if s0 cannot shift left anymore, all numbers have been evaluated and branches to false
	srl $s0, $s0, 1					# s0 / 2
	sll $s0, $s0, 2					# s0 * 4
	add $a0, $s3, $s0				# move down the stack s0 times 
	move $sp, $a0					# set the pointer to a0 (which is curently the middle of the stack
	lw $t2, 0($sp)					# load value of current middle of binary search to t2

	beq	$t2, $s1, true				# if t2 (mid) == s1 (target) branch to true
	blt $t2, $s1, smallerMid		# branch to smallerMid if t2(mid) less than s1 (target)
	addi $s3, $sp, 4				# moves down the stack once and sets that to new high
	srl $s0, $s0, 2					# s0 / 4 (shift s0 back)
	j search						# jump to search

smallerMid:
	addi	$s4, $sp, -4			# moves up the stack once and sets that to new low
	srl $s0, $s0, 2					# s0 / 4 (shift s0 back)
	j search						# jump to search
true:
	li	$a0, 1						# changes a0 to 1 (to be printed later)
	j		return
false:
	move	$a0, $0
return:								# return to callee
	move $sp, $s7					# restore stack pointer
	jr $ra			