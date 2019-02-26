In Project 4, the objective was to create a priority queue using the stack with user inputs. By creating a binary search method will it be utilized properly to find specific experiments.

In our .data we initialize different prompts to specify user inputs and create distinct responses for case scenarios.
Our program entry starts off initializing $t1 (loop counter) and $s0 (stack counter) with 0. By saving the position of the stack pointer ($sp) to frame pointer ($fp) does it allow the starting point of the stack to be saved. Then we prompt the user for a number of values to enter, where this particular value (n) will be utilized in our loop method. This value is moved to register $t0 to avoid missing or replaced data. 

In our loop function, we define an exiting statement by branching to printValue, once register $t1 (our loop counter) is greater than or equal to $t0 (n). Otherwise, we will keep prompting the user for values to store in our stack. By doing so, our loop will continue iterating in appropriate amounts with respect to the user's input of n. Once the user's input of value is received, we move that value from $v0 to $a0, and immediately jump to the function storeValue, while saving the return address into $ra. Then $t1 is increased by one, as its function is an iterator, and continues the loop. 

In our storeValue function, we aim to store the value received from the user into the stack in its respectful location. We begin by making space in the stack and saving the bottom address of the number into the register $a0. We also save the address to restore later into $s7. Our stack counter is incremented by one. 
In our sortStack, it is defined by a branching statement utilizing $fp and $sp. If the two are equal, then it will branch to the return function. We loaded $t2 and $t3 with the value from $sp respectively. Also, if $t2 is greater or equal to $t3, then it will branch to the return function. This is because we need to stop sorting if the new element is already correctly placed. If not, the loop will continue. We swap if $t2 is greater than $t3. Then we restore stack pointer and continue looping.

In our return method, we restore the stack pointer and return to our $ra address, where it goes back into loop and iterates respectively to the user's n. 

In our printValue method, we prompt our user to enter a value to search (specifications for smallest or largest value would be here). We take the user input and move it from $v0 to $s1. Then we jump to searchSetup, saving the next instruction's address into $ra. 

In our function searchSetup, we prepare s registers for search. We define register $s3 with $sp, specifying it with the address of the high value. Similarly, we define $s4 with $fp, making it hold the address of the lowest value. We define $s0 with $s2, the size of the unchecked stack. 
In our search method, we aim to go through our list to find a specific value. If $s0 is equal to 0, then branch to false. This is due to the understanding that if $s0 cannot shift left anymore, all the numbers have been evaluated and branches accordingly. We shift right and save that value in $s0, essentially having $s0/2. Then we multiply $s0 by 4. Following that, we add $s3 with $s0 into $a0, and change $sp into $a0, making it the new address holder that $sp contains. We then load the value of the current middle of the binary search to $t2. If $t2 is equal to $s1, then branch to true. if $t2 is less than $s1, then branch to smallerMid. We move down the stack and sets it as the new highest value, and loop continuously until one of the branch statements are met.

In our smallerMid function, it moves up the stack once and sets a new lowest value. We then shift $s0 back by having s0/4 and jump back into the search loop. 

In our true function, we load $a0 as 1 and jump to return.

In our false function, we set $a0 as 0 and directly go into the return statement, which returns back printValue, where an if statement compares $a0 and 0. If it proves to be true, we branch to found. Otherwise, we load a false message that has been stated in .data and exits the program.

In our found method, we load a true message that has been specified in .data and continue to our exit function, where we terminate the program.
