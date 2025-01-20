[org 0x0100]
jmp start

right: dw 600
mid: dw 550
left: dw 500

right_b: dw 3000
mid_b: dw 2790
left_b: dw 2420

oldisr: dd 0
oldisr2: dd 0

flag: db 0
flag2: db 0
flag3: db 0

ground_flag:db 0

rec_colour: dw 0x3020

f1: db 0
f2: db 0
f3: db 0


l: db 7,5,3




buffer: times 2000 dw 0
gamename: db 'FLAPPY BIRD....$'
name1: db 'Member1: Abdul Ghani , 23L-0761....$'
name2: db 'Member2: Ali Shahzad , 23L-0719....$'
smester: db '3rd Smester....$'
sc: db 'Score: ',0


message1: db 'Welcome to Flappy Bird'
length1: dw 22
message2: db 'Press S to start AND E to End the Game'
length2: dw 45
msg: db 'press I to view the intructions'
len: dw 32

message3: db 'Press E to End the game And C to continue'
length3: dw 49


velocity db 0
gravity db 1
flap_strength db -3
x: dw 40        
y: dw 12        



gameover_message: db 'Game Over :(....$'
gameover_length: dw 13

score_message: db 'Your Score:'
score_length: dw 11
score :dw 0
highest_score :dw 10

prompt_message: db 'Press E to end '
prompt_length: dw 15


congrats_message: db 'Congratulations :)...$'
congrats_length: dw 18

score_message2: db 'You broke the record!....$'
score_length2: dw 22
prompt_message2: db 'Press E to end....$'
 prompt_length2: dw 15




old_x db 0
old_y db 0

update_screen:
cli                    ; Disable interrupts
pusha                  ; Save all registers
mov ax, buffer         ; Load the address of the buffer
mov si, ax             ; SI points to the buffer start
mov ax, 0xB800         ; Video memory segment
mov es, ax             ; Set ES to video segment
xor di, di             ; DI points to start of video memory

mov cx, 2000           ; Number of words (80x25 characters)
copy_loop:
movsw                  ; Move word from [SI] to [ES:DI], SI and DI increment by 2
loop copy_loop         ; Repeat for all screen words

popa                   ; Restore all registers
sti                    ; Re-enable interrupts
ret




draw_bird:
    push ax
    push bx
    push es
    push di

    mov ax, 0xb800         
    mov es, ax
    xor di, di             

  
    mov al, 80             
    mul byte [y]           
    add ax, 40             
    shl ax, 1              
    mov di, ax             

   
    mov bx, [es:di]
    cmp bx, [rec_colour]  
    je .collsionDetected
    mov word [es:di], 0x4020  
    add di, 2                 
							  
    mov bx, [es:di]
    cmp bx, [rec_colour]  
    je .collsionDetected
    mov word [es:di], 0x4020  
    add di, 2                 

    mov bx, [es:di]
    cmp bx, [rec_colour]  
    je .collsionDetected
    mov word [es:di], 0x4020 
	ADD DI,160

	mov bx, [es:di]
    cmp bx, [rec_colour]  
	
	je .collsionDetected
	MOV WORD[ES:DI],0x4020
	

    
	mov ah,0x82
	mov al,'^'
	sub di, 2
	MOV WORD[ES:DI],ax
	
    
	SUB DI,2
	mov bx, [es:di]
    cmp bx, [rec_colour]  
    je .collsionDetected
	MOV WORD[ES:DI],0x4020
	 
    jmp .end_update
	

.collsionDetected:
    mov byte[cs:collision_flag],1
    call unhook_keyboard_isr
    call unhook_timer_isr
    

.end_update:
    pop di
    pop es
    pop bx
    pop ax
    ret

clear_bird:
    push ax
    push bx
    push es
    push di

    mov ax, 0xb800         
    mov es, ax
    xor di, di             

   
    mov al, 80             
    mul byte [y]           
    add ax, 40             
    shl ax, 1              
    mov di, ax             

   
    mov word [es:di], 0x0720

    pop di
    pop es
    pop bx
    pop ax
    ret


