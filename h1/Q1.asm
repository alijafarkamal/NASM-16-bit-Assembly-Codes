

[org 0x0100]

mov si, [N]				; save base value in bx
mov ax, 0				; initialize sum to 0

l1: 	add ax, si		; add value of bx to ax
		sub si, 1			;decrement value by 1 which is also behaving as counter
		jnz l1				;JUMP to l1 if ZERO FLAG is not Set
mov [total], ax			; save sum in total

mov ax, 0x4c00		;terminate the program
int 0x21

N:		dw 6
total:	dw 0