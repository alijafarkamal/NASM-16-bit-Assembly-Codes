[org 0x0100]
jmp start
zero_count: dw 0
one_count: dw 0
clrscr:
    push es
    push ax
    push di

    mov ax, 0xb800
    mov es, ax             ; Video memory segment
    mov di, 0              ; Start at the top left corner

nextloc:
    mov word [es:di], 0x0720  ; Clear with space character, grey on black background
    add di, 2               ; Move to next character position
    cmp di, 4000            ; Check if we've reached the end of screen buffer (80x25)
    jne nextloc             ; Continue clearing if not done

    pop di
    pop ax
    pop es
    ret
	
count_bits:
	push bp              
    mov bp, sp
    mov cx, 16     
    mov ax, [bp+4]      
	xor si,si
	xor di,di
loop1:
	test ax,1
	jz increment
	add si,1
	jmp bit_by_bit
increment:
	add di,1
bit_by_bit:
	shr ax,1
	loop loop1
	
	
	mov ax,[bp+6]
	mov cx,16
loop2:
	test ax,1
	jz increment1
	add si,1
	jmp bit_by
increment1:
	add di,1
bit_by:
	shr ax,1
	loop loop2

	mov [zero_count],si
	mov [one_count],di
	
	pop bp
	ret
draw_rectangle:
	push bp              
    mov bp, sp
	push si;0
	push di;1

	mov dx,di
	mov bx,160
	mul bx
	shl dx,1
		
	mov cx,si
	shl cx,1
	push cx
	mov ax,0xB800
	mov es,ax
	mov di,0
	
	mov bx,[bp-4]
label1:
	mov ax,0xB800
	mov es,ax
	mov cx,si
row:
	mov al,'#'
	mov ah,0x0F
	mov [es:di],ax
	add di,2
	loop row
col:
	dec bx
	add di,160
	sub di,[bp-6]
	cmp bx,0
	jne label1
	
	pop cx
	pop di
	pop si
	pop bp
	ret 4
start:
    call clrscr
    push 23585       
	push 4832
    call count_bits      
    call draw_rectangle  
	
    mov ax, 0x4C00
    int 0x21               ; Exit program
