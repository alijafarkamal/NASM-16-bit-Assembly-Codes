;               COAL PROJECT - GRAND PRIX CIRCUIT GAME IMPLEMENTATION
; MEMBERS:  SYED MUHAMMAD ANAS NAUMAN    21L-5230 
;           SAAD ASIF                    21L-7532  
; SECTION:  3-B

   ; PROGRAM TO ACT AS NORMAL CLOCK IN THE FORM
   ; OF   MINUTES:SECONDS  00:00
   ; HOURS IS EXCLUDED AS OF YET
   ; MINUTES IS NOT ROUNDED OFF TO ZERO IF IT REACHES 60

[org 0x0100]
jmp start
    Seconds: db 70
    Minutes: db 0
  TickCount: db 0
oldTimerISR: dd 0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clrscrn:
       push es
       push ax
       push cx
       push di

       mov ax,0xb800
       mov es,ax
       xor di,di
       mov ax,0x0720
       mov cx,2000

       cld
       rep stosw 

       pop di
       pop cx
       pop ax
       pop es

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
printClock:
        push bp
	mov bp, sp
	push es
	push ax
	push bx
	push cx
	push dx
	push di

	mov ax, 0xb800
	mov es, ax

      mov di,[bp+4]
      sub di,2

      mov ax,0x073A     ; ASCII for :(colon) character
      mov [es:di],ax

      cmp byte[cs:Seconds],60
      jb prntSecondsNormal
      
      sub byte[cs:Seconds],60
      inc byte[cs:Minutes]

prntSecondsNormal:
       xor ax,ax
       mov al, byte[cs:Seconds]
       mov bx, 10
       mov cx, 0

nextdigitSec:	
          mov dx, 0
	  div bx
	  add dl, 0x30
	  push dx
	  inc cx
	  cmp ax, 0
	  jnz nextdigitSec

          cmp cx,1
          jne prntSec    
          mov dx,0x0030
          push dx
          inc cx

prntSec:
	mov di,[bp+4]

nextposSec:	
        pop dx
	mov dh, 0x07
	mov [es:di], dx
	add di, 2
	loop nextposSec

        xor ax,ax
	mov al,byte[cs:Minutes]
	mov bx, 10
	mov cx, 0

nextdigitMin:	
           mov dx, 0
	   div bx
	   add dl, 0x30
	   push dx
	   inc cx
	   cmp ax, 0
	   jnz nextdigitMin

          cmp cx,1
          jne prntMin    
          mov dx,0x0030
          push dx
          inc cx

prntMin:
	mov di,[bp+4]
        sub di,6

nextposMin:	
        pop dx
	mov dh, 0x07
	mov [es:di], dx
	add di, 2
	loop nextposMin

		pop di
		pop dx
		pop cx
		pop bx
		pop ax
		pop es
		pop bp

		ret 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
timer:
     push ax

     inc byte [cs:TickCount]
     
     cmp byte[cs:TickCount],18
     jne exitTimer
     inc byte[cs:Seconds]
     mov byte [cs:TickCount],0

     mov ax,140                    ; LOAD POSITION ON STACK
     push ax
     call printClock

exitTimer:
     mov al, 0x20
     out 0x20, al

     pop ax
     iret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
start:		

    call clrscrn

    xor ax, ax
    mov es, ax

      mov ax,[es:8*4]
      mov [cs:oldTimerISR],ax
      mov ax,[es:8*4+2]
      mov [cs:oldTimerISR+2],ax

    cli
    mov word [es:8*4], timer
    mov [es:8*4+2], cs
    sti

loopesc:
      mov ah,0
      int 0x16
      cmp al,27
      jne loopesc


      mov ax,[cs:oldTimerISR]
      mov bx,[cs:oldTimerISR+2]

      cli
      mov [es:8*4],ax
      mov [es:8*4+2],bx
      sti

    call clrscrn

mov ax, 0x4c00
int 0x21