;               COAL PROJECT - GRAND PRIX CIRCUIT GAME IMPLEMENTATION
; MEMBERS:  SYED MUHAMMAD ANAS NAUMAN    21L-5230 
;           SAAD ASIF                    21L-7532  
; SECTION:  3-B
[org 0x0100]
mov [cs:DataSegment],ds
jmp start
DataSegment: dw 0
    Seconds: db 50
    Minutes: db 11
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clrscrn:
       push es
       push ax
       push cx
       push di

       mov ax,0xb800
       mov es,ax 
       xor di,di        ; load di to point to top left of screen
       mov ax,0x0720    ; load space character on black background
       mov cx,2000      ; number of columns to color

       cld              ; auto increment method 
       rep stosw        ; repeat until  cx turns zero
   
       pop di
       pop cx
       pop ax
       pop es

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;
delay:
     push cx

     mov  cx,0xffff             ; load cx with highest count
loop1: loop loop1               ; loop instruction until cx is zero
 
     mov  cx,0xffff             ; load cx with highest count
loop2: loop loop2               ; loop instruction until cx is zero

     mov  cx,0xffff             ; load cx with highest count
loop3: loop loop3               ; loop instruction until cx is zero

     mov  cx,0xffff             ; load cx with highest count
loop4: loop loop4               ; loop instruction until cx is zero

     mov  cx,0xffff             ; load cx with highest count
loop5: loop loop5               ; loop instruction until cx is zero

     mov  cx,0xffff             ; load cx with highest count
loop6: loop loop6               ; loop instruction until cx is zero

     mov  cx,0xffff             ; load cx with highest count
loop7: loop loop7               ; loop instruction until cx is zero

     mov  cx,0xffff             ; load cx with highest count
loop8: loop loop8               ; loop instruction until cx is zero

     pop  cx

     ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
prntstr:
       push bp
       mov  bp,sp
       push es
       push ax
       push cx
       push si
       push di
  
       mov es,[cs:DataSegment] ; load ds in es

       mov   di,[bp+4]   ; point di to string address
       mov   cx,0xffff   ; set cx to highest count
       xor   al,al       ; set al to zero as a terminating factor
       repne scasb       ; compare string till terminating factor
       mov   ax,0xffff   ; set ax to highest count
       sub   ax,cx       ; get length of string in ax
       dec   ax          ; decrement length by one
       
       mov cx,ax         ; update cx with the count
       mov ax,0xb800   
       mov es,ax
       mov al,80         ; load 80 in al
       mul byte[bp+8]    ; multiply with y position
       add ax,[bp+10]    ; add x position
       shl ax,1          ; convert into byte offset
       mov di,ax         ; update di accordingly
       mov si,[bp+4]     ; make si point to string address
       mov ah,[bp+6]     ; load attribute in ah

       cld               ; auto increment method

nxtchar:
       lodsb             ; load string byte in al
       stosw             ; print ax on screen
       loop nxtchar      ; continue till cx isnt zero
   
      pop di
      pop si
      pop cx
      pop ax
      pop es
      pop bp

      ret 8 
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

   GameName: db 'GRAND PRIX CIRCUIT GAME',0
ResultSheet: db 'QUALIFYING ROUND RESULT SHEET',0
     Header: db 'Pos.             Name                        Time  ',0
  Position1: db '01         Don Matrelli                     04:00  ',0
  Position2: db '02         Travis Daye                      05:00  ',0
  Position3: db '03         Cal Tyrone                       06:00  ',0
  Position4: db '04         Peter Kurtz                      07:00  ',0
  Position5: db '05         Tse Sakamoto                     08:00  ',0
  Position6: db '06         Alfonso Rodriguez                09:00  ',0
  Position7: db '07         Bruno Gourdo                     10:00  ',0
  Position8: db '08         Toni Borlini                     11:00  ',0
  Position9: db '09         Vito Giuffre                     12:00  ',0
 Position10: db '10         Nigel Levins                     13:00  ',0
  PositionX: db '           Player X                                ',0
