	.text
NUMBER = 10
main:
	

main_while_init:
	li	$t0, 1
main_while_cond:
	bgt	$t0, NUMBER, main_while_end
main_while_body:
	move	$a0, $t0         #printin i
	li	$v0, 1
	syscall

	li	$a0, '\n'        #printing \n
	li	$v0, 11
	syscall

main_while_loop:
	b	main_while_cond

main_while_end:

	li	$v0, 0
	jr	$ra





	.data