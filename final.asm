[org 0x0100]
jmp start
num: 30 times dw 10
start:
mov si,num+30
mov es,ds
mov di,sp
cld
mov cx,15
rep movsw
mov ax,0x4c00
int 0x21