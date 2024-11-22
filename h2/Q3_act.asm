; sorting a list of ten numbers using bubble sort
; a program to add ten numbers without a separate counter
[org 0x0100]
	jmp start ; unconditionally jump over data
num1: dw 2,4,2,8,2
num: dw 2
start:
	mov si, 0
	
outerloop:
	mov di, si
	add di, 2
	
innerloop:
		mov ax, [num1+si]
		cmp ax, [num1+di]
		jl noswap
		mov dx, [num1+di]
		mov [num1+si], dx
		mov [num1+di], ax
		
noswap:
	add di, 2
	cmp di, 10
	jl innerloop
	add si,2
	cmp si, 8
	jl outerloop
	
mov ax, 0x4c00 ; terminate program
int 0x21
