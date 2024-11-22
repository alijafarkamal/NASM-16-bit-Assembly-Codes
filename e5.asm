; ; [org 0x0100]
		; ; mov ax, 0xb800
		; ; mov es, ax					; point es to video base
		; ; jmp start
		
; ; nextloc:	
			; ; mov word [es:di], 0x0720	; clear next char on screen
			; ; add di, 2					; move to next screen location
			; ; cmp di, 4000				; has the whole screen cleared
			; ; jne nextloc					; if no clear next position
			; ; mov di,0
; ; MovingStar:
	; ; mov word[es:di],0x8C2A
	; ; call delay
	; ; mov word[es:di],0x0720
	; ; add di,bx
	; ; cmp di,si
	; ; jz out
	; ; ret
	
; ; MovingStar1:
	; ; mov word[es:di],0x8A2A
	; ; call delay
	; ; mov word[es:di],0x0720
	; ; sub di,bx
	; ; cmp di,si
	; ; jz out1
	; ; ret
; ; delay:      push cx
			; ; mov cx, 0xFFFF
; ; loop3:		loop loop3
			; ; mov cx, 0xFFFF
; ; loop4:		loop loop4
			; ; mov cx, 0xFFFF
; ; loop2:		loop loop2
			; ; mov cx, 0xFFFF
; ; loop5:		loop loop5
			; ; pop cx
			; ; ret
; ; start:
		; ; mov di,0
		; ; mov cx,80
		; ; mov bx,2
		; ; mov si,158
		; ; call nextloc
; ; next: 
			; ; mov ax, 0xb800 					; load video base in ax
			; ; mov es, ax 					; point es to video base
			; ; mov di, 0 					; point di to top left column
									; ; es:di pointint to --> 0xB800:0000 (B8000)

; ; nextchar: 	
		; ; mov word [es:di], 0x0720 				; clear next char on screen
		; ; add di, 2 						; move to next screen location
		; ; cmp di, 4000 						; has the whole screen cleared
		; ; jne nextchar 
		; ; ret 
; ; start:	
		; ; call next
		; ; mov di,1640
		; ; mov byte[es:di],0x2A00
		; ; mov ax,0x8434
		; ; mov bl,0x85
		; ; div bl
		; ; mov ax,0xffff
		; ; mov dx,0x0100
		; ; mov bl,0x3
		; ; div bl
; ; LOOP1:
		; ; call MovingStar
		; ; loop LOOP1
; ; out:
		; ; mov cx,24	
		; ; mov bx,160
		; ; mov si,4000
; ; LOOP2:
		; ; call MovingStar
		; ; loop LOOP2
		; ; mov cx,80
		; ; mov bx,2
		; ; mov si,3840
; ; LOOP3:
		; ; call MovingStar1
		; ; loop LOOP3
; ; out1:
		; ; mov cx,24
		; ; mov bx,160
		; ; mov si,160
; ; LOOP4:
	; ; call MovingStar1
	; ; loop LOOP4
; ; exit:
		; ; mov di,2
		; ; mov cx,80
		; ; mov bx,2
		; ; mov si,158
; ; jmp start1
; ; mov ax, 0x4c00 ; terminate program
; ; int 0x21
; ; [org 0x0100]
; ; jmp start
; ; clrscr:		push es
			; ; push ax
			; ; push di

			; ; mov ax, 0xb800
			; ; mov es, ax					; point es to video base
			; ; mov di, 0					; point di to top left column

; ; nextloc:	mov word [es:di], 0x0720	; clear next char on screen
			; ; add di, 2					; move to next screen location
			; ; cmp di, 4000				; has the whole screen cleared
			; ; jne nextloc					; if no clear next position

			; ; pop di
			; ; pop ax
			; ; pop es
			; ; ret
; ; --------------------------------------------------------------------
; ; subroutine to print a string at top left of screen
; ; takes address of string and its length as parameters
; ; --------------------------------------------------------------------
; ; printstr:	push bp
			; ; mov bp, sp
			; ; push es
			; ; push ax
			; ; push cx
			; ; push si
			; ; push di

			; ; mov ax, 0xb800
			; ; mov es, ax				; point es to video base
			; ; mov di, 160				; point di to top left column
									; ; es:di --> b800:0000
			; ; mov si, [bp+6]			; point si to string
			; ; mov cx, [bp+4]			; load length of string in cx
			; ; mov ah, 0x07			; normal attribute fixed in al
			
