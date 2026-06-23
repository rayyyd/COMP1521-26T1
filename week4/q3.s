

#Here, I have already implemented the main and sum2 functions. Implement sum4.
main:
        push    $ra             # move stack pointer down to make room
                                # save $ra on $stack
                                

        li      $a0, 11         # sum4(11, 13, 17, 19)
        li      $a1, 13
        li      $a2, 17
        li      $a3, 19
        jal     sum4

        move    $a0, $v0        # printf("%d", z);
        li      $v0, 1
        syscall

        li      $a0, '\n'       # printf("%c", '\n');
        li      $v0, 11
        syscall

        pop     $ra             # recover $ra from $stack
                                # move stack pointer back up to what it was when main called
                                # equivalent to `pop $ra`

        li      $v0, 0          # return 0 from function main
        jr      $ra             # return from function main

sum4:
	#TODO

	# what registers need to be in $s registers?
	# c, d, res1
	# what registers should push and pop?

	# int sum4(int a, int b, int c, int d) {
	# 	int res1 = sum2(a, b);
	# 	int res2 = sum2(c, d);
	# 	return sum2 (res1, res2);
	# }
	push	$ra
	push	$s0
	push	$s1
	push	$s2
	push	$s3
	push	$s4
sum4__body:
	move	$s2, $a2
	move	$s3, $a3     #saving c and d

	move	$a0, $a0
	move	$a1, $a1             #int res1 = sum2(a, b)
	jal	sum2

	move	$s0, $v0        #we need to save res1

	move	$a0, $s2
	move	$a1, $s3       #int res2 = sim2(c, d)
	jal	sum2

	# output res2 is in $v0

	move	$a0, $s0
	move	$a1, $v0
	jal	sum2

	# output is already in $v0
sum4__epilogue:
	pop	$s4
	pop	$s3
	pop	$s2
	pop	$s1
	pop	$s0
	pop	$ra
	jr	$ra




sum2:                           # sum2 doesn't call other functions,
                                # so it doesn't need to save any registers.
        add     $v0, $a0, $a1   # return argument + argument 2
        jr      $ra             #