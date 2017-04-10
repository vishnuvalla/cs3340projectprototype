.data

columnInput: .asciiz "\nEnter a column between 1 and 7:\n"
column: .word 
x: .asciiz "|X|"
o: .asciiz "|O|"
space: .asciiz "| |"
border: .asciiz "-"
newLine: .asciiz "\n"
board: .word 3,3,3,3,3,3,3,3,3,3,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,3,3,3,3,3,3,3,3,3,3
play1: .word 1
play2: .word 2
temp: .asciiz "NL"
.text

main:
	jal boardReader
	
	addi $t0, $zero, 0 #end = 0
	
	while1:
		beq $t0, 1, exit1 #if end is reached
		
		li $v0, 4
		la $a0, columnInput
		syscall
		
		li $v0, 5
		syscall
		
		
		move $a0, $v0 # a0 has the column as an argument
		
		addi $a1, $a1, 1
		
		
		jal placer
		
		
		jal boardReader
		
		addi $t0, $zero, 1 
		
		j while1
		
	exit1:
	li $v0, 10 #End of the program
	syscall


boardReader:
	addi $t0, $zero, 0 #clear t0
	addi $t1, $zero, 0 #clear t1
	addi $t2, $zero, 0 #clear t2
	addi $t3, $zero, 0 #clear t3
	
	addi $t3, $zero, 9
	la $t1, board  #get array address
	
	#i=0 Set loop counter
	addi $t0, $zero, 0
	
	
	while2:
		bgt $t0, 71, exit
		
		lw $t2, ($t1) #First element in t2
		
		div $t0, $t3
		mfhi $t4
		beq $t4, 0, printNL
		
		beq $t2, 0, printSpace
		beq $t2, 1, printX
		beq $t2, 2, printO
		beq $t2, 3, printBorder
		
	printX:
		li $v0, 4
		la $a0, x
		syscall
		
		addi $t0, $t0, 1 #i++ Advance loop counter
		addi $t1, $t1, 4 #advance array pointer
		
		j while2
	printO:
		li $v0, 4
		la $a0, o
		syscall
		
		addi $t0, $t0, 1 #i++ Advance loop counter
		addi $t1, $t1, 4 #advance array pointer
		
		j while2
	printSpace:
		li $v0, 4
		la $a0, space
		syscall
		
		addi $t0, $t0, 1 #i++ Advance loop counter
		addi $t1, $t1, 4 #advance array pointer
		
		j while2
	printBorder:
		li $v0, 4
		la $a0, border
		syscall
		
		addi $t0, $t0, 1 #i++ Advance loop counter
		addi $t1, $t1, 4 #advance array pointer
		
		j while2
	printNL:
		li $v0, 4
		la $a0, newLine
		syscall
		
		addi $t0, $t0, 1 #i++ Advance loop counter
		addi $t1, $t1, 4 #advance array pointer
		
		j while2
	exit:
		jr $ra


placer:
	addi $t0, $zero, 0 #clear t0
	addi $t1, $zero, 0 #clear t1
	addi $t2, $zero, 0 #clear t2
	addi $t3, $zero, 0 #clear t3
	addi $t4, $zero, 0 #clear t4
	addi $t5, $zero, 0 #clear t5
	
	#the column is in a0
	
	li $v0, 1
	la $a0, ($a0)
	syscall
	
	la $s0, board
	
	add $t6, $zero, $a1 #player is 1
	
	li $v0, 1
	la $a0, ($t6)
	syscall
	
	#to accessthe element in the position
	addi $t0, $a0, 54
	sll $t0, $t0, 2
	add $t0, $t0, $s0
	
	addi $t1, $a0, 45
	sll $t1, $t1, 2
	add $t1, $t1, $s0
	
	addi $t2, $a0, 54
	sll $t2, $t2, 2
	add $t2, $t2, $s0
	
	addi $t3, $a0, 54
	sll $t3, $t3, 2
	add $t3, $t3, $s0
	
	addi $t4, $a0, 54
	sll $t4, $t4, 2
	add $t4, $t4, $s0
	
	addi $t5, $a0, 54
	sll $t5, $t5, 2
	add $t5, $t5, $s0
	
	
	
	#place in the correct position
	lw $s1, ($t0)
	
	beq $s1, 0, place1
	
	addi $s1, $zero, 0
	
	lw $s1, ($t1)
	
	beq $s1, 0, place2
	
	addi $s1, $zero, 0
	
	lw $s1, ($t2)
	
	beq $s1, 0, place3
	
	addi $s1, $zero, 0
	
	lw $s1, ($t3)
	
	beq $s1, 0, place4
	
	addi $s1, $zero, 0
	
	lw $s1, ($t4)
	
	beq $s1, 0, place5
	
	addi $s1, $zero, 0
	
	lw $s1, ($t5)
	
	beq $s1, 0, place6
	
	addi $s1, $zero, 0
	
	
	place1: 
		add $v0, $zero, $t0
		lw $s1, play1
		sw $s1, ($t0)
		
		
		
		j exit3  
	
	place2: 
		add $v0, $zero, $t1
		lw $s1, play1
		sw $s1, ($t1)
		j exit3  
		
	place3: 
		add $v0, $zero, $t2
		lw $s1, play1
		sw $s1, ($t2)
		j exit3
		
	place4: 
		add $v0, $zero, $t3
		lw $s1, play1
		sw $s1, ($t3)
		j exit3
		
	place5: 
		add $v0, $zero, $t4
		lw $s1, play1
		sw $s1, ($t4)
		j exit3
		
	place6: 
		add $v0, $zero, $t5
		lw $s1, play1
		sw $s1, ($t5)
		j exit3
	
	
	
	exit3:
		jr $ra


winCheck:
