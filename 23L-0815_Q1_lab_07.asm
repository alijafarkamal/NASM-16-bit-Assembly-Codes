[org 0x0100]
jmp start

; Clear screen routine
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
drawedges:
	push bp
    mov bp, sp
    push di
    push ax
    push es
	
	mov ax,0xB800
	mov es,ax
	
	mov di,[bp+4]
	mov ax, '+'            
    mov ah, 0x0F        
    mov [es:di], ax     
	
	mov di,[bp+6]
	mov ax, '+'            
    mov ah, 0x0F        
    mov [es:di], ax     
	
	mov di,[bp+8]
	mov ax, '+'            
    mov ah, 0x0F        
    mov [es:di], ax     
	;push '/'
	add di,156
	mov cx,4
loop1:
	mov ax,'/'
	mov ah,0x1F
	mov [es:di], ax
	add di,156
	loop loop1
	
	add di,2
	mov cx,19
loop2:	
	mov ax,'-'
	mov ah,0x2F
	mov [es:di],ax
	add di,2
	loop loop2
	
	mov di,[bp+8]
	add di,164
	mov cx,4
loop3:
	mov ax,'\'
	mov ah,0x4F
	mov [es:di],ax
	add di,164
	loop loop3
	
	pop es
    pop ax
    pop di
    pop bp
    ret
	
	
calcvert:
    push bp
    mov bp, sp
    push di
    push ax
    push es

    mov ax, 0xB800	
    mov es, ax           

    mov ax, [bp+12]   
    mov bx, 160         
    mul bx                 
    mov di, ax           

    mov bx, [bp+14]  
    shl bx, 1              
    add di, bx            
	
	push di
	
	mov ax, [bp+10]  
    mov bx, 160         
    mul bx                 
    mov di, ax           

    mov bx, [bp+8]    
    shl bx, 1              
    add di, bx            
	push di
	
	mov ax, [bp+6]    
    mov bx, 160         
    mul bx                 
    mov di, ax           

    mov bx, [bp+4]         ; 
    shl bx, 1              ;
    add di, bx             ;
	push di
	call drawedges

    pop es
    pop ax
    pop di
    pop bp
    ret

start:
    call clrscr
	
    push 15                ; Right
    push 5                 ; Left
    push 10                ; Top
	push 5
	push 10
	push 25
    call calcvert

    mov ax, 0x4C00
    int 0x21               ; Exit program
