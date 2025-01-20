; multitasking and dynamic thread registration
[org 0x0100]
jmp start
; PCB layout:
; ax,bx,cx,dx,si,di,bp,sp,ip,cs,ds,ss,es,flags,next,dummy
; 0, 2, 4, 6, 8,10,12,14,16,18,20,22,24, 26 , 28 , 30
pcb: times 32*16 dw 0 ; space for 32 PCBs
stack: times 32*256 dw 0 ; space for 32 512 byte stacks
nextpcb: dw 1 ; index of next free pcb
current: dw 0 ; index of current pcb
lineno: dw 0 ; line number for next thread


;;;;; COPY LINES 028-071 FROM EXAMPLE 10.1 (printnum) ;;;;;
; subroutine to print a number on screen
; takes the row no, column no, and number to be printed as parameters
printnum: push bp
			mov bp, sp
			push es
			push ax
			push bx
			push cx
			push dx
			push di
			mov di, 80 ; load di with columns per row
			mov ax, [bp+8] ; load ax with row number
			mul di ; multiply with columns per row
			mov di, ax ; save result in di
			add di, [bp+6] ; add column number
			shl di, 1 ; turn into byte count
			add di, 8 ; to end of number location
			mov ax, 0xb800
			mov es, ax ; point es to video base
			mov ax, [bp+4] ; load number in ax
			mov bx, 16 ; use base 16 for division
			mov cx, 4 ; initialize count of digits
			nextdigit: mov dx, 0 ; zero upper half of dividend
			div bx ; divide by 10
			add dl, 0x30 ; convert digit into ascii value
			cmp dl, 0x39 ; is the digit an alphabet
			jbe skipalpha ; no, skip addition
			add dl, 7 ; yes, make in alphabet code
			skipalpha: mov dh, 0x07 ; attach normal attribute
			mov [es:di], dx ; print char on screen
			sub di, 2 ; to previous screen location
			loop nextdigit ; if no divide it again
			pop di
			pop dx
			pop cx
			pop bx
			pop ax
			pop es
			pop bp
			ret 6

clrscr:
			mov ax, 0xb800 					; load video base in ax
			mov es, ax 					; point es to video base
			mov di, 0 					; point di to top left column
									; es:di pointint to --> 0xB800:0000 (B8000)

nextchar: 	
		mov word [es:di], 0x0720 				; clear next char on screen
		add di, 2 						; move to next screen location
		cmp di, 4000 						; has the whole screen cleared
		jne nextchar 						; if no clear next position
ret

; mytask subroutine to be run as a thread
; takes line number as parameter
mytask: push bp
		mov bp, sp
		sub sp, 2 ; thread local variable
		push ax
		push bx
		mov ax, [bp+4] ; load line number parameter
		mov bx, 70 ; use column number 70
		mov word [bp-2], 0 ; initialize local variable
		
		printagain: push ax ; line number
					push bx ; column number
					push word [bp-2] ; number to be printed
					call printnum ; print the number
					inc word [bp-2] ; increment the local variable
					jmp printagain ; infinitely print
		pop bx
		pop ax
		mov sp, bp
		pop bp
		ret
; subroutine to register a new thread
; takes the segment, offset, of the thread routine and a parameter
; for the target thread subroutine

start: 
	call clrscr
		nextkey: xor ah, ah ; service 0 – get keystroke
				int 0x16 ; bios keyboard services	
				push word [lineno] ; thread parameter
				push 20
				push 1234
				; call printnum
				call mytask ; register the thread
				inc word [lineno]
				jmp nextkey ; wait for next keypress
				
		mov ax,0x4c00
		int 0x21