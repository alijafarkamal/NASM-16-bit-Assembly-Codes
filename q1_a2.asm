; scroll down the screen
[org 0x0100]
jmp start
ter
scrolldown:	push bp
			mov bp,sp
			push ax
			push cx
			push si
			push di
			push es
			push ds

			mov ax, 80 ; load chars per row in ax
			mul byte [bp+4] ; calculate source position
			push ax ; save position for later use
			shl ax, 1 ; convert to byte offset
			;ax has now address of 

			mov si, 3998 ; last location on the screen
			sub si, ax ; load source position in si
			;si has less 
			mov cx, 4000 ; number of screen locations
			sub cx, si ; count of words to move
			shr ax,1

			mov ax, 0xb800
			mov es, ax ; point es to video base
			mov ds, ax ; point ds to video base
			mov di, 3998 ; point di to lower right column

			std ; set auto decrement mode
			rep movsw ; scroll up
			
			mov ax, 0x0720 ; space in normal attribute
			pop cx ; count of positions to clear
			mov di,cx						
			rep stosw ; clear the scrolled space

			pop ds
			pop es
			pop di
			pop si
			pop cx
			pop ax
			pop bp
			ret 2
start:  mov ax,12
		push ax 
		call scrolldown

		mov ax, 0x4c00 ; terminate program
		int 0x21