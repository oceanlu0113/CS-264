# c) All in integers in a single line in the reverse order separated by spaces; n integers per line with separated by space;

.data
	arr: .space 100
	msg1: .asciiz "Enter integer: "
	msg2: .asciiz "The array elements are: \n"
	msg3: .asciiz "The number of values per line: \n"
	spaces: .asciiz " "
	enter: .asciiz "\n"
    
.text
.globl main
	main:
		la $a1, arr
		li $s0, 0
		li $t5, 0
 		li $t9,0
		li $t1,20
	readArray:
		beq $t5,$t1,arrayPrint
		la $a0, msg1
		li $v0, 4
		syscall
		li $v0, 5
		syscall
		addi $t5,$t5,1
		addi $s0,$s0,4
		sw $v0, ($a1)
		addi $a1, $a1, 4
		j readArray
	arrayPrint:
		la $a1,arr
		li $s4,0
		la $a0, msg3
		li $v0, 4
		syscall
		li $v0, 5
		syscall
		move $t8,$v0
		la $a0, msg2
		li $v0, 4
		syscall
	write:
		blez $s0, end
		li $v0, 1
		lw $a0, 76($a1)
		syscall
		addi $s4,$s4,1
		beq $s4,$t8,printNewLine
		la $a0, spaces
		li $v0, 4
		syscall
	loop:
		addi $a1, $a1, -4
		addi $s0, $s0, -4
		j write  
	printNewLine:
		li $s4,0
		la $a0, enter
		li $v0, 4
		syscall
		j loop
	end:
		j end