

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
	# what registers should push and pop?


sum2:                           # sum2 doesn't call other functions,
                                # so it doesn't need to save any registers.
        add     $v0, $a0, $a1   # return argument + argument 2
        jr      $ra             #