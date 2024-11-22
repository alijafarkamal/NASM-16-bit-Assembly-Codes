;New! Keyboard shortcuts … Drive keyboard shortcuts have been updated to give you first-letters navigation
; Flag Register with unsigned subtraction

[org 0x0100]
		jmp start
a: dq 0xABCDD4E1 ; dq allocates 64 bit memory space. a is 32-bit number but it has space allocation of 64 bits
b: dd 0xAB5C32 ; 32-bit space for multiplier
result: dq 0x0 ; result should be 0x73005CB8FF6FF2 verify on calculator programmer’s view
start:
	mov cl,16
	mov dx, word[b]
checkbit:
	shr dx,1
	jnc skip
	mov ax,[a]
	add [result],ax
	mov ax,[a+2]
	adc [result+2],ax
	
skip:
	shl word [a],1
	rcl word[a+2],1
	dec cl
	jnz checkbit
	
	mov cl,16
	mov dx, word[b+2]
checkbit1:
	shr dx,1
	jnc skip1
	mov ax,[a+4]
	add [result+4],ax
	mov ax,[a+6]
	adc [result+6],ax
	
skip1:
	shl word [a+4],1
	rcl word[a+6],1
	dec cl
	jnz checkbit1
	
	mov ax, 0x4c00		;terminate the program
	int 0x21
