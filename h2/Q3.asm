;New! Keyboard shortcuts … Drive keyboard shortcuts have been updated to give you first-letters navigation
; Flag Register with unsigned subtraction

[org 0x0100]
		jmp start
wor: dq 0xEEEEEEEE11111111
wor1: dq 0x11111111EEEEEEEE
result: dq 
start:
	mov ax,word[wor+6]
	add ax,word[wor1+6]
	mov word[result+6],ax
	
	mov ax,word[wor+4]
	adc ax,word[wor1+4]
	mov word[result+4],ax
	
	mov ax,word[wor+2]
	adc ax,word[wor1+2]
	mov word[result+2],ax
	
	mov ax,word[wor]
	adc ax,word[wor1]
	mov word[result],ax
	
	
	
	mov ax, 0x4c00		;terminate the program
	int 0x21
