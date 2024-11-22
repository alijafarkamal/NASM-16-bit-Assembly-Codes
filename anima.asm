[org 0x0100]
jmp start
msg1: db'hamza is a gay',0
msg2: db 'Hamza is very selfish',0
msg3: db'hamza is a gay',0
length:
		push bp
		mov bp,sp
		les di,[bp+4]
		mov al,0
		mov cx,0xffff
		repne scasb
		mov ax,0xffff
		sub ax,cx
		dec ax
		pop bp
		ret 4
print:	
		pusha
		push es
		push ds
		mov cx,ax
		mov ax,0xB800
		mov es,ax
		mov ah,0xCC
		;mov al,byte[msg1]
		cld		
		loopr:
		lodsb
		stosw
		loop loopr

		pop es
		pop ds
		popa
ret 
comparing:
		push bp
		mov bp,sp
		pusha
		push es
		push ds
		lds si,[bp+4]
		les di,[bp+8]
		push ds
		push si

		call length
		push di
		mov di,160*3
		add di,20
		call print
		pop di
		mov dx,ax
		push es
		push di
		call length
		push di
		mov di,160*4
		add di,40
		call print 
		pop di
		cmp dx,ax
		jne out
		mov cx,dx
		repe cmpsb 
		mov ax,1
		cmp cx,0
		jz out
		mov ax,0
out:
		pop es
		pop ds
		popa
		pop bp
		ret 8
clrscr:
		mov di,0
		
		mov ax,0xB800
		mov es,ax
		mov cx,2000
		mov ax,0x0720
		cld
		rep stosw
		ret
start:  
		call clrscr
		push ds
		push msg1
		push ds
		push msg2
		call comparing
		
		mov ax, 0x4c00 ; terminate program
		int 0x21 