; ; nextchar:	mov al, [si]			; load next char of string
			; ; mov [es:di], ax			; show this char on screen
			; ; add di, 2				; move to next screen location
			; ; add si, 1				; move to next char in string			
			; ; loop nextchar			; repeat the operation cx times
			
			; ; pop di
			; ; pop si
			; ; pop cx
			; ; pop ax
			; ; pop es
			; ; pop bp
			; ; ret 4
; ; makeborders:
; ; push bp
; ; mov bp,sp
; ; pusha
; ; mov cx,2000
; ; mov ax,0xB800
; ; mov es,ax
; ; mov ax,0x7000
; ; mov di,0
; ; loopa:
	; ; add word[es:di],ax
	; ; add di,2
; ; loop loopa
; ; mov cx,80
; ; mov di,0
; ; mov ah,0x70
; ; mov al,'A'
; ; rep stosw
; ; mov cx,78
; ; mov di,162
; ; mov al,'B'
; ; rep stosw

; ; mov cx,80
; ; mov di,160*24
; ; mov al,'A'
; ; rep stosw
; ; mov cx,78
; ; mov di,160*23+2
; ; mov al,'B'
; ; rep stosw
; ; mov cx,0xFFFF
; ; push es
; ; pop ds
; ; cld
; ; mov si,162
; ; mov di,160*23+2
; ; repe cmpsb
; ; mov ah,0xCC
; ; mov al,'L'
; ; mov [es:di],ax
; ; mov word[msg],di
; ; mov ah, 0x13
; ; mov al, 1c
; ; mov bh, 0
; ; mov bl, 7
; ; mov dx, 0x0A03
; ; mov cx, 5
; ; push cs
; ; pop es
; ; mov bp, msg
; ; int 0x10
; ; mov [es:di],
	; ; popa
; ; pop bp
; ; rep stosw
; ; banomansingh:
	; ; push bp
; ; mov bp,sp
; ; pusha
	; ; mov ax,0xB800
	; ; mov es,ax
	; ; mov ah,0x07
	; ; mov al,'$'
	; ; mov di,160
	; ; mov cx,20
	; ; rep stosw
	; ; mov cx,20
	; ; mov di,1600
	; ; rep stosw
	; ; mov cx,8
	; ; mov di,320
; ; loopa:
	; ; stosw
	; ; add di,158
; ; loop loopa

; ; mov ax,0xCC20
; ; mov di,322
; ; mov dx,1
; ; bigLoop:
	; ; mov cx,18
	; ; rep stosw
	; ; add di,160
	; ; sub di,36
	; ; inc dx
	; ; cmp dx,9
	; ; je out
; ; jmp bigLoop
; ; out:
	; ; popa
	; ; pop bp
; ; ret
; ; start:
	; ; call clrscr
	; ; call banomansingh
; ; mov ah, 0x13
; ; mov al, 1
; ; mov bh, 0
; ; mov bl, 7
; ; mov dx, 0x0A03
; ; mov cx, 11
; ; push cs
; ; pop es
; ; mov bp, message
; ; int 0x10; service 13 - print string
; ; subservice 01 – update cursor
; ; output on page 0
; ; normal attrib
; ; row 10 column 3
; ; length of string
	; ; call makeborders
	; ; xor ax, ax
	; ; mov es, ax
	; ; load zero in es
	; ; mov word [es:0*4], myisrfor0 ; store offset at n*4
	; ; mov [es:0*4+2], cs
	; ; store segment at n*4+2
	; ; call genint0
	; ; generate interrupt 0
; ; mov ax, 0x4c00
; ; int 0x21
; BITS 16
; ORG 0x100               ; COM file starts at 100h

; SECTION .data           ; Data section
; oldInt9 dw 0            ; To store old INT 9h vector
; videoMemoryStart dw 0xB800
; videoMemorySize dw 4000 ; 80 columns, 25 rows, 2 bytes per character

; SECTION .bss            ; Uninitialized data section
; screenBuffer resb 4000  ; Buffer to save the screen (80x25x2)

