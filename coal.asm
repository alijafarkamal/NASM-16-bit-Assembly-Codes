[org 0x0100]
jmp start

arr: dw 11111010, 10110001, 10101011, 01110010, 11000101, 10011100, 01010100, 01010000, 10001011
size: dw 10

																									;start1:
																									;	mov cx, 0           ; Initialize counter
																									;	mov si, 0           ; Initialize index for array
																									;
																									;loop_start:
																									;	cmp cx, word [size]  ; Compare counter with size
																									;	jge finish           ; Jump to finish if end of array is reached
																									;
																									;	mov ax, [arr + si]   ; Load word from array
																									;	mov ah, al           ; Copy low byte to high (for manipulation)
																									;	shr ah, 2            ; Shift right twice, now bits 2-7 are in positions 0-5
																									;	and ah, 0x1C         ; Mask out all but bits 3, 4, 5 (0x1C = 11100b)
																									;
																									;	mov bl, al
																									;	shr bl, 5            ; Shift right five times, bits 5-7 move to 0-2
																									;	and bl, 0x07         ; Mask out all but bits 0, 1, 2 (00000111b)
																									;
																									;	xor al, 0x03         ; Toggle the least significant two bits
																									;	and al, 0x03         ; Mask out all but these two toggled bits
																									;	shl al, 6            ; Shift them to positions 6 and 7
																									;
																									;	or al, bl            ; Combine the 0-2 bits
																									;	or al, ah            ; Combine the 3-5 bits
																									;
																									;	mov [arr + si], ax   ; Store the transformed word back to array
																									;
																									;	add si, 2            ; Increment index by 2 (word size)
																									;	inc cx               ; Increment counter
																									;	jmp loop_start
																									;
																									;finish:
																									;	ret


print: 
	mov cx,[size]
	mov si,0
loopa:
	mov ax,[arr+si]
	mov bx,ax
	shl ax,1
	and bx,0xC7
	or ax,bx
	rcl ax,3
	mov bx,[arr+si]
	and bx,0xC0
	xor ax,bx
	mov [arr+si],ax
	add si,2
loop loopa
	ret
start:
	call print
	mov ax, 0x4c00
	int 0x21
