; ; sorting a list of ten numb   xers using bubble sort
; [org 0x0100]
			; jmp start
; num: dw 5
; result: dw 0

; start:		
		; mov ax,[num]			;getting number whose factorial is to be calculated value
		; mov dx,ax			;total sum

; outerloop:			
		; mov bx,0			;counter
		; mov cx,dx			;tracker
		; sub ax,1			;number giver
		; mov dx,0			;inititalized to zero
		; cmp ax,0x01   			;campare to 1
		; je outOfLoop
		
; innerloop:	add dx,ax			;factorial counting
		; add bx,1			;counting
		; cmp bx,cx			;checking if equal
		; jne innerloop			;again run iteration if not equal
		; jmp outerloop			
		
; outOfLoop:
		; mov [result],cx			;result stored
		
; mov ax, 0x4c00 ; terminate program
; int 0x21
[org 0x0100]


graphics:
	; mov cx,80 * 25   
	; mov ax,0xB800
	; mov es,ax
	; mov ds,ax
	; mov di,buffer
	; mov si,0
	; rep movsw
	mov ax, 0x0013	;for 320*200 pixels
	int 0x10				;switches to this mode
	mov ax, 0xA000	;seg address for video memory
	mov es, ax			;access to video buffer
	call background
	jmp start
buffer: resb 80 * 25    
bird_pos: dw 31180
beak_pos: dw 32158
rect_pos: dw 48920
collision_detected: dw 0
rect_pos1: dw 0
rect_pos2: dw 0
rect_pos_down: dw 0
rect_pos_down1: dw 0
rect_pos_down2: dw 0
isAnimating: dw 0
BirdDirection: db 'D'
bird_position_holder: dw 0
section .data
    GameTitle db 'Assembler Aviator', 0
    RollNumbers db 'Roll Numbers: 23L-0815, 23L-0576', 0
    Names db 'Developed by: Ali Jafar,Tayyab Khalil', 0
    Semester db 'Semester: Fall 2024', 0
    Instructions db 'Press UP ARROW to move up,ESC to quit', 0
    StartMessage db 'Press any key to start...', 0


PrintStringCentered:
    pusha
    mov ah, 0Eh         ; BIOS teletype output function
    mov bh, 0           ; Page number
    mov bl, 15          ; White text color

print_loop:
    lodsb               ; Load next character from string
    cmp al, 0           ; Check for null terminator
    je done_print
    int 10h             ; Print character
    jmp print_loop

done_print:
    popa
    ret
background:
    xor di, di          ; Start at the beginning of video memory
    mov cx, 320 * 200   ; Total pixels (320x200 screen)
    mov al, 2   ; Red background, light yellow text
    rep stosb           ; Fill the screen with color
    ret
; --- Display Introduction Screen ---
DisplayIntroduction:
    call background     ; Ensure background is visible
    mov dh, 7           ; Start printing vertically centered (row 7)
    mov dl, 3         ; Start printing horizontally centered (column 10)
    mov si, GameTitle
    call PrintStringAtPosition

    mov dh, 9
    mov si, RollNumbers
    call PrintStringAtPosition

    mov dh, 11
    mov si, Names
    call PrintStringAtPosition

    mov dh, 13
    mov si, Semester
    call PrintStringAtPosition
    mov dh, 15
    mov si, Instructions
    call PrintStringAtPosition
    mov dh, 17
    mov si, StartMessage
    call PrintStringAtPosition
    ret
; --- Print String at Specified Position ---
PrintStringAtPosition:
    pusha
    mov ah, 02h         ; Set cursor position function
    int 10h

    mov ah, 0Eh         ; BIOS teletype output function
    mov bh, 0           ; Page number
    mov bl, 15          ; White text color

print_position_loop:
    lodsb               ; Load next character from string
    cmp al, 0           ; Check for null terminator
    je done_position_print
    int 10h             ; Print character
    jmp print_position_loop

done_position_print:
    popa
    ret 


