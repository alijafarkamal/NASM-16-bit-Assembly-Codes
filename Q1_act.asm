; 4-bit multiplication using test for bit testing
[org 0x0100]
jmp start

multiplicand: 	db 0xD ; 4-bit multiplicand (8-bit space)
multiplier: 	db 0xA ; 4-bit multiplier
result: 	db 0 ; 8-bit result

start: 		mov cl, 4 ; initialize bit count to four			
		mov bl, [multiplicand] ; load multiplicand in bl
		mov dl, 1 ; initialize bit mask

checkbit:	test dl, [multiplier] ; test right most bit
		jz skip ; skip addition if bit is zero
		add [result], bl ; accumulate result

skip:		shl bl, 1 ; shift multiplicand left
		shl dl, 1 ; shift mask towards next bit
			
		dec cl ; decrement bit count
		jnz checkbit ; repeat if bits left

mov ax, 0x4c00 ; terminate program
int 0x21 
