        .text
# where you write your code
SQUARE_MAX = 46430

main:
        # $t0 = x
        # $t1 = y

        li	$a0, string
        li	$v0, 4            #printf("Enter a number")
        syscall

        #scanf("%d", &x);
        li	$v0, 5
        syscall
        move	$t0, $v0        # back to front

main_if:
        ble     $t0, SQUARE_MAX, main_else

        li	$a0, too_big
        li	$v0, 4         #printf("square too big ....)
        syscall

        b	main_else_end
main_else:
        mul	$t1, $t0, $t0        #y = x * x

        #printf("%d\n", y);
        move	$a0, $t1
        li	$v0, 1
        syscall

        li	$a0, '\n'
        li	$v0, 11
        syscall

        li	$v0, 0         # return value
        jr	$ra           #return

main_else_end:

        .data
# where string literals and global variables are put.
string:
        .asciiz "Enter a number: "
wrong_string:
        .asciiz "hello world"
too_big:
        .asciiz "square too big for 32 bits\n"
