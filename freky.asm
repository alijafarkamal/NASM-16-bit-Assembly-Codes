; [org 0x0100]

; jmp start

; pausescreenmessage: db 'Press ENTER to confirm or BACKSPACE to return'
; pausescreenmessage_length: dw 45

; instructionscreenmessage1: db 'Objective:'
; instructionscreenmessage1_length: dw 10
; instructionscreenmessage2: db '- Navigate the bird through the gaps in the pipes'
; instructionscreenmessage2_length: dw 49
; instructionscreenmessage3: db '- Avoid crashing into the pipes or the ground'
; instructionscreenmessage3_length: dw 45
; instructionscreenmessage4: db '- Earn 1 point for every pipe you successfully pass'
; instructionscreenmessage4_length: dw 51
; instructionscreenmessage5: db 'Controls:'
; instructionscreenmessage5_length: dw 9
; instructionscreenmessage6: db '- Press SPACEBAR to make the bird jump'
; instructionscreenmessage6_length: dw 38
; instructionscreenmessage7: db '- Press ANY key to start the game & ESC to pause'
; instructionscreenmessage7_length: dw 48

; title_text1: db 'PRESS ANY KEY'
; title_text1_length: dw 13
; title_text2: db 'DANIYAL ZAIDI  23L-0718'
; title_text2_length: dw 23
; title_text3: db 'SAREM WAHEED   23L-0885'
; title_text4: db 'Fall 2024'
; title_text4_length: dw 9

; pipeWidth: dw 1      ; changes
; pipeWidthReal: dw 8  ; constant

; pipeWidth1: dw 1
; pipeWidth2: dw 1
; pipeWidth3: dw 1

; pipeHeight: dw 9

; pipeHeight1: dw 9
; pipeHeight2: dw 9
; pipeHeight3: dw 9

; difference: dw 8
; groundHeight: dw 2
; CurrentCol: dw 79

; CurrentCol1: dw 79
; CurrentCol2: dw 79
; CurrentCol3: dw 79

; birdR: dw 12
; birdC: dw 35

; birdDirection: db 'D'

; init: dw 0

; init1: dw 0
; init2: dw 0
; init3: dw 0

; flagPillar: dw 0

; flagPillar1: dw 0
; flagPillar2: dw 0
; flagPillar3: dw 0

; pipe1Flag: dw 0
; pipe2Flag: dw 0
; pipe3Flag: dw 0

; pipe1Exists: dw 0
; pipe2Exists: dw 0
; pipe3Exists: dw 0

; has_Collided: dw 0

; backGroundBuffer: times 2000 dw 0 ; space for 4000 bytes
; saveBuffer: times 2000 dw 0 ; space for 4000 bytes
; oldisr: dd 0 ; space for saving old isr
; oldisr_timer: dd 0 ; space for saving old isr
; newisr: dd 0 ; space for saving old isr

; bufferforground: dw 0, 0, 0

; starttimer: dw 0
; counting: dw 0
; pausetime: dw 6

; border_end_screen_color: dw 0x0F20
; gameover_color: dw 0x0020

; endscreen_text1 db 'Score: '
; endscreen_text1_length: dw 7

; scoreofgame: dw 0

; shouldexit: dw 0
; pause_flag: dw 0

; moveGround:
	; pusha

	; mov ax, 0xb800
	; mov es, ax

	; mov ax, [cs:groundHeight]
	; mov cx, 160
	; mul cx
	; mov di, ax

	; mov ax, 4000
	; sub ax, di
	; mov di, ax

	; mov cx, di
	; add cx, 146

	; mov ax, [es:di]
	; mov [bufferforground], ax
	; mov ax, [es:di+160]
	; mov [bufferforground +2], ax
	; mov ax, [es:di+320]
	; mov [bufferforground +4], ax

; movetoleftvalues:
	; add di,2
	; mov ax, [es:di]
	; mov [es:di-2], ax
	; mov ax, [es:di+160]
	; mov [es:di+158], ax
	; mov ax, [es:di+320]
	; mov [es:di+318], ax

	; cmp di, cx
	; jne movetoleftvalues


	; mov ax, [bufferforground]
	; mov [es:di], ax
	; mov ax, [bufferforground + 2]
	; mov [es:di+160], ax
	; mov ax, [bufferforground + 4]
	; mov [es:di+320], ax

	; popa
	; ret

; random:
	; push ax

	; mov al, 00h
	; out 0x70, al ; command byte written at first port
	; jmp D1 ; waste one instruction time
	; D1: in al, 0x71 ; result of command is in AL now

	; mov ah, al ; since its stored in bcd we store it in our convention
	; shr al, 4
	; and ah, 0Fh
	; add al, ah

	; and al, 0Dh
	
	; add al, 2
	
	; cmp al, 14
	; jle contRand1
	
	; mov al, 14
	
; contRand1:
	; mov ah, 0

	; mov [cs:pipeHeight], ax
	; ;mov word[cs:pipeHeight], 2

	; pop ax
	; ret

; clrscr:
	; push bp
	; mov bp,sp
	; push es
	; push ax
	; push cx
	; push di

	; mov ax, 0xb800
	; mov es, ax
	; xor di, di
	; mov ax, [bp +4]
	; mov cx, 2000

	; cld
	; rep stosw

	; pop di
	; pop cx
	; pop ax
	; pop es
	; pop bp
	; ret 2

; delay:
	; push cx
	; mov cx, 0xFFFF
; loop1:
	; loop loop1
	; mov cx, 0xFFFF
; loop2:
	; loop loop2
	; pop cx
	; ret

; Background:
	; push es
	; push ax
	; push di
	; push cx
	; push bx

	; mov ax, 0xb800
	; mov es, ax

	; mov cx, 4000
	; mov ax, [cs:groundHeight]
	; mov bx, 160
	; mul bx
	; sub cx, ax

	; mov di, 0
	; mov ah, 0x30
	; mov al, 0x20

; next:
	; mov [es:di], ax
	; add di, 2
	; cmp di, cx
	; jnz next

	; pop bx
	; pop cx
	; pop di
	; pop ax
	; pop es
	; ret

; PipeU:
	; push bp
	; mov bp, sp
	; sub sp, 2
	; push es
	; push ax
	; push di
	; push cx
	; push bx

	; mov ax, 0xb800
	; mov es, ax

	; mov ax, [cs:pipeWidth]
	; mov cx, 2
	; mul cx
	; mov cx, ax
	; mov ax, [cs:CurrentCol]
	; mov di, 2
	; mul di
	; mov di, ax
	; add cx, di

	; mov ax, [cs:pipeHeight]
	; sub ax, 1
	; mov bx, 160
	; mul bx
	; mov bx, ax
	; mov word[bp - 2], bx
	; add word[bp - 2], cx


	; mov ah, 0x20
	; mov al, 0x20


; next3:
	; mov [es:di], ax
	; add di, 2
	; cmp di, cx
	; jnz next3
	; add cx, 160
	; mov di, [cs:pipeWidth]
	; shl di, 1
	; mov bx, cx
	; sub bx, di
	; mov di, bx
	; cmp cx, [bp - 2]
	; jnz next3

	; pop bx
	; pop cx
	; pop di
	; pop ax
	; pop es
	; mov sp, bp
	; pop bp
	; ret


; PipeD:
	; push bp
	; mov bp, sp
	; sub sp, 2
	; push es
	; push ax
	; push di
	; push cx
	; push bx

	; mov ax, 0xb800
	; mov es, ax

	; mov ax, [cs:pipeWidth]
	; shl ax, 1
	; mov cx, ax

	; mov ax, [cs:pipeHeight]
	; add ax, [cs:difference]
	; mov bx, 160
	; mul bx
	; mov bx, ax

	; mov ax, [cs:CurrentCol]
	; shl ax, 1
	; mov di, ax
	; add di, bx
	; add cx, di

	; mov ax, 25
	; sub ax, [cs:difference]
	; sub ax, [cs:pipeHeight]
	; sub ax, [cs:groundHeight]

	; mov bx, 160
	; mul bx
	; mov bx, ax
	; mov word[bp - 2], bx
	; add word[bp - 2], cx


	; mov ah, 0x20
	; mov al, 0x20


; next4:
	; mov [es:di], ax
	; add di, 2
	; cmp di, cx
	; jnz next3
	; add cx, 160
	; mov di, [cs:pipeWidth]
	; shl di, 1
	; mov bx, cx
	; sub bx, di
	; mov di, bx
	; cmp cx, [bp - 2]
	; jnz next4

	; pop bx
	; pop cx
	; pop di
	; pop ax
	; pop es
	; mov sp, bp
	; pop bp
	; ret

; Bird:
	; pusha

	; mov ax, 0xb800
	; mov es, ax

	; mov ax, 80
	; mov di, [cs:birdR]
	; mul di
	; add ax, word[cs:birdC]
	; shl ax, 1
	; mov di, ax

	; mov word[es:di - 162], 0x1020
	; mov word[es:di - 158], 0x1020

	; mov ax, 0x4020
	; mov cx, 3
	; mov si, di
; lB2:
	; mov [es:di], ax
	; add di, 2
	; loop lB2

	; mov word[es:di], 0x0020
	; mov [es:di + 2], ax
	; mov word[es:di + 4], 0x0020

	; mov cx, 5
	; mov di, si
	; add di, 160
	; mov word[es:di], 0x6020
	; add di, 2
	; mov si, di
; lB3:
	; mov [es:di], ax
	; add di, 2
	; loop lB3

	; popa
	; ret

; Ground:
	; push es
	; push ax
	; push di
	; push cx
	; push dx
	; push bx
	; push si

	; mov ax, 0xb800
	; mov es, ax

	; mov ax, [cs:groundHeight]
	; mov cx, 160
	; mul cx
	; mov di, ax

	; mov ax, 4000
	; sub ax, di
	; mov di, ax
	; mov dx, di
	; mov bx, di
	; add bx, 36
	; mov si, di
	; add si, 46

	; mov cx, 4000
	; mov ah, 0x60
	; mov al, 0x20

; next2:
	; cmp dx, bx
	; je print_pebble_not_dots_not_lines

	; cmp di, dx
	; je print_pebble

	; cmp di, bx
	; je print_dots

	; cmp di, si
	; je print_lines

	; mov [es:di], ax
	; add di, 2

; otherwise_continue:
	; cmp di, cx
	; jnz next2
	
	; call printbrownboxattherightbottom
	
	; push cs
	; pop ds	
	; push endscreen_text1
	; push 0x6F
	; push word[endscreen_text1_length]
	; push 0x169A
	; call printline

	; pop si
	; pop bx
	; pop dx
	; pop cx
	; pop di
	; pop ax
	; pop es
	; ret

; print_pebble_not_dots_not_lines:
		; mov al, 0x6F
		; mov ah, 0x64
		; mov [es:di], ax
		; add di, 2
		; mov al, 0x20
		; mov ah, 0x60
		; add dx, 70
		; add bx, 36
		; jmp otherwise_continue

; print_pebble:
		; mov al, 0x6F
		; mov ah, 0x64

		; mov [es:di], ax
		; add di, 2

		; mov al, 0x20
		; mov ah, 0x60

		; add dx, 70
		; jmp otherwise_continue

; print_dots:
		; mov al, 0x2E
		; mov ah, 0x64

		; mov [es:di], ax
		; add di, 2

		; mov al, 0x20
		; mov ah, 0x60

		; add bx, 36
		; jmp otherwise_continue

; print_lines:
		; mov al, 0x2D
		; mov ah, 0x64

		; mov [es:di], ax
		; add di, 2

		; mov al, 0x20
		; mov ah, 0x60

		; add si, 46
		; jmp otherwise_continue

; printbrownboxattherightbottom:
	; mov ax, [cs:groundHeight]
	; mov cx, 160
	; mul cx
	; mov di, ax

	; mov ax, 4000
	; sub ax, di
	; mov di, ax
	; add di, 148
	; mov bx, di
	; mov cx, 6
	
; loopforblackbox:
	; mov word[es:di], 0x6720
	; mov word[es:di+160], 0x6720
	; mov word[es:di+160], 0x6720
	; add di, 2
	; loop loopforblackbox
	
	; ret

; printCloud:
	; push bp
	; mov bp, sp
	; push ax
	; push es
	; push cx
	; push di
	; push si

	; mov ax, 0xb800
	; mov es, ax


	; mov di, [bp + 4]
	; mov ax, 0x7020
	; mov si, di
	; mov cx, 2
; nextCR1:
	; mov [es:di], ax
	; add di, 2
	; loop nextCR1

	; mov di, si
	; mov cx, 6
	; add di, 160
	; sub di, 4
	; mov si, di
; nextCR2:
	; mov [es:di], ax
	; add di, 2
	; loop nextCR2

	; mov di, si
	; add di, 160
	; sub di, 4
	; mov cx, 10
; nextCR3:
	; mov [es:di], ax
	; add di, 2
	; loop nextCR3

	; pop si
	; pop di
	; pop cx
	; pop es
	; pop ax
	; pop bp
	; ret 2

; Clouds:
	; pusha

	; push 500
	; call printCloud
	; push 2280
	; call printCloud
	; push 1210
	; call printCloud
	; push 460
	; call printCloud
	; push 2830
	; call printCloud

	; popa
	; ret

; moveUpperPipe:
	; pusha

	; mov ax, 0xb800
	; mov es, ax
	; mov ds, ax

	; mov si, [cs:CurrentCol]     ; si = Current Col ; di = Current Col - 1
	; mov di, si
	; shl si, 1            ; change if currentCol is made in 160 form

	; cmp si, 0
	; jz fadeAwayPillar

	; sub di, 1
	; shl di, 1
	; mov cx, [cs:pipeWidth]
	; mov dx, [cs:pipeHeight]
	; sub dx, 1

	; mov ax, si
	; jmp upperPipe

; fadeAwayPillar:
	; add di, word[cs:pipeWidth]
	; dec di
	; shl di, 1

	; mov cx, 25
	; sub cx, word[cs:groundHeight]

; nextPiece:
	; push ax
	; push ds
	; push cs
	; pop ds
	; mov si, backGroundBuffer
	; add si, di
	; mov ax, [ds:si]
	; mov [es:di], ax
	; pop ds
	; pop ax

	; add di, 160
	; loop nextPiece

	; dec word[cs:pipeWidth]
	; jmp endup2

; upperPipe:
	; cld
	; rep movsw

	; ; give original background back
	; push ax
	; push ds

	; push cs
	; pop ds

	; mov si, backGroundBuffer
	; add si, di

	; mov ax, [ds:si]
	; mov [es:di], ax
	; pop ds
	; pop ax

	; ; reinitialise for next one
	; mov cx, [cs:pipeWidth]
	; mov si, ax
	; add si, 160
	; mov ax, si
	; mov di, si
	; sub di, 2
	; dec dx
	; cmp dx, 0
	; jnz upperPipe

	; mov dx, 25
	; sub dx, [cs:pipeHeight]
	; sub dx, [cs:difference]
	; sub dx, [cs:groundHeight]

	; mov cx, [cs:difference]
	; add si, 160
; lop:
	; add si, 160
	; loop lop

	; mov cx, [cs:pipeWidth]

	; mov ax, si
	; mov di, si
	; sub di, 2

; lowerPipe:
	; cld
	; rep movsw

	; ; give original background back
	; push ax
	; push ds

	; push cs
	; pop ds

	; mov si, backGroundBuffer
	; add si, di

	; mov ax, [ds:si]
	; mov [es:di], ax
	; pop ds
	; pop ax

	; ; reinitialise for next one
	; mov cx, [cs:pipeWidth]
	; mov si, ax
	; add si, 160
	; mov ax, si
	; mov di, si
	; sub di, 2
	; dec dx
	; cmp dx, 0
	; jnz lowerPipe


; lPCont:
	; cmp word[cs:flagPillar], 0
	; jnz endup2

	; ; when it fades into the screen

; fadeInPillar:
	; mov di, word[cs:CurrentCol]
	; add di, word[cs:pipeWidth]
	; sub di, 1
	; shl di, 1

	; mov cx, word[cs:pipeHeight]
	; sub cx, 1

; nextIn1:
	; mov word[es:di], 0x2020
	; add di, 160
	; loop nextIn1

	; mov cx, word[cs:difference]

; tempLoop:
	; add di, 160
	; loop tempLoop

	; add di, 160
	; mov cx, 25
	; sub cx, word[cs:pipeHeight]
	; sub cx, word[cs:groundHeight]
	; sub cx, word[cs:difference]

; nextIn2:
	; mov word[es:di], 0x2020
	; add di, 160
	; loop nextIn2

	; inc word[cs:pipeWidth]

	; mov ax, [cs:pipeWidthReal]
	; cmp word[cs:pipeWidth], ax    ; after it passes the right side fully ; replace 8 with pipeWidth
	; jnz endup2

	; mov word[cs:flagPillar], 1    ; 1 for the state that it has emerged fully

; endup2:
	; popa
	; ret
	
; ;-------------------------------------------------------------
; moveBird_down:
	; pusha

	; mov ax, 0xb800
	; mov es, ax

	; push cs
	; pop ds

	; mov ax, 80
	; mov di, [cs:birdR]
	; mul di
	; add ax, word[cs:birdC]
	; shl ax, 1
	; mov di, ax

	; mov bx, di

	; add word[cs:birdR], 1

	; ; now we change the screen back to what it was behind the bird
	
	; mov si, saveBuffer
	; add si, di
	; ;sub si, 6   ; to accomodate for the link between ds and es

	; mov ax, [ds:si - 162]
	; mov word[es:di - 162], ax
	; mov ax, [ds:si - 158]
	; mov word[es:di - 158], ax
	; mov ax, [ds:si - 160]
	; mov word[es:di - 160], ax
	; mov ax, [ds:si - 156]
	; mov word[es:di - 156], ax
	; mov ax, [ds:si - 154]
	; mov word[es:di - 154], ax
	; mov ax, [ds:si - 152]
	; mov word[es:di - 152], ax
	; mov ax, [ds:si - 150]
	; mov word[es:di - 150], ax
	
	; mov cx, 3
	; mov bx, di
; mB21:
	; mov ax, [ds:si]
	; mov [es:di], ax
	; add di, 2
	; add si, 2
	; loop mB21

	; mov ax, [ds:si]
	; mov word[es:di], ax
	; mov ax, [ds:si + 2]
	; mov [es:di + 2], ax
	; mov ax, [ds:si + 4]
	; mov word[es:di + 4], ax

	; mov cx, 5
	; mov di, bx
	; add di, 160
	; add si, 160
	; mov ax, [ds:si]
	; mov word[es:di], ax
	; add di, 2
	; add si, 2
	; mov bx, di
; mB31:
	; mov ax, [ds:si]
	; mov [es:di], ax
	; add di, 2
	; add si, 2
	; loop mB31

	; call Bird

	; popa
	; ret
; ;-------------------------------------------------------------
; moveBird:
	; pusha

	; mov ax, 0xb800
	; mov es, ax

	; push cs
	; pop ds

	; mov ax, 80
	; mov di, [cs:birdR]
	; mul di
	; add ax, word[cs:birdC]
	; shl ax, 1
	; mov di, ax

	; mov bx, di

	; mov al, byte[cs:birdDirection]
	; cmp al, 'D'
	; je downwards
	; cmp al, 'S'
	; je jumptobirdend
	
	; ; upwards
	; ;sub di, 158    ; check for bounds here
	; sub word[cs:birdR], 1
	; ;add word[cs:birdC], 1
	; jmp changeTraj

; downwards:
	; ;add di, 162
	; add word[cs:birdR], 1
	; ;add word[cs:birdC], 1

; changeTraj:
	; ; now we change the screen back to what it was behind the bird
	; mov si, backGroundBuffer
	; add si, di
	; sub si, 6   ; to accomodate for the link between ds and es
	; ;sub si, 1 ; doing this leaves a trail behind heh maybe we can do something with this later on

	; mov ax, [ds:si - 162]
	; ; mov [es:di], ax
	; mov word[es:di - 162], ax
	; mov ax, [ds:si - 158]
	; mov word[es:di - 158], ax

	; ; mov ax, 0x4020
	; mov cx, 3
	; mov bx, di
; mB2:
	; mov ax, [ds:si]
	; mov [es:di], ax
	; add di, 2
	; add si, 2
	; loop mB2

	; mov ax, [ds:si]
	; mov word[es:di], ax
	; mov ax, [ds:si + 2]
	; mov [es:di + 2], ax
	; mov ax, [ds:si + 4]
	; mov word[es:di + 4], ax

	; mov cx, 5
	; mov di, bx
	; add di, 160
	; add si, 160
	; mov ax, [ds:si]
	; mov word[es:di], ax
	; add di, 2
	; add si, 2
	; mov bx, di
; mB3:
	; mov ax, [ds:si]
	; mov [es:di], ax
	; add di, 2
	; add si, 2
	; loop mB3

; jumptobirdend:
	; ; now we call the Bird function again so that it redraws the bird with new coords
	; call Bird

	; popa
	; ret

; pillarMovement:
	; pusha

	; cmp word[cs:init], 0
	; jnz notInit

	; mov word[cs:init], 1
	; jmp initPassed

; notInit:
	; cmp word[cs:pipeWidth], 0
	; jz emptyCall

; initPassed:
	; mov ax, word[cs:pipeWidthReal]
	; cmp word[cs:pipeWidth], ax    ; when it emerges from the right till its full
	; jz rightPassedPillar

	; cmp word[cs:flagPillar], 1    ; when it reaches left end
	; jz rightPassedPillar

	; ; add word[cs:pipeWidth], 1


; rightPassedPillar:
	; call moveUpperPipe
	; cmp word[cs:CurrentCol], 0
	; jz emptyCall

	; dec word[cs:CurrentCol]

; emptyCall:
	; popa
	; ret


; ;-----------------------------------------------------------------
; ;SAVES BACKGROUND IN BUFFER
; ;-----------------------------------------------------------------
; saveScreen:
	; pusha

	; mov cx, 2000 ; number of screen locations

	; mov bx, [cs:groundHeight]
	; mov ax, 160
	; mul bx
	; sub cx, bx

	; mov ax, 0xb800
	; mov ds, ax ; ds = 0xb800
	; push cs
	; pop es
	; mov si, 0
	; mov di, backGroundBuffer
	; cld ; set auto increment mode
	; rep movsw ; save screen
	; ;[es:di] = [ds:si]

	; popa
	; ret
; ;-----------------------------------------------------------------	
	
	
; ;-----------------------------------------------------------------
; ;SAVES CURRENT SCREEN IN BUFFER
; ;-----------------------------------------------------------------
; saveScreen_state:
	; pusha

	; mov cx, 2000 ; number of screen locations

	; mov ax, 0xb800
	; mov ds, ax ; ds = 0xb800
	; push cs
	; pop es
	; mov si, 0
	; mov di, saveBuffer
	; cld ; set auto increment mode
	; rep movsw ; save screen
	; ;[es:di] = [ds:si]

	; popa
	; ret
; ;-----------------------------------------------------------------



; ;-----------------------------------------------------------------
; ; subroutine to restore the screen
; ;-----------------------------------------------------------------
; restoreScreen:
	; pusha

	; mov cx, 2000 ; number of screen locations

	; mov ax, 0xb800
	; mov es, ax ; es = 0xb800
	; push cs
	; pop ds
	; mov si, saveBuffer
	; mov di, 0
	; cld ; set auto increment mode
	; rep movsw ; save screen
	; ;[ds:si] -> [es:di]

	; popa
	; ret
; ;-----------------------------------------------------------------


; ; restoreScreen_background:
	; ; pusha

	; ; mov cx, 2000 ; number of screen locations

	; ; mov ax, 0xb800
	; ; mov es, ax ; es = 0xb800
	; ; push cs
	; ; pop ds
	; ; mov si, backGroundBuffer
	; ; mov di, 0
	; ; cld ; set auto increment mode
	; ; rep movsw ; save screen
	; ;;[ds:si] -> [es:di]

	; ; popa
	; ; ret