clear:
    push es
    push ax
    push cx
    push di

    mov ax, 0xb800
    mov es, ax
    xor di, di
    mov ax, 0x0720  
    mov cx, 2000    

    cld
    rep stosw       

    pop di
    pop cx
    pop ax
    pop es
    ret


background:
    push es
    push ax
    push cx
    push di

    mov ax, 0xb800
    mov es, ax
    xor di, di
    mov ax, 0x7F20  ; space char with blue background
    mov cx, 2000

    cld
    rep stosw       ; apply blue background across screen

    pop di
    pop cx
    pop ax
    pop es
    ret

printstr:
    push bp
    mov bp, sp
    push es
    push ax
    push cx
    push si
    push di

    mov ax, 0xb800
    mov es, ax           

    mov al, 80           
    mul byte [bp+12]     
    add ax, [bp+10]      
    shl ax, 1            

    mov di, ax           
    mov si, [bp+6]       
    mov cx, [bp+4]       
    mov ah, [bp+8]       

    cld 

nextchar:
    lodsb                
    stosw                
    loop nextchar        
        
    pop di
    pop si
    pop cx
    pop ax
    pop es
    pop bp
    ret 10

print_message:
    push bp
    mov bp, sp
    push es
    push ax
    push cx
    push si
    push di
    
    mov ax, 0xb800
    mov es, ax           

    mov al, 80           
    mul byte [bp+12]     
    add ax, [bp+10]      
    shl ax, 1            

    mov di, ax           
    mov si, [bp+6]       
    mov cx, [bp+4]       
    mov ah, [bp+8]       

    cld 

nextchar1:
    lodsb                
    stosw                
    loop nextchar1        
        
    pop di
    pop si
    pop cx
    pop ax
    pop es
    pop bp
    ret 10
	
uped:
    push bp
    mov bp, sp
    pusha
    
    
    mov ax, 0xB800
    mov es, ax
    xor di, di 
    
    mov ax,0
	mov bx,80;
	mul bx
	add ax,0;
	shl ax,1
	mov di,ax
	
loop_ground1:
    mov word [es:di], 0x6820 
    add di, 2                
    cmp di, 480
    jb loop_ground1          
    popa
    pop bp
    ret
	
	
ground:
    push bp
    mov bp, sp
    pusha
    
    
    mov ax, 0xB800
    mov es, ax
    xor di, di 
    
    mov ax,20
	mov bx,80;
	mul bx
	add ax,0;
	shl ax,1
	mov di,ax
	
loop_ground:
    mov word [es:di], 0x6020 
    add di, 2                
    cmp di, 4000
	;mov word[es:3780],0x0720
    jb loop_ground
	
    popa
    pop bp
    ret
	
scrollGround:
    push bp
    mov bp, sp
    pusha
    
    mov ax, 0xb800            ; Set ES to video memory
    mov es, ax
    mov di, 3190              ; Start at the first ground row (row 19)
    mov si, 0                 ; Offset into Save_Ground (starting point)
    mov bx, Save_Ground       ; Address of Save_Ground
    mov cx, 5                 ; Process 5 rows (lines 19-24)

    cld                       ; Ensure forward direction (left to right)
    
    ; Save the current ground rows to Save_Ground
save_ground_loop:
    mov dx, [es:di]           ; Save the first word of the row (current row)
    mov [bx + si], dx         ; Store it in Save_Ground
    add di, 160               ; Move to next row (next row in video memory)
    add si, 2                 ; Increment Save_Ground offset (2 bytes per word)
    loop save_ground_loop     ; Repeat for 5 rows

    ; Now we begin the scroll (shift rows left)
    mov di, 3190              ; Reset to the first ground row
    mov si, 3192              ; Start shifting from column 2 (word 2 in the row)
    mov cx, 5                 ; Process 5 rows (lines 19-24)
    
    push ds
    mov ds, ax                ; Set DS to the correct segment

    ; Shift rows left
