#4/13/17
#works with displaying what was previously in the array
#need to use board reader for proper display
#needs a wincheck for the game to end
#doesn't account for scenario of a full board with no wins

#need to display a line telling user player 1 is x,
#player 2 is O

#fell into a infinite loop somewhere
#all i could do was enter which column
.data

ErrorMsg: .asciiz "Error! Incorrect input."
ColMsg: .asciiz "Enter a number between 1 and 7: "
newline: .asciiz "\n"
job: .asciiz "good job"
FullMsg: .asciiz "Sorry this column is full.\n"
Turn: .asciiz "Player's Turn: Player "

x: .asciiz "|X|"
o: .asciiz "|O|"
space: .asciiz "| |"
side_bar: .asciiz "|"
dash: .asciiz "-"

opening_prompt: .asciiz "Welcome to a game of Connect 4!\nConnect 4 pieces in a row to win.\nPlayer 1 is O and Player 2 is X.\nIt is a 6x7 board.\n"
player1_prompt: .asciiz "\nPlayer 1's turn\n"
player2_prompt: .asciiz "\nPlayer 2's turn\n"

compOrTwoPlayer: .asciiz "Choose 1 for comp and 2 for two player"

win_msg: .asciiz "\nPlayer playing won\n"

#create an array of 72 words
board: .word 3,3,3,3,3,3,3,3,3,
	     3,0,0,0,0,0,0,0,3,
	     3,0,0,0,0,0,0,0,3,
	     3,0,0,0,0,0,0,0,3,
	     3,0,0,0,0,0,0,0,3,
	     3,0,0,0,0,0,0,0,3,
	     3,0,0,0,0,0,0,0,3,
	     3,3,3,3,3,3,3,3,3
.text
	la $s0, board		
	li $s4, 1		#start off the game with player 1
welcome:
	
	#Print welcome message
	li $v0, 4		
	la $a0, opening_prompt
	syscall

main:   
	#print a newline
	li $v0, 4		
	la $a0, newline
	syscall
	
	#Prompt for play against comp or two player
	li $v0, 4
	la $a0, compOrTwoPlayer
	syscall
	
	li $v0, 5
	syscall
	
	move $t2, $v0
		li $v0, 1
	move $a0, $t2
	syscall	

	beq $t2, 1, comp
	beq $t2, 2, twoPlayer
	
	
comp:
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
	
	beq $s4, 2, userTurn
	beq $s4, 1, compTurn
	
userTurn:
	#Print prompt message to user
	li $v0, 4		
	la $a0, ColMsg
	syscall
	
	#Get the input from the user
	li $v0, 5
	syscall
	
	#Put input into $t0 			#user input in $t0
	move $t0, $v0
	
	j validCol
compTurn:
	li $v0, 42  	#42 is system call code to generate random int
	li $a1, 7 	#$a1- upper bound of 6. Random int range is 0-6
	syscall		
	
	move $t0, $a0		#move to s0 so a0 is clear
	addi $t0, $t0, 1	#add 1  so the range is between 1 and 7
	
	j Placing
twoPlayer:
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
	
	#Print prompt message to user
	li $v0, 4		
	la $a0, ColMsg
	syscall
	
	#Get the input from the user
	li $v0, 5
	syscall
	
	#Put input into $t0 			#user input in $t0
	move $t0, $v0
	
	#if user entered a number more than 7 or less than 0, go to loop
	#else continue on
validCol:	
	#t1 will hold 7 to check against, $t2 will hold 1
	li $t1, 7
	#li $t2, 1
	
	#conditions to branch
	blt $t0, 1, colLoop		#if less than 0
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
	
	#add 10 first time around, then 9 each other time
	addi $s1, $t0, 10		#s1 holds col + 10
	
	#add 44 to get to the bottom of the board ->basically holding col (11, 12, ..,17) + 44
	#56 -col1, 57 -col2, 58 -col3
	addi $s1, $s1, 44

#add 44 to get bottom row and subtract 9 to traverse to top of row

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
	
	j boardDisplay
	
	beq $ra, 1, displayWinMsg
	
	j changePlayer
	
	#wincheck should jump back to here
changePlayer:
		beq $s4, 1, changeFrom_Player1
		beq $s4, 2, changeFrom_Player2
		
displayWinMsg: 
	li $v0, 4
	la $a0,win_msg
	syscall
	
	li $v0, 10
	syscall
	
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
	
	beq $t2, 1, jumpToComp
	beq $t2, 2, jumpToTwoPlayer
			#jump back to main for valid col again

changeFrom_Player1:
	li $s4, 2
	#j main
	#instead of going to main, display the new board and then go to main
	beq $t2, 1, jumpToComp
	beq $t2, 2, jumpToTwoPlayer

	
changeFrom_Player2:
	li $s4, 1
	#j main
	beq $t2, 1, jumpToComp
	beq $t2, 2, jumpToTwoPlayer

