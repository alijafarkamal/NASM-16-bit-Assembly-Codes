
; [org 0x0100]
; jmp start
; graphics:
	; mov ax, 0x0013	;for 320*200 pixels
	; int 0x10				;switches to this mode
	; mov ax, 0xA000	;seg address for video memory
	; mov es, ax			;access to video buffer
	; ret
; upper_part:
	; xor di, di				;points to start
	; mov al, 11			;color
	; mov cx, 320*60	;range
	; rep stosb				;instruction to color this range
	; ret

; medium_part:
	; mov di, 320*60		;points to specific point
	; mov al, 9              ;color
	; mov cx, 360*60    ;range
	; rep stosb             ;instruction to color this range
	; ret
	
; lower_part:
	; mov di, 320*120	;points to specific point
	; mov al, 1              ;color
	; mov cx, 320*80    ;range
	; rep stosb             ;instruction to color this range
	; ret
	
; bird_body:
    ; mov bx,12            ;height of bird body
    ; mov si, 31180      ;points to the middle of screen
	; body:
    ; mov di, si           	;Start at pixel 31180 
    ; mov al, 14			;Color index for yellow
    ; mov cx, 18			;width of body
    ; rep stosb
    ; sub bx,1				;decrement the length counter
    ; add si, 320           ;move to the next row since one line consists of 320 pixels
    ; cmp bx ,0 
    ; jnz body
    ; mov bx,2              ;height of bird's peak
    ; mov si, 32158       ;points to the top left corner of bird's peak
	; ret	
	
; bird_beak:
    ; mov di, si             ;Start at pixel 32158 
    ; mov al, 10            ;Color index for lightgreen
    ; mov cx, 4             ;width of beak
    ; rep stosb
    ; sub bx,1               ;decrement the length counter
    ; add si, 320            ;move to the nex row since one line consists of 320 pixels
    ; cmp bx ,0 
    ; jnz bird_beak
    ; mov si,0	
    ; mov bx,50             ;height of lower rectangle
    ; mov si, 48920       ;position of rectangle 
	; ret	
; green_rect_down:
    ; mov di, si              ;Start at pixel 38400 
    ; mov al, 2               ;Color index for Green
    ; mov cx, 28             ;width of body
    ; rep stosb
    ; sub bx,1                ;decrement the length counter
    ; add si, 320             ;move to uithe nex row since one line consists of 320 pixels
    ; cmp bx ,0 
    ; jnz green_rect_down
	
    ; mov si,0	
    ; mov bx,70             ;height of rectangle
    ; mov si, 00280        ;position of upper rectangle 
	; ret
; green_rect_up:
	; mov di, si               ;Start at pixel 00920 
	; mov al, 2                ;Color index for Green
	; mov cx, 28             ;width of body
	; rep stosb
	; sub bx,1                 ;decrement the length counter
	; add si, 320             ;move to the nex row since one line consists of 320 pixels
	; cmp bx ,0 
	; jnz green_rect_up

    ; mov dx,50				;width of triangle
    ; mov si,120            	;starting row
	; ret
; wave_loop:
	; mov ax, si
	; shl ax, 8					;multiply by 256
	; mov bx, si
	; shl bx, 6					;multiply by 64
	; add ax, bx				;point on video memory where it will start making wave
	; mov di, ax				;starting point copies to di				
	; cmp dx, 0
	; jle end_wave			;exit
	; mov al, 9					;color
	; mov cx, dx				;width
	; rep stosb
	; sub dx, 2					;width of triangle
	; add si, 1					;loop to go to next row
	; jmp wave_loop
	
	; end_wave:
	; mov dx, 50
	; mov si, 120
	; mov bp, 50
	; ret
; wave_loop_inverted:
	; mov ax, si
	; shl ax, 8					;multiply by 256
	; mov bx, si
	; shl bx, 6					;multiply by 64
	; add ax, bx				;calculate video memory start point
	; mov di, ax				;set DI for start
	; add di, bp				;adjust DI by BP offset
	; cmp dx, 0
	; jle end_wave_inverted		;exit if DX is zero
	; mov al, 9					;set color
	; mov cx, dx				;set width
	; rep stosb					;draw line
	; sub dx, 2					;decrease width
	; add bp, 2					;move start right
	; add si, 1					;next row
	; jmp wave_loop_inverted		;repeat loop
	
	; end_wave_inverted:
	; mov dx, 50				;reset DX
	; mov si, 120				;reset SI
	; ret
; wave_loop1:	
	; mov ax, si         		;copy si
	; shl ax, 8            		;multiply
	; mov bx, si         		
	; shl bx, 6            		;multiply
	; add ax, bx         		
	; mov di, ax         		;set di
	; add di, 100        		
	; cmp dx, 0          		;check DX
	; jle end_wave1    		;exit
	; mov al, 9           		;color
	; mov cx, dx        		;width
	; rep stosb           		;draw
	; sub dx, 2           		;decrease
	; add si, 1            		;next row
	; jmp wave_loop1        ;loop
	
	; end_wave1:
	; mov dx, 50          		;reset DX
	; mov si, 120         		;reset SI
	; mov bp, 150        		;set BP
	; ret                 