; Pipe1Movement:
	; pusha

	; cmp word[cs:pipe1Flag], 0
	; jnz movePipe1

	; mov word[cs:pipe1Flag], 1  ; flag (rem to reinitialise the CurrentCol value once it hits 0 and the flag asw)

	; ; initialisation 
	; mov ax, [cs:pipeHeight]
	; call random
	; mov bx, [cs:pipeHeight]
	; mov word[cs:pipeHeight1], bx

	; mov ax, [cs:CurrentCol1]
	; mov [cs:CurrentCol], ax

	; mov ax, [cs:pipeWidth1]
	; mov [cs:pipeWidth], ax

	; call PipeU
	; call PipeD

; movePipe1:
	; mov ax, [cs:pipeHeight1]
	; mov [cs:pipeHeight], ax

	; mov ax, [cs:pipeWidth1]
	; mov [cs:pipeWidth], ax

	; mov ax, [cs:CurrentCol1]
	; mov [cs:CurrentCol], ax

	; mov ax, [cs:flagPillar1]
	; mov [cs:flagPillar], ax

	; mov ax, [cs:init1]
	; mov [cs:init], ax

	; call pillarMovement

	; ; mov dx, 0xFFFF

	; ; sub dx, [pipeWidth]

	; ; dec word[CurrentCol]

	; ;cmp word[CurrentCol], 0

	; mov ax, [cs:init]
	; mov [cs:init1], ax

	; mov ax, [cs:flagPillar]
	; mov [cs:flagPillar1], ax

	; mov ax, [cs:CurrentCol]     ; this statement recovers the change in currentCol
	; mov [cs:CurrentCol1], ax

	; mov ax, [cs:pipeWidth]
	; mov [cs:pipeWidth1], ax

	; ; cmp word[cs:CurrentCol1], 45
	; ; jna Pipe2
	; ; cmp word[cs:CurrentCol1], 0
	; ; jmp continue

	; cmp word[cs:CurrentCol1], 45
	; jnz endPipe1Mov

; setpipe2Flag:
	; mov word[cs:pipe2Exists], 1

	; mov word[cs:init2], 0
	; mov word[cs:flagPillar2], 0
	; mov word[cs:pipeWidth2], 1
	; mov word[cs:pipe2Flag], 0
	; mov word[cs:CurrentCol2], 79

; endPipe1Mov:
	; popa
	; ret

; Pipe2Movement:
	; pusha

	; cmp word[cs:pipe2Flag], 0
	; jnz movePipe2

	; mov word[cs:pipe2Flag], 1  ; flag (rem to reinitialise the CurrentCol value once it hits 0 and the flag asw)

	; mov ax, [cs:pipeHeight]
	; call random
	; mov bx, [cs:pipeHeight]
	; mov word[cs:pipeHeight2], bx

	; mov ax, [cs:CurrentCol2]
	; mov [cs:CurrentCol], ax

	; mov ax, [cs:pipeWidth2]
	; mov [cs:pipeWidth], ax

	; call PipeU
	; call PipeD

; movePipe2:
	; mov ax, [cs:pipeHeight2]
	; mov [cs:pipeHeight], ax

	; mov ax, [cs:pipeWidth2]
	; mov [cs:pipeWidth], ax

	; mov ax, [cs:CurrentCol2]
	; mov [cs:CurrentCol], ax

	; mov ax, [cs:flagPillar2]
	; mov [cs:flagPillar], ax

	; mov ax, [cs:init2]
	; mov [cs:init], ax

	; call pillarMovement

	; ;dec word[CurrentCol]
	; ; cmp word[CurrentCol], 0

	; mov ax, [cs:init]
	; mov [cs:init2], ax

	; mov ax, [cs:flagPillar]
	; mov [cs:flagPillar2], ax

	; mov ax, [cs:CurrentCol]
	; mov [cs:CurrentCol2], ax

	; mov ax, [cs:pipeWidth]
	; mov [cs:pipeWidth2], ax

	; ; cmp word[cs:CurrentCol2], 45
	; ; jna Pipe3
	; ; jmp continue

	; cmp word[cs:CurrentCol2], 45
	; jnz endPipe2Mov

; setPipe3Flag:
	; mov word[cs:pipe3Exists], 1

	; mov word[cs:init3], 0
	; mov word[cs:flagPillar3], 0
	; mov word[cs:pipeWidth3], 1
	; mov word[cs:pipe3Flag], 0
	; mov word[cs:CurrentCol3], 79

; endPipe2Mov:
	; popa
	; ret

; Pipe3Movement:
	; pusha

	; cmp word[cs:pipe3Flag], 0
	; jnz movePipe3

	; mov word[cs:pipe3Flag], 1  ; flag (rem to reinitialise the CurrentCol value once it hits 0)

	; mov ax, [cs:pipeHeight]
	; call random
	; mov bx, [cs:pipeHeight]
	; mov word[cs:pipeHeight3], bx

	; mov ax, [cs:CurrentCol3]
	; mov [cs:CurrentCol], ax

	; mov ax, [cs:pipeWidth3]
	; mov [cs:pipeWidth], ax

	; call PipeU
	; call PipeD

; movePipe3:
	; mov ax, [cs:pipeHeight3]
	; mov [cs:pipeHeight], ax

	; mov ax, [cs:pipeWidth3]
	; mov [cs:pipeWidth], ax

	; mov ax, [cs:CurrentCol3]
	; mov [cs:CurrentCol], ax

	; mov ax, [cs:flagPillar3]
	; mov [cs:flagPillar], ax

	; mov ax, [cs:init3]
	; mov [cs:init], ax

	; call pillarMovement

	; ; dec word[CurrentCol]
	; ; cmp word[CurrentCol], 0

	; mov ax, [cs:init]
	; mov [cs:init3], ax

	; mov ax, [cs:flagPillar]
	; mov [cs:flagPillar3], ax

	; mov ax, [cs:CurrentCol]
	; mov [cs:CurrentCol3], ax

	; mov ax, [cs:pipeWidth]
	; mov [cs:pipeWidth3], ax

	; cmp word[cs:CurrentCol3], 45
	; jnz endPipe3Mov

; initPillar1:
	; mov word[cs:pipe1Exists], 1

	; mov word[cs:init1], 0
	; mov word[cs:flagPillar1], 0
	; mov word[cs:pipeWidth1], 1
	; mov word[cs:pipe1Flag], 0
	; mov word[cs:CurrentCol1], 79

; endPipe3Mov:
	; popa
	; ret


; create_box:
	; push bp
	; mov bp, sp
	; push es
	; push ax
	; push di
	; push dx
	; push bx
	
	; mov ax, 0xb800
	; mov es, ax

; ;------------------------------------
; ;PRINTING FOR THE BOX
; ;------------------------------------
	; mov di, [bp + 8]	;to contain position for printing
	; mov bx,	[bp + 8]	;to always have the start positon
	; mov cx, [bp + 6]	;to keep track of columns to be printed
	; mov dx, 0			;to check if the total no of rows are printed

; loop_for_box:
	; mov word[es:di], 0x6820
	; add di, 2
	; loop loop_for_box

	
	; add bx, 160 		;move to the next line
	; mov di, bx
	; mov cx, [bp + 6]
	
	; add dx, 1			;check for total rows
	; cmp dx, [bp + 4]
	; jne loop_for_box
; ;------------------------------------

	
; ;------------------------------------
; ;PRINTING FOR THE WHITE BOUNDARY
; ;------------------------------------
	; mov di,[bp + 8]						;return to starting point
	; mov cx, [bp + 6]					;to keep track of columns to be printed
	
; loop_for_white_boundary_1:				;print the top boundary
	; mov bx, [bp +10]
	; mov word[es:di], bx	
	; add di, 2
	; loop loop_for_white_boundary_1
	
	; sub di, 2							;di gets incremented even if condition failed hence to return to orignal state
	; mov cx, [bp + 4]					;to keep track of rows to be printed
; loop_for_white_boundary_2:				;print the top boundary
	; mov bx, [bp +10]
	; mov word[es:di], bx	
	; add di, 160
	; loop loop_for_white_boundary_2
	
	; sub di, 160							;di gets incremented even if condition failed hence to return to orignal state
	; mov cx, [bp + 6]					;to keep track of columns to be printed
; loop_for_white_boundary_3:				;print the bottom boundary
	; mov bx, [bp +10]
	; mov word[es:di], bx	
	; sub di, 2
	; loop loop_for_white_boundary_3
	
	; add di, 2							;di gets incremented even if condition failed hence to return to orignal state
	; mov cx, [bp + 4]					;to keep track of rows to be printed
; loop_for_white_boundary_4:				;print the left boundary
	; mov bx, [bp +10]
	; mov word[es:di], bx	
	; sub di, 160
	; loop loop_for_white_boundary_4
	
; ;------------------------------------
	
	
	; pop bx
	; pop dx
	; pop di
	; pop ax
	; pop es
	; pop bp

	; ret 8
; ;-----------------------------------------------------------------
; create_box_end:
	; push bp
	; mov bp, sp
	; push es
	; push ax
	; push di
	; push dx
	; push bx
	
	; mov ax, 0xb800
	; mov es, ax

; ;------------------------------------
; ;PRINTING FOR THE BOX
; ;------------------------------------
	; mov di, [bp + 8]	;to contain position for printing
	; mov bx,	[bp + 8]	;to always have the start positon
	; mov cx, [bp + 6]	;to keep track of columns to be printed
	; mov dx, 0			;to check if the total no of rows are printed

; loop_for_box1:
	; mov word[es:di], 0x6820
	; add di, 2
	; call delay_for_end
	; loop loop_for_box1

	
	; add bx, 160 		;move to the next line
	; mov di, bx
	; mov cx, [bp + 6]
	
	; add dx, 1			;check for total rows
	; cmp dx, [bp + 4]
	; jne loop_for_box1
; ;------------------------------------

	
; ;------------------------------------
; ;PRINTING FOR THE WHITE BOUNDARY
; ;------------------------------------
	; mov di,[bp + 8]						;return to starting point
	; mov cx, [bp + 6]					;to keep track of columns to be printed
	
; loop_for_white_boundary_11:				;print the top boundary
	; mov bx, [bp +10]
	; mov word[es:di], bx	
	; add di, 2
	; call delay_for_end
	; loop loop_for_white_boundary_11
	
	; sub di, 2							;di gets incremented even if condition failed hence to return to orignal state
	; mov cx, [bp + 4]					;to keep track of rows to be printed
; loop_for_white_boundary_21:				;print the top boundary
	; mov bx, [bp +10]
	; mov word[es:di], bx	
	; add di, 160
	; call delay_for_end
	; loop loop_for_white_boundary_21
	
	; sub di, 160							;di gets incremented even if condition failed hence to return to orignal state
	; mov cx, [bp + 6]					;to keep track of columns to be printed
; loop_for_white_boundary_31:				;print the bottom boundary
	; mov bx, [bp +10]
	; mov word[es:di], bx	
	; sub di, 2
	; call delay_for_end
	; loop loop_for_white_boundary_31
	
	; add di, 2							;di gets incremented even if condition failed hence to return to orignal state
	; mov cx, [bp + 4]					;to keep track of rows to be printed
; loop_for_white_boundary_41:				;print the left boundary
	; mov bx, [bp +10]
	; mov word[es:di], bx	
	; sub di, 160
	; call delay_for_end
	; loop loop_for_white_boundary_41
	
; ;------------------------------------
	
	
	; pop bx
	; pop dx
	; pop di
	; pop ax
	; pop es
	; pop bp

	; ret 8
; ;-----------------------------------------------------------------

; ;-----------------------------------------------------------------
; ;PRINTING FOR THE PAUSE SCREEN
; ;-----------------------------------------------------------------
; pause_screen:
	; call saveScreen_state	;save the state of the game
	
	; pusha
	
	; mov ax, 0xb800
	; mov es, ax
	; push cs
	; pop ds
	
	; push 0x7F20 							; color
	; push 1300 								;pushs location of box
	; push 61									;pushs width of the box
	; push 9									;pushs height of the box
	; call create_box							;creates the box for text to be placed in

	; push pausescreenmessage
	; push 0x6F
	; push word[pausescreenmessage_length]
	; push 0x0C11
	; call printline
	
	; push 0
	; push 24
	; call curosrlocation
	
