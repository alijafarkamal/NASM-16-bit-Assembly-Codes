; [org 0x0100]
; jmp start
; zero_count: dw 0
; one_count: dw 0
; ; Clear screen routine
; clrscr:
    ; push es
    ; push ax
    ; push di

    ; mov ax, 0xb800
    ; mov es, ax             ; Video memory segment
    ; mov di, 0              ; Start at the top left corner

; nextloc:
    ; mov word [es:di], 0x0720  ; Clear with space character, grey on black background
    ; add di, 2               ; Move to next character position
    ; cmp di, 4000            ; Check if we've reached the end of screen buffer (80x25)
    ; jne nextloc             ; Continue clearing if not done

    ; pop di
    ; pop ax
    ; pop es
    ; ret
	

; count_bits:
	; push bp              
    ; mov bp, sp
    ; mov cx, 16     
    ; mov ax, [bp+4]      
	; xor si,si
	; xor di,di
; loop1:
	; test ax,1
	; jz increment
	; add si,1
	; jmp bit_by_bit
; increment:
	; add di,1
; bit_by_bit:
	; shr ax,1
	; loop loop1
	
	
	; mov ax,[bp+6]
	; mov cx,16
; loop2:
	; test ax,1
	; jz increment1
	; add si,1
	; jmp bit_by
; increment1:
	; add di,1
; bit_by:
	; shr ax,1
	; loop loop2
	; mov [zero_count],si
	; mov [one_count],di
	
	; pop bp
	; ret
; draw_rectangle:
	; push bp              
    ; mov bp, sp
	; push si;0
	; push di;1

	; mov dx,di
	; mov bx,160
	; mul bx
	; shl dx,1
		
	; mov cx,si
	; shl cx,1
	; push cx
	; mov ax,0xB800
	; mov es,ax
	; mov di,0
	
	; mov bx,[bp-4]
; label1:
	; mov ax,0xB800
	; mov es,ax
	; mov cx,si
; row:
	; mov ax,'#'
	; mov ah,0x0F
	; mov [es:di],ax
	; add di,2
	; loop row
; col:
	; dec bx
	; add di,160
	; sub di,[bp-6]
	; cmp bx,0
	; jne label1
	
	; pop cx
	; pop di
	; pop si
	; pop bp
	; ret 4
; start:
    ; call clrscr
	
    ; push 23585       
	; push 4832
    ; call count_bits      
    ; call draw_rectangle  
	
    ; mov ax, 0x4C00
    ; int 0x21               ; Exit program
[org 0x0100]
jmp start
sett dw 0
move db 'r'        
row dw 0            
col dw 0            
tick dw 0
clrscr:
    pusha
    mov ax, 0xb800
    mov es, ax
    mov di, 0
    mov cx, 2000
myloop:
    mov word [es:di], 0x0720
    add di, 2
    loop myloop
    popa
    ret

print:
    pusha
    mov ax, 0xb800
    mov es, ax
mov ax,0
    mov bx, [cs:row]
    mov al, 80
    mul bx                
    add ax, [cs:col]  
mov di,0
    shl ax, 1          
    mov di, ax
    cmp byte [cs:move], 'r'
    je clear_right
    cmp byte [cs:move], 'd'
    je clear_down
    cmp byte [cs:move], 'l'
    je clear_left
    cmp byte [cs:move], 'u'
    je clear_up

clear_right:
    mov word [es:di-2], 0x0720  
    mov word [es:di], 0x072A    
    inc word [cs:col]              
    cmp word [cs:col], 79          
    je change_dir_right
    jmp print_asterisk

change_dir_right:
    mov byte [cs:move], 'd'         ; Change direction to down
    inc word [cs:row]               ; Move down
    jmp print_asterisk

clear_down:
    mov word [es:di-160], 0x0720 ; Clear previous position
    mov word [es:di], 0x072A      ; Print asterisk
    inc word [cs:row]                ; Move down
    cmp word [cs:row], 24            ; Check if end of column (bottom border)
    je change_dir_down
    jmp print_asterisk

change_dir_down:
    mov byte [cs:move], 'l'         ; Change direction to left
    dec word [cs:col]               ; Move left
    jmp print_asterisk

clear_left:
    mov word [es:di+2], 0x0720    ; Clear previous position
    mov word [es:di], 0x072A      ; Print asterisk
    dec word [cs:col]                ; Move left
    cmp word [cs:col], 0             ; Check if end of row (left border)
    je change_dir_left
    jmp print_asterisk

change_dir_left:
    mov byte [cs:move], 'u'         ; Change direction to up
    dec word [cs:row]               ; Move up
    jmp print_asterisk

clear_up:
    mov word [es:di+160], 0x0720  ; Clear previous position
    mov word [es:di], 0x072A      ; Print asterisk
    dec word [cs:row]                ; Move up
    cmp word [cs:row], 0             ; Check if end of column (top border)
    je change_dir_up
    jmp print_asterisk

change_dir_up:
    mov byte [cs:move], 'r'         ; Change direction to right
    inc word [cs:col]               ; Move right
    jmp print_asterisk

print_asterisk:
    popa
    ret

delay:
    push cx
    mov cx, 0xffff
delay_loop:
    loop delay_loop
    pop cx
    ret
timer:push ax
inc word[cs:tick]
;
cmp word[cs:tick],18
je chkkk
jmp enddddd
chkkk:
cmp word[cs:sett],1
jne exi
call print
call delay
mov word[cs:sett],0
exi:
mov word[cs:tick],0
enddddd:
mov al,0x20
out 0x20,al
pop ax
iret
kbsir:push ax
in al,0x60
cmp al,0x2a
jne nextcmp
mov word[cs:sett],1
jmp exit
nextcmp cmp al,0x36
jne exit
mov word[cs:sett],0
jmp exit
exit:
mov al,0x20
out 0x20,al
pop ax
iret
start:
    call clrscr

xor ax,ax
mov es,ax
cli
mov word [es:9*4], kbsir ; store offset at n*4
mov [es:9*4+2], cs
mov word[es:8*4],timer
mov [es:8*4+2],cs
sti
mov dx ,start
add dx,15
mov cl,4
shr dx,cl
mov ax,0x3100
int 0x21
;jmp start
               ; Number of iterations (adjust as needed)
;
;jmp start