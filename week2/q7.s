	.text

main:

main__for_init:
	li	$t0, 24
main__for_cond:
	bge	$t0, 42, main__for_end 
	# opp. condition, go to the end
main__for_body:
	li	$v0, 1
	move	$a0, $t0
	syscall

	li	$v0, 11
	li	$a0, '\n'
	syscall
main__for_iter:
	addi	$t0, $t0, 3     # x = x + 3
	b	main__for_cond
main__for_end:
	jr	$ra


	.data