EnterToExit: db 'Press Enter Key To Exit!',0
qualifyresultsheet:
       push bp
       mov  bp,sp
       sub  bp,4                    ; create local variable space
       push si
       push es
       push ax
       push bx 
       push cx
       push dx
       push di
       push ds

       mov ax,0xb800
       mov es,ax

       cld

       call clrscrn

       mov ax,0x04db
       xor di,di
       mov cx,240
       rep stosw

    mov  ax,28                ; load x position
    push ax                   ; push x position
    mov  ax,1                 ; load y position
    push ax                   ; push y position
    mov  ax,0x0040            ; black on red attribute
    push ax                   ; push attribute
    mov  ax,GameName          ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov  ax,25                ; load x position
    push ax                   ; push x position
    mov  ax,4                 ; load y position
    push ax                   ; push y position
    mov  ax,0x000f            ; white on blackattribute
    push ax                   ; push attribute
    mov  ax,ResultSheet       ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

        mov bx,10             ; load Overall x position

    mov  ax,bx                ; load x position
    push ax                   ; push x position
    mov  ax,6                 ; load y position
    push ax                   ; push y position
    mov  ax,0x0007            ; grey on blackattribute
    push ax                   ; push attribute
    mov  ax,Header            ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov  ax,bx                ; load x position
    push ax                   ; push x position
    mov  ax,8                 ; load y position
    push ax                   ; push y position
    mov  ax,0x000f            ; white on blackattribute
    push ax                   ; push attribute
    mov  ax,Position1         ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov  ax,bx                ; load x position
    push ax                   ; push x position
    mov  ax,9                 ; load y position
    push ax                   ; push y position
    mov  ax,0x000f            ; white on blackattribute
    push ax                   ; push attribute
    mov  ax,Position2         ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov  ax,bx                ; load x position
    push ax                   ; push x position
    mov  ax,10                ; load y position
    push ax                   ; push y position
    mov  ax,0x000f            ; white on blackattribute
    push ax                   ; push attribute
    mov  ax,Position3         ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov  ax,bx                ; load x position
    push ax                   ; push x position
    mov  ax,11                ; load y position
    push ax                   ; push y position
    mov  ax,0x000f            ; white on blackattribute
    push ax                   ; push attribute
    mov  ax,Position4         ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov  ax,bx                ; load x position
    push ax                   ; push x position
    mov  ax,12                ; load y position
    push ax                   ; push y position
    mov  ax,0x000f            ; white on blackattribute
    push ax                   ; push attribute
    mov  ax,Position5         ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov  ax,bx                ; load x position
    push ax                   ; push x position
    mov  ax,13                ; load y position
    push ax                   ; push y position
    mov  ax,0x000f            ; white on blackattribute
    push ax                   ; push attribute
    mov  ax,Position6         ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov  ax,bx                ; load x position
    push ax                   ; push x position
    mov  ax,14                ; load y position
    push ax                   ; push y position
    mov  ax,0x000f            ; white on blackattribute
    push ax                   ; push attribute
    mov  ax,Position7         ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov  ax,bx                ; load x position
    push ax                   ; push x position
    mov  ax,15                ; load y position
    push ax                   ; push y position
    mov  ax,0x000f            ; white on blackattribute
    push ax                   ; push attribute
    mov  ax,Position8         ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov  ax,bx                ; load x position
    push ax                   ; push x position
    mov  ax,16                ; load y position
    push ax                   ; push y position
    mov  ax,0x000f            ; white on blackattribute
    push ax                   ; push attribute
    mov  ax,Position9         ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov  ax,bx                ; load x position
    push ax                   ; push x position
    mov  ax,17                ; load y position
    push ax                   ; push y position
    mov  ax,0x000f            ; white on blackattribute
    push ax                   ; push attribute
    mov  ax,Position10        ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    xor ax,ax
    xor bx,bx

    mov ax,1280
    
    cmp byte[cs:Minutes],4
    jg  QRScmp2
     mov ax,1
    jmp exitQRS

QRScmp2:
    cmp byte[cs:Minutes],5
    jg  QRScmp3
      mov ax,2
    jmp exitQRS


QRScmp3:
    cmp byte[cs:Minutes],6
    jg  QRScmp4
      mov ax,3
    jmp exitQRS


QRScmp4:
    cmp byte[cs:Minutes],7
    jg  QRScmp5
      mov ax,4
    jmp exitQRS

QRScmp5:
    cmp byte[cs:Minutes],8
    jg  QRScmp6
      mov ax,5
    jmp exitQRS


QRScmp6:
    cmp byte[cs:Minutes],9
    jg  QRScmp7
      mov ax,6
    jmp exitQRS


QRScmp7:
    cmp byte[cs:Minutes],10
    jg  QRScmp8
      mov ax,7
    jmp exitQRS

QRScmp8:
    cmp byte[cs:Minutes],11
    jg  QRScmp9
      mov ax,8
    jmp exitQRS

QRScmp9:
    cmp byte[cs:Minutes],12
    jg  QRScmp10
      mov ax,9
    jmp exitQRS

QRScmp10:
    mov ax,10

exitQRS:
    mov word[bp-4],ax         ; store rank in local variable for position print
    mov word[bp-2],ax         ; store rank in local variable for time print
    mov dx,7
    add dx,word[bp-2]         ; move to respective row

    mov  bx,10                ; load x position
    push bx                   ; push x position
    push dx                   ; push y position
    mov  bx,0x000C            ; pink on blackattribute
    push bx                   ; push attribute
    mov  bx,PositionX         ; load string address
    push bx                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING


    mov al,80
    mul dx
    add ax,57
    shl ax,1
    mov word[bp-2],ax          ; store rank
    
    xor ax,ax
    mov al, byte[cs:Seconds]
    mov bx, 10
    mov cx, 0

QRSdigitSec:	
          mov dx, 0
	  div bx
	  add dl, 0x30
	  push dx
	  inc cx
	  cmp ax, 0
	  jnz QRSdigitSec

          cmp cx,1
          jne QRSprntSec    
          mov dx,0x0030
          push dx
          inc cx

QRSprntSec: 
	mov di,[bp-2]

