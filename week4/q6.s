main:
main__prologue:
	push	$ra

main__body:
	la	$a0, array
	li	$a1, 10
	jal	max			# result = max(array, 10)

	move	$a0, $v0
	li	$v0, 1			# syscall 1: print_int
	syscall				# printf("%d", result)

	li	$a0, '\n'
	li	$v0, 11			# syscall 11: print_char
	syscall				# printf("%c", '\n');

	li	$v0, 0

main__epilogue:
	pop	$ra
	jr	$ra			# return 0;





max:
    # Frame:    [...]   <-- FILL THESE OUT!
    # Uses:     [...]
    # Clobbers: [...]
    #
    # Locals:           <-- FILL THIS OUT!
    #   - ...
    #
    # Structure:        <-- FILL THIS OUT!
    #   max
    #   -> [prologue]
    #       -> body
    #   -> [epilogue]
max__prologue:
	begin
	push	$ra
	push	$s0
	#which one of the variables need to be saved in
	#s regs

	# look for things that appear both before and after
	# a function call
	# or is in a loop with a function.
	
max__body:
	lw	$s0, ($a0)
	
max__if:
	bne	$a1, 1, max__else

	move	$v0, $s0   #ret val in v0
	b	max__epilogue
max__else:
	addi	$a0, $a0, 4
	addi	$a1, $a1, -1
	jal	max  #v0

	ble	$s0, $v0, max__if_end
	move	$v0, $s0 

max__if_end:
	move	$v0, $v0


max__epilogue:
	pop	$s0
	pop	$ra
	end
	jr	$ra





.data
array:
	.word 1, 2, 3, 4, 5, 6, 4, 3, 2, 1

