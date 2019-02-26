# Who:  Ocean
# What: Project 3
# Why:  Understanding Stacks
# When: 05.14.17
# How:  Orders integers in a stack

.data
prompt: .asciiz "qty of ints to store: "
int: .asciiz "enter integer: "
printLine: .asciiz "\nyour sorted ints:\n"
space: .asciiz " "

.text
.globl main
main:	# program entry
	li $s2, 0		#$s2 = 0 (iterator)
	li $t3, 0		#$t3 = 0
	li $v0, 4		#prints prompt
	la $a0, prompt		#prompt = $a0
	syscall
	li $v0, 5		#$v0 = input
	syscall
	move $s1, $v0		#$s1 = n

loop:	#loop
	beq $s1, $s2, print	#if $s1 (n) == $s2 (iterator), go to print
	la $a0, int		#int = $a0
	li $v0, 4		#prints int (prompt)
	syscall
	li $v0, 5		#$v0 = ints
	syscall
	move $s0, $v0		#$s0 = $v0
	jal insert		#jump to insert, $ra = position
	j loop			#jump to loop

print:	#printing
	la $a0, printInts	#print integers
	li $v0, 4
	syscall

printInts:	#print integers
	blez $s1, end		#if $s1 == 0, go to end
	lw $a0, ($sp)		#load lowest value
	li $v0, 1		#print int value
	syscall
	la $a0, space		#print space
	li $v0, 4
	syscall
	addi $sp, $sp, 4	#pop
	addi $s1, $s1, -1	#$s1 = $s1 - 1
	j print

end:
	li $v0, 10		# terminate the program
	syscall

insert: #piorityArray.insert(val)
	addi $sp, $sp, -4	#allocating space
	li $t0, 4		#$t0 = 4, new pos
	li $t1, 0		#$t1 = 0, prev pos
	beq $s2, $0, push	#if #s2 == 0, go to push

compare:
	add $sp, $sp, $t0	#$sp = $sp + $t0
	lw $t2, ($sp)		# load int from stack
	sub $sp, $sp, $t0
	slt $t3, $t2, $s0	#checks if new is greater than prev
	bgtz $t3, next 		#if new is greater, move to next

push:	
	add $sp, $sp, $t1
	sw $s0, ($sp)	
	sub $sp, $sp, $t1
	addi $s2, $s2, 1
	jr $ra	

next: 	#next value on the stack
	add $sp, $sp, $t1
	sw $t2, ($sp)
	sub $sp, $sp, $t1
	addi $t0, $t0, 4
	addi $t1, $t1, 4
	j compare
	