shift_ground_loop:
    push cx
    mov cx, 79                ; Shift 79 words (158 bytes) in the row
    rep movsw                 ; Move row data one word left (shift)
    add di, 2                 ; Skip the last word (clear rightmost column)
    pop cx
    add si, 2                 ; Move to the next row
    loop shift_ground_loop    ; Repeat for all 5 rows

    ; Restore the last column (rightmost part of the rows)
    mov si, 0                 ; Reset Save_Ground offset
    mov di, 3198              ; Start restoring from the last column
    mov cx, 5                 ; Process 5 rows

    pop ds                    ; Restore DS
restore_ground_loop:
    mov dx, [bx + si]         ; Load saved word from Save_Ground
    mov [es:di], dx           ; Restore it to the last column
    add si, 2                 ; Increment Save_Ground offset (2 bytes per word)
    add di, 160               ; Move to the next row
    loop restore_ground_loop  ; Repeat for all 5 rows

    popa
    pop bp
    ret



RECTANGLE:
    push bp
    mov bp, sp
    push ax
    push bx
    push cx
    push dx
    push si
    push di

    mov di, [bp+6]        ; di = start address of the rectangle
    mov dx, [bp+4]             ; dx = row counter

outerloop:
    mov cx, 0                
innerloop:
	mov ax,[rec_colour]
    mov word [es:di], ax 
    add di, 2            
    inc cx
    cmp cx, 6      
    jne innerloop        

    add di, 148  
	
    dec dx
    cmp dx, 0       
    jne outerloop        

    pop di
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    pop bp
    ret 4             



wait_for_key:
    xor ax, ax
    int 0x16           
    ret




delay:
    pusha
    mov cx, 0FFFFh         
.delay_loop:
    nop                    
    loop .delay_loop       
    popa
    ret
	
	
	
	
update_bird_position:
    ; Preserve registers
    push ax
    push bx
    push cx
    push dx
    push es
    push di

    ; Check if update should be performed
    MOV AL, [CS:release_flag]
    CMP AL, 1
    je NOUPDATE                    

    ; Reset status flags
    mov byte [ground_flag], 0      

    ; Apply gravity and update velocity
    mov al, [velocity]
    add al, [gravity]             
    mov [velocity], al

    ; Update Y position
    mov al, [y]
    add al, [velocity]            
    mov [y], al

  
   


    

    ; Boundary checks
    cmp byte [y], 3
    jge no_limit_up
    mov byte [y], 3              
no_limit_up:

    cmp byte [y], 22
    jl no_limit_down
    call unhook_keyboard_isr
    call unhook_timer_isr
    mov byte [ground_flag], 1
    jmp collision_detected        
no_limit_down:

    mov byte [CS:release_flag], 0
    jmp end_update

collision_detected:
    call unhook_keyboard_isr
    call unhook_timer_isr
    mov byte[cs:collision_flag], 1
   
    jmp end_update                  

NOUPDATE:
    mov byte [CS:release_flag], 0

end_update:
    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    ret


endscreen:
mov ax,  word[score]
cmp ax,word [highest_score]
jl end_scr
mov word[highest_score],ax
call highest_score_scr

end_scr:

   
    call background

    ; Display "Game Over 😞" message
    mov ax, 10
    push ax
    mov ax, 30
    push ax
    mov ax, 0x70       ; Attribute for foreground and background color
    push ax
    mov ax, gameover_message
    push ax
    push word [gameover_length]
    call print_message

    ; Display score (You can replace with actual score logic if needed)
    mov ax, 12
    push ax
    mov ax, 30
    push ax
    mov ax, 0x70       ; Attribute for foreground and background color
    push ax
    mov ax, score_message
    push ax
    push word [score_length]
    call print_message
 call display_score
    ; Display "Press E to end, S to start again"
    mov ax, 14
    push ax
    mov ax, 30
    push ax
    mov ax, 0x70       ; Attribute for foreground and background color
    push ax
    mov ax, prompt_message
    push ax
    push word [prompt_length]
    call print_message

   h: 
