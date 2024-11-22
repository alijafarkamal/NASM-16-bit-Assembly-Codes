; sorting a list of ten numbers using bubble sort
; a program to add ten numbers without a separate counter
[org 0x0100]
	jmp start ; unconditionally jump over data
num1: dw 2,4,2,8,2
num: dw 2
start:
	mov ax,[num]
	mov cx,10
	mov bx,0
	mov dx,0

loop:
	cmp [num1+bx],ax
	jz count
adder:
	add bx,2
	cmp bx,cx
	jz out
	jmp loop
count:
	add dx,1
	jmp adder
out:
	
mov ax, 0x4c00 ; terminate program
int 0x21
