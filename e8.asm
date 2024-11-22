
[org 0x0100]

mov al, 0x74
mov bl, 0x5A
cmp bl, al	
jle skip

mov bx,88
skip:

mov ax,0x4C00
int 0x21