call wait_for_key
  
	
	cmp al,'e'
    je handle_endgame
	cmp al,'E'
	je handle_endgame
	
	jmp h

	

    
	
unhook_keyboard_isr:
    cli                     
    xor ax, ax
    mov es, ax		
    mov ax, [oldisr]       
    mov [es:9*4], ax       
    mov ax, [oldisr+2]     
    mov [es:9*4+2], ax     
    sti  
	
    ret
unhook_timer_isr:
    cli                     
    xor ax, ax
    mov es, ax		
    mov ax, [oldisr2]       
    mov [es:8*4], ax       
    mov ax, [oldisr2+2]     
    mov [es:8*4+2], ax     
    sti  
	
    ret


again_start:
	mov byte[x],40
	mov byte[y],12
    call draw_bird
	JMP start
	

flaapy:
    mov al, [flap_strength]
    mov [velocity], al
    ret

flap:
    call flaapy
   jmp out_kbisr

pause_screen:

call update_screen

call background


    mov ax, 13
    push ax
    mov ax, 16
    push ax
    mov ax, 0x70       
    push ax
    mov ax, message3
    push ax
    push word [length3]
    call print_message
	
   
   mov byte[flag] ,1 
   
	.pause_loop:
    in al, 0x60             
    cmp al, 0x2E            
    je resume_game
	cmp al ,0x12
	je handle_endgame
    
	
    jmp .pause_loop         

resume_game:
    mov byte [flag], 0  

 
    JMP out_kbisr           





   
   
wait_for_retrace:
    mov dx, 0x03DA        ; VGA status register
.wait_not_retrace:
    in al, dx
    test al, 0x08         ; Check if in vertical retrace
    jz .wait_not_retrace  ; Loop until retrace starts

    ret
kbisr:
    push ax                
	in al,0x60
	
	
	cmp al,0x48
	je flap
	
	
	
	cmp al,0x01
	je pause_screen
	

cmp al,0xC8
    jne out_kbisr
	mov byte [release_flag],1
	
	
	
	
	
out_kbisr:
	
	mov al,0x20
	out 0x20,al
	pop ax
	iret
	
	
	display_score:
    PUSH BP 
	MOV BP,sp
	pusha
    mov ax, 0xB800         
    mov es, ax       
    mov di, 2006        
    mov bx ,10 
    mov cx,0
    mov ax,[score]
   
   nextdigit:
    xor dx, dx 
   div bx 
   add dl,0x30
   push dx 
   inc cx
   cmp ax,0
   jnz nextdigit

   
   nextpos:
   pop dx
   mov dh,0x70
   mov [es:di],dx
   add di,2
   loop nextpos
   popa
   pop bp
   
   
    ret
         

highest_score_scr:
    push es
    push ax
    push cx
    push dx
    push si
    push di

    ; Set background and foreground color
    call background

    ; Display "Congratulations 🎉" message
    mov ax, 10
    push ax
    mov ax, 30
    push ax
    mov ax, 0x70       ; Attribute for foreground and background color
    push ax
    mov ax, congrats_message
    push ax
    push word [congrats_length]
    call print_message

    ; Display score message
    mov ax, 12
    push ax
    mov ax, 30
    push ax
    mov ax, 0x70       ; Attribute for foreground and background color
    push ax
    mov ax, score_message2
    push ax
    push word [score_length2]
    call print_message

    ; Display "Press E to end, S to start again"
    mov ax, 14
    push ax
    mov ax, 30
    push ax
    mov ax, 0x70       ; Attribute for foreground and background color
    push ax
    mov ax, prompt_message2
    push ax
    push word [prompt_length2]
    call print_message

   h1:
    call wait_for_key
    cmp al, 'E'
    je endgame
    cmp al, 'e'
    je endgame
    cmp al, 'S'
    je game_start
    cmp al, 's'
    je game_start
    jmp h1    
	
	
    pop di
    pop si
    pop dx
    pop cx
    pop ax
    pop es
    ret