; SECTION .text           ; Code section
; start:
    ; ; Save old INT 9h vector
    ; cli                 ; Clear interrupts
    ; push ax
    ; push es
    ; mov ax, 0           ; Segment address of IVT
    ; mov es, ax
    ; mov ax, [es:9*4]    ; Offset of old INT 9h handler
    ; mov word [oldInt9], ax
    ; mov ax, [es:9*4+2]  ; Segment of old INT 9h handler
    ; mov word [oldInt9+2], ax

    ; ; Set new INT 9h vector to our ISR
    ; lea dx, newInt9Handler
    ; mov [es:9*4], dx
    ; mov [es:9*4+2], cs

    ; pop es
    ; pop ax
    ; sti                 ; Set interrupts

    ; ; Terminate but stay resident
    ; mov ax, 0x3100      ; AH = 31h, AL = 0 (return code)
    ; mov dx, 0x1000      ; DX = number of paragraphs to keep resident
    ; int 0x21            ; DOS interrupt

; newInt9Handler:
    ; pusha               ; Save all registers
    ; in al, 0x60         ; Read from the keyboard port
    ; cmp al, 0x2E        ; Scan code for 'c'
    ; je saveScreen
    ; cmp al, 0x2F        ; Scan code for 'v'
    ; je restoreScreen
    ; jmp callOldInt9     ; Not 'c' or 'v', call old ISR

; saveScreen:
    ; mov si, videoMemoryStart
    ; mov di, screenBuffer
    ; mov cx, videoMemorySize
    ; rep movsb           ; Save screen to buffer
    ; jmp endISR

; restoreScreen:
    ; mov si, screenBuffer
    ; mov di, videoMemoryStart
    ; mov cx, videoMemorySize
    ; rep movsb           ; Restore screen from buffer

; callOldInt9:
    ; call dword [oldInt9] ; Call old ISR

; endISR:
    ; popa                ; Restore all registers
    ; mov al, 0x20        ; EOI to PIC
    ; out 0x20, al
    ; iret                ; Return from interrupt

; SECTION .bss
; align 16
; screenBuffer resb 4000 ; 80*25*2 bytes (screen size 80x25, 2 bytes per character)

; SECTION .text
; global _start
; _start:
    ; ; Installation of the TSR part omitted for brevity

; ; Assume SaveScreen and RestoreScreen are implemented correctly somewhere
[org 0x0100]
jmp start

buffer: times 4000 db 0
oldisr: dd 0

kbisr:
    push ax
    push es
    mov ax, 0xb800
    mov es, ax
    in al, 0x60
    cmp al, 0x2E
    jne nextcmp2
    call saveScreen
    jmp exit

nextcmp2:
    cmp al, 0x2F
    jne nomatch
    call restoreScreen
    jmp nomatch

nomatch:
    pop es
    pop ax
    jmp far [cs:oldisr]

exit:
    mov al, 0x20
    out 0x20, al
    pop es
    pop ax
    iret

start1:

sleep:
    push cx
    mov cx, 0xFFFF
delay:
    loop delay
    pop cx
    ret

clrscr:
    push es
    push ax
    push di
    mov ax, 0xb800
    mov es, ax
    mov di, 0
nextloc:
    mov word [es:di], 0x0720
    add di, 2
    cmp di, 4000
    jne nextloc
    pop di
    pop ax
    pop es
    ret

saveScreen:
    pusha
    mov cx, 4000
    mov ax, 0xb800
    mov ds, ax
    push cs
    pop es
    mov si, 0
    mov di, buffer
    cld
    rep movsb
    popa
    ret

restoreScreen:
    pusha
    mov cx, 4000
    mov ax, 0xb800
    mov es, ax
    push cs
    pop ds
    mov si, buffer
    mov di, 0
    cld
    rep movsb
    popa
    ret

start:
    xor ax, ax
    mov es, ax
    mov ax, [es:9*4]
    mov [oldisr], ax
    mov ax, [es:9*4+2]
    mov [oldisr+2], ax
    cli
    mov word [es:9*4], kbisr
    mov [es:9*4+2], cs
    sti
    mov dx, start
    add dx, 15
    mov cl, 4
    shr dx, cl
    mov ax, 0x3100
    int 0x21