ShowExitConfirmation:
    mov ah, 0Eh
    mov al, 'E'
    int 10h
    mov al, 'x'
    int 10h
    mov al, 'i'
    int 10h
    mov al, 't'
    int 10h
    mov al, '?'
    int 10h
    ; Wait for 'Y' or 'N' key press
    mov ah, 0
    int 16h
    cmp al, 'Y'
    je exit_game
    ret
exit_game:
		; mov cx,80 * 25   
	; mov ax,0xB800
	; mov es,ax
	; mov ds,ax
	; mov si,buffer
	; mov si,0
	; rep movsw
    xor di, di                			;Start at the top of video memory
    mov cx, 320 * 200 / 2     ;Number of words to write (160,000 bytes / 2)
    mov ax, 0x0720            ; Attribute: White text on black background, character: space (0x20)
    rep stosw                 ; Fill the screen with spaces
    mov ax, 0x4C00            ; DOS function to terminate the program
    int 0x21                  ; Call DOS interrupt to exit the game

; exit_game:
	; xor di,di
	; mov cx,320*200
	; mov ax,0x0720
	; rep stosb
	; mov ax, 0x4C00        ; DOS function to terminate the program
    ; int 0x21              ; Call DOS interrupt to exit the game

upper_part:
	xor di, di				;points to start
	mov al, 11			;color
	mov cx, 320*60	;range
	rep stosb				;instruction to color this range
	ret

medium_part:
	mov di, 320*60		;points to specific point
	mov al, 9              ;color
	mov cx, 360*60    ;range
	rep stosb             ;instruction to color this range
	ret
lower_part:
	mov di, 320*120	;points to specific point
	mov al, 1              ;color
	mov cx, 320*80    ;range
	rep stosb             ;instruction to color this range
	ret
bird_body:
	pusha
    mov bx,12            ;height of bird body
    mov si, [bird_pos]      ;points to the middle of screen
	body:
    mov di, si           	;Start at pixel 31180 
    mov al, 14			;Color index for yellow
    mov cx, 18			;width of body

    rep stosb
    sub bx,1				;decrement the length counter
    add si, 320           ;move to the next row since one line consists of 320 pixels
    cmp bx ,0 
    jnz body
	sub si,320
	mov [bird_position_holder],si
	popa
    mov bx,2              ;height of bird's peak
    mov si, [beak_pos]       ;points to the top left corner of bird's peak
	ret	
bird_beak:
    mov di, si             ;Start at pixel 32158 
    mov al, 10            ;Color index for lightgreen
    mov cx, 4             ;width of beak
    rep stosb
    sub bx,1               ;decrement the length counter
    add si, 320            ;move to the nex row since one line consists of 320 pixels
    cmp bx ,0 
    jnz bird_beak

    mov si,0	
    mov bx,50             ;height of lower rectangle
    mov si, [rect_pos]       ;position of rectangle 
	ret	
green_rect_down:
    mov di, si              ;Start at pixel 38400 
    mov al, 2               ;Color index for Green
    mov cx, 28             ;width of body
    rep stosb
    sub bx,1                ;decrement the length counter
    add si, 320             ;move to uithe nex row since one line consists of 320 pixels
    cmp bx ,0 
    jnz green_rect_down
    mov si,0	
    mov bx,70             ;height of rectangle
    mov si, 00280        ;position of upper rectangle 
	ret
green_rect_up:
	mov di, si               ;Start at pixel 00920 
	mov al, 2                ;Color index for Green
	mov cx, 28             ;width of body
	rep stosb
	sub bx,1                 ;decrement the length counter
	add si, 320             ;move to the nex row since one line consists of 320 pixels
	cmp bx ,0 
	jnz green_rect_up

    mov dx,50				;width of triangle
    mov si,120            	;starting row
	ret
wave_loop:
	mov ax, si
	shl ax, 8					;multiply by 256
	mov bx, si
	shl bx, 6					;multiply by 64
	add ax, bx				;point on video memory where it will start making wave
	mov di, ax				;starting point copies to di				
	cmp dx, 0
	jle end_wave			;exit
	mov al, 9					;color
	mov cx, dx				;width
	rep stosb
	sub dx, 2					;width of triangle
	add si, 1					;loop to go to next row
	jmp wave_loop
	end_wave:
	mov dx, 50
	mov si, 120
	mov bp, 50
	ret
