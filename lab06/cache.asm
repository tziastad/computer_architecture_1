
	.data
array:
	.space	2048
	
	.text
main:

# Supply values for array size, step size, and repetition count.
# arraysize must be a positive power of 2, less than or equal the number of bytes
#   allocated for "array".
# summary of register use:
#  $s0 = array size
#  $s3 = number of times to repeat
#  $s5 = index in bytes
#  $s6 = &array[index/4]
	
    li     $s0, 32	# array size
    li     $s3, 1	# rep count

	
outerloop:
    # loop initialization: $s5 contains index, $s6 contains &array[index]
    add	   $s5, $0, $0
    la	   $s6, array

innerloop:
    # array[index] += 1
    lw     $t0, 0($s6)
    addi   $t0, $t0, 1
    sw     $t0, 0($s6)
	
    # inner loop done?
    addiu  $s5, $s5, 1
    addiu  $s6, $s6, 4
    bne    $s5, $s0, innerloop
	
    addi   $s3, $s3,   -1
    bne    $s3, $zero, outerloop
		
    li     $v0, 10
    syscall
