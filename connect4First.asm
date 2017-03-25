   .data

xs: .asciiz "|X|"
os: .asciiz "|O|"
blank: .asciiz "| |"
space: .asciiz "||"
.text
.globl boardReader
boardReader:

	addi $t0, $t0, 10 #set $t0 = i = 10th position
	addi $t1, $t1, 62 #set $t1 = max = 64th position
	addi $s0, $s0, 1 #to update i
	
	#print '||'	
	li $v0, 4 
	la $a0, space
	syscall
	
	beq $t0, $0, printBlank
	beq $t0, 1, printX
	beq $t0, 2, printO
	beq $t0, $t1, exit

	j exit
	
printX:	li $v0, 4
	la $a0, xs
	syscall	
	
	add $t0, $t0, $s1
	
	j boardReader
	
printO:	li $v0, 4
	la $a0, os
	syscall	
	
	add $t0, $t0, $s1
	
	j boardReader
	
printBlank:	li $v0, 4
		la $a0, blank
		syscall

		add $t0, $t0, $s1
			
		j boardReader
		
exit:	li $v0, 10
	syscall

	
	