wave_loop_inverted:
	mov ax, si
	shl ax, 8					;multiply by 256
	mov bx, si
	shl bx, 6					;multiply by 64
	add ax, bx				;calculate video memory start point
	mov di, ax				;set DI for start
	add di, bp				;adjust DI by BP offset
	cmp dx, 0
	jle end_wave_inverted		;exit if DX is zero
	mov al, 9					;set color
	mov cx, dx				;set width
	rep stosb					;draw line
	sub dx, 2					;decrease width
	add bp, 2					;move start right
	add si, 1					;next row
	jmp wave_loop_inverted		;repeat loop
	end_wave_inverted:
	mov dx, 50				;reset DX
	mov si, 120				;reset SI
	ret
wave_loop1:	
	mov ax, si         		;copy si
	shl ax, 8            		;multiply
	mov bx, si         		
	shl bx, 6            		;multiply
	add ax, bx         		
	mov di, ax         		;set di
	add di, 100        		
	cmp dx, 0          		;check DX
	jle end_wave1    		;exit
	mov al, 9           		;color
	mov cx, dx        		;width
	rep stosb           		;draw
	sub dx, 2           		;decrease
	add si, 1            		;next row
	jmp wave_loop1        ;loop
	end_wave1:
	mov dx, 50          		;reset DX
	mov si, 120         		;reset SI
	mov bp, 150        		;set BP
	ret                 
wave_loop_inverted1:
	mov ax, si            	;copy SI
	shl ax, 8           		;multiply
	mov bx, si          		;copy SI
	shl bx, 6          			;multiply
	add ax, bx          		;calculate
	mov di, ax          		;set DI
	add di, bp          		;offset
	cmp dx, 0          		;check DX
	jle end_wave_inverted1 ; exit
	mov al, 9           		;color
	mov cx, dx          		;width
	rep stosb           		;draw
	sub dx, 2           		;decrease
	add bp, 2          		;increment BP
	add si, 1           		;increment to next row
	jmp wave_loop_inverted1 ; loop
	end_wave_inverted1:
	mov dx, 50          ; reset DX
	mov si, 120         ; reset SI
	ret 
wave_loop2:	
	mov ax, si          		;copy SI
	shl ax, 8            		;multiply
	mov bx, si          		;copy SI
	shl bx, 6            		;multiply
	add ax, bx          		;calculate
	mov di, ax          		;set DI
	add di, 200         		;offset
	cmp si, 200        		 ;check SI
	jge end_wave2    		 ;exit
	cmp dx, 0           		;check DX
	jle end_wave2     		 ;exit
	mov al, 9           		 ;color
	mov cx, dx         		 ;width
	rep stosb           		 ;draw
	sub dx, 2           		 ;decrease
	add si, 1           		 ;increment to next row
	jmp wave_loop2        ;loop
	end_wave2:
	mov dx, 50          		;reset DX
	mov si, 120         		;reset SI
	mov bp, 250        		;set BP
	ret              

wave_loop_inverted2:
	mov ax, si          	;copy SI
	shl ax, 8           	;multiply
	mov bx, si          	;copy SI
	shl bx, 6          		;multiply
	add ax, bx          	;calculate
	mov di, ax          	;set DI
	add di, bp          	;offset
	cmp si, 200         ;check SI
	jge end_wave_inverted2 ;exit
	cmp dx, 0           ;check DX
	jle end_wave_inverted2 ;exit
	mov al, 9           	;color
	mov cx, dx          	;width
	rep stosb           	;draw
	sub dx, 2           	;decrease
	add bp, 2           	;increment BP
	add si, 1           	;increment
	jmp wave_loop_inverted2 ;loop
	end_wave_inverted2:
	mov dx, 50          ;reset DX
	mov si, 120         ;reset SI
	ret                