; untilcorrectkey:
    ; mov ah, 0
    ; int 0x16    			; Wait for key input again
	; cmp al, 0Dh 			; enter pressed
	; je chagneexitscreenvalue;exit the game

	; cmp al, 08h				;enter backspace
	; je returntoorginalstate	;return the game to original state

	; jmp untilcorrectkey		;wait for user to enter the correct key


; ;RETURNING THE GAME TO PREVIOUS STATE;----------------------------
; returntoorginalstate:
	; popa

	; call restoreScreen		;restores original state of the game
	; mov word[cs:pause_flag], 0
	; ret						;return back to keyboard interrupt code
	
; chagneexitscreenvalue:
	; mov word[cs:shouldexit], 1
	; jmp returntoorginalstate
	
; ;PRINT END SCREEN ANIMATION;--------------------------------------
; endscreen:	
	
	; xor ax, ax
	; mov es, ax
	; cli 						; disable interrupts
	; mov ax, [cs:oldisr]
	; mov word [es:9*4], ax 		; store offset at n*4
	; mov ax, [cs:oldisr + 2]
	; mov [es:9*4+2], ax 			; store segment at n*4+2
	; mov ax, [cs:oldisr_timer]
	; mov word [es:8*4], ax 		; store offset at n*4
	; mov ax, [cs:oldisr_timer + 2]
	; mov [es:8*4+2], ax 			; store segment at n*4+2
	; sti 						; enable interrupts
		
	; mov ax, 0xb800
	; mov es, ax
	; mov cx, 2000
	; mov ax, 0x0720
	; mov di, 0

	; cld
; loopforendanimation:
	; stosw
	; call delay_for_end			;delay before next box is turned black
	; loop loopforendanimation	;using loop so that delay can be added
	
	; call endofprogram
; ;-----------------------------------------------------------------


; ;-----------------------------------------------------------------
; ;CUSTOM DELAY FOR END SCREEN 
; ;-----------------------------------------------------------------
; delay_for_end:
	; push cx
	; mov cx, 0x0FFF
; loop_for_end:
	; loop loop_for_end
	; pop cx
	; ret
; ;-----------------------------------------------------------------


; ;-----------------------------------------------------------------
; ;CURSOR LOCATION
; ;-----------------------------------------------------------------
; curosrlocation:
	; push bp
	; mov bp,sp
	
	; mov ah, 02h         ; Function to set cursor position
	; mov bh, 0           ; Page number (usually 0 for text mode)
	; mov dh, [bp+4]      ; Row (0-based)
	; mov dl, [bp+6]      ; Column (0-based)
	; int 10h             ; Call BIOS video interrupt

	; pop bp
	; ret 4
; ;-----------------------------------------------------------------


; ;-----------------------------------------------------------------
; ;PRINT NEW LINE
; ;-----------------------------------------------------------------
; printline:
		; push bp
		; mov bp, sp
		; push ax
		; push bx
		; push cx
		; push dx
		; push es
		
		; mov ah, 0x13		; service 13 - print string
		; mov al, 0			; subservice 01 – update cursor 
		; mov bh, 0			; output on page 0
		; mov bl, [bp + 8]	; color attrib
		; mov cx, [bp + 6]	; length of string
		; mov dx, [bp + 4]	; row/column
		
		; ; push endscreen_text1
		; ; push 0x00
		; ; push word[cs:endscreen_text1_length]
		; ; push 0x1020
		; ; call printline
		
		; ;es:bp = ds:message
		; push ds
		; pop es				; es=ds segment of string
		; mov bp, [bp + 10]	; bp = offset of string
		
		; INT 0x10			; call BIOS video service
		
		; pop es
		; pop dx
		; pop cx
		; pop bx
		; pop ax
		; pop bp
		
		; ret 8
; ;-----------------------------------------------------------------

