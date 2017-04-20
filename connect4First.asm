.data

#columnInput: .asciiz "\nEnter a column between 1 and 7:\n"
column: .word 
x: .asciiz "|X|"
o: .asciiz "|O|"
space: .asciiz "| |"
border: .asciiz "-"
newLine: .asciiz "\n"
board: .word 3,3,3,3,3,3,3,3,3,3,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,3,3,0,0,0,0,0,0,0,3,3,3,3,3,3,3,3,3,3
#play1: .word 1
#play2: .word 2
#temp: .asciiz "NL"
ErrorMsg: .asciiz "Error! Incorrect input."
ColMsg: .asciiz "Enter a number between 1 and 7: "
newline: .asciiz "\n"
job: .asciiz "good job"
FullMsg: .asciiz "Sorry this column is full.\n"
Turn: .asciiz "Player's Turn: Player "
.text
	la $s0, board		
	li $s4, 1		#start off the game with player 1
main:
	jal boardReader
	
	addi $t0, $zero, 0 #end = 0
	
	while1:
		beq $t0, 1, exit1 #if end is reached
		
		#print statement for whose turn
		li $v0, 4		
		la $a0, Turn
		syscall
	
		#print the player number
		li $v0, 1
		move $a0, $s4
		syscall
	
		#print a newline twice
		li $v0, 4		
		la $a0, newline
		syscall
	
		li $v0, 4		
		la $a0, newline
		syscall
		
		li $v0, 4
		la $a0, ColMsg
		syscall
		
		li $v0, 5
		syscall
		
		
		move $t0, $v0 # t0 has the column as an argument
		
		#addi $a1, $a1, 1
		
		j validCol
		
		
		jal boardReader
		
		addi $t0, $zero, 1 
		
		j while1
		
	exit1:
	li $v0, 10 #End of the program
	syscall
	
validCol:	
	#t1 will hold 7 to check against, $t2 will hold 1
	li $t1, 7
	li $t2, 1
	
	#conditions to branch
	blt $t0, $t2, colLoop		#if less than 0
	bgt $t0, $t1, colLoop		#if more than 7
	
	#jump to placing based on valid column number when finished checking between 1-7
	j Placing
	
	#validation loop - until user enters a valid col number
	
colLoop:
	#Print prompt message to user
	li $v0, 4		
	la $a0, ErrorMsg
	syscall
	
	#Print prompt message to user
	li $v0, 4		
	la $a0, newline
	syscall
	
	#Print prompt message to user
	li $v0, 4		
	la $a0, ColMsg
	syscall
	
	#Get the user's input
	li $v0, 5
	syscall
	
	#Move from v0 to new t0
	move $t0, $v0
	j validCol
	
Placing:
####################################
#sample printing the user input which is in t0
	#li $v0, 1
	#move $a0, $t0
	#syscall
#sample print end
####################################	
	
	#add 10 first time around, then 9 each other time
	addi $s1, $t0, 10		#s1 holds col + 10
	
	#add 44 to get to the bottom of the board ->basically holding col (11, 12, ..,17) + 44
	#56 -col1, 57 -col2, 58 -col3
	addi $s1, $s1, 44

#add 44 to get bottom row and subtract 9 to traverse to top of row

	#word align this index and check
	j check

check:
#check what the value is at that index
	sll $s2, $s1, 2		#s2-index *4 for word aligned
	add $s3, $s0, $s2	#add new offset to starting address
				#new address now in $s3
				
	lw $s5, 0($s3)		#load what was in this address to s5
	
	#####Display
	li $v0, 1
	move $a0, $s5
	syscall
	
	beq $s5, 0, put
	beq $s5, 1, next
	beq $s5, 2, next
	beq $s5, 3, Full
	
	###### for testing only #######
	#bne $s5, 0, Full
	##############
	
#	j put_Col1
put:
###############################################################################
#places the value into the array				
				#base address is in s0
				#s2-index
	#sll $s2, $s2, 2		#s2-index *4 for word aligned
	#add $s3, $s0, $s2	#add new offset to starting address
	sw $s4, 0($s3)		#s3 is the address