QRSnextposSec:	
        pop dx
	mov dh, 0x0C
	mov [es:di], dx
	add di, 2
	loop QRSnextposSec

        xor ax,ax
	mov al,byte[cs:Minutes]
	mov bx, 10
	mov cx, 0

QRSdigitMin:	
           mov dx, 0
	   div bx
	   add dl, 0x30
	   push dx
	   inc cx
	   cmp ax, 0
	   jnz QRSdigitMin

          cmp cx,1
          jne QRSprntMin    
          mov dx,0x0030
          push dx
          inc cx

QRSprntMin:
	mov di,[bp-2]
        sub di,6

QRSposMin:	
        pop dx
	mov dh, 0x0C
	mov [es:di], dx
	add di, 2
	loop QRSposMin

      mov di,[bp-2]
      sub di,2

      mov ax,0x0C3A         ; ASCII for :(colon) character
      mov [es:di],ax

    xor ax,ax
    mov al, byte[bp-4]
    mov bx, 10
    mov cx, 0

QRSdigitRank:	
          mov dx, 0
	  div bx
	  add dl, 0x30
	  push dx
	  inc cx
	  cmp ax, 0
	  jnz QRSdigitRank

          cmp cx,1
          jne QRSprntRank   
          mov dx,0x0030
          push dx
          inc cx

QRSprntRank: 
	mov di,[bp-2]
        sub di,94
QRSnextposRank:	
        pop dx
	mov dh, 0x0C
	mov [es:di], dx
	add di, 2
	loop QRSnextposRank

    mov  ax,25                ; load x position
    push ax                   ; push x position
    mov  ax,20                ; load y position
    push ax                   ; push y position
    mov  ax,0x0087            ; white on blackattribute
    push ax                   ; push attribute
    mov  ax,EnterToExit       ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

loopEntKey
    mov ah,0
    int 0x16
    cmp al,0x0D               ; ASCII of enter Key (NOT Scan Code)
    jne loopEntKey

    call clrscrn

       pop ds
       pop di
       pop dx
       pop cx
       pop bx
       pop ax
       pop es
       pop si
       add bp,4                ; free local variable space
       pop bp

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;

 RaceEndMsg: db ' END OF QUALIFYING ROUND ',0
  FetchData: db ' Fetching Data ...',0
 CalcResult: db ' Calculating Results ...',0 
PrintResult: db ' Printing',0
loadingresult:

       push bp
       mov  bp,sp
       push si
       push es
       push ax
       push bx 
       push cx
       push dx
       push di
       push ds

       mov ax,0xb800
       mov es,ax

       cld

       call clrscrn

    mov  ax,28                ; load x position
    push ax                   ; push x position
    mov  ax,5                 ; load y position
    push ax                   ; push y position
    mov  ax,0x0004            ; red on black attribute
    push ax                   ; push attribute
    mov  ax,RaceEndMsg        ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

   call delay
   call delay
   call delay
   call delay
   call delay
   call delay

    mov  ax,32                ; load x position
    push ax                   ; push x position
    mov  ax,8                 ; load y position
    push ax                   ; push y position
    mov  ax,0x000e            ; red on black attribute
    push ax                   ; push attribute
    mov  ax,FetchData         ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov ax,0x0720
    mov di,1374
    xor bx,bx

loopFD:
    push di
    mov cx,4
    rep stosw
    pop di
    call delay
    call delay
    mov word[es:di],0x0e2e
    call delay
    call delay
    mov word[es:di+2],0x0e2e
    call delay
    call delay
    mov word[es:di+4],0x0e2e
    call delay
    call delay
    inc bx
    cmp bx,4
    jne loopFD

    mov  ax,29                ; load x position
    push ax                   ; push x position
    mov  ax,11                ; load y position
    push ax                   ; push y position
    mov  ax,0x0008            ; red on black attribute
    push ax                   ; push attribute
    mov  ax,CalcResult        ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov ax,0x0720
    mov di,1860
    xor bx,bx

loopCR:
    push di
    mov cx,4
    rep stosw
    pop di
    call delay
    call delay
    mov word[es:di],0x082e
    call delay
    call delay
    mov word[es:di+2],0x082e
    call delay
    call delay
    mov word[es:di+4],0x082e
    call delay
    call delay
    inc bx
    cmp bx,4
    jne loopCR

    mov  ax,35                ; load x position
    push ax                   ; push x position
    mov  ax,13                ; load y position
    push ax                   ; push y position
    mov  ax,0x000c            ; red on black attribute
    push ax                   ; push attribute
    mov  ax,PrintResult       ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov di,2172

    call delay
    call delay
    call delay
    mov word[es:di],0x0c2e
    call delay
    call delay
    call delay
    call delay
    mov word[es:di+2],0x0c2e
    call delay
    call delay
    call delay
    call delay
    mov word[es:di+4],0x0c2e
    call delay
    call delay
    call delay
    call delay

       pop ds
       pop di
       pop dx
       pop cx
       pop bx
       pop ax
       pop es
       pop si
       pop bp

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
start:
   call clrscrn
   call loadingresult
   call qualifyresultsheet

   call delay
   call delay
   call delay
   call delay
   call delay

mov ax, 0x4c00
int 0x21