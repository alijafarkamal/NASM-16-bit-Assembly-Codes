

[org 0x0100]

mov bp, 10
mov di, 0
mov si,Array1
mov bx,Array2
mov ax,0
mov cx,6
l1: 	
		mov ax,[si+bp]
		mov [bx+di]  ,ax
		add di,2
		sub bp,2
		sub cx,1
		jnz l1				;JUMP to l1 if ZERO FLAG is not Set
		
mov ax, 0x4c00		;terminate the program
int 0x21

Array1:  dw 1, 2, 3, 4, 5, 6
Array2:  dw 0,0,0,0,0,0
