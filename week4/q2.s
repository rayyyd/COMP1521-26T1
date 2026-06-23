# int main(void) {
#     for (int row = 0; row < FLAG_ROWS; row++) {
#         for (int col = 0; col < FLAG_COLS; col++) {
#             printf("%c", flag[row][col]);
#         }
#         printf("\n");
#     }
# }
FLAG_ROWS = 6
FLAG_COLS = 12

main:

main__loop1_init:
	li	$t0, 0
main__loop1_cond:
	bge	$t0, FLAG_ROWS, main__loop1_end
main__loop1_body:

main__loop2_init:
	li	$t1, 0
main__loop2_cond:
	bge	$t1, FLAG_COLS, main__loop2_end
main__loop2_body:
## Todo: implement 
#printf("%c", flag[row][col]]).
# row = $t0, col = $t1.

	#row * total_cols + cols
	mul	$t2, $t0, FLAG_COLS   # row * total_cols
	add	$t2, $t2, $t1         # + cols
	# now we have the 1d offset equivalent

	mul	$t2, $t2, 1   #* element size
	lb	$t3, flag($t2)    # add the base address

	move	$a0, $t3
	li	$v0, 11
	syscall



main__loop2_incr:
	addi	$t1, $t1, 1
	j 	main__loop2_cond
main__loop2_end:
	li	$v0, 11
	li	$a0, '\n'
	syscall
main__loop1_incr:
	add	$t0, $t0, 1
	j	main__loop1_cond
main__loop1_end:
	jr	$ra




.data
# This label inside the data region refers to the bytes of the flag.
# Note that even thought the bytes are listed on separate lines,
# they are actually stored as a single contiguous chunk or 'string' in memory.
flag:
	.byte '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'
	.byte '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'
	.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
	.byte '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.', '.'
	.byte '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'
	.byte '#', '#', '#', '#', '#', '.', '.', '#', '#', '#', '#', '#'


# Todo: implement printf("%c", flag[row][col]]).
# row = $t0, col = $t1.