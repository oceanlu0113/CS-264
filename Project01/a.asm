# a) One integer per line;

.data
     arr: .space 100
     msg1: .asciiz "Enter integer: "
     msg2: .asciiz "The array elements are: \n"
     spaces: .asciiz "\n"
    
.text
.globl main
     main:
          la $a1, arr
          li $s0, 0
          li $t5, 0
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
          la $a0, msg2
          li $v0, 4
          syscall
     write:
          blez $s0, end
          li $v0, 1
          lw $a0, 0($a1)
          syscall
          la $a0, spaces
          li $v0, 4
          syscall
          addi $a1, $a1, 4
          addi $s0, $s0, -4
          j write
     end:
          j end