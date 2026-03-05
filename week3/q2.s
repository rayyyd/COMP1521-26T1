0x10010020

a) 
addr: 0x10010020
val:  42

b)
addr: 0x10010024
val:  unitialise

c)
addr: 0x10010028    / 4
val: "abcde '\0'"   

.align 2   -> d is 4-byte aligned (addr is divisible by 4)
.align 3 ->   d is 8-byte aligned
.align 4 ->        16

d)
addr: 0x10010030   (+8)
val: 1, 2, 3, 4

e)
addr: 0x10010034 (+4)
val: 1, 2, 3, 4
f)
addr: 0x10010044  (+16)
val: unitialised.
