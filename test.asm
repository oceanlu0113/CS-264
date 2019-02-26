# Program 2: Bianry Search Tree in MIPS

.data

buffer: .space 4

space:    .asciiz " "

println:    .asciiz    "\n"

i:    .asciiz " is the number we want to insert.\n"

p:    .asciiz "Print something\n"

d:    .asciiz " is the number we want to delete.\n"

q:    .asciiz "Quit\n\n"

CMD:    .asciiz    "Input command (I,P,D,Q,O): "

input:    .asciiz    "Input inputeger: "

result:    .asciiz    "The result is: "

error:    .asciiz    "Please input a valid command.\n"

.text

main:

li $s2, 0 # $s2 = the sentinel value.

move $a0, $s2 # value = $s2

li $a1, 0 # left = NULL

li $a2, 0 # right = NULL

jal node_create # call node_create

move $s0, $v0 # and put the result inpu to $s0.

input_loop:

li    $v0, 4

la    $a0, CMD

syscall

li $v0, 8

la $a0, buffer

li $a1, 4

syscall

lb $t1, 0($a0)

li $t3, 'O'

li $t4, 'D'

li $t5, 'I'

li $t6, 'P'

li $t7, 'Q'

beq $t1, $t4, input_integer

beq $t1, $t5, input_integer

beq $t1, $t6, print_input

beq $t1, $t3, print_input     

beq $t1, $t7, exit

b err

input_integer:

li    $v0, 4

la    $a0, input

syscall

li    $v0, 5

syscall

move    $t2, $v0

beq $t1, $t4, delete

beq $t1, $t5, insert

delete:

li    $v0, 1

move    $a0, $t2

syscall

li    $v0, 4

la    $a0, d

syscall

#delete

b input_loop

insert:

# li $v0, 5 # read the input integer

# syscall

move $s1, $t2 # set $s1 as the integer inserted

# beq $s1, $s2, end_input # if $s2 is equal to $s1 then break the loop

# tree_insert (number, root);

move $a0, $s1 # number= $s1

move $a1, $s0 # root = $s0

jal tree_insert # call tree_insert.

b input_loop # repeat the input_loop.

err:

li    $v0, 4

la    $a0, error

syscall

b input_loop

print_input:

## Step 3: print out the left and right subtrees.

lw $a0, 4($s0) # print out the roots of the left child.

jal tree_print_input

lw $a0, 8($s0) # print out the roots of the right child.

jal tree_print_input

b input_loop # exit.

## end of main.

b input_loop

node_create:

# set up the stack:

subu $sp, $sp, 32

sw $ra, 28($sp)

sw $fp, 24($sp)

sw $s0, 20($sp)

sw $s1, 16($sp)

sw $s2, 12($sp)

sw $s3, 8($sp)

addu $fp, $sp, 32

# capture the parameters:

move $s0, $a0 # $s0 = value

move $s1, $a1 # $s1 = left

move $s2, $a2 # $s2 = right

li $a0, 12 # it needs 12 bytes for a new node.

li $v0, 9 # sbrk is syscall 9.

syscall

move $s3, $v0

beqz $s3, ERRORMEM

sw $s0, 0($s3) # node->number = number

sw $s1, 4($s3) # node->left = left

sw $s2, 8($s3) # node->right = right

move $v0, $s3 # put return value input into v0.

# release the stack frame:

lw $ra, 28($sp) # restore the Return Address.

lw $fp, 24($sp) # restore the Frame Poinputer.

lw $s0, 20($sp) # restore $s0.

lw $s1, 16($sp) # restore $s1.

lw $s2, 12($sp) # restore $s2.

lw $s3, 8($sp) # restore $s3.

addu $sp, $sp, 32 # restore the Stack Poinputer.

jr $ra # return.

## end of node_create.

## tree_insert (value, root): make a new node with the given value

## Register usage:

## $s0 - value

## $s1 - root node

## $s2 - a new node

## $s3 - a pointer for the root to the assigned value (root_value)

## $s4 - temporary pointer

tree_insert: # set up the stack frame:

subu $sp, $sp, 32

sw $ra, 28($sp)

sw $fp, 24($sp)

sw $s0, 20($sp)

sw $s1, 16($sp)

sw $s2, 12($sp)

sw $s3, 8($sp)

sw $s3, 4($sp)

addu $fp, $sp, 32

