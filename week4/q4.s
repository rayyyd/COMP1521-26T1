	.text

MAP_SIZE = 5
N_POINTS = 4


main:
main__for_init:
	li	$t0, 0
main__for_cond:
	bge	$t0, N_POINTS, main__for_end
main__for_body:
	#handle array first
	la	$t1, my_points
	mul	$t2, $t0, 8

	#struct offset
	addi	$t1, $t2, 0  #row
	lw	$t2, my_points($t1)

	addi	$t1, $t1, 4
	lw	$t3, my_points($t1)   #col
	# t2 = row
	# t3 = col

	# row * N_COLS + cols
	# $t2   CONST    $t3

	mul	$t4, MAP_SIZE, $t2
	add	$t4, $t4, $t3
	mul	$t4, $t4, 4

	lw	$t5, topography_grid($t4)   #height

	li	$v0, 4			# $v0 = 4 (print string)
	la	$a0, height_str		# load address of height_str into $a0
	syscall				# print height_str

	li	$v0, 1			# $v0 = 1 (print int)
	move	$a0, $t2		# $a0 = row
	syscall				# print row

	li	$v0, 11			# $v0 = 11 (print ASCII character)
	li	$a0, ','		# $a0 = ','
	syscall				# print ','

	li	$v0, 1			# $v0 = 1 (print int)
	move	$a0, $t3		# $a0 = col
	syscall				# print col

	li	$v0, 11			# $v0 = 11 (print ASCII character)
	li	$a0, '='		# $a0 = '='
	syscall				# print '='

	li	$v0, 1			# $v0 = 1 (print int)
	move	$a0, $t5		# $a0 = height
	syscall				# print height

	li	$v0, 11			# $v0 = 11 (print ASCII character)
	li	$a0, '\n'		# $a0 = '\n'
	syscall	





main__for_iter:
	addi	$t0, $t0, 1
	j	main__for_cond
main__for_end:

	li	$v0, 0
	jr	$ra





	.data

# 2D grid representing the height data for an area.
topography_grid:
	.word	0, 1, 1, 2, 3
	.word	1, 1, 2, 3, 4
	.word	1, 2, 3, 5, 7
	.word	3, 3, 4, 5, 6
	.word	3, 4, 5, 6, 7

# Points of interest to print heights for, as a 1D array of point2D_t structs.
# Note the memory layout of this array: each element requires 8 bytes, not 4.
my_points:
	.word	1, 2
	.word	2, 3
	.word	0, 0
	.word	4, 4

height_str: .asciiz "Height at "