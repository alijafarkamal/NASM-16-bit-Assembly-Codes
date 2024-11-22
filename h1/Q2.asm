

[org 0x0100]

mov ax, 0				; initialize sum to 0
mov bp, [num]			;

l1: 	add ax, [num]	; add value of bx to ax
		sub bp, 1			;decrement value by 1 which is  behaving as counter
		jnz l1				;JUMP to l1 if ZERO FLAG is not Set
mov [square], ax			; save sum in total

mov ax, 0x4c00		;terminate the program
int 0x21

num:		dw 9
square: 	dw 0