; wave_loop_inverted1:
	; mov ax, si            	;copy SI
	; shl ax, 8           		;multiply
	; mov bx, si          		;copy SI
	; shl bx, 6          			;multiply
	; add ax, bx          		;calculate
	; mov di, ax          		;set DI
	; add di, bp          		;offset
	; cmp dx, 0          		;check DX
	; jle end_wave_inverted1 ; exit
	; mov al, 9           		;color
	; mov cx, dx          		;width
	; rep stosb           		;draw
	; sub dx, 2           		;decrease
	; add bp, 2          		;increment BP
	; add si, 1           		;increment to next row
	; jmp wave_loop_inverted1 ; loop
	
	; end_wave_inverted1:
	; mov dx, 50          ; reset DX
	; mov si, 120         ; reset SI
	; ret 
; wave_loop2:	
	; mov ax, si          		;copy SI
	; shl ax, 8            		;multiply
	; mov bx, si          		;copy SI
	; shl bx, 6            		;multiply
	; add ax, bx          		;calculate
	; mov di, ax          		;set DI
	; add di, 200         		;offset
	; cmp si, 200        		 ;check SI
	; jge end_wave2    		 ;exit
	; cmp dx, 0           		;check DX
	; jle end_wave2     		 ;exit
	; mov al, 9           		 ;color
	; mov cx, dx         		 ;width
	; rep stosb           		 ;draw
	; sub dx, 2           		 ;decrease
	; add si, 1           		 ;increment to next row
	; jmp wave_loop2        ;loop
	
	; end_wave2:
	; mov dx, 50          		;reset DX
	; mov si, 120         		;reset SI
	; mov bp, 250        		;set BP
	; ret              

	
; wave_loop_inverted2:
	; mov ax, si          	;copy SI
	; shl ax, 8           	;multiply
	; mov bx, si          	;copy SI
	; shl bx, 6          		;multiply
	; add ax, bx          	;calculate
	; mov di, ax          	;set DI
	; add di, bp          	;offset
	; cmp si, 200         ;check SI
	; jge end_wave_inverted2 ;exit
	; cmp dx, 0           ;check DX
	; jle end_wave_inverted2 ;exit
	; mov al, 9           	;color
	; mov cx, dx          	;width
	; rep stosb           	;draw
	; sub dx, 2           	;decrease
	; add bp, 2           	;increment BP
	; add si, 1           	;increment
	; jmp wave_loop_inverted2 ;loop
	
	; end_wave_inverted2:
	; mov dx, 50          ;reset DX
	; mov si, 120         ;reset SI
	; ret                
; wave_loop3:
	; mov ax, si          	;copy SI
	; shl ax, 8           	;multiply
	; mov bx, si          	;copy SI
	; shl bx, 6           	;multiply
	; add ax, bx          	;calculate
	; mov di, ax          	;set DI
	; add di, 300         	;offset
	; cmp si, 200         	;check SI
	; jge end_wave3      ;exit
	; cmp dx, 0           	;check DX
	; jle end_wave3       ;exit
	; mov al, 9          	;color
	; mov cx, dx          	;width
	; rep stosb           	;draw
	; sub dx, 2           	;decrease
	; add si, 1           	;increment
	; jmp wave_loop3    ;loop
	
	; end_wave3:
	; sub dx, 2           	;decrease DX
	; add si, 1          		;increment SI
	; ret                 

; ground:
	; mov di,57600      ;position
	; mov al,10            ;color green
	; mov cx,320*10    ;width
	; rep stosb            ;draw
	; mov di,60800      ;position
	; mov al,6              ;color brown
	; mov cx,320*10     ;width
	; rep stosb             ;draw
	; ret 
          

; iteration:
	; mov cx,64000
; delay1:

	; loop delay1
	; mov cx,64000
; delay1:
	; loop delay1
	; mov ax,es
	; mov ds,ax
	; mov ax,200
	; mov si,63998
	; mov di,63918
	; mov ax,0
; iter:
	; cmp ax,200
	; je outer
	; mov cx,40
	; std
	; rep movsw
	; sub si,160
	; sub di,160
	; inc ax
	; jmp iter
; outer:
	; mov cx,64000
; delay:
	; loop delay
	; ;call iteration
    ; ret 

; start:
	; call graphics
	; call upper_part		
	; call medium_part
	; call lower_part
	; call bird_body
	; call bird_beak
	; call green_rect_down
	; call green_rect_up
	; ;call wave_loop
	; ;call wave_loop_inverted
	; ;call wave_loop1
	; ;call wave_loop_inverted1
	; ;call wave_loop2
	; ;call wave_loop_inverted2
	; ;call wave_loop3
; labela:
	; call iteration
; jmp labela
	; xor ax, ax
	; int 0x16	
	; mov ax, 0x0003
	; int 0x10
	; mov ax, 0x4C00
; int 0x21







%imacro note 2
%ifidni %1,C
 db (%2)*12 + 0
%elifidni %1,C#
 db (%2)*12 + 1
