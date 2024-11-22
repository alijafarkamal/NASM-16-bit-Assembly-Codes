; scroll up the screen
[org 0x0100]
 jmp start
 ;-----------------------------------------------------------------
; subroutine to scroll up the screen
; take the number of lines to scroll as parameter
;-----------------------------------------------------------------
scrollup:	push bp
			mov bp,sp
			push ax
			push cx
			push si
			push di
			push es
			push ds

			mov ax, 80 ; load chars per row in ax
			mul byte [bp+4] ; calculate source position
			mov si, ax ; load source position in si
			push si ; save position for later use
			shl si, 1 ; convert to byte offset

			mov cx, 2000 ; number of screen locations
			sub cx, ax ; count of words to move

			mov ax, 0xb800
			mov es, ax ; point es to video base
			mov ds, ax ; point ds to video base
		
			xor di, di ; point di to top left column
			cld ; set auto increment mode
			rep movsb; scroll up

			mov ax, 0x0720 ;
			pop cx ;
			rep stosb; 
		
			pop ds
			pop es
			pop di
			pop si
			pop cx
			pop ax
			pop bp
			ret 2	
;-----------------------------------------------------------------
start: 		mov ax,5
			push ax ; push number of lines to scroll

			call scrollup ; call the scroll up subroutine

mov ax, 0x4c00 ; terminate program 
int 0x21 