; ;-----------------------------------------------------------------
; ;PRINT NEW LINE
; ;-----------------------------------------------------------------
; printliners:
		; push bp
		; mov bp, sp
		; push ax
		; push bx
		; push cx
		; push dx
		; push es
		
		; mov ah, 0x13          ; service 13 - print string
		; mov al, 0             ; subservice 01 – update cursor
		; mov bh, 0             ; output on page 0
		; mov bl, 0x67          ; color attribute
		; mov cx, word[cs:endscreen_text1_length] ; length of string

		; push ds               ; save current data segment
		; pop es                ; set ES=DS (string's segment)
		; lea bp, endscreen_text1 ; BP = offset of string
		
		; mov dx, 0x1020        ; row/column
		; int 0x10              ; call BIOS video service
		
		; pop es
		; pop dx
		; pop cx
		; pop bx
		; pop ax
		; pop bp
		
		; ret 8
; ;-----------------------------------------------------------------


; ;-----------------------------------------------------------------
; ;PRINTS TITLE SCREEN
; ;-----------------------------------------------------------------
; title_screen:
	; pusha
	
	; mov ax, 0xb800
	; mov es, ax
	
	; mov bx, 530
	; mov di, bx
	
	; ;PRINTS F------------------------------
	; mov word[es:di],  0x3020
	; mov word[es:di+160],  0x3020
	; mov word[es:di+320],  0x3020
	; mov word[es:di+480],  0x3020
	; mov word[es:di+640],  0x3020

	; mov word[es:di+2],  0x3020
	; mov word[es:di+4],  0x3020
	; mov word[es:di+6],  0x3020
	
	; mov word[es:di+322],  0x3020
	; mov word[es:di+324],  0x3020
	; ;-------------------------------------
	
	; add bx, 10
	; mov di, bx
	; ;PRINTS R------------------------------
	; mov word[es:di],  0x3020
	; mov word[es:di+160],  0x3020
	; mov word[es:di+320],  0x3020
	; mov word[es:di+480],  0x3020
	; mov word[es:di+640],  0x3020
	
	; mov word[es:di+2],  0x3020
	; mov word[es:di+4],  0x3020
	; mov word[es:di+166],  0x3020
	; mov word[es:di+322],  0x3020
	; mov word[es:di+324],  0x3020
	
	; mov word[es:di+486],  0x3020
	; mov word[es:di+646],  0x3020
	; ;-------------------------------------
	
	; add bx, 10
	; mov di, bx
	; ;PRINTS E------------------------------
	; mov word[es:di],  0x3020
	; mov word[es:di+160],  0x3020
	; mov word[es:di+320],  0x3020
	; mov word[es:di+480],  0x3020
	; mov word[es:di+640],  0x3020
	
	; mov word[es:di+2],  0x3020
	; mov word[es:di+4],  0x3020
	; mov word[es:di+6],  0x3020
	
	; mov word[es:di+322],  0x3020
	; mov word[es:di+324],  0x3020
	; mov word[es:di+326],  0x3020
	
	; mov word[es:di+642],  0x3020
	; mov word[es:di+644],  0x3020
	; mov word[es:di+646],  0x3020
	; ;-------------------------------------
	
	; add bx, 10
	; mov di, bx
	; ;PRINTS A------------------------------
	; mov word[es:di],  0x3020
	; mov word[es:di+160],0x3020
	; mov word[es:di+320],  0x3020
	; mov word[es:di+480],  0x3020
	; mov word[es:di+640],  0x3020
	
	; mov word[es:di+2],  0x3020
	; mov word[es:di+4],  0x3020
	; mov word[es:di+322],  0x3020
	; mov word[es:di+324],  0x3020
	
	; mov word[es:di+6],  0x3020
	; mov word[es:di+166],  0x3020
	; mov word[es:di+326],  0x3020
	; mov word[es:di+486],  0x3020
	; mov word[es:di+646],  0x3020
	; ;-------------------------------------
	
	; add bx, 10
	; mov di, bx
	; ;PRINTS K------------------------------
	; mov word[es:di],  0x3020
	; mov word[es:di+160],  0x3020
	; mov word[es:di+320],  0x3020
	; mov word[es:di+480],  0x3020
	; mov word[es:di+640],  0x3020
	
	
	; mov word[es:di+6],  0x3020
	; mov word[es:di+164],  0x3020
	; mov word[es:di+322],  0x3020
	; mov word[es:di+484],  0x3020
	; mov word[es:di+646],  0x3020
	; ;-------------------------------------
	
	; add bx, 10
	; mov di, bx
	; ;PRINTS Y------------------------------
	; mov word[es:di],  0x3020
	; mov word[es:di+160],  0x3020
	; mov word[es:di+322],  0x3020

	; mov word[es:di+326],  0x3020
	; mov word[es:di+168],  0x3020
	; mov word[es:di+8],  0x3020
	
	; mov word[es:di+484],  0x3020
	; mov word[es:di+644],  0x3020
	; ;-------------------------------------
	
	; sub bx, 50
	; add bx, 1130	;next line
	; mov di, bx
	; ;PRINTS B------------------------------
	; mov word[es:di],  	  0x6020
	; mov word[es:di+160],  0x6020
	; mov word[es:di+320],  0x6020
	; mov word[es:di+480],  0x6020
	; mov word[es:di+640],  0x6020
	
	; mov word[es:di+2],  0x6020
	; mov word[es:di+4],  0x6020
	; mov word[es:di+322],  0x6020
	; mov word[es:di+324],  0x6020
	; mov word[es:di+642],  0x6020
	; mov word[es:di+644],  0x6020
	
	; mov word[es:di+166],  0x6020
	; mov word[es:di+486],  0x6020
	; ;-------------------------------------
	
	; add bx, 10
	; mov di, bx
	; ;PRINTS I------------------------------
	; mov word[es:di],  	  0x6020
	; mov word[es:di+2],  	  0x6020
	; mov word[es:di+4],  	  0x6020
	; mov word[es:di+6],  	  0x6020
	; mov word[es:di+8],  	  0x6020
	
	; mov word[es:di+640],  	  0x6020
	; mov word[es:di++642],  	  0x6020
	; mov word[es:di++644],  	  0x6020
	; mov word[es:di++646],  	  0x6020
	; mov word[es:di++648],  	  0x6020
	
	; mov word[es:di+164],  0x6020
	; mov word[es:di+324],  0x6020
	; mov word[es:di+484],  0x6020
	; ;-------------------------------------
	
	; add bx, 12
	; mov di, bx
	; ;PRINTS R------------------------------
	; mov word[es:di],  0x6020
	; mov word[es:di+160],  0x6020
	; mov word[es:di+320],  0x6020
	; mov word[es:di+480],  0x6020
	; mov word[es:di+640],  0x6020
	
	; mov word[es:di+2],  0x6020
	; mov word[es:di+4],  0x6020
	; mov word[es:di+166],  0x6020
	; mov word[es:di+322],  0x6020
	; mov word[es:di+324],  0x6020
	
	; mov word[es:di+486],  0x6020
	; mov word[es:di+646],  0x6020
	; ;-------------------------------------
	
	; add bx, 10
	; mov di, bx
	; ;PRINTS D------------------------------
	; mov word[es:di],  0x6020
	; mov word[es:di+160],  0x6020
	; mov word[es:di+320],  0x6020
	; mov word[es:di+480],  0x6020
	; mov word[es:di+640],  0x6020
	
	; mov word[es:di+2],  0x6020
	; mov word[es:di+642],  0x6020
	; mov word[es:di+4],  0x6020
	; mov word[es:di+644],  0x6020
	
	; mov word[es:di+166],  0x6020
	; mov word[es:di+326],  0x6020
	; mov word[es:di+486],  0x6020
	
	; ;-------------------------------------
	
	; sub bx,32
	; sub bx, 654

	; mov di, bx
	
	; ;prints border around bird------------
	; mov cx, 4
; loop_title_1:
	; mov word[es:di],  0x2720
	; sub di, 2
	; loop loop_title_1
	
	; mov cx, 11
; loop_title_2:
	; mov word[es:di],  0x2720
	; add di, 160
	; loop loop_title_2
	
	; mov cx, 41
; loop_title_3:
	; mov word[es:di],  0x2720
	; add di, 2
	; loop loop_title_3
	
	; mov cx, 11
; loop_title_4:
	; mov word[es:di],  0x2720
	; sub di, 160
	; loop loop_title_4
	
	; mov cx, 6
; loop_title_5:
	; mov word[es:di],  0x2720
	; sub di, 2
	; loop loop_title_5
; ;-------------------------------------

	; ;prints enter any key test
	; push title_text1
	; push 0x87
	; push word[title_text1_length]
	; push 0x1321
	; call printline
	
	; push title_text4
	; push 0x07
	; push word[title_text4_length]
	; push 0x1600
	; call printline
	
	; push title_text2
	; push 0x07
	; push word[title_text2_length]
	; push 0x1700
	; call printline
	
	; push title_text3
	; push 0x07
	; push word[title_text2_length]
	; push 0x1800
	; call printline
	
	; popa
	; ret
; ;-----------------------------------------------------------------
; ;CHECKS SCORE OF THE GAME
; ;-----------------------------------------------------------------	
; checkscore:
	; pusha
	; mov ax, [cs:birdC]
	; sub ax, 2
	; mov bx, [cs:CurrentCol]
	; add bx, word[cs:pipeWidth]
	; cmp ax, bx
	; jne endofcheckscore
	; inc word[cs:scoreofgame]
	
	; push 3988
	; push word[cs:scoreofgame]
	; call printnum
	
; endofcheckscore:
	; popa
	; ret
; ;-----------------------------------------------------------------


; ;-----------------------------------------------------------------
; ;MAKES THE BIRD FALL DOWN
; ;-----------------------------------------------------------------
; Birdfalls:
	; pusha 
	
	; call saveScreen_state
	; mov byte[cs:birdDirection], 'D'
	
	; mov cx, 3
; loop3:	
	; cmp word[cs:birdR], 21
	; je endoffuc
	
	; call moveBird
	; call delay
	; call delay
	; loop loop3
	
	; cmp word[cs:birdR], 21
	; je endoffuc
; untilbirdreachesground:
	; call moveBird_down
	; call delay
	; call delay
	; cmp word[cs:birdR], 21
	; jne untilbirdreachesground
	
; endoffuc:	
	; popa
	; ret
	
; ;-----------------------------------------------------------------
; ;CREATES END SCREEN
; ;-----------------------------------------------------------------
; gameoverscreen:
	; xor ax, ax
	; mov es, ax
	; cli 						; disable interrupts
	; mov ax, [cs:oldisr]
	; mov word [es:9*4], ax 		; store offset at n*4
	; mov ax, [cs:oldisr + 2]
	; mov [es:9*4+2], ax 			; store segment at n*4+2
	; mov ax, [cs:oldisr_timer]
	; mov word [es:8*4], ax 		; store offset at n*4
	; mov ax, [cs:oldisr_timer + 2]
	; mov [es:8*4+2], ax 			; store segment at n*4+2
	; sti 						; enable interrupts
	
	; call delay
	; call delay
	; call delay
	; call delay
	
	; call Birdfalls
	
	; call printbrownboxattherightbottom
	
	; pusha
	; push word[cs:border_end_screen_color] 							; color
	; push 820 ; location
	; push 61	; width
	; push 15	; height
	; call create_box_end
	
	; mov ax, 0xb800
	; mov es, ax
	
	; mov bx, 1474
	; mov di, bx
	; mov ax, word[cs:gameover_color]
	; ;PRINTS G------------------------------
	; mov word[es:di],  ax
	; mov word[es:di+160],  ax
	; mov word[es:di+320],  ax
	; mov word[es:di+480],  ax
	; mov word[es:di+640],  ax

	; mov word[es:di+2],  ax
	; mov word[es:di+4],  ax
	; mov word[es:di+6],  ax
	
	; mov word[es:di+640+2],  ax
	; mov word[es:di+640+4],  ax
	; mov word[es:di+640+6],  ax
	
	; mov word[es:di+480+6],  ax
	; mov word[es:di+320+6],  ax
	; mov word[es:di+320+4],  ax
	; ;-------------------------------------
	
	; add bx, 10
	; mov di, bx
	; ;PRINTS A------------------------------
	; mov word[es:di],  	ax
	; mov word[es:di+160],ax
	; mov word[es:di+320],  ax
	; mov word[es:di+480],  ax
	; mov word[es:di+640],  ax
	
	; mov word[es:di+2],  ax
	; mov word[es:di+4],  ax
	; mov word[es:di+322],  ax
	; mov word[es:di+324],  ax
	
	; mov word[es:di+6],  ax
	; mov word[es:di+166],  ax
	; mov word[es:di+326],  ax
	; mov word[es:di+486],  ax
	; mov word[es:di+646],  ax
	; ;-------------------------------------
	
	; add bx, 10
	; mov di, bx
	; ;PRINTS M------------------------------
	; mov word[es:di],  		ax
	; mov word[es:di+160],	ax
	; mov word[es:di+320],  	ax
	; mov word[es:di+480],  	ax
	; mov word[es:di+640],  	ax
	
	; mov word[es:di],  		ax
	; mov word[es:di+160+2],	ax
	; mov word[es:di+320+4],  ax
	
	; mov word[es:di+8],  	ax
	; mov word[es:di+160+6],	ax
	
	; mov word[es:di+8],  	ax
	; mov word[es:di+168],  	ax
	; mov word[es:di+328],  	ax
	; mov word[es:di+488],  	ax
	; mov word[es:di+648], 	ax
	; ;-------------------------------------

	; add bx, 12
	; mov di, bx
	; ;PRINTS E------------------------------
	; mov word[es:di], 	 	ax
	; mov word[es:di+160],  	ax
	; mov word[es:di+320],  	ax
	; mov word[es:di+480],  	ax
	; mov word[es:di+640], 	ax
	
	; mov word[es:di+2],  	ax
	; mov word[es:di+4],  	ax
	; mov word[es:di+6],  	ax
	
	; mov word[es:di+322],  	ax
	; mov word[es:di+324],  	ax
	; mov word[es:di+326],  	ax
	
	; mov word[es:di+642],  	ax
	; mov word[es:di+644],  	ax
	; mov word[es:di+646],  	ax
	; ;-------------------------------------
	
	; add bx, 20
	; mov di, bx
	; ;PRINTS O------------------------------
	; mov word[es:di], 	 	ax
	; mov word[es:di+160],  	ax
	; mov word[es:di+320],  	ax
	; mov word[es:di+480],  	ax
	; mov word[es:di+640], 	ax
	
	; mov word[es:di+6], 	 	ax
	; mov word[es:di+160+6],  ax
	; mov word[es:di+320+6],  ax
	; mov word[es:di+480+6],  ax
	; mov word[es:di+640+6], 	ax
	
	; mov word[es:di+2],  	ax
	; mov word[es:di+4],  	ax
	; mov word[es:di+6],  	ax
	
	; mov word[es:di+642],  	ax
	; mov word[es:di+644],  	ax
	; mov word[es:di+646],  	ax
	; ;-------------------------------------
	
	; add bx, 10
	; mov di, bx
	; ;PRINTS V------------------------------
	; mov word[es:di], 	 	ax
	; mov word[es:di+160],  	ax
	; mov word[es:di+320+2],  ax
	; mov word[es:di+480+2],  ax
	; mov word[es:di+640+4], 	ax
	
	; mov word[es:di+8], 	 	ax
	; mov word[es:di+160+8],  ax
	; mov word[es:di+320+6],  ax
	; mov word[es:di+480+6],  ax
	; mov word[es:di+640+4], 	ax
	; ;-------------------------------------
	
	; add bx, 12
	; mov di, bx
	; ;PRINTS E------------------------------
	; mov word[es:di], 	 	ax
	; mov word[es:di+160],  	ax
	; mov word[es:di+320],  	ax
	; mov word[es:di+480],  	ax
	; mov word[es:di+640], 	ax
	
	; mov word[es:di+2],  	ax
	; mov word[es:di+4],  	ax
	; mov word[es:di+6],  	ax
	
	; mov word[es:di+322],  	ax
	; mov word[es:di+324],  	ax
	; mov word[es:di+326],  	ax
	
	; mov word[es:di+642],  	ax
	; mov word[es:di+644],  	ax
	; mov word[es:di+646],  	ax
	; ;-------------------------------------
	
	; add bx, 10
	; mov di, bx
	; ;PRINTS R------------------------------
	; mov word[es:di],  		ax
	; mov word[es:di+160],  	ax
	; mov word[es:di+320],  	ax
	; mov word[es:di+480],  	ax
	; mov word[es:di+640],  	ax
	
	; mov word[es:di+2],  	ax
	; mov word[es:di+4],  	ax
	; mov word[es:di+166],  	ax
	; mov word[es:di+322],  	ax
	; mov word[es:di+324],  	ax
	
	; mov word[es:di+486],  	ax
	; mov word[es:di+646],  	ax
	; ;-------------------------------------
	
	; push 2640
	; push word[cs:scoreofgame]
	; call printnum
	
	; push cs
	; pop ds	
	; push endscreen_text1
	; push 0x6F
	; push word[cs:endscreen_text1_length]
	; push 0x1020
	; call printline
	
	; mov ax, 0xb800
	; mov es, ax
	; mov cx, 2000
	; mov ax, 0x0720
	; mov di, 0
	
	; jmp endofprogram
; ;-----------------------------------------------------------------

; printnum: 
	; push bp
	; mov bp, sp
	; push es
	; push ax
	; push bx
	; push cx
	; push dx
	; push di

	; mov ax, 0xb800
	; mov es, ax 		; point es to video base
	
	; mov ax, [bp+4] 	; load number in ax
	; mov bx, 10 		; use base 10 for division
	; mov cx, 0 		; initialize count of digits
	
; nextdigit: 
	; mov dx, 0 		; zero upper half of dividend
	; div bx ; divide by 10
	; add dl, 0x30 ; convert digit into ascii value
	; push dx ; save ascii value on stack
	; inc cx ; increment count of values
	; cmp ax, 0 ; is the quotient zero
	; jnz nextdigit ; if no divide it again
	
	; mov di, [bp + 6] ; point di to 2640 index
; nextpos: 
	; pop dx ; remove a digit from the stack
	; mov dh, 0x6F ; use normal attribute
	; mov [es:di], dx ; print char on screen
	; add di, 2 ; move to next screen location
	; loop nextpos ; repeat for all digits on stac
	
	; pop di
	; pop dx
	; pop cx
	; pop bx
	; pop ax 
	; pop es
	; pop bp
	; ret 4


; ;-----------------------------------------------------------------
; ;CREATES INSTRUCTION SCREEN AT THE START
; ;-----------------------------------------------------------------
; create_instruction_screen:
	; pusha
	
	; push 0x7F20 							; color
	; push 1140 								;pushs location of box
	; push 61									;pushs width of the box
	; push 11									;pushs height of the box
	; call create_box							;creates the box for text to be placed in

	; mov ax, 0xb800
	; mov es, ax										
	; push cs
	; pop ds									;loads cs in ds
	
	; push instructionscreenmessage1
	; push 0x6B
	; push word[instructionscreenmessage1_length]
	; push 0x090C
	; call printline
	
	; push instructionscreenmessage2
	; push 0x6F
	; push word[instructionscreenmessage2_length]
	; push 0x0A0C
	; call printline
	
	; push instructionscreenmessage3
	; push 0x6F
	; push word[instructionscreenmessage3_length]
	; push 0x0B0C
	; call printline
	
	; push instructionscreenmessage4
	; push 0x6F
	; push word[instructionscreenmessage4_length]
	; push 0x0C0C
	; call printline
	
	; push instructionscreenmessage5
	; push 0x6B
	; push word[instructionscreenmessage5_length]
	; push 0x0D0C
	; call printline
	
	; push instructionscreenmessage6
	; push 0x6F
	; push word[instructionscreenmessage6_length]
	; push 0x0E0C
	; call printline
	
	; push instructionscreenmessage7
	; push 0x6F
	; push word[instructionscreenmessage7_length]
	; push 0x0F0C
	; call printline

	; push 0
	; push 24
	; call curosrlocation
	
	; popa
	; ret
; ;-----------------------------------------------------------------

; ;process control block
		; ; ax,bx,ip,cs,flags storage area
; pcb:	dw 0, 0, 0, 0, 0 ; task0 regs[cs:pcb + 0]
		; dw 0, 0, 0, 0, 0 ; task1 regs start at [cs:pcb + 10]
		; dw 0, 0, 0, 0, 0 ; task2 regs start at [cs:pcb + 20]

; current:	db 0 ; index of current task

; music_length: dw 20836 
; music_data: incbin "titlescreen.imf"

; ;-----------------------------------------------------------------
; ; timer interrupt service routine
; ;-----------------------------------------------------------------
; timer:		push si
			; push bx

			; cmp word [cs:starttimer], 1 ; is the printing flag set
			; jne skipall ; no, leave the ISR

			; inc word [cs:counting] ; increment tick count
			; mov ax, word[cs:pausetime]
			; cmp word[cs:counting], ax
			; je reset_starttimer
			
; skipall:	
			; mov bl, [cs:current]				; read index of current task ... bl = 0
			; mov ax, 10							; space used by one task
			; mul bl								; multiply to get start of task.. 10x0 = 0
			; mov bx, ax							; load start of task in bx....... bx = 0

			; pop ax								; read original value of bx
			; mov [cs:pcb+bx+2], ax				; space for current task's BX

			; pop ax								; read original value of si
			; mov [cs:pcb+bx+0], ax				; space for current task's SI

			; pop ax								; read original value of ip
			; mov [cs:pcb+bx+4], ax				; space for current task

			; pop ax								; read original value of cs
			; mov [cs:pcb+bx+6], ax				; space for current task

			; pop ax								; read original value of flags
			; mov [cs:pcb+bx+8], ax					; space for current task

			; inc byte [cs:current]				; update current task index...1
			; cmp byte [cs:current], 3			; is task index out of range
			; jne skipreset						; no, proceed
			; mov byte [cs:current], 0			; yes, reset to task 0

; skipreset:	mov bl, [cs:current]				; read index of current task
			; mov ax, 10							; space used by one task
			; mul bl								; multiply to get start of task
			; mov bx, ax							; load start of task in bx... 10
			
			; mov al, 0x20
			; out 0x20, al						; send EOI to PIC

			; push word [cs:pcb+bx+8]				; flags of new task... pcb+10+8
			; push word [cs:pcb+bx+6]				; cs of new task ... pcb+10+6
			; push word [cs:pcb+bx+4]				; ip of new task... pcb+10+4
			; mov si, [cs:pcb+bx+0]				; si of new task...pcb+10+0
			; mov bx, [cs:pcb+bx+2]				; bx of new task...pcb+10+2
			
			; iret ; return from interrupt
			
; reset_starttimer:
			; mov word[cs:counting], 0
			; mov word[cs:starttimer], 0
			; mov byte[cs:birdDirection], 'D'
			; jmp skipall
; ;-----------------------------------------------------------------

; music:
		; ; 2) now let's just read "getthem.imf" file content
		; ;    every 4 bytes. I'll use SI register as index.
		
		; ;mov si, 0 ; current index for music_data
		
		; ;mov di, 8
		
	; .next_note:
	
		; ; 3) the first byte is the opl2 register
		; ;    that is selected through port 388h
		; mov dx, 388h
		; mov al, [cs:si + music_data + 0]
		; out dx, al
		
		; ; 4) the second byte is the data need to
		; ;    be sent through the port 389h
		; mov dx, 389h
		; mov al, [cs:si + music_data + 1]
		; out dx, al
		
		; ; 5) the last 2 bytes form a word
		; ;    and indicate the number of waits (delay)
		; mov bx, [cs:si + music_data + 2]
		
		; ; 6) then we can move to next 4 bytes
		; add si, 4
		
		; ; 7) now let's implement the delay
		
	; .repeat_delay:	
		; mov cx, 1500 ; <- change this value according to the speed
		              ; ;    of your computer / emulator
	; .delay:
	
		; ; if keypress then exit
		; ; mov ah, 1
		; ; int 16h
		; ; jnz .exit
		
		; loop .delay
		
		; dec bx
		; jg .repeat_delay
		
		; cmp si, [cs:music_length]
		; je .exit
		
		; ;dec di
		; ;cmp di, 0
		; ;jne .next_note
		
		; jmp music
		
		; ; 8) let's send all content of music_data
		; cmp si, [cs:music_length]
		; jb .next_note
		
	; .exit:	
		; ; return to DOS
		; mov si, 0
		; ;dec di
		; ;cmp di, 0
		; ;jne .next_note
		; jmp music

