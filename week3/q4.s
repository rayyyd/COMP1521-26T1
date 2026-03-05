a)
0x10010000 

b)
666

c)
0x 00 00 02 9A
0x 9A 02 00 00
# not break, loads 1 byte
# which byte is determined by your machine.
# some will laod 00, some will load 9A, cse will load 9A.

f)
5

g)
5

h)
# words must be 4-byte aligned
# cause an error.

.data
numbers:
	.word 0, 1, 2, -3, 4, ...