%elifidni %1,D
 db (%2)*12 + 2
%elifidni %1,D#
 db (%2)*12 + 3
%elifidni %1,E
 db (%2)*12 + 4
%elifidni %1,F
 db (%2)*12 + 5
%elifidni %1,F#
 db (%2)*12 + 6
%elifidni %1,G
 db (%2)*12 + 7
%elifidni %1,G#
 db (%2)*12 + 8
%elifidni %1,A
 db (%2)*12 + 9
%elifidni %1,A#
 db (%2)*12 + 10
%elifidni %1,H
 db (%2)*12 + 11
%else
 %error Invalid use of note macro.
%endif
%endmacro


;
; code
;

bits 16
org 0x100

; ch=0, ah=0 on entry
main:

  ; bp will point to the adlibreg routine (during the whole demo)
  mov bp,adlibreg

  ; initialize 320x200 256 color video mode
  mov al,0x13
  call initialize

  mov di,0xA000                         ; 0xA000 = 320 * 128
  mov ES,di

  core:

    ; bl = frame counter
    ; bh = 0 (at least it seems so, but who cares, it's working well :)
    inc bl
    push bx

; ---------------------------------------------------------------------------
; adlib player routine
; ---------------------------------------------------------------------------

player:
    mov ax,bx
    and al,0xEF
    shr bx,5
    mov cl,[bx+pattern]
    and al,0x0F
    mov bx,ax
    add cl,[bx+pattern]

    and al,0x03
    cmp al,0x03
    jne .skip
    dec ax
   .skip:

    add al,0xA0

    push ax
    xor ax,ax
    mov al,cl
    mov dh,12
    div dh
    mov bl,ah
    shl ax,2
    mov dh,al
    pop ax

   ; play one note
   ; al = channel (0..3) + 0xA0
   ; bx = note (0..11)
   ; dh = 4 * octave (0..7)

    ; set frequency
    mov ah,[bx+freqtable]
    call bp

    ; note off
    add al,0x10
    mov ah,dh
    call bp

    ; note on
    add ah,0x20
    call bp

; ---------------------------------------------------------------------------
; end of adlib player routine
; ---------------------------------------------------------------------------

    hlt

; ---------------------------------------------------------------------------
; particle effect - 'snow'
; ---------------------------------------------------------------------------

particles:
    std
    mov di,320*170 - 1
    mov cx,di
    .loop:
      mov bx,321 - 1                    ; Substract 1 to compensate
      in al,0x40                        ; the bad pseudo random routine.
      and al,0x03                       ; It would be better to keep the
      add bl,al                         ; value in range 0..2 instead of 0..3
      mov ax,0x0007
      cmp byte[ES:di+bx],al
      jae .cantmove
      mov byte[ES:di+1],ah
      mov byte[ES:di+bx],al             ; This repne scasb should be in the
     .cantmove:                         ; beginning of the loop, but it takes
      repne scasb              ; <----  ; less bytes this way. That's why
      inc cx                            ; there are a few messy pixels in
    loop .loop                          ; the bottom of the screen.

    ; generate new particles
    ; mov byte[ES:bx+0x7B],al

; ---------------------------------------------------------------------------
; end of particle effect
; ---------------------------------------------------------------------------

    hlt
    hlt

    pop bx

    ; repeat core loop unless ESC is pressed
    in al,0x60
    cbw
    dec ax
  jne core

  mov al,3
initialize:
  mov al,244
  .clear:
    call bp
    dec ax
  jne .clear

  mov si,instrument
  mov cl,7
  .loop:
    lodsw
    call bp
    inc ax
    call bp
    inc ax
    call bp
  loop .loop

  retn
adlibreg:

  pusha

  mov dx,0x388
  out dx,al

  push word .here
  pusha
 .here:

  mov al,ah
  inc dx
  out dx,al
  dec dx

 .timer:
  mov cx,dx
  .loop:
    in al,dx
  loop .loop

  popa
  retn


; frequency table
; I've got the idea of this 1 byte/note table from
; Viznut/PWP's "Phygo" Assembly 1999 4kb intro source
freqtable:
db 0x157/4 ; C
db 0x16B/4 ; C#
db 0x181/4 ; D
db 0x198/4 ; D#
db 0x1B0/4 ; E
db 0x1CA/4 ; F
db 0x1E5/4 ; F#
db 0x202/4 ; G
db 0x220/4 ; G#
db 0x241/4 ; A
db 0x263/4 ; A#
db 0x287/4 ; H

; (register, data) pairs
; if there were at least two instruments, it would be smaller to use
; (register, data1, data2) format, where data2 is written to register+3
instrument:
db 0x20
db 00100000b
db 0x23
db 10100000b
db 0x60
db 11111000b
db 0x63
db 11110011b
db 0x80
db 01001010b
db 0x83
db 00110010b
db 0xC0
db 00000110b

pattern:
note C ,3
note C ,1
note C ,2
note D#,3
note G ,3
note G ,2
note D#,3
note D#,2
note F ,3
note F ,1
note F ,2
note F ,3
note A#,2
note A#,0
note A#,1
note A#,2