###############################################################################
	#Print prompt message to user
	li $v0, 4		
	la $a0, job
	syscall
	
	j winCheck
	#wincheck should jump back to here
	beq $s4, 1, changeFrom_Player1
	beq $s4, 2, changeFrom_Player2
	
next:
	#subtract 9 from s1 to get to the position immediately above
	addi $s1, $s1, -9	
	#sll $s2, $s1, 2		#word align the offset
	#add $s3, $s2, $s0	#add the offset to the base address
	j check
Full:
	#statement that this is full
	li $v0, 4		
	la $a0, FullMsg
	syscall
	
	j main			#jump back to main for valid col again

changeFrom_Player1:
	li $s4, 2
	j main
	
changeFrom_Player2:
	li $s4, 1
	j main

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


winCheck:
	addi $t2, $0, 1		# $t2 = i when representing column number
	addi $t5, $0, 10	# $t5 = i set to 11 (11th pos in array) (row number)
	addi $t6, $0, 64	# $t6 set to max value for loop
	srl $s4, $s2, 2
	sub $s4, $s4, $t0
	sll $s4, $s4, 2		# $s4 = inLR
	sll $s1, $t0, 2		# $s1 = $a1*4 = inRC multiplied for use in sw functions
	bne $a2, $0, else	# set $t3 = who based on $a2 = player
	addi $t3, $0, 1
	j for1
	
else:	add $t3, $0, $0

for1:	beq $t2, 8, next1
	sll $t2, $t2, 2
	
	if1:	add $t7, $t2, $s4
		add $t8, $t7, $s0
		lw $t8, 0($t8)
		beq $t8, $t3, then1
		
		else1: 	li $t9, 0	# $t9 = count
			j if2
		then1: 	addi $t9, $t9, 1
		
		if2: beq $t9, 4, then2
			
			else2:	srl $t2, $t2, 2
				addi $t2, $t2, 1
				j for1
			then2:	addi $v0, $0, 1
				jr $ra
	
next1:	li $t9, 0

for2: 	beq $t5, 64, next2
	sll $t5, $t5, 2
	
	if3:	add $t7, $t5, $s1
		add $t8, $t7, $s0
		lw $t8, 0($t8)
		beq $t8, $t3, then3
		
		else3: 	li $t9, 0
			j if4
		then3:	addi $t9, $t9, 1
		
		if4: beq $t9, 4, then4
		
			else4:	srl $t5, $t5, 2
				addi $t5, $t5, 9
				j for2
			then4:	li $v0, 1
				jr $ra

next2:	li $t9, 0
	addi $t7, $s4, 0
	addi $t8, $s1, 0
	add $t0, $s0, $t7
	add $t0, $t0, $t8

while4:	lw $t1, ($t0)
	beq $t1, 3, do1
	addi $t0, $t0, 40
	j while4
	
do1:	addi $t0, $t0, -40
	lw $t1, ($t0)
	
	if5:	beq $t1, $t3, then5
	
		else5:	li $t9, 0
			j cond1
		
		then5: addi $t9, $t9, 1
			
	cond1: bne $t1, 3, do1

if6:	bne $t9, 4, next3
	li $v0, 1
	jr $ra

next3:	li $t9, 0
	addi $t7, $s4, 0
	addi $t8, $s1, 0
	add $t0, $s0, $t7
	add $t0, $t0, $t8

while5:	lw $t1, ($t0)
	beq $t1, 3, do2
	addi $t0, $t0, 32
	j while5
	
do2:	addi $t0, $t0, -32
	lw $t1, ($t0)
	
	if7:	beq $t1, $t3, then7
	
		else7:	li $t9, 0
			j cond2
		
		then7: addi $t9, $t9, 1
			
	cond2: bne $t1, 3, do1

if8:	bne $t9, 4, end
	li $v0, 1
	jr $ra

end:	addi $v0, $0, 0			# return false
	jr $ra