boardDisplay:
			
		li $t3, 0		#starting index 0 in t3 (only once)
	while:
	#use t3- for board display
		
		beq $t3, 292, exit	#max index w/ word align is 288
					#288 + 4 outside of loop
		lw $t4, board($t3)	#now t4 holds the value of array at index t3
		
		#addi $t3, $t3, 4	#update the index in each branch?
		
		#to display a new line
		addi $t5, $zero, 36
		
		div $t3, $t5
		
		mfhi $t6
		
		beq $t6,$zero,print_Line
		
		#branch based on what to display
		beq $t4, 0, print_0
		beq $t4, 1, print_1
		beq $t4, 2, print_2
		
		blt $t3, 36, print_dash		#the 3s on the top row
		bgt $t3, 252, print_dash 	#the 3s on the bottom row
		
		beq $t4, 3, print_3		#the 3s throughout the board
		
		#j while shold never reach here
	
	print_0:
		#if it's 0, print an empty space
		li $v0, 4
		la $a0, space
		syscall
		
		addi $t3, $t3, 4	#update the index in each branch?
		j while
		
	print_1:
		#if it's 1, print an X
		li $v0, 4
		la $a0, x
		syscall
		
		addi $t3, $t3, 4	#update the index in each branch?
		j while
	print_2:
		#if 2, print O
		li $v0, 4
		la $a0, o
		syscall
		
		addi $t3, $t3, 4	#update the index in each branch?
		j while
	print_3:
		#if it's 3, then its a border (the vertical bar)
		li $v0, 4
		la $a0, side_bar
		syscall
		
		addi $t3, $t3, 4	#update the index in each branch?
		j while
	print_dash:
		#if its the top or bottom row, print a dash
		li $v0, 4
		la $a0, dash
		syscall
		
		addi $t3, $t3, 4	#update the index in each branch?
		j while
		
	print_Line:
		li $v0, 4		
		la $a0, newline
		syscall
		
		addi $t3, $t3, 4
		j while
		
			 
	exit:

		jal winCheck
		

		
		beq $s7, 1, displayWinMsg
		beq $s7, 0, changePlayer
	
		#j changePlayer
		
jumpToComp: j comp

jumpToTwoPlayer: j twoPlayer
		
		
winCheck:	
		#addi $t2, $0, 1		# $t2 = i when representing column number
	        addi $t5, $0, 10	# $t5 = i set to 11 (11th pos in array) (row number)
	        srl $s6, $s2, 2
        	sub $s6, $s6, $t0
        	sll $s6, $s6, 2		# $s6 = inLR*4
        	sll $s1, $t0, 2		# $s1 = $t0*4 = inRC multiplied for use in sw functions
	        beq $s4, 1, else	# set $t3 = who based on $s4 = player
        	addi $t3, $0, 2
        	j next1
	
          	else:	addi $t3, $0, 1

next1:	li $t9, 0
	addi $t7, $s6, 0
	addi $t8, $s1, 0
	add $t4, $s0, $t7
	add $t4, $t4, $t8

while1:	lw $t1, ($t4)
	beq $t1, 3, do1
	addi $t4, $t4, 4
	j while1
	
do1:	addi $t4, $t4, -4
	lw $t1, ($t4)
	
	if1:	beq $t1, $t3, then1
	
		else1:	li $t9, 0
			j cond1
		
		then1: 	addi $t9, $t9, 1
			beq $t9, 4, ret1
			
	cond1: 	bne $t1, 3, do1
		j next2

ret1:	li $s7, 1
	jr $ra
      
next2:	li $t9, 0
	addi $t7, $s6, 0
	addi $t8, $s1, 0
	add $t4, $s0, $t7
	add $t4, $t4, $t8

while2:	lw $t1, ($t4)
	beq $t1, 3, do2
      	addi $t4, $t4, 36
	j while2
	
do2:	addi $t4, $t4, -36
	lw $t1, ($t4)
	
	if2:	beq $t1, $t3, else2
	
		else2:	li $t9, 0
			j cond2
		
	  	then2: 	addi $t9, $t9, 1
			beq $t9, 4, ret2
			
	cond2: 	bne $t1, 3, do2
		j next3

ret2:	li $s7, 1
	jr $ra
  
next3:	li $t9, 0
	addi $t7, $s6, 0
	addi $t8, $s1, 0
	add $t4, $s0, $t7
      	add $t4, $t4, $t8

while3:	lw $t1, ($t4)
	beq $t1, 3, do3
	addi $t4, $t4, 40
	j while3
	
do3:	addi $t4, $t4, -40
	lw $t1, ($t4)
	
	if3:	beq $t1, $t3, then3
	
		else3:	li $t9, 0
			j cond3
		
		then3: 	addi $t9, $t9, 1
			beq $t9, 4, ret3
			
	cond3: 	bne $t1, 3, do3
		j next4

ret3:	li $s7, 1
	jr $ra

next4:	li $t9, 0
	addi $t7, $s6, 0
	addi $t8, $s1, 0
	add $t4, $s0, $t7
	add $t4, $t4, $t8

while4:	lw $t1, ($t4)
	beq $t1, 3, do4
	addi $t4, $t4, 32
	j while4
	
do4:	addi $t4, $t4, -32
	lw $t1, ($t4)
	
	if4:	beq $t1, $t3, then4
	
		else4:	li $t9, 0
			j cond4
		
		then4: 	addi $t9, $t9, 1
			beq $t9, 4, ret4
			
	cond4: 	bne $t1, 3, do4
		j end

ret4:	li $s7, 1
	jr $ra

end:	addi $s7, $0, 0			# return false
	jr $ra
