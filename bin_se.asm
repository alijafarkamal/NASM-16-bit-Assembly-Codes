; 16bit multiplication
[org 0x0100]
jmp start

multiplicand:		dd 0xD000 ; 16bit multiplicand 32bit space
multiplier:			dw 0xF000 ; 16bit multiplier
result:				dd 0 ; 32bit result

start:				mov cl, 16 ; initialize bit count to 16
					mov dx, [multiplier] ; load multiplier in dx

checkbit:			shr dx, 1 ; move right most bit in carry
					jnc skip ; skip addition if bit is zero

					mov ax, [multiplicand]
					add [result], ax ; add less significant word
					mov ax, [multiplicand+2]
					adc [result+2], ax ; add more significant word

skip:				shl word [multiplicand], 1
					rcl word [multiplicand+2], 1 ; shift multiplicand left
					dec cl ; decrement bit count
					jnz checkbit ; repeat if bits left


mov ax, 0x4c00 ; terminate program
int 0x21