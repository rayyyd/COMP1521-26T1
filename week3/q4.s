a)
0x10010000

b)
666

c)
0x 00 00 02 9A
# dont do this because it works - but only sometimes
# 

d)


e)


f) 5

g) 5


h)
# if you run into the error of
# trying to access a non 4-byte aligned address
# what might you have done wrong?

# 1. forgot to multiply by element size.
# 2. overwritten register
# 3. accidently used lw/sw, when you were meant
# to use lb.
