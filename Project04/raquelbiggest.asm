#    Testing: Biggest

# How:  Registers used:
    # $t0    =n input (number of numbers)
    # $t1    = i
    # #t3    =temp counter for printing from stack
    # $t5     =temp for swapping
    # $t6    =temp for swapping
    # $t7    =temp for swapping
    # $t8    =temp save for stack pointer
    
    # s5 BIGGEST
    # a3 RESULT
    # $s1    =n
    # $s2    =count of integers already added to stack
    # $s3    =initial position of stack pointer
    
.data
prompt:     .asciiz "\nEnter the quantity of numbers to be stored: "
prompt2:     .asciiz "\nEnter number to add: "
space:         .asciiz " "
newLine:     .asciiz "\n"
test:         .asciiz "~~~~~~TEST BIGGEST~~~~~~"
printSmallest:     .asciiz "\nValue of Biggest element to search: "
printResult:     .asciiz "\nResult: "
printList:     .asciiz "\nNumbers in descending order:\n"
.text

main:        # program entry
    li $t1, 0
    li $t3, 0
    li $s2, 0
    la $s3, 0($sp)    #save initial state of stack pointer

    li $v0, 4
    la $a0, prompt
    syscall

    li $v0, 5     #take input from user
    syscall
    move $s1, $v0    #save quantity of numbers to s1 and t0
    move $t0, $s1    

loop:    #loop taking n input from user
    bge $t1, $t0, continue    
    li $v0, 4
    la $a0, prompt2
    syscall
    li $v0, 5     #take input from user
    syscall
    move $a0, $v0
    jal storeInStack    #subroutine call to add number to a sorted stack
    addi $t1, $t1, 1    #counter
    b loop

continue:

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+
# Calculating BIGGest
    add $s7,$sp,0
    add $t6,$s7,0
    lw $t5,0($t6)
    add $a0,$0,$t5
    move $s5,$a0
    add $a1,$0,0
    add $a2,$0,7
    jal bin_Search
    move $a3,$v0
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+

li $v0, 4
la $a0, printList
syscall

printNextNum:
bge $t3, $s1, endPrint    #loop to print number from stack and increment stack pointer
lw $a0, 0($sp)        #print number at top of stack
li $v0, 1
syscall
li  $v0, 4
la $a0, newLine
syscall
addi $sp, $sp, 4    #move stack pointer to previous number on stack
addi $t3, $t3, 1    #counter
b printNextNum

endPrint:

#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~+
# Print Results
    li $v0, 4
    la $a0, test
    syscall
    
    li $v0, 4
    la $a0, printSmallest
    syscall    
    
    add $a0,$s5,$0         # a0 = integer to print
    li $v0, 1        # v0= 1 print integer
    syscall
    
    li $v0, 4
    la $a0, printResult
    syscall
    
    move $a0,$a3         # a0 = integer to print
    li $v0, 1        # v0= 1 print integer
    syscall

exit:
    li $v0, 10    # terminate the program
    syscall

##########################################################################################

# SUBROUTINE storeInStack
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# registers:
#       $a0: contains the number to add to the stack
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
storeInStack:
addi $sp, $sp, -4    #make space in stack
sw $a0, 0($sp)        #save number to bottom of stack
la $t8, 0($sp)
addi $s2, $s2, 1    #stack size counter
li $t3, 0

sort:            #sort stack
beq $s3, $sp, return    #branch if top of stack
lw $t5, 0($sp)        #compare two elements
lw $t6, 4($sp)        
bge $t5, $t6, return    #stop sorting if new element is in correct position in stack
sw $t6, 0($sp)        #swap the numbers
sw $t5, 4($sp)        #swap the numbers
addi $sp, $sp, 4    
b sort

return:
move $sp, $t8        #reset stack pointer
jr $ra            #return to callee

##########################################################################################

# SUBROUTINE bin_Search
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
# registers:
#       $a0: the number to search
#    $a1: lowest index
#    $a2: highest index
#    $v0: Result of the search. 1 if the value was found, 0 if not
#~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
bin_Search:
    addi $sp, $sp, -4    #make space in stack
    sw   $ra, 0($sp)
    
    add $v0,$zero,$zero        
    bgt $a1,$a2,end_BS

    add $t5,$a1,$a2        # t5 = low + high     
    divu $t5,$t5,2        # t5 = low + high / 2     (mid)
    mul $t7,$t5,4        # We mul by 4, each element takes 4 bytes (1 word, 1 element on the stack)
    and $t7,$t7,0xFC

    add $t6,$s7,$t7        #t6 contains the address to obtain s[mid]
    lw $t2,0($t6)
    beq $t2,$a0,equal
    bgt $t2,$a0,greaterThan
    sub $a2,$t5,1
    jal bin_Search
    j end_BS
#lessThan:
greaterThan:
    add $a1,$t5,1
    jal bin_Search

end_BS:
    lw   $ra, 0($sp)                   
    addi $sp, $sp, 4
    jr $ra            #return to callee

equal:
    add $v0,$zero,1
    j end_BS



