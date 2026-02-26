	.text
# where our code goes
SQUARE_MAX = 46340

main:

        #$t0 = x
        #$t1 = y

        #printf("Entera number")
        li	$v0, 4
        la	$a0, enter
        syscall

        #scanf("%d", &x)
        li	$v0, 5
        syscall
        #result is in $v0
        move	$t0, $v0

main__if:
        ble	$t0, SQUARE_MAX, main__else

        li	$v0, 4
        la	$a0, too_big
        syscall


main__else:
        mul	$t1, $t0, $t0  # y = x * x

        #printf("%d")
        li	$v0, 1
        move	$a0, $t1
        syscall

        #printf("\n")
        li	$v0, 11
        li	$a0, '\n'
        syscall

main__else_end:
        li	$v0, 0
        jr	$ra


	.data
# string literals + global variables
# identify string literals by ""
enter:
        .asciiz "Enter a number: "
too_big:
        .asciiz "square too big for 32 bits\n"

