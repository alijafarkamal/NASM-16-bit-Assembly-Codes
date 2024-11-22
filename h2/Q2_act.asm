;New! Keyboard shortcuts … Drive keyboard shortcuts have been updated to give you first-letters navigation
; Flag Register with unsigned subtraction

[org 0x0100]
		jmp start
Arr: dw 2,2,2,3,4,4,5,5,5,6

start:
	mov bx,Arr		;pointer
	mov si,bx		;next value container
	mov cx,0		;counter
	
loop:
	add cx,1		;counter behavior
	add si,2		;moves to next address
	cmp cx,10		;compares to full array iteration
	jz outOfLoop		;end program
	
	mov ax,[si]		;moves value for comparison
	cmp [bx],ax		;comparison
	jz noswap		;same numbers so jump to noswap loop
	jmp swap		;different so swap
	
swap:	
	mov dx,[si]		;takes value of number to be swapped
	add bx,2		;points to next index
					
	mov [bx],dx		;moves value to next index one step further
	mov word[si],0x00	;puts zero
	jmp loop		;jump back to loop
	
noswap:
	mov word[si],0x00
	jmp loop
outOfLoop:

	mov ax, 0x4c00		;terminate the program
	int 0x21
OuterLoop:
	mov dx,[Union+bx]
	add bx,2
	mov si,bx
InnerLoop:
		mov cx,[Union+si]
		cmp dx,cx
		
