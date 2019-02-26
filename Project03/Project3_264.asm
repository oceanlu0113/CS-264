# Who:  Andrew Gonzales
# What: Project3_264.asm
# Why:  To store integers on the stack and print them out in descending order
# When: Created 5/15/2017 due 5/16/2018

	
.data
	prompt: .asciiz "Enter the quantity of ints to store: "
	prompt2: .asciiz "Enter integer: "
	print: .asciiz "Numbers in descending order:\n"
	space: .asciiz " "
	newLine: .asciiz "\n"
	test: .asciiz "TEST "
	

.text

main:			# program entry
	li $t1, 0	
	li $t3, 0	
	li $s2, 0
	
	la $s3, 0($sp)	# save position of stack pointer

	li $v0, 4	
	la $a0, prompt
	syscall		# Ask for number of values to store

	li $v0, 5 	# read input from user
	syscall
	
	move $s1, $v0	
	move $t0, $s1	

loop:			# loop taking n input from user
	bge $t1, $t0, printStack	# branch to printStack if completed entering integers
	li $v0, 4	
	la $a0, prompt2				
	syscall				# Asked to Enter Integer
	li $v0, 5 	
	syscall				# User input Stored
	move $a0, $v0
	jal storeInStack		# subroutine to add integer in sorted stack
	addi $t1, $t1, 1		
	b loop


printStack:	
	li $v0, 4
	la $a0, print		# Prints integers existing in the stack	
	syscall

printNext:
	bge $t3, $s1, exit	# print number and increment sp
	lw $a0, 0($sp)		
	li $v0, 1
	syscall
	li  $v0, 4
	la $a0, newLine
	syscall
	addi $sp, $sp, 4	# move sp to previous number on stack
	addi $t3, $t3, 1	
	b printNext

exit:
	li $v0, 10	# terminate the program
	syscall


storeInStack:
	addi $sp, $sp, -4	# make space in stack 
	sw $a0, 0($sp)		# save number at address of the bottom of the stack
	la $t8, 0($sp)
	addi $s2, $s2, 1	
	li $t3, 0 

stackSort:				# sort stack
	beq $s3, $sp, return	# branch if at top of stack
	lw $t5, 0($sp)		# compare two elements
	lw $t6, 4($sp)		
	
	bge $t5, $t6, return	# stop sorting if new element is in correct position in stack
	
	sw $t6, 0($sp)		
	sw $t5, 4($sp)		
	addi $sp, $sp, 4	
	b stackSort

return:				# Return to callee
	move $sp, $t8		
	jr $ra			