; music_length1: dw 6928
; music_data1: incbin "background.imf"

; music1:
		; ; 2) now let's just read "getthem.imf" file content
		; ;    every 4 bytes. I'll use SI register as index.
		
		; mov si, 0 ; current index for music_data
		
		; push cs
		; pop ds
		
	; .next_note1:
	
		; ; 3) the first byte is the opl2 register
		; ;    that is selected through port 388h
		; mov dx, 388h
		; mov al, [cs:si + music_data1 + 0]
		; out dx, al
		
		; ; 4) the second byte is the data need to
		; ;    be sent through the port 389h
		; mov dx, 389h
		; mov al, [cs:si + music_data1 + 1]
		; out dx, al
		
		; ; 5) the last 2 bytes form a word
		; ;    and indicate the number of waits (delay)
		; mov bx, [cs:si + music_data1 + 2]
		
		; ; 6) then we can move to next 4 bytes
		; add si, 4
		
		; ; 7) now let's implement the delay
		
	; .repeat_delay1:	
		; mov cx, 600 ; <- change this value according to the speed
		              ; ;    of your computer / emulator
	; .delay1:
	
		; ; if keypress then exit
		; mov ah, 1   ; ah, 1 since it should not wait for the input
		; int 16h
		; jnz .exit1
		
		; loop .delay1
		
		; dec bx
		; jg .repeat_delay1
		
		; ; 8) let's send all content of music_data
		; cmp si, [cs:music_length1]
		; jb .next_note1
		
		; mov si, 0
		; jmp .next_note1
		
	; .exit1:	
		; ; return to DOS
		; ret


; ;-----------------------------------------------------------------
; ; keyboard interrupt service routine
; ;-----------------------------------------------------------------
; kbisr:		push ax
			; push es

			; mov ax, 0xb800
			; mov es, ax ; point es to video memory

			; in al, 0x60 ; read a char from keyboard port

			; cmp al, 0x01  ;esc pressed
			; jne spacecmp ;pauses the game and opens a instruction screen
			; mov word [cs:pause_flag], 1

; spacecmp:  	cmp al, 0xb9 ; space key released
			; jne nextcmp ; no, try next comparison
			; mov word[cs:starttimer], 1
			; mov byte[cs:birdDirection], 'S'
			; jmp nomatch ; leave interrupt routine

; nextcmp:	cmp al, 0x39 ; has the space key pressed
			; jne nomatch
			; mov word[cs:counting], 0
			; mov word[cs:starttimer], 0
			; mov ax, [cs:birdR]
			; sub ax, 1
			; mov byte[cs:birdDirection], 'U'
			; cmp ax, 0
			; jne nomatch
			
			; mov byte[cs:birdDirection], 'S'
			; jmp nomatch ; leave interrupt routine

; nomatch:	pop es
			; pop ax
			; jmp far [cs:oldisr] ; call the original ISR

; exit:		mov al, 0x20
			; out 0x20, al ; send EOI to PIC
			; pop es
			; pop ax
			; iret ; return from interrupt
; ;-----------------------------------------------------------------


; wingCollision:
	; pusha
	
	; mov ax, [cs:birdC]
	; add ax, 1
	; mov bx, [cs:CurrentCol]
	; cmp ax, bx
	; jl exit_WC
	
	; mov ax, [cs:birdR]
	; ;sub ax, 1
	; ;add ax, 1
	; mov bx, [cs:pipeHeight]
	; cmp ax, bx
	; jg exit_WC
	
	; mov word[cs:has_Collided], 1

; exit_WC:	
	; popa
	; ret

; pipeUCollision:
	; pusha
	
	; verticalCheck:
		; mov ax, [cs:birdC]
		; add ax, 6
		; cmp ax, [cs:CurrentCol]
		; jl exit_pUC
		
		; mov ax, [cs:birdC]
		; add ax, 1
		; mov bx, [cs:CurrentCol]
		; add bx, word[cs:pipeWidth]
		; sub bx, 1
		; cmp ax, bx
		; jg exit_pUC
	
	; horizontalCheckAbove:
		; call wingCollision
		
		; mov ax, [cs:birdR]
		; ;sub ax, 1
		; mov bx, [cs:pipeHeight]
		; cmp ax, bx
		; jg exit_pUC
		
		; ; mov ax, cs:birdC
		; ; sub ax, 1
		; ; mov bx, [cs:CurrentCol]
		; ; add bx, word[cs:pipeWidth]
		; ; sub bx, 1
		; ; cmp ax, bx
		; ; jg exit_pUC
		
		; mov ax, [cs:birdC]
		; add ax, 5
		; mov bx, [cs:CurrentCol]
		; add bx, word[cs:pipeWidth]
		; sub bx, 1
		; cmp ax, bx
		; jg exit_pUC
	
	; collisionU:
		; mov word[cs:has_Collided], 1

; exit_pUC:
	; popa
	; ret

; pipeDCollision:
	; pusha
	
	; verticalCheckBelow:
		; mov ax, [cs:birdC]
		; add ax, 6
		; cmp ax, [cs:CurrentCol]
		; jl exit_pDC
		
		; mov ax, [cs:birdC]
		; add ax, 1
		; mov bx, [cs:CurrentCol]
		; add bx, word[cs:pipeWidth]
		; sub bx, 1
		; cmp ax, bx
		; jg exit_pDC
	
	; horizontalCheckBelow:
		; mov ax, [cs:birdR]
		; add ax, 1
		; mov bx, [cs:pipeHeight]
		; add bx, word[cs:difference]
		; sub bx, 1
		; cmp ax, bx
		; jl exit_pDC
		
		; mov ax, [cs:birdC]
		; mov bx, [cs:CurrentCol]
		; add bx, word[cs:pipeWidth]
		; sub bx, 1
		; cmp ax, bx
		; jg exit_pDC
	
	; collisionD:
		; mov word[cs:has_Collided], 1

; exit_pDC:
	; popa
	; ret
		

; groundCollision:
	; pusha
	
	; mov ax, [cs:birdR]
	; add ax, 1
	; cmp ax, 22
	; jne exit_G
	
	; mov word[cs:has_Collided], 1
	
; exit_G:	
	; popa
	; ret

; skyCollision:
	; pusha
	
	; mov ax, [cs:birdR]
	; sub ax, 1
	; cmp ax, 0
	; jne exit_S
	
	; mov byte[cs:birdDirection], 'D'
	
; exit_S:	
	; popa
	; ret

; checkCollision:
	; pusha
	
	; call pipeUCollision
	; call pipeDCollision
	; call groundCollision
	; ;call skyCollision
	
	; popa
	; ret

; PlayAnimation:
	; cmp word [cs:pause_flag], 1
	; jne continueanimation
	; call pause_screen
	
	; cmp word[cs:shouldexit], 1
	; je endscreen
	
; continueanimation:
	; call moveGround

; Pipe1:
	; cmp word[cs:pipe1Exists], 1
	; jnz Pipe2

	; call Pipe1Movement
	; call checkCollision
	; cmp word[cs:has_Collided], 1
	; je gameoverscreen
	; call checkscore

; Pipe2:
	; cmp word[cs:pipe2Exists], 1
	; jnz Pipe3

	; call Pipe2Movement
	; call checkCollision
	; cmp word[cs:has_Collided], 1
	; je gameoverscreen
	; call checkscore
	
