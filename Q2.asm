;New! Keyboard shortcuts … Drive keyboard shortcuts have been updated to give you first-letters navigation
; Flag Register with unsigned subtraction

[org 0x0100]
		jmp start
wor: dq 0xB189;1011 0001 1000 1001
start:
	mov cx,0
	mov ax,15
loop:
	shl word[wor],1
	rcl word [wor+2],1
	cmp cx,ax
	jz out
	add cx,1
	jmp loop
out:
	mov cx,0
loop1:
	shl word[wor+2],1
	rcl word [wor+4],1
	cmp cx,ax
	jz out1
	add cx,1
	jmp loop1
out1:

	mov cx,0
loop2:
	shl word[wor+4],1
	rcl word [wor+6],1
	cmp cx,ax
	jz out2
	add cx,1
	jmp loop2
out2:
	
	
	
	
	mov ax, 0x4c00		;terminate the program
	int 0x21