# grab the parameters:

move $s0, $a0 # $s0 = value

move $s1, $a1 # $s1 = root

# make a new node:

# new_node = node_create (value, 0, 0);

move $a0, $s0 # value = $s0

li $a1, 0 # left = 0

li $a2, 0 # right = 0

jal node_create # call node_create

move $s2, $v0 # save the result.

SLOOP:

lw $s3, 0($s1) # root_value = root->value;

ble $s0, $s3, SLEFT # if (valueue <= s3) goto SLEFT;

b SRIGHT # goto SRIGHT;

SLEFT:

lw $s4, 4($s1) # ptr = root->left;

beqz $s4, add_left # if (ptr == 0) goto add_left;

move $s1, $s4 # root = ptr;

b SLOOP # goto SLOOP;

add_left:

sw $s2, 4($s1) # root->left = new_node;

b end_SLOOP # goto end_SLOOP;

SRIGHT:

lw $s4, 8($s1) # ptr = root->right;

beqz $s4, add_right # if (ptr == 0) goto add_right;

move $s1, $s4 # root = ptr;

b SLOOP # goto SLOOP;

add_right:

sw $s2, 8($s1) # root->right = new_node;

b end_SLOOP # goto end_SLOOP;

end_SLOOP:

# release the stack frame:

lw $ra, 28($sp) # restore the Return Address.

lw $fp, 24($sp) # restore the Frame Pointers.

lw $s0, 20($sp) # restore $s0.

lw $s1, 16($sp) # restore $s1.

lw $s2, 12($sp) # restore $s2.

lw $s3, 8($sp) # restore $s3.

lw $s4, 4($sp) # restore $s4.

addu $sp, $sp, 32 # restore the Stack Pointers.

jr $ra # return.

## end of node_create.

## Do an inorder traversal of the tree, printing out each value.

## Register usage:

## s0 - the tree.

tree_print_input:

# set up the stack frame:

subu $sp, $sp, 32

sw $ra, 28($sp)

sw $fp, 24($sp)

sw $s0, 20($sp)

addu $fp, $sp, 32

# grab the parameter:

move $s0, $a0 # $s0 = tree

beqz $s0, tree_print_input_end # if tree == NULL, then return.

lw $a0, 4($s0) # recurse left.

jal tree_print_input

# prinput the value of the node:

lw $a0, 0($s0) # prinput the value, and

li $v0, 1

syscall

la $a0, println # also prinput a println.

li $v0, 4

syscall

lw $a0, 8($s0) # recurse right.

jal tree_print_input

tree_print_input_end: # clean up and return:

lw $ra, 28($sp) # restore the Return Address.

lw $fp, 24($sp) # restore the Frame Poinputer.

lw $s0, 20($sp) # restore $s0.

addu $sp, $sp, 32 # restore the Stack Poinputer.

jr $ra # return.

## end of tree_print_input.

tree_print_input2:

# set up the stack frame:

subu $sp, $sp, 32

sw $ra, 28($sp)

sw $fp, 24($sp)

sw $s0, 20($sp)

addu $fp, $sp, 32

# grab the parameter:

move $s0, $a0 # $s0 = tree

beqz $s0, tree_print_input_end # if tree == NULL, then return, if not conintue.

lw $a0, 8($s0) # recurse to the left of the tree.

jal tree_print_input2

# prinput the value of the node:

lw $a0, 0($s0) # prinput the value, and

li $v0, 1

syscall

la $a0, println # also prinput a println.

li $v0, 4

syscall

lw $a0, 4($s0) # recurse to the right of the tree.

jal tree_print_input2

tree_print_input_end2: # clean up and return:

lw $ra, 28($sp) # restore the Return Address.

lw $fp, 24($sp) # restore the Frame Pointer.

lw $s0, 20($sp) # restore $s0.

addu $sp, $sp, 32 # restore the Stack Pointer.

jr $ra

# end of tree_print_input.

# The routine to call when sbrk fails; It will jump to exit the program.

ERRORMEM:

la $a0, ERRORMEM_MSG

li $v0, 4

syscall

j exit

## The routine to call to exit the program.

exit:

li $v0, 10

syscall

## exit the program

## Here is where the data for this program is stored:

.data

ERRORMEM_MSG: .asciiz "Out of memory!\n"

## end of BinarySearchTree.asm