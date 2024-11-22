; sorting a list of ten numbers using bubble sort
; a program to add ten numbers without a separate counter
[org 0x0100]
	jmp start 		;unconditionally jump over data
	
Set1: dw 1,4,6,0
Set2: dw 1,3,6,8,0
Intersection: dw 0,0,0,0,0

start:
	mov bx,0	;bx to zero
	mov bp,0	;bp to zero
	mov si,0	;si to zero
	
OuterLoop:
	cmp bx,6	;comparison
	ja out
	mov bp,0
	mov ax,[Set1+bx]	
	add bx,2
	
InnerLoop:
	cmp ax,[Set2+bp]
	jz matching
	
counter:
	add bp,2
	cmp bp,8
	ja OuterLoop
	jmp InnerLoop

matching:
	mov [Intersection+si],ax
	add si,2
	jmp counter
out:
	mov ax, 0x4c00 ; terminate program
int 0x21
