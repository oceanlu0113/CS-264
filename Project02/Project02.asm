# Who:  Ocean Lu
# What: Project2.asm
# Why:  Understand Iterative Loops
# When: Created 04.30.18 Due 05.02.18
# How:  Calculate the nth Fibonacci Sequence
.data
	msg1: .asciiz "N = "
	msg2: .asciiz "Incorrect input. Terminating."
.text
.globl main

main:	# program entry
	li $v0, 4
	la $a0, msg1
	syscall
	li $v0, 5
	syscall
	move $t2, $v0
	move $a0, $t2
	move $v0, $t2
	jal fib
	move $t3,$v0 
	move $a0,$t3
	li $v0,1
	syscall
	li $v0,10	# terminate the program
	syscall

fib:	# fibonacci procedure
	beqz $a0,zero   
	beq $a0,1,one 
	sub $sp,$sp,4
	sw $ra,0($sp)
	sub $a0,$a0,1 
	jal fib
	add $a0,$a0,1
	lw $ra,0($sp)  
	add $sp,$sp,4
	sub $sp,$sp,4 
	sw $v0,0($sp)
	sub $sp,$sp,4  
	sw $ra,0($sp)
	sub $a0,$a0,2
	jal fib
	add $a0,$a0,2
	lw $ra,0($sp) 
	add $sp,$sp,4
	lw $s7,0($sp) 
	add $sp,$sp,4
	add $v0,$v0,$s7
	jr $ra 

zero:
	li $v0,0
	jr $ra

one:
	li $v0,1
	jr $ra
	
