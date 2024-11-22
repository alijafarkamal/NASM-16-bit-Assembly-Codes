[org 0x100]
jmp start
clrscr:		push es
			push ax
			push di

			mov ax, 0xb800
			mov es, ax					; point es to video base
			mov di, 0					; point di to top left column

nextloc:	mov word [es:di], 0x0720	; clear next char on screen
			add di, 2					; move to next screen location
			cmp di, 4000				; has the whole screen cleared
			jne nextloc					; if no clear next position

			pop di
			pop ax
			pop es
			ret
	check:
			mov al,'\'  
			;left
			mov word[es:di],ax
			add di,162
			cmp di, dx
			jl loop2
			jmp loop3
			
	check1:
			 mov al,'/'          ; right
			 mov word[es:di],ax
			 add di,158
			 cmp di, dx
	  	     jl loop3	
jmp end			 

print :
           push es
			push ax
			push di
			push bp
			mov bp,sp
			
			mov ax, 0xb800
			mov es, ax
			mov al,'+'
			mov ah,0x04
			mov di,dx	
			mov[es:di],ax
	        mov di,bx
			mov [es:di],ax
		    mov di,cx
			mov [es:di],ax
			
			mov di,bx
			add di,2
			loop1: 
			mov al,'-'          ; base
			mov word[es:di],ax
			add di,2
			cmp di, cx
			jl loop1
			 
			mov di,bx
			add di,162
		
			loop2:
			cmp di ,dx
			jl check
			
		
			
			 mov di,cx
			 add di,158
			
			loop3:
			cmp di, dx
			jl check1
			
			
	end:		
			pop bp
			pop di 
			pop ax 
			pop es
			ret

calculate:

	mov ax,80
	push ax
	push bp 
	mov bp,sp
	mov ax,[bp+16]
	mul word[bp+2]
	add ax,[bp+14]
	shl ax,1
	mov di,ax
	push di
	mov ax,[bp+12]
	mul word[bp+2]
	add ax,[bp+10]
	shl ax,1
	mov di,ax
	push di
	mov ax,[bp+8]
	mul word[bp+2]
	add ax,[bp+6]
	shl ax,1
	mov di,ax
	push di
	pop cx
	pop bx
	pop dx
	pop bp 
	pop si
	ret 12
	
	
   
start:

	mov ax,2         ;row of top  
	push ax
	mov ax,5          ;c of top
	push ax	
	mov ax,1          ;row of left corner
	push ax
	mov ax,4         ;c of left corner
	push ax
	mov ax,1        ;row of right corner 
	push ax
	mov ax,6          ;c of right corner
	push ax
	
	call calculate
	call clrscr
	call print
	
	mov ax,6         ;row of top  
	push ax
	mov ax,10         ;c of top
	push ax	
	mov ax,4         ;row of left corner
	push ax
	mov ax,9        ;c of left corner
	push ax
	mov ax,4        ;row of right corner 
	push ax
	mov ax,11          ;c of right corner
	push ax
	call calculate
	call print
mov ax,0x04c00 ; terminate
int 0x21