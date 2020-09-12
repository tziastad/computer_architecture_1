# Lab03 - odd parity for a single word and an array of 32 words
# for MYY505 - Computer Architecture, fall 2019
# Aris Efthymiou
# Department of Computer Engineering, University of Ioannina


        .globl parity, blockParity # declare the labels as global. 
        
        .data
array:
        .word 0x80000000, 0x00000000, 0xc0001111, 0x88880008, 0x50000005, 0x44444444, 0xaaaa777c, 0x9d9d0009, 
              0x90000000, 0x00010000, 0xb0001111, 0x88880108, 0xc0000005, 0x44444445, 0x55557777, 0x9d9d0008, 
              0x80000000, 0x00000000, 0xc0001111, 0x88880008, 0x50000005, 0x44444444, 0xaaaa777c, 0x9d9d0009, 
              0x90000000, 0x00010000, 0xb0001111, 0x88880108, 0xc0000005, 0x44444445, 0x55557777, 0x9d9d0008, 
# parities:
#           1, 0, 0, 1, 0, 0, 1, 0,
#           0, 1, 1, 0, 0, 1, 0, 1,
#           1, 0, 0, 1, 0, 0, 1, 0,
#           0, 1, 1, 0, 0, 1, 0, 1,
#  result 0x92659265

        .text  
     
        li   $a0, 0x1000
        jal  parity
        la   $a0, array
        jal  blockParity
        li   $v0, 10
        syscall

parity:
###################################################################################
	
		add		$t0,$zero,$zero		#parity initialization
		add		$t9,$zero,$a0
loop:

		andi	$t2,$t9,1		#$t2 gets the lsb of a0
		beq		$t9,$zero,parityBit	#	while $t9!=0
		slti	$t3,$t2,1		#test if $t2<1
		beq		$t3,$zero,else	#while	$t3!=0
		srl		$t9,$t9,1		#shift right logical $t9 to get next bit
		j		loop	
		
else:
								#odd parity
		xori	$t0,$t0,1		#invert parity
		srl		$t9,$t9,1		#shift right logical $t9 to get next bit
		j		loop
		
parityBit:

		andi	$v0,$t0,1		#store the parity bit at the lsb of $v0

			
		
###################################################################################
        jr   $ra

blockParity:
###################################################################################
		addi	$sp,$sp,-4		#make room for the a thing in stack
		sw		$ra,0($sp)		#pUsh $ra in the stack
		add		$t8,$zero,$a0	#get its number of the array
		addi	$t6,$zero,32	#t6=32

forLoop:
		
		beq 	$t6,$zero,exit	#while t6!=32
		lw		$a0,0($t8)		#$a0 gets the first word of t8
		jal 	parity			#call the parity
		sw		$v0,0($t8)		#store the parity bit at first word of t8
		addi	$t6,$t6,-1		#$t6=$t6-1
		addi	$t8,$t8,4		#t8 gets the next word
		j		forLoop

exit:
		addi	$t8,$t8,-128	#$t8 goes again at the first word of the array
		add		$v0,$zero,$zero	#v0 initialization
		addi	$t5,$zero,32	#t5=32
loop1:
		beq	$t5,$zero,return
		lw	$t7,0($t8)		#$t7 gets the first word of $t8(t8 has the parity bit of each word of the array)
		sll	$v0,$v0,1		#shift left logical $v0
		add	$v0,$v0,$t7		#$v0=$v0+$t7
		addi	$t5,$t5,-1	#$t5=$t5-1
		addi	$t8,$t8,4	#t8 gets the next word
		j 		loop1
		
		
		
		
		
		
return:		
	
		lw		$ra,0($sp)	#pop $ra of the stack
		addi	$sp,$sp,4	#adjust stack to delete 1item
		
		
###################################################################################
        jr   $ra
