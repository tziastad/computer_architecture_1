# Count occurencies of chars in string
#   coded in  MIPS assembly using MARS
# for MYΥ-505 - Computer Architecture, Fall 2019
# Department of Computer Engineering, University of Ioannina
# Instructor: Aris Efthymiou

        .globl countChar # declare the label as global for munit
        
###############################################################################
        .data
string:    .asciiz "Lets see how many times each char shows up in this one."
           .align 4   # Makes sure the next word is aligned.
counters:  .word 0 : 256   # 256 words all initialised to 0

###############################################################################
        .text 
# label main freq. breaks munit, so it is removed...
        la         $a0, string
        la         $a1, counters
countChar:
###############################################################################
		lbu     $t0 , 0($a0)   		#load byte from a0
		beq 	$t0, $zero, exit	# while ($t0==0) exit
		sll		$t1,$t0,2			#t1=t0*4
		add		$t1,$t1,$a1			#t1=a1[t1]
		lw		$t2,0($t1)			#t2 gets the value of t1
		addi	$t2,$t2,1			#update the counter
		sw		$t2,0($t1)			#store the counter
		addiu 	$a0, $a0,1  		# address of next byte
		j 		countChar
###############################################################################
exit:
        addiu      $v0, $zero, 10    # system service 10 is exit
        syscall                      # we are outta here.