; Pipe3:
	; cmp word[cs:pipe3Exists], 1
	; jnz continue

	; call Pipe3Movement
	; call checkCollision
	; cmp word[cs:has_Collided], 1
	; je gameoverscreen
	; call checkscore
	
; continue:
	; call delay
	; ;call delay
	; call moveBird
	; ;call delay
	; jmp PlayAnimation

; endofprogram:
; mov dx, 388h
    ; mov al, 0xff  ; Select all registers to silence
    ; out dx, al

    ; mov dx, 389h
    ; mov al, 0x00  ; Write 0 to silence the sound
    ; out dx, al
	
; mov ax, 0x3100 ; terminate and stay resident
; int 0x21

; start:
	; push 0x0720
	; call clrscr
	; call title_screen
	
	; call music1
	
	; ;wait for key input
	; mov ah, 0
	; int 0x16
	
	; push 0x3020
	; call clrscr

	; xor ax, ax
	; mov es, ax 					; point es to IVT base
	; mov ax, [es:9*4]
	; mov [cs:oldisr], ax 			; save offset of old routine
	; mov ax, [es:9*4+2]
	; mov [cs:oldisr+2], ax 			; save segment of old routine

	; cli 						; disable interrupts
	; mov word [es:9*4], kbisr 	; store offset at n*4
	; mov [es:9*4+2], cs 			; store segment at n*4+2
	; sti 						; enable interrupts

	; mov dx, start ; end of resident portion
	; add dx, 15 ; round up to next para
	; mov cl, 4
	; shr dx, cl ; number of paras..../2^4

; PrintStartScreen:
	; call Background
	; call Ground
	; call Clouds
	; call saveScreen
	
	; call create_instruction_screen
	
	; ;wait for key input
	; mov ah,0
	; int 0x16
	
	; call Background
	; call Ground
	; call Clouds
	; call Bird
	; mov word[cs:pipe1Exists], 1
	
	; push 3988
	; push word[cs:scoreofgame]
	; call printnum
	
	; ;wait for key input
	; mov ah, 0
	; int 0x16
	
	; mov word [cs:pcb+10+4], music			    ; initialize ip
	; mov [cs:pcb+10+6], cs						; initialize cs
	; mov word [cs:pcb+10+8], 0x0200				; initialize flags

	; mov word [cs:pcb+20+4], PlayAnimation	    ; initialize ip
	; mov [cs:pcb+20+6], cs						; initialize cs
	; mov word [cs:pcb+20+8], 0x0200				; initialize flags

	; mov word [cs:current], 0					; set current task index
	; xor ax, ax
	; mov es, ax									; point es to IVT base
	
	; xor ax, ax
	; mov es, ax 					; point es to IVT base
	; mov ax, [es:8*4]
	; mov [cs:oldisr_timer], ax 			; save offset of old routine
	; mov ax, [es:8*4+2]
	; mov [cs:oldisr_timer+2], ax 			; save segment of old routine
	
	
	; cli
	; mov word [es:8*4], timer
	; mov [es:8*4+2], cs							; hook timer interrupt
	; mov ax, 0xb800
	; mov es, ax									; point es to video base
	; xor bx, bx									; initialize bx for tasks, bx=0
	; mov si, 0
	; sti

	; jmp $										; infinite loop ... Task 0
[org 0x100]
jmp start
count: dd 0
check_death: db 0
num: dw 260
w_key: db 'w'
s_key: db 's'
a_key: db 'a'
d_key: db 'd'
e_key: db 'e'
p_key: db 'p'
curr_move: db 0
game_over_msg: db 'GAME 0VER'
score_msg: db 'SCORE'
is_eat: db 0
score: dw 0
snake_heading: db "SNAKE GAME",0
names: db "Ali Ahmad (21F-9207)                Hafiza Haiqa (21F-9107)",0
press_s: db "Press 'S' to continue",0
instruction1: db "W", 0
instruction2: db "A S D", 0
instruction0: db "CONTROLLER INSTRUCTIONS", 0
instruction3: db "PLAYING INSTRUCTIONS :", 0
instruction4: db "1) Snake will die if it collides with any of the boundary", 0
instruction5: db "2) Snake will die if it collides with itself", 0
food_color: db 1


;--------------> SCREEN CLEARING SUBROUTINE
clrscr:    
    push ax
    push es
    push di
    mov ax, 0xb800
    mov es, ax
    mov di, 0
clr:
    mov word [es:di], 0x0720
    add di, 2
    cmp di, 4000
    jne clr
    pop di
    pop es
    pop ax
    ret



;--------------> STRING PRINTING SUBROUTINE
printstr: push bp
mov bp, sp
push es
push ax
push cx
push si
push di
push ds
pop es ; load ds in es
mov di, [bp+4] ; point di to string
mov cx, 0xffff ; load maximum number in cx
xor al, al ; load a zero in al
repne scasb ; find zero in the string
mov ax, 0xffff ; load maximum number in ax
sub ax, cx ; find change in cx
dec ax ; exclude null from length
jz exit ; no printing if string is empty
mov cx, ax ; load string length in cx
mov ax, 0xb800
mov es, ax ; point es to video base
mov al, 80 ; load al with columns per row
mul byte [bp+8] ; multiply with y position
add ax, [bp+10] ; add x position
shl ax, 1 ; turn into byte offset
mov di,ax ; point di to required location
mov si, [bp+4] ; point si to string
mov ah, [bp+6] ; load attribute in ah
cld ; auto increment mode
nextchar: lodsb ; load next char in al
stosw ; print char/attribute pair
loop nextchar ; repeat for the whole string
exit: pop di
pop si
pop cx
pop ax
pop es
pop bp
ret 8


;--------------> BANNER PRINTING SUBROUTINE
print_banner:
    push 30
    push 6
    mov ax, 0x0A
    push ax
    mov ax, instruction0
    push ax
    call printstr

    push 41
    push 8
    mov ax, 0x0A
    push ax
    mov ax, instruction1
    push ax
    call printstr

    push 39
    push 10
    mov ax, 0x0A
    push ax
    mov ax, instruction2
    push ax
    call printstr

    push 0
    push 17
    mov ax, 0x02
    push ax
    mov ax, instruction3
    push ax
    call printstr

    push 0
    push 18
    mov ax, 0x03
    push ax
    mov ax, instruction4
    push ax
    call printstr

    push 0
    push 19
    mov ax, 0x03
    push ax
    mov ax, instruction5
    push ax
    call printstr

    mov cx, 40
    looping_delay_banner:
    call delay
    loop looping_delay_banner

    call clear_scr
    push 35
    push 5
    mov ax, 0x0A
    push ax
    mov ax, snake_heading
    push ax
    call printstr

    push 12
    push 10
    mov ax, 0x0A
    push ax
    mov ax, names
    push ax
    call printstr

    push 29
    push 20
    mov ax, 0x0A
    push ax
    mov ax, press_s
    push ax
    call printstr
    ret


;--------------> SETUP THE BEEP ISR
 beep_setup:
  push es
  push ax

  xor ax, ax
  mov es, ax

  ;Save the original ISR
  mov ax, WORD [es: TIMER_INT * 4]
  mov WORD [cs:original_timer_isr], ax
  mov ax, WORD [es: TIMER_INT * 4 + 2]
  mov WORD [cs:original_timer_isr + 2], ax

  ;Setup the new ISR

  cli
  mov ax, beep_isr
  mov WORD [es: TIMER_INT * 4], ax
  mov ax, cs
  mov WORD [es: TIMER_INT * 4 + 2], ax
  sti

  pop ax
  pop es
  ret 


;--------------> TEAR DOWN THE BEEP ISR
 beep_teardown:
  push es
  push ax

  call beep_stop

  xor ax, ax
  mov es, ax

  ;Restore the old ISR

  cli
  mov ax, WORD [cs:original_timer_isr]
  mov WORD [es: TIMER_INT * 4], ax
  mov ax, WORD [cs:original_timer_isr + 2]
  mov WORD [es: TIMER_INT * 4 + 2], ax
  sti

  pop ax
  pop es
  ret 


;--------------> BEEP ISR
 beep_isr:
  cmp BYTE [cs:sound_playing], 0
  je _bi_end

  cmp WORD [cs:sound_counter], 0
  je _bi_stop

  dec WORD [cs:sound_counter]

 jmp _bi_end

_bi_stop:
  call beep_stop

_bi_end:
  ;Chain
  jmp FAR [cs:original_timer_isr]
 ;Stop beep
 ;
 beep_stop:
  push ax

  ;Stop the sound

  in al, 61h
  and al, 0fch    ;Clear bit 0 (PIT to speaker) and bit 1 (Speaker enable)
  out 61h, al

  ;Disable countdown

  mov BYTE [cs:sound_playing], 0

  pop ax
  ret


 ;Beep
 ;AX = 1193180 / frequency
 ;BX = duration in 18.2th of sec
 beep_play:
  push ax
  push dx

  mov dx, ax

  mov al, 0b6h
  out 43h, al

  mov ax, dx
  out 42h, al
  mov al, ah
  out 42h, al


  ;Set the countdown
  mov WORD [cs:sound_counter], bx

  ;Start the sound

  in al, 61h
  or al, 3h    ;Set bit 0 (PIT to speaker) and bit 1 (Speaker enable)
  out 61h, al


  ;Start the countdown

  mov BYTE [cs:sound_playing], 1

  pop dx
  pop ax
  ret

 ;Keep these in the code segment
 sound_playing      db  0
 sound_counter      dw  0
 original_timer_isr     dd  0

 TIMER_INT      EQU     1ch


;--------------> EATING SUBROUTINE
eat:
push bp
mov bp, sp
sub sp, 2
push ax
push bx
push cx
push dx
push si

mov si, pos
mov ax, word[len]
dec ax
shl ax, 1
add si, ax  ;calculating the head position of snake
mov ax, word[num]
mov word[bp-2], ax
cmp [si], ax
jne no_eat
call beep_setup ;Setup
;produces beep when eat food
mov ax, 4000	; beep frequency
mov bx, 4	;time for beep
call beep_play
call delay
call beep_teardown  ;Tear down
mov ax, word[num]
mov word[space], ax
call print_space
call print_food

inc word[len]
inc word[score]
add si, 2

mov ax, word[bp-2]
mov word[si], ax
no_eat:


pop si
pop dx
pop cx
pop bx
pop ax

mov sp, bp
pop bp
ret


;--------------> KEYBOARD INTTERUPT SUBROUTINE
snake_int:
    push ax

    xor ax, ax
    mov ah, 0x01 
    int 0x16 ; call BIOS keyboard service
    jz no_int
	call movement
    no_int:

    pop ax
    ret


;--------------> RANDOM NUMBER SUBROUTINE
rand_no:
    push ax
    push dx
    push cx

    rdtsc
    xor dx, dx
    mov cx, 3998
    div cx
    mov word[num], dx

    pop cx
    pop dx
    pop ax
    ret


;--------------> DELAY SUBROUTINE
delay: 
    mov dword[count], 60000
looping_delay:
	dec dword[count]
	cmp dword[count], 0
	jne looping_delay
    ret


;--------------> CLEAR SCREEN SUBROUTINE
clear_scr:
    push ax
    push es
    push di

    mov ax, 0xb800
    mov es, ax
    xor di, di
looping_clr:
    mov word [es:di], 0x0720
    add di, 2
    cmp di, 4000
    jne looping_clr

    pop di
    pop es
    pop ax
    ret


;--------------> RANDOM FOOD GENERATING SUBROUTINE
print_food:
push ax
push es
push di
push cx

mov ax, 0xb800
mov es, ax
call rand_no
test word[num], 1
jz ok
dec word[num]
ok:
call checking_food
mov ax, word[num]
mov di, ax
cmp byte[food_color], 10
jne skip_color
mov byte[food_color], 1
skip_color:
inc byte[food_color]
mov ah, byte[food_color]
mov al, 0x6F
mov word[es:di], ax

pop cx
pop di
pop es
pop ax
ret

