	.text

main:




# for (int x = 24; x < 42; x += 3) {
#         printf("%d\n", x);
#     }

main__INIT:
	li	$t0, 24    #x = $t0
main__COND:
	# take opp cond. then go to the end
	bge	$t0, 42, main__END
main__BODY:
	li	$v0, 1
	move	$a0, $t0     #printf("%d")
	syscall

	li	$v0, 11
	li	$a0, '\n'     #printf("\n')
	syscall
main__INC:
	# x = x + 3
	addi	$t0, $t0, 3
	b	main__COND
main__END:
	jr	$ra





	.data