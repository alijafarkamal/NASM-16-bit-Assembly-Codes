[org 0x0100]
	jmp check123
arr: db 1,1,2,2,2,2,4,4,4,4,4
count: dw 11
mode: db 0
start:
	mov cx,0			;counter
	mov bl,[arr+1]			;1st element
	mov dl,1			;one step ahead
	mov cx,0
	mov bp,0			;frequency holder
	mov di,1			;one index ahead
loop:
	cmp [count],cx			;checks condition
	jz out				;if not equal jump out of loop
	cmp bl,[arr+di-1]		;element comparison
	jnz check
pre_check:
	add cx,1			;increment
	add di,1			;increment
	mov bl,[arr+di]			;element holder
	add dx,1			;increment
	jmp loop	
check:
	cmp dx,bp			;checks if previous frequency is 			 			than current
	ja move				;if not jump to move
	mov dx,0			;otherwise again set to 0
	jmp pre_check			;jump back
move:
	mov al,[arr+di-1]		;mode holder
	mov bp,dx			;frequency holder
	mov dx,0			;again initialized to 0
	jmp pre_check	;return back to iteration
out:
	mov [mode],al
	ret
	and123:
	
	mov ax,0x4c00
	int 0x21
	check123: call start
	jmp and123