print_current_score:
    push ax
    push bx
    push cx
    push dx
    push es
    push di

    mov ax, 0xb800         ; Video memory segment
    mov es, ax
    xor di, di             ; Clear DI
	
	 mov al, 80             ; Number of columns per row
	mov bl,1
    mul bl                 ; Multiply by row number (2nd row)
    add ax, 24             ; Add column number (30th column)
    shl ax, 1              ; Multiply by 2 (each character is 2 bytes)
    mov di, ax             ; Set DI to the correct position
	mov si, sc             ; Address of "score" string
  .print_score_word:
    lodsb                  ; Load next character from the string
    cmp al, 0              ; Check if end of string (null terminator)
    je hell        ; If null terminator, jump to print number
    mov ah, 0x60           ; Attribute byte (black background, white text)
    stosw                  ; Store character and attribute at [ES:DI]
    jmp .print_score_word   ; Repeat for the next character
	
	
hell:
    mov al, 80             ; Number of columns per row
	mov bl,1
    mul bl                 ; Multiply by row number (2nd row)
    add ax, 30             ; Add column number (30th column)
    shl ax, 1              ; Multiply by 2 (each character is 2 bytes)
    mov di, ax             ; Set DI to the correct position

    mov ax, [score]        ; Load current score
    call int_to_str        ; Convert score to string

    mov cx, 5              ; Length of the score string
print_loop:
    lodsb                  ; Load next character from score string
    mov ah, 0x60           ; Attribute byte (black background, white text)
    stosw                  ; Store character and attribute at [ES:DI]
    loop print_loop        ; Repeat for all characters

    pop di
    pop es
    pop dx
    pop cx
    pop bx
    pop ax
    ret

int_to_str:
    ; Converts the integer in AX to a string in DS:SI
    ; Assumes AX contains the integer and DS:SI points to the buffer
    push ax
    push bx
    push cx
    push dx

    mov cx, 0              ; Initialize digit count
    mov bx, 10             ; Divisor for decimal conversion

.convert_loop:
    xor dx, dx             ; Clear DX
    div bx                 ; Divide AX by 10, quotient in AX, remainder in DX
    add dl, '0'            ; Convert remainder to ASCII
    push dx                ; Push remainder onto stack
    inc cx                 ; Increment digit count
    test ax, ax            ; Check if quotient is zero
    jnz .convert_loop      ; Repeat if quotient is not zero

    mov si, buffer         ; Load buffer address
    add si, cx             ; Move SI to the end of the string
    mov byte [si], 0       ; Null-terminate the string

.pop_digits:
    pop dx                 ; Pop digit from stack
    dec si                 ; Move SI back
    mov [si], dl           ; Store digit in buffer
    loop .pop_digits       ; Repeat for all digits

    pop dx
    pop cx
    pop bx
    pop ax
    ret
print:
           

    mov dx, sc 	
    mov ah, 9 		
    int 0x21 
	
	ret



game_loop:
game:
   
    call delay
    call delay
    call delay
    
    call wait_for_retrace
	call update_screen
	

    call background
    call ground
    call uped
	
call print_current_score
       
	   
    ; mov ah, 01h            
    ; int 16h
    ; jz no_key_pressed      

   
    ; mov ah, 00h            
    ; int 16h
    ; cmp al, 'U'
    ; je flap 

	


	
 
    
    sub word [right], 2
	
    cmp word [right], 480    ;;;;;LEFT CORNER
    jge skip1
     INC WORD [score]
    mov word [right], 624

