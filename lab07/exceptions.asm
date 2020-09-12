###############################################################################
# Simple exception handling in Mips. 
###############################################################################


###############################################################################
# USER TEXT SEGMENT
###############################################################################

	.globl main
	.text
main:
       	# The largest 32 bit positive two's complement number.
	li $s0, 0x7fffffff  
	
	# Trigger an arithmetic overflow exception. 
	addi $s1, $s0, 1
	
	# Trigger a bad data address (on load) exception.
	lw $s0, 0($zero)
	
	# Trigger a trap exception. 
	teqi $zero, 0

infinite_loop: 
	# This will cause an exception if you leave it running for too long.
	addi $s0, $s0, 1
	j infinite_loop


###############################################################################
# KERNEL DATA SEGMENT
###############################################################################

	.kdata
		
UNHANDLED_EXC_MSG:	.asciiz "===>UNHANDLED EXCEPTION<==========\n\n"
OVERFLOW_MSG: 		.asciiz "===>ARITHMETIC OVERFLOW<==========\n\n" 
TRAP_MSG: 			.asciiz "===>TRAP EXCEPTION<===============\n\n"
BAD_ADDRESS_MSG: 	.asciiz "===>BAD DATA ADDRESS EXCEPTION<===\n\n"
		
###############################################################################
# KERNEL TEXT SEGMENT 
# 
# For simplicity, this kernel will not save and retore any register values. 
# It will use $k0, $k1.
#
# Note, that if the kernel uses any pseudo instruction that translates 
# to instructions using $at, this may interfere with  user level programs 
# using $at. In a real system, the kernel must  also save and restore the 
# value of $at. 
###############################################################################

   	# The exception handler address for MIPS
   	.ktext 0x80000180  
   
__handler_entry:

	mfc0 $k0, $13   # Get Cause register
	andi $k1, $k0, 0x00007c  # Keep the exception code (bits 2 - 6).
	srl  $k1, $k1, 2
	# For simplicity, we don't check for interrupts (k == 0)
__exception:
	# Branch on value of the the exception code in $k1. 
	addi $at, $zero, 12
	beq  $k1, $at, __overflow_exception
	
	###############################################################################
	addi $at, $zero, 4
	beq  $k1,$at, __bad_address_exception
	addi $at,$zero,13
	beq  $k1,$at,__trap_exception
	###############################################################################
	
__unhandled_exception: 
  	#  Use the MARS built-in system call 4 (print string) to print error messsage.
	li $v0, 4
	la $a0, UNHANDLED_EXC_MSG
	syscall
 
 	j __resume_from_exception
	
__overflow_exception:
  	#  Use the MARS built-in system call 4 (print string) to print error messsage.
	li $v0, 4
	la $a0, OVERFLOW_MSG
	syscall
 
 	j __resume_from_exception
 	
	###############################################################################
__bad_address_exception:
	
	 li $v0,4
	 la $a0, BAD_ADDRESS_MSG
	 syscall
	 j __resume_from_exception
	 
	 
__trap_exception:
	
	li $v0,4
	la $a0, TRAP_MSG
	syscall
	j __resume_from_exception
	###############################################################################


__resume_from_exception: 
	
	# When an exception or interrupt occurs, the value of the program counter 
	# ($pc) of the user level program is automatically stored in the exception 
	# program counter (ECP), the $14 in Coprocessor 0. 
	mfc0 $k0,$14
	addi $k0,$k0,4
	mtc0 $k0,$14
	
    
	

__resume:
	# Use the eret (Exception RETurn) instruction to set the program counter
	# (PC) to the value saved in the ECP register (register 14 in coporcessor 0).
	
	eret # Look at the value of $14 in Coprocessor 0 before single stepping.
	

