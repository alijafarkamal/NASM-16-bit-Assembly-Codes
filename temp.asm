[org 0x0100]
jmp start    
InputString: db 'ddsdfhgrtsdfhjghjksdd'
CharToFind: db 'd'
CharToReplace: db '$'
ModifiedString: db 0
clrscr:	
	push es
	push ax
	push cx
	push di

	mov ax, 0xb800
	mov es, ax ; point es to video base
	xor di, di ; point di to top left column
	mov ax, 0x0720 ; space char in normal attribute
	mov cx, 2000 ; number of screen locations
	
	cld ; auto increment mode
	rep stosw ; clear the whole screen

	pop di 
	pop cx
	pop ax
	pop es
	ret

count:
	push bp
	mov bp,sp
	push es
	push ax
	push cx
	push si
	push di
	push ds
	pop es ;es = ds
	mov al,byte[CharToFind]
	mov di,InputString
	mov cx,50
	add cx,di
loopa:
	repne scasb
	mov bl,byte[CharToReplace]
	mov [di-1],bl
	cmp di,cx
	ja out
	jmp loopa
out:
	mov ax,0xB800
	mov es,ax
	mov si,InputString

	mov di,0
	mov ah,0x0C
	mov cx,21
	cld
loopr:
	lodsb
	stosw
	loop loopr
;	mov di,[bp+4]
;	mov cx,0xffff
;	xor al,al
;	repne scasb
;	mov ax,0xffff
;	sub ax,cx
;	dec ax
;
;	jz exit
;	mov cx,ax
;	mov ax,0xB800
;	mov es,ax
;	
;	mov di,0
;	mov si,[bp+4]
;	mov ah,0x0C
;	mov bx,1
;	mov dx,1
;	cld
;next:
;	lodsb
;	cmp al,' '
;	jnz label 
;	push ax
;	push di	;di ki orig value
;	mov bx,dx; incre
;	mov dx,ax; 	;ax ki value
;	mov ax,160 ;mul 
;	mul bx
;	mov dx,bx		;dx ki orig vapis
;	pop bx	;di ki value
;	sub ax,bx	;value to add 
;	add di,ax	;
;	pop ax
;	inc dx
;label:
;	stosw
;	loop next
;exit:	
    pop di
	pop si
	pop cx
	pop ax
	pop es
	pop bp
	ret
start:
	call clrscr
	call count
mov ax,0x4c00
int 0x21