skip1:
    mov ax, [right]
    push ax
	
	mov ax,4
	push ax
    
    call RECTANGLE
	
	
	

    sub word [mid], 2
    cmp word [mid], 480
    jge skip2
	INC WORD [score]
    mov word [mid], 624

skip2:
    mov ax, [mid]
    push ax
	
	mov ax,6
	push ax
   
    call RECTANGLE

    sub word [left], 2
    cmp word [left], 480
    jge skip3
	INC WORD [score]
    mov word [left], 624

skip3:
    mov ax, [left]
    push ax
	
	mov ax,3
	push ax
   
    call RECTANGLE

    sub word [right_b], 2
    cmp word [right_b], 2880
    jge skip4
	
    mov word [right_b], 3024

skip4:
    mov ax, [right_b]
    push ax
	mov ax,2
	push ax
   
    call RECTANGLE

    sub word [mid_b], 2
    cmp word [mid_b], 2720
    jge skip5
    mov word [mid_b], 2864

skip5:
    mov ax, [mid_b]
    push ax
	mov ax,3
	push ax
    
    call RECTANGLE

    sub word [left_b], 2
    cmp word [left_b], 2400
    jge skip6
    mov word [left_b], 2544

skip6:
    mov ax, [left_b]
    push ax
	
	mov ax,5
	push ax
   
    call RECTANGLE
	
	no_key_pressed:
	 
	call update_bird_position
    call clear_bird
   call draw_bird
	
	
	cmp byte[ground_flag],1
	je endscreen
	
	cmp byte[collision_flag],1
	je endscreen
    
	
	

   cmp byte[flag2],1
   
	je endscreen
    jmp game



start:
	
	
	                    ; Re-enable interrupts
    call clear
    call background
	
	
	
	mov ah, 02h     
    mov bh,  0        
    mov dh, 2         
    mov dl, 27        
    int 10h           

    mov dx, gamename 	
    mov ah, 9 		
    int 0x21 
	
	
    mov ah, 02h     
    mov bh,  0        
    mov dh, 3         
    mov dl, 27        
    int 10h           

    mov dx, smester 	
    mov ah, 9 		
    int 0x21 
	
	mov ah, 02h     
    mov bh,  0        
    mov dh, 4        
    mov dl, 20        
    int 10h           

    mov dx, name1 	
    mov ah, 9 		
    int 0x21 
	
	
	
    mov ah, 02h       
    mov bh,  0        
    mov dh, 5        
    mov dl, 20        
    int 10h           

    mov dx, name2 	
    mov ah, 9 		
    int 0x21 
	
	mov ch, 32
    mov ah, 1
    int 10h
	
	call wait_for_key
	
	
	wapis:
	
	call background
	
	
    mov ax, 12
    push ax
    mov ax, 25
    push ax
    mov ax, 0x70       
    push ax
    mov ax, message1
    push ax
    push word [length1]
    call printstr
    pop ax
    
    
    mov ax, 13
    push ax
    mov ax, 16
    push ax
    mov ax, 0x70       
    push ax
    mov ax, message2
    push ax
    push word [length2]
    call print_message
	 mov ax, 14
    push ax
    mov ax, 24
    push ax
    mov ax, 0x70       
    push ax
    mov ax, msg
    push ax
    push word [len]
    call print_message
	
	
	

start_game:
    call wait_for_key
    cmp al, 'S'        
    je game_start
    cmp al, 's'
    je game_start
    cmp al, 'E'
    je endgame
    cmp al, 'e'
    je endgame
	CMP al,'I'
	je show_instructions
	CMP al,'i'
	je show_instructions
    jmp start_game    

game_start:



  
    call background
	call uped
	call ground
	mov  ax, [right]
    push ax
	mov ax,4
	push ax
	
	call RECTANGLE
	
	
	
	 mov ax, [right_b] 
    push ax
	mov ax,2
	push ax
	call RECTANGLE

	
	call draw_bird
	
	CALL wait_for_key
	
	
	
	xor ax, ax
	mov es, ax
	mov ax,[es:9*4]
	mov [oldisr],ax
	mov ax,[es:9*4+2]
	mov [oldisr+2],ax
	
	
	mov ax, [es:8*4]          ; Save INT 8 old ISR offset
