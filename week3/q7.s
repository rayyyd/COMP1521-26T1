N_SIZE = 10

main:
	#i = 0;
	li	$t0, 0
main__while:
	# while (i < N_SIZE) {
	bge	$t0, N_SIZE, main__while_end
main__if:

	# how do we get numbers[i]???
	# base address
	la	$t1, number
	#calculate offset
	# idx * element size
	mul	$t2, $t0, 4    # i * 4
	add	$t1, $t1, $t2

	#lw to get the value
	lw	$t2, ($t1)   #this load the value
			#at $t1 into $t2


	#if (numbers[i] < 0) {
	bge	$t2, 0, main__if_end
main__if_body:
	addi	$t2, $t2, 42
	sw	$t2, ($t1)  #saves $t2 into $t1
main__if_end:
	addi	$t0, $t0, 1
	b	main__while
main__while_end:
	jr	$ra



	.data
number: 
	.word 0, 1, 2, -3, 4, -5, 6, -7, 8, 9