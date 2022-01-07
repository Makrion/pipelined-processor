.ORG 0  #this means the the following line would be  at address  0 , and this is the reset address
300
#you should ignore empty lines

.ORG 2  #this is empty stack exception handler address
100

.ORG 4  #this is invalid addess exception handler address
150

.ORG 6  #this is int 0
af15

.ORG 8  #this is int 2
fffff


#helllo
.org 5
NOP
inc r7
#sub r0,r1,r3 #hello

inc r0
#helllo
inc r3
out r6
mov r1 r7
.org f00
mov r1 r7