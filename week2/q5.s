	.text
# you write your code here
SQUARE_MAX = 46340

main:
        # $t0 = x
        # $t1 = y

        # printf("Enter a number: ")
        li	$v0, 4     # load integer
        la	$a0, str  # load address
        syscall


        #scanf("%d", &x)
        li	$v0, 5
        syscall
        #output is in $v0
        move	$t0, $v0 
        # t0 = v0

        ble	$t0, SQUARE_MAX, main__else

        # printf(square too big for 32 bits\n)
        li	$v0, 4
        la	$a0, too_big
        syscall

        b	main__else_end

main__else:
        mul	$t1, $t0, $t0   #y is $t0, x is $t0

        li	$v0, 1
        move	$a0, $t1     
        syscall          #print(y)

        li	$v0, 11
        li	$a0, '\n'
        syscall         #print("\n")

main__else_end:
        li      $v0, 0
        jr	$ra            #return 0 (the value of return comes from $v0)







	.data
# global variables, string literals, data structures (arrays)
str:
        .asciiz "Enter a number: "
too_big:
        .asciiz "square too big for 32 bits\n"