wave_loop3:
	mov ax, si          	;copy SI
	shl ax, 8           	;multiply
	mov bx, si          	;copy SI
	shl bx, 6           	;multiply
	add ax, bx          	;calculate
	mov di, ax          	;set DI
	add di, 300         	;offset
	cmp si, 200         	;check SI
	jge end_wave3      ;exit
	cmp dx, 0           	;check DX
	jle end_wave3       ;exit
	mov al, 9          	;color
	mov cx, dx          	;width
	rep stosb           	;draw
	sub dx, 2           	;decrease
	add si, 1           	;increment
	jmp wave_loop3    ;loop
	end_wave3:
	sub dx, 2           	;decrease DX
	add si, 1          		;increment SI
	ret                 

ground:
	mov di,57600      ;position
	mov al,10            ;color green
	mov cx,320*10    ;width
	rep stosb            ;draw
	mov di,60800      ;position
	mov al,6              ;color brown
	mov cx,320*10     ;width
	rep stosb             ;draw
	ret 
          
delay:
	pusha
	mov cx,64000
delay1:
	loop delay1
	popa
	ret

collision:
	pusha
	cmp word[bird_pos],0
	jae next_check
	mov word[collision_detected],1
	jmp get_out
next_check:
	cmp word[bird_pos],59840
	jb next_check1
	mov word[collision_detected],1
	jmp get_out
next_check1:
	mov ax,[beak_pos]
	mov dx,0
	mov cx,320
	div cx
	cmp dx,[rect_pos]
	jne next_check2
	mov word[collision_detected],1
	jmp get_out
next_check2:
	cmp dx,[rect_pos1]
	jne next_check3
	mov word[collision_detected],1
	jmp get_out
next_check3:
	cmp dx,[rect_pos2]
	jne next_check4
	mov word[collision_detected],1
	jmp get_out
next_check4:
	mov si,dx
	mov ax,[rect_pos_down]
	mov cx,320
	mov dx,0
	div cx
	cmp si,dx
	jne next_check5
	mov word[collision_detected],1
	jmp get_out
next_check5:
	mov ax,[rect_pos_down1]
	mov cx,320
	mov dx,0
	div cx
	cmp si,dx
	jne next_check6
	mov word[collision_detected],1
	jmp get_out
next_check6:
	mov ax,[rect_pos_down2]
	mov cx,320
	mov dx,0
	div cx
	cmp si,dx
	jne get_out
	mov word[collision_detected],1
	jmp get_out
get_out:	
	popa
	ret

remover_bird:
	pusha
	cmp si, 320*60
	jb sky_color
	cmp si,320*120
	jb blue_color

	mov al,1
	mov cx,18
	rep stosb
	jmp outa
blue_color:
	mov al,9
	mov cx,18
	rep stosb
	jmp outa

sky_color:
	mov al,11
	mov cx,18
	rep stosb
	jmp outa
outa:
	popa
	ret

bird_falling:
	pusha
	mov si,word[bird_pos]
	call remover_bird
	add word[bird_pos],320
	add word[beak_pos],320
	call bird_body
	call collision
	popa
	ret

shift_left:
    pusha                   ; Save registers
    mov ax, 0xA000          ; Video memory segment
    mov es, ax
    mov ds, ax              ; Set DS to video memory
    mov si, 48800            ; Start from the second column
    mov di, 48798         ; Copy to the first column
    mov cx, 8800  ; Total pixels - 2 (to avoid overflow)
    cld                     ; Clear direction flag (forward copy)
    rep movsb               ; Copy bytes to shift left
	mov si,2
	mov di,0
	mov cx,320*60-2
	cld                     ; Clear direction flag (forward copy)
    rep movsb               ; Copy bytes to shift left
	mov si,320*60+2
	mov di,320*60
	mov cx,320*10
	cld
    rep movsb   
    popa                    ; Restore registers
    ret

moving_up:
	pusha
mov ax,0xb800
   mov ds, ax
	sub word[bird_pos],320
	sub word[beak_pos],320
	call bird_body
	call collision
	mov si,[bird_position_holder]
	call remover_bird
	popa
	ret