mov [oldisr2], ax
mov ax, [es:8*4+2]        ; Save INT 8 old ISR segment
mov [oldisr2+2], ax

	
	cli                       
	mov word [es:9*4], kbisr  
	mov [es:9*4+2], cs   

	mov word[es:8*4],timer
	mov [es:8*4+2],cs


	
	sti 
	
	
	
	
	
	jmp game_loop

endgame:

mov al,0x20
out 0x20,al	
call clear
	mov ch, 6
	mov cl, 7
	mov ah, 1
	int 10h
	
    mov ax, 0x4c00
    int 0x21          
	
	
handle_endgame:
    call unhook_keyboard_isr  
    call unhook_timer_isr  
	call clear
    jmp endgame
	
	
timer:
    push ax
    push bx
    push cx
    push dx

    mov al, [cs:flag]
    cmp al, 1
    je timer_done         
   
    inc word [cs:tick_count]

    cmp word [cs:tick_count], 18
    jne timer_done            
    
   
    mov word [cs:tick_count], 0
    mov byte [cs:release_flag], 1
    CALL update_bird_position

timer_done:
   
    mov al, 0x20
    out 0x20, al

    
    pop dx
    pop cx
    pop bx
    pop ax

    iret
	
	
print_string:
mov ax,0xB800
mov es, ax
    
    lodsb                     
    cmp al, 0                 
    je end_print              
    mov ah, 0x0E              
    mov bh, 0                 
    mov bl, 0x14              
    int 0x10                  
    jmp print_string          

end_print:
    ret

show_instructions:
    
    call background

   call move_to_next_line
   

    
    mov si, welcome_msg      
    call print_string        
    call move_to_next_line   

    
    mov si, line_1_msg
    call print_string
    call move_to_next_line

    mov si, line_2_msg
    call print_string
    call move_to_next_line

    mov si, line_3_msg
    call print_string
    call move_to_next_line

    mov si, line_4_msg
    call print_string
    call move_to_next_line

    mov si, line_5_msg
    call print_string
    call move_to_next_line

    mov si, line_6_msg
    call print_string
    call move_to_next_line

    mov si, line_7_msg
    call print_string
    call move_to_next_line

    mov si, line_8_msg
    call print_string
	CALL move_to_next_line
	mov si, line_9_msg
    call print_string
	
	mov byte[counter],8

    
    call wait_for_key

    
    jmp  wapis
	


                     






move_to_next_line:
	
    mov ah, 0x02            
    mov bh, 0             
    mov dh, [counter]       
    mov dl, 20               
	add byte[counter],1
    int 0x10                
    ret
	


  
	
	
	
	
welcome_msg db 'WELCOME TO FLAPPY BIRD GAME!', 0
line_1_msg db '1. PRESS up arrow key FLAP AND GAIN HEIGHT.', 0
line_2_msg db '2. AVOID PIPES OR GROUND TO STAY ALIVE.', 0
line_3_msg db '3. YOUR SCORE INCREASES AS YOU PASS PIPES.', 0
line_4_msg db '4. PRESS ESC TO PAUSE THE GAME.', 0
line_5_msg db '5. PRESS I TO VIEW INSTRUCTIONS AGAIN.', 0
line_6_msg db '6. PRESS E TO exit THE GAME.', 0
line_7_msg db '7. TRY TO SCORE THE HIGHEST POINTS!', 0
line_8_msg db '-> GOOD LUCK AND HAVE FUN!', 0
line_9_msg db '-> Press any key to continue', 0


counter: db 8
release_flag : db 0
tick_count : dw 0


Save_Ground: dw 0,0,0,0,0


collision_flag: db 0;