.data
space: .asciiz " "

.text
	li $t0, 1	#for displayy purpose- t0 is initialized loop control variable

while:
	li $v0, 42  	#42 is system call code to generate random int
	li $a1, 7 	#$a1- upper bound of 6. Random int range is 0-6
	syscall		
	
	move $s0, $a0		#move to s0 so a0 is clear
	addi $s0, $s0, 1	#add 1  so the range is between 1 and 7
		
	li $v0, 1   		#display $a0 which is holding the random number
	move $a0, $s0
	syscall
	
########################################### For display purposes
	#print a space
	li $v0, 4		
	la $a0, space
	syscall
	
	#loop control variable only used so i can see what's being generated
	addi $t0, $t0, 1
	bne $t0, 50, while
	
##########################################  FOR DISPLAY PURPOSE