HandleKeyPress:
    pusha                       ; Save all general-purpose registers
    push ds                     ; Save data segment
    push es                     ; Save extra segment
    mov ax, 0xA000              ; Set DS to text mode segment (to avoid video memory interference)
	mov es,ax
	mov ax,0xb800
   mov ds, ax
    mov ah, 01h               ; Check if a key is pressed (non-blocking)
    int 16h
    jz no_key                   ; If no key is pressed, jump to no_key
    mov ah, 0                   ; BIOS function to read key press (blocking)
    int 16h
    cmp al, 01h                 ; Check if ESC key is pressed
    je ShowExitConfirmation
    cmp ah, 48h                 ; Check if UP ARROW key is pressed (scan code)
    je up_up
    mov byte [BirdDirection], 'D' ; Default to downward movement
    jmp end_keypress
up_up:
    mov byte [BirdDirection], 'U' ; Set direction to Up
end_keypress:
    pop es                      ; Restore extra segment
    pop ds                      ; Restore data segment
    popa                        ; Restore general-purpose registers
    ret
no_key:
    mov byte [BirdDirection], 'D' ; Default to downward movement when no key is pressed
    pop es                       ; Restore extra segment
    pop ds                       ; Restore data segment
    popa                         ; Restore general-purpose registers
    ret
PrintStartScreen:
	call upper_part		
	call medium_part
	call lower_part
	call bird_body
	call bird_beak
	call green_rect_down
	call green_rect_up
	call wave_loop
	call wave_loop_inverted
	call wave_loop1
	call wave_loop_inverted1
	call wave_loop2
	call wave_loop_inverted2
	call wave_loop3
	call ground
	ret

PlayAnimation:
    call delay
    ; call delay
    ; call delay
    ; call delay
    ; call delay
    ; call delay
    ; call delay
    ; call delay
    ; call delay
    ; call delay
    ; call delay
   ; call delay
    ; call delay
    ; call delay
    ; call delay
    ; call delay
    ; call delay
    call shift_left

    mov al, [BirdDirection]
    cmp al, 'U'
    je move_up
    cmp al, 'D'
    je move_down
move_up:
   call moving_up
    jmp end_move
move_down:
    call bird_falling
    jmp end_move
end_move:
    ret
anime:
main_loop:
     call HandleKeyPress
    call PlayAnimation
    jmp main_loop
	ret
kbisr:
    pusha                       ; Save all general-purpose registers
    push ds                     ; Save DS
    push es                     ; Save ES
    mov ax, 0xA000              ; Point ES to video memory segment
    mov es, ax
    in al, 0x60                 ; Read the scan code from keyboard port (0x60)
    cmp al, 0x01                ; Check if ESC key was pressed (scan code 0x01)
    je exit_game                ; If ESC, jump to exit game routine
    call PrintStartScreen       ; Display the static screen
    mov byte [isAnimating], 1   ;Set animation flag to start the game
	call anime
    mov al, 0x20                ; End of interrupt (EOI) command
    out 0x20, al                ; Send EOI to the PIC
    pop es                      ; Restore ES
    pop ds                      ; Restore DS
    popa                        ; Restore general-purpose registers
    iret                        ; Return from interrupt
start:
	call DisplayIntroduction	
	pusha
	xor ax, ax
	mov es, ax					; es=0, point es to IVT base
	cli					
	mov word [es:9*4], kbisr		; store offset at n*4....... csabc:kbisr	
	mov [es:9*4+2], cs			;store segment at n*4+2
	sti	
	popa

	; mov ah,0x99
	; mov al,0x2A
	; mov word [es:4], ax
	mov ax, cs
	mov ds, ax
	; call PrintStartScreen
; WaitForStart:
    ; cmp byte [isAnimating], 1
    ; jne WaitForStart               ;Loop until isAnimating is set 
	; jmp main_loop

	; call PrintStartScreen




labela:
	; call iteration
; jmp labela
	xor ax, ax
	int 0x16	
	mov ax, 0x0003
	int 0x10
	mov ax, 0x4C00
int 0x21