;--------------> Y-AXIS BORDER PRINTING SUBROUTINE
border_y:                         
    push bp
    mov bp, sp
    push ax
    push cx
    push es
    push di

    mov ax, 0xb800
    mov es, ax
    mov di, [bp+4]
    mov cx, 25
looping_border_y:
    mov word [es:di], 0x7020
    add di, 160
    loop looping_border_y

    pop di
    pop es
    pop cx
    pop ax
    pop bp
    ret 2


;--------------> X-AXIS BORDER PRINTING SUBROUTINE
border_x:                         
    push bp
    mov bp, sp
    push ax
    push cx
    push es
    push di

    mov ax, 0xb800
    mov es, ax
    mov di, [bp+4]
    mov cx, 80
looping_border_x: 
    mov word [es:di], 0x7020
    add di, 2
    loop looping_border_x

    pop di
    pop es
    pop cx
    pop ax
    pop bp
    ret 2


;--------------> ALL BORDER PRINTING AND CLEARING SCREEN (INITIALIZING GAME) SUBROUTINE
load_border:
push ax

call clear_scr
push 0
call border_y
push 158
call border_y
push 0
call border_x
push 3840
call border_x

pop ax
ret


;--------------> SNAKE PRINTING SUBROUTINE
print_snake:
    push ax
    push es
    push di
    push cx 
    push bx

    mov ax, 0xb800
    mov es, ax
    mov bx, pos
    mov cx, word[len]
    dec cx
looping_snake:  ;snake body printing 
    mov di, [bx]
    mov word[es:di], 0x0A2A   
    add bx, 2  
    loop looping_snake
    mov di, [bx]    ;snake head printing
    mov word[es:di], 0x0A02

    pop bx
    pop cx
    pop di
    pop es
    pop ax
    ret


;--------------> SPACE PRINTING SUBROUTINE
print_space:
    push ax
    push es
    push di

    mov ax, 0xb800
    mov es, ax
    mov word di, [space]
    mov word [es:di], 0x0720

    pop di
    pop es
    pop ax
    ret


;--------------> RIGHT SHIFTING SUBROUTINE
right_shifting:
    push ax
    push cx
    push si
    push di
    
    mov di, pos
    mov si, pos
    mov ax, word[pos]
    add si, 2
    mov word[space], ax
    mov cx, word[len]
    dec cx
looping_right:
    mov ax , word[si]
    mov word[di], ax
    add si, 2
    add di, 2
    loop looping_right
    mov bx, pos
    mov cx, word[len]
    dec cx
    shl cx, 1
    add bx, cx
    add word[bx], 2

    pop di
    pop si
    pop cx
    pop ax
    ret


;--------------> LEFT SHIFTING SUBROUTINE
left_shifting:
    push ax
    push cx
    push si
    push di
    
    mov di, pos
    mov si, pos
    mov ax, word[pos]
    add si, 2
    mov word[space], ax
    mov cx, word[len]
    dec cx
looping_left:
    mov ax , word[si]
    mov word[di], ax
    add si, 2
    add di, 2
    loop looping_left
    mov bx, pos
    mov cx, word[len]
    dec cx
    shl cx, 1
    add bx, cx
    sub word[bx], 2

    pop di
    pop si
    pop cx
    pop ax
    ret


;--------------> DOWN SHIFTING SUBROUTINE
down_shifting:
    push ax
    push cx
    push si
    push di
    
    mov di, pos
    mov si, pos
    mov ax, word[pos]
    add si, 2
    mov word[space], ax
    mov cx, word[len]
    dec cx
looping_down:
    mov ax , word[si]
    mov word[di], ax
    add si, 2
    add di, 2
    loop looping_down
    mov bx, pos
    mov cx, word[len]
    dec cx
    shl cx, 1
    add bx, cx
    add word[bx], 160

    pop di
    pop si
    pop cx
    pop ax
    ret


;--------------> DOWN SHIFTING SUBROUTINE
up_shifting:
    push ax
    push cx
    push si
    push di
    
    mov di, pos
    mov si, pos
    mov ax, word[pos]
    add si, 2
    mov word[space], ax
    mov cx, word[len]
    dec cx
looping_up:
    mov ax , word[si]
    mov word[di], ax
    add si, 2
    add di, 2
    loop looping_up
    mov bx, pos
    mov cx, word[len]
    dec cx
    shl cx, 1
    add bx, cx
    sub word[bx], 160

    pop di
    pop si
    pop cx
    pop ax
    ret


;--------------> BORDER DEATH CHECKING SUBROUTINE
check_border:
    push ax
    push cx
    push dx
    push si
    push bx

    mov cx, word[len]
    dec cx
    shl cx, 1
    mov bx, pos
    add bx, cx
    mov ax, [bx]
    mov cx, 0
check_left:                        ;LEFT SIDE BORDER CHECK
    cmp ax, cx
    je found
    add cx, 160
    cmp cx, 3840
    jne check_left

    mov cx, 158
check_right:                       ;RIGHT SIDE BORDER CHECK
    cmp ax, cx
    je found
    add cx, 160
    cmp cx, 3998
    jne check_right

    mov cx, 0
check_up:                          ;TOP SIDE BORDER CHECK
    cmp ax, cx
    je found
    add cx, 2
    cmp cx, 158
    jne check_up

    mov cx, 3840
check_down:                        ;BOTTOM SIDE BORDER CHECK
    cmp ax, cx
    je found
    add cx, 2
    cmp cx, 3998
    jne check_down

    jmp skip_checking
found:                             ;IF SNAKE TOUCHES BORDER, COME TO "found" AND EXIT
    mov byte[check_death], 1
skip_checking:

    pop bx                           ;IF NOT TOUCH BORDER, LEAVE THE LOOP AS IT IS
    pop si
    pop dx
    pop cx
    pop ax
    ret


;--------------> BORDER FOOD CHECKING SUBROUTINE
checking_food:
    push ax
    push cx

    mov ax, word[num]
    mov cx, 0
checking_left:                        ;LEFT SIDE BORDER CHECK
    cmp ax, cx
    je founded
    add cx, 160
    cmp cx, 3840
    jne checking_left

    mov cx, 158
checking_right:                       ;RIGHT SIDE BORDER CHECK
    cmp ax, cx
    je founded
    add cx, 160
    cmp cx, 3998
    jne checking_right

    mov cx, 0
checking_up:                          ;TOP SIDE BORDER CHECK
    cmp ax, cx
    je founded
    add cx, 2
    cmp cx, 158
    jne checking_up

    mov cx, 3840
checking_down:                        ;BOTTOM SIDE BORDER CHECK
    cmp ax, cx
    je founded
    add cx, 2
    cmp cx, 3998
    jne checking_down

    jmp skip_check
founded:                             ;IF SNAKE TOUCHES BORDER, COME TO "found" AND EXIT
    call print_food
skip_check:

    pop cx
    pop ax
    ret


;--------------> LEFT MOVEMENT SUBROUTINE
move_left:
push ax

mov byte[curr_move], 2
looping_left_move:
mov byte[check_death], 0
call check_border
cmp byte[check_death], 1
je death_left
call print_snake
call left_shifting
call delay
call print_space
call eat
call self_collision
call snake_int
jmp looping_left_move

death_left:
call game_over
pop ax
ret


;--------------> RIGHT MOVEMENT SUBROUTINE
move_right:
mov byte[curr_move], 1
push cx
push ax

looping_right_move:
mov byte[check_death], 0
call check_border
cmp byte[check_death], 1
je death_right
call print_snake
call right_shifting
call delay
call print_space
call eat
call self_collision
call snake_int
jmp looping_right_move
death_right:
call game_over
pop ax
pop cx
ret


;--------------> UP MOVEMENT SUBROUTINE
move_up:
push ax

mov byte[curr_move], 3
looping_up_move:
mov byte[check_death], 0
call check_border
cmp byte[check_death], 1
je death_up
call print_snake
call up_shifting
call delay
call print_space
call eat
call self_collision
call snake_int
call delay
jmp looping_up_move
death_up:
call game_over
pop ax
pop cx
ret


;--------------> DOWN MOVEMENT SUBROUTINE
move_down:
push ax

mov byte[curr_move], 4
looping_down_move:
mov byte[check_death], 0
call check_border
cmp byte[check_death], 1
je death_down
call print_snake
call down_shifting
call delay
call print_space
call eat
call self_collision
call snake_int
call delay
jmp looping_down_move
death_down:
call game_over
pop ax
ret


;--------------> PAUSE SUBROUTINE
pausing:
looping_pausing:
call snake_int
jmp looping_pausing

ret


;--------------> OVERALL MOVEMENT CONTROLLER
movement:
    push ax
    xor ah, ah
    int 0x16

    cmp al, [a_key]
	jne skip1
    cmp byte[curr_move], 1
    jne move_left
    skip1:
	cmp al, [d_key]
	jne skip2
    cmp byte[curr_move], 2
    jne move_right
    skip2:
	cmp al, [w_key]
	jne skip3
    cmp byte[curr_move], 4
    jne move_up
    skip3:
	cmp al, [s_key]
	jne skip4
    cmp byte[curr_move], 3
    jne move_down
    skip4:
    cmp al, [e_key]
    jne skip5
    call game_over
    skip5:
    cmp al, [p_key]
    jne skip6
    call pausing
    skip6:

    pop ax
    ret


;--------------> SCORE PRINTING SUBROUTINE
print_score:
; subroutine to print a score at top left of screen
; takes the number to be printed as its parameter
push es
push ax
push bx
push cx
push dx
push di
mov ax, 0xb800
mov es, ax ; point es to video base
mov ax, word[score] ; load number in ax
mov bx, 10 ; use base 10 for division
mov cx, 0 ; initialize count of digits
nextdigit: mov dx, 0 ; zero upper half of dividend
div bx ; divide by 10
add dl, 0x30 ; convert digit into ascii value
push dx ; save ascii value on stack
inc cx ; increment count of values
cmp ax, 0 ; is the quotient zero
jnz nextdigit ; if no divide it again
mov di, 2162 ; point di to top left column
nextpos: pop dx ; remove a digit from the stack
mov dh, 0x03 ; use normal attribute
mov [es:di], dx ; print char on screen
add di, 2 ; move to next screen location
loop nextpos ; repeat for all digits on stack
pop di
pop dx
pop cx
pop bx
pop ax
pop es
ret 


;--------------> SELF-COLLISION DEATH CHECK SUBROUTINE
self_collision:
push bx
push ax
push cx

mov bx, pos
mov ax, word[len]
dec ax
shl ax, 1
add bx, ax
mov ax, word[bx]
mov bx, pos
mov cx, word[len]
sub cx, 2
looping_self:
cmp [bx], ax
jne skip_self
call game_over
skip_self:
add bx, 2
dec cx
jnz looping_self

pop cx
pop ax
pop bx
ret

    
;--------------> GAME OVER SUBROUTINE
game_over:
    call clear_scr
    mov ax, 0xb800
    mov es, ax
    mov si, game_over_msg
    mov di, 1990
    mov cx, 9
    mov ah, 0x04
    looping_game_over:
    mov byte al, [si]
    mov word[es:di], ax
    add di, 2
    inc si
    loop looping_game_over
    mov si, score_msg
    mov ax, 0xb800
    mov es, ax
    mov di, 2150
    mov cx, 5
    mov ah, 0x04
    looping_score:
    mov byte al, [si]
    mov word[es:di], ax
    add di, 2
    inc si
    loop looping_score
    call print_score
    mov cx, 3
    loop_over_delay:
    call delay
    loop loop_over_delay

    mov ax, 0x4c00
    int 0x21
    ret


;--------------> GAME STARTING SUBROUTINE
start:

    call clrscr
    call print_banner

loading:
    xor ax, ax
    mov ah, 0x01 
    int 0x16 ; call BIOS keyboard service
    jz loading

    xor ax, ax
    int 0x16

    cmp al, byte[s_key]
    je continue
    jmp loading

continue:
    call load_border
    call print_food
    call move_right
   

    mov ax, 0x4c00
    int 0x21


;--------------> SNAKE RELATED DATA
len: dw 3
space: dw 162
pos: dw 162, 164, 166