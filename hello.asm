; this is a comment. Comment starts with semicolon
; this program adds three numbers in registers

[org 0x0100]	;we will see org directive later

mov ax, 3	; AX = 5
mov bx, 6	; BX = 10
add ax, bx	; AX = AX + BX
mov bx, 9	; BX = 15
add ax, bx	; AX = AX + BX
mov bx, 12	; BX = 15
add ax, bx	; AX = AX + BX
mov bx, 15	; BX = 154
add ax, bx	; AX = AX + BX

mov ax, 0x4c00	;terminate the program
int 0x21
