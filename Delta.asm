[org 0x0100]
jmp start
clrscr:
    push es
    push ax
    push di

    mov ax, 0xb800
    mov es, ax             ; Video memory segment
    mov di, 0              ; Start at the top left corner
    
	mov ax,0x0720
	mov cx,2000
	cld
	rep stosw

    pop di
    pop ax
    pop es
    ret
start:
	
    call clrscr
	

	
    mov ax, 0x4C00
    int 0x21               ; Exit program
