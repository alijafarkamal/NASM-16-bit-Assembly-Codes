;              COAL PROJECT - GRAND PRIX CIRCUIT GAME IMPLEMENTATION
; MEMBERS:  SYED MUHAMMAD ANAS NAUMAN    21L-5230 
;           SAAD ASIF                    21L-7532  
; SECTION:  3-B          
[org 0x0100]
jmp start
     CarName: db ' BLOOD HUNTER ',0
        Fire: db 'FIRE',0
    Ignition: db ' IGN ',0
        Fuel: db ' FUEL',0
    OnButton: db 'On',0
   OffButton: db 'Off',0
       Speed: db 'SPEED',0
        Gear: db 'GEAR',0
         Rpm: db 'RPM',0
  SpeedMeter: dw 0
   GearMeter: dw 0
    RpmMeter: dw 0
    OldKbISR: dd 0
 DataSegment: dw 0
  CarCrashed: db ' CAR CRASHED. RESETTING CAR ON TRACK ',0
    isRouteA: db 1
    isRouteB: db 0
    isRouteC: db 0
    isRouteD: db 0
    lengthAC: db 15
    lengthBD: db 27
  multipleAC: db 5
  multipleBD: db 3
    noOfLaps: db 3
   lencvrdAC: db 0
   lencvrdBD: db 0
  isMultiple: db 0
   isCrashed: db 0
 RaceFinised: db 0
 CarPosMapRA: dw 642
 CarPosMapRB: dw 162
 CarPosMapRC: dw 340
 CarPosMapRD: dw 820
     Seconds: db 0
     Minutes: db 0
   TickCount: db 0
 oldTimerISR: dd 0
    isRouteS: db 0
 isForwardRS: db 0
 isReverseRS: db 0
     lengthS: db 12
    lengthBS: db 21
    lengthDS: db 6
   multipleS: db 4
    lencvrdS: db 0
CarPosMapRSf: dw 176
CarPosMapRSr: dw 656
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
  RaceEndMsg: db ' END OF QUALIFYING ROUND ',0
   FetchData: db ' Fetching Data ...',0
  CalcResult: db ' Calculating Results ...',0 
 PrintResult: db ' Printing',0
   SaveMapR1: dw 0,0,0,0,0,0,0,0,0,0,0,0
   SaveMapR2: dw 0,0,0,0,0,0,0,0,0,0,0,0
   SaveMapR3: dw 0,0,0,0,0,0,0,0,0,0,0,0
   SaveMapR4: dw 0,0,0,0,0,0,0,0,0,0,0,0
   SaveMapR5: dw 0,0,0,0,0,0,0,0,0,0,0,0
   StartRace: db ' STARTING QUALIFYING ROUND ',0
   LoadTrack: db ' LOADING TRACK ... ',0
      SetCar: db ' SETTING CAR ON TRACK ...',0
    GetReady: db ' GET READY',0
   Refueling: db ' REFUELING CAR ...',0
    IgnSwtch: db ' IGNITION SWITCH ',0
     swtchOn: db ' ON',0
EnterToStart: db 'Press Enter Key To Start!',0
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;         CLEAR SCREEN        ;
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       PRINTING STRINGS      ;
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       PRINTING DIGITS       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
prntdgt:
       push bp
       mov  bp,sp
       push es
       push ax
       push bx
       push cx
       push dx
       push di

       mov ax,0xb800
       mov es,ax

       mov ax,[bp+4]         ; load ax with the decimal number
       mov bx,10             ; load the base system (10 for decimal number system)
       mov cx,0              ; initialize digit counter

nxtdgt:
       mov  dx,0             ; reset dx to 0
       div  bx               ; perform division to its base
       add  dl,0x30          ; convert digit to its ascii
       push dx               ; store digit on stack
       inc  cx               ; increment digit count
       cmp  ax,0             ; check if ax is empty
       jnz  nxtdgt           ; repeat until ax is empty
         
        cmp  cx,1            ; check if 1 digit is present or not
        jne  below1          ; check if greater number of digits than 1
        mov  dx,0x0030       ; load dx with digit 0
        push dx              ; push the digit on stack
        inc  cx              ; increment digit count

below1: cmp cx,2             ; check if 2 digits present or not
        jne  below2          ; check if greater number of digits than 2
        mov  dx,0x0030       ; load dx with digit 0
        push dx              ; push the digit on stack
        inc  cx              ; increment digit count


below2:
         mov di,[bp+6]       ; load location to print digit at

nxtpos:
       pop dx                ; restore the digit
       mov dh,byte[bp+8]     ; load attribute byte              
       mov [es:di],dx        ; print digit on desired location
       add di,2              ; update di to point to next location
       loop nxtpos           ; repeat until all digits are printed

       pop di
       pop dx
       pop cx
       pop bx
       pop ax
       pop es
       pop bp
       
       ret 6
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;        PRINTING SKY         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
prntsky:
       push es
       push ax
       push cx
       push di

       mov ax,0xb800
       mov es,ax
       xor di,di         ; move di to location 0
       mov ax,0x0bdb     ; color character with cyan foreground and black background
       mov cx,560        ; COLOR FIRST 7 ROWS (80 * 7 = 560)
 
       cld               ; auto increment method 
       rep stosw         ; repeat until  cx turns zero
     
       pop di
       pop cx
       pop ax
       pop es

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PRINTING REAR VIEW MIRROR SKY;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
RMsky:
       push es
       push ax
       push cx
       push di
     
      mov ax,0xb800
      mov es,ax

     mov di,3040               ; point di to starting location
     mov cx,3                  ; number of rows to color
     mov ax,0x0bdb             ; cyan color attribute

loopRMsky:
     push di                   ; store di for later use
     push cx                   ; store cx for later use
     mov cx,16                 ; number of columns to color
     rep stosw                 ; color the desired columns
     pop cx                    ; restore cx
     pop di                    ; restore di
     add di,160                ; update di
     sub cx,1                  ; decrement rows counter
     cmp cx,0                  ; check if all rows colored
     jnz loopRMsky             ; keep coloring if false

       pop di
       pop cx
       pop ax
       pop es

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     PRINTING MOUNTAINS      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
mts:
       push bp
       mov bp,sp
       push es
       push ax
       push cx
       push di
       push bx

       mov ax,0xb800
       mov es,ax

       cld             ; auto increment method

       mov di,[bp+4]   ; load di location
       mov ax,[bp+6]   ; load attribute in ax
       mov cx,[bp+8]   ; load number of columns to color
       mov bx,[bp+10]  ; load number of rows to color

loopMts:
     push di           ; store di for later use
     push cx           ; store cx for later use
     rep stosw         ; color desired number of columns
     pop cx            ; restore cx
     sub cx,2          ; decrement cx by 2
     pop di            ; restore di
     sub di,158        ; update di accordingly
     dec bx            ; decrement bx
     cmp bx,0          ; check if all rows colored
     jnz loopMts       ; keep coloring if false

       pop bx
       pop di
       pop cx
       pop ax
       pop es
       pop bp

       ret 8
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    PRINTING BACKGROUND A    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
prntbgA:
       push es
       push ax
       push cx
       push di

       mov ax,0xb800
       mov es,ax

       cld               ; auto increment method

       call prntsky      ; FUNCTION CALL:  PRINTING SKY

       mov di, 360       ; point di to location 
       mov ax,0x50fe     ; magenta background on black foreground
       mov cx,40         ; number of columns to color
       rep stosw         ; color desired number of columns
    
       mov ax,0x70ea     ; white background on black foreground
       mov di, 520       ; move di to location 
       mov cx,40         ; number of columns to color
       rep stosw         ; color desired number of columns

       mov di, 680       ; point di to location 
       mov ax,0x50fe     ; magenta background on black foreground
       mov cx,40         ; number of columns to color
       rep stosw         ; color desired number of columns

       mov di, 660       ; point di to location 
       mov ax,0x50fe     ; grey background on black foreground
       mov cx,2          ; number of columns to color
       rep stosw         ; color the desired columns

       mov di, 776       ; move di to location 
       mov ax,0x50fe     ; grey background on black foreground
       mov cx,2          ; number of columns to color
       rep stosw         ; color the desired columns
    
       mov ax,0x70ea     ; white backround on black foreground
       mov di, 822       ; point di to location 
       mov cx,58         ; number of columns to color
       rep stosw         ; color desired number of columns    

       mov ax,0x50fe     ; magenta background on black foreground
       mov di, 980       ; move di to location 
       mov cx,60         ; number of columns to color
       rep stosw         ; color desired number of columns

       mov ax,0x50fe      ; magenta background on black foreground
       mov [es:200],ax    ; print the attribute
       mov [es:202],ax    ; print the attribute
       mov [es:220],ax    ; print the attribute
       mov [es:222],ax    ; print the attribute
       mov [es:238],ax    ; print the attribute
       mov [es:240],ax    ; print the attribute
       mov [es:258],ax    ; print the attribute
       mov [es:260],ax    ; print the attribute
       mov [es:276],ax    ; print the attribute
       mov [es:278],ax    ; print the attribute
       mov [es:520],ax    ; print the attribute
       mov [es:598],ax    ; print the attribute
       mov [es:660],ax    ; print the attribute
       mov [es:662],ax    ; print the attribute
       mov [es:670],ax    ; print the attribute
       mov [es:672],ax    ; print the attribute
       mov [es:766],ax    ; print the attribute
       mov [es:768],ax    ; print the attribute
       mov [es:820],ax    ; print the attribute
       mov [es:938],ax    ; print the attribute

     call RMsky                ; FUNCTION CALL:  PRINTING REAR VIEW MIRROR SKY

     mov di,3200               ; point di to starting location
     mov ax,0x0fdb             ; white color attribute
     mov cx,2                  ; number of columns to color
    
loopbdg1:
     push di                   ; store di for later use
     push cx                   ; store cx for later use
     mov cx,4                  ; number of columns to color
     rep stosw                 ; color the desired number of columns
     pop cx                    ; restore cx
     pop di                    ; restore di
     add di,160                ; update di
     sub cx,1                  ; decrement rows count
     cmp cx,0                  ; check if all rows colored
     jnz loopbdg1              ; keep coloring if false

     mov di,3210               ; point di to starting location
     mov ax,0x01db             ; blue color attribute
     mov cx,2                  ; number of columns to color
    
loopbdg2:
     push di                   ; store di for later use
     push cx                   ; store cx for later use
     mov cx,4                  ; number of columns to color
     rep stosw                 ; color the desired number of columns
     pop cx                    ; restore cx
     pop di                    ; restore di
     add di,160                ; update di
     sub cx,1                  ; decrement rows count
     cmp cx,0                  ; check if all rows colored
     jnz loopbdg2              ; keep coloring if false

     mov di,3220               ; point di to starting location
     mov ax,0x06db             ; brown color attribute
     mov cx,2                  ; number of columns to color
    
loopbdg3:
     push di                   ; store di for later use
     push cx                   ; store cx for later use
     mov cx,4                  ; number of columns to color
     rep stosw                 ; color the desired number of columns
     pop cx                    ; restore cx
     pop di                    ; restore di
     add di,160                ; update di
     sub cx,1                  ; decrement rows count
     cmp cx,0                  ; check if all rows colored
     jnz loopbdg3              ; keep coloring if false

       pop di
       pop cx
       pop ax
       pop es

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    PRINTING BACKGROUND B    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
prntbgB:
       push es
       push ax
       push cx
       push di

       mov ax,0xb800
       mov es,ax

       cld               ; auto increment method

       call prntsky      ; FUNCTION CALL:  PRINTING SKY

       mov di,974        ; point di to location
       mov cx,7          ; number of mountains to print

prntMt:
     mov ax,7            ; number of rows to color
     push ax             ; push value on stack
     mov ax,13           ; number of columns to color
     push ax             ; push value on stack
     mov ax,0x62f0       ; attribute and character
     push ax             ; push value on stack
     push di             ; push the di value on stack
     call mts            ; FUNCTION CALL:  PRINTING MOUNTAINS
     add di,20           ; update di accordingly 
     loop prntMt         ; keep printing till cx is zero

     call RMsky          ; FUNCTION CALL:  PRINTING REAR VIEW MIRROR SKY

    mov di,3362          ; point di to location
    mov cx,4             ; number of tree barks to print
    mov ax,0x06db        ; brown attribute character

loopBark:
    mov [es:di],ax       ; print attribute on screen
    add di,8             ; update di accordingly
    loop loopBark        ; keep repeating till cx is zero

    mov di,3200          ; point di to  location
    mov ax,0x0adb        ; light green attribute character
    mov cx,16            ; number of columns to color 
    rep stosw            ; color the desired number of columns

    mov di,3042          ; point di to  location
    mov cx,4             ; number of tree tops to print

 loopTreeTop:
    push cx              ; store cx for later use
    mov cx,2             ; number of columns to color
    rep stosw            ; color the desired number of columns
    add di,4             ; update di accordingly
    pop cx               ; restore cx
    loop loopTreeTop     ; keep repeating till cx is zero

       pop di
       pop cx
       pop ax
       pop es

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    PRINTING BACKGROUND C    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
prntbgC:
       push es
       push ax
       push cx
       push di

       mov ax,0xb800
       mov es,ax

       cld               ; auto increment method

       call prntsky      ; FUNCTION CALL:  PRINTING SKY

       mov ax,0x13c4     ; line attribute on blue background
       mov cx,240        ; number of columns to color
       mov di,640        ; point di to location
       rep stosw         ; color desired number of rows

       mov ax,0x0edb     ; yellow attribute character
       mov di,830        ; point di to location
       mov cx,52         ; number of columns to color
       rep stosw         ; color desired number of rows

       mov di,986        ; point di to location
       mov cx,56         ; number of columns to color
       rep stosw         ; color desired number of rows
      
       xor bx,bx         ; set bx to 0
       mov di,360        ; point di to location
       mov ax,0x06db     ; brown attribute character

tree1:    
       mov cx,2          ; number of columns to color
       add di,156        ; update di accordingly
       rep stosw         ; color desired number of rows
       inc bx            ; increment bx
       cmp bx,3          ; check if desired rows colored
       jne tree1         ; keep coloring if false

       xor bx,bx         ; set bx to 0
       mov di,390        ; point di to location

tree2: 
       mov cx,2          ; number of columns to color
       add di,156        ; update di accordingly
       rep stosw         ; color desired number of rows
       inc bx            ; increment bx
       cmp bx,3          ; check if desired rows colored
       jne tree2         ; keep coloring if false
    
       xor bx,bx         ; set bx to 0
      mov di,420

tree3:
       mov cx,2          ; number of columns to color
       add di,156        ; update di accordingly
       rep stosw         ; color desired number of rows
       inc bx            ; increment bx
       cmp bx,3          ; check if desired rows colored
       jne tree3         ; keep coloring if false


       xor bx,bx         ; set bx to 0
       mov di,450

tree4:
       mov cx,2          ; number of columns to color
       add di,156        ; update di accordingly
       rep stosw         ; color desired number of rows
       inc bx            ; increment bx
       cmp bx,3          ; check if desired rows colored
       jne tree4         ; keep coloring if false


     mov di,36           ; point di to location
     mov ax,0x02db       ; green attribute character
     mov [es:di],ax      ; print attribute on screen
     mov [es:di+2],ax    ; print attribute on screen
     mov [es:di+30],ax   ; print attribute on screen
     mov [es:di+32],ax   ; print attribute on screen
     mov [es:di+60],ax   ; print attribute on screen
     mov [es:di+62],ax   ; print attribute on screen
     mov [es:di+90],ax   ; print attribute on screen
     mov [es:di+92],ax   ; print attribute on screen

        mov cx,6         ; number of columns to color
        mov di,192       ; point di to location
        rep stosw        ; color desired number of columns

        mov cx,6         ; number of columns to color
        mov di,222       ; point di to location
        rep stosw        ; color desired number of columns

        mov cx,6         ; number of columns to color
        mov di,252       ; point di to location
        rep stosw        ; color desired number of columns

        mov cx,6         ; number of columns to color
        mov di,282       ; point di to location
        rep stosw        ; color desired number of columns

        mov cx,10        ; number of columns to color
        mov di,348       ; point di to location
        rep stosw        ; color desired number of columns

        mov cx,10        ; number of columns to color
        mov di,378       ; point di to location
        rep stosw        ; color desired number of columns

        mov cx,10        ; number of columns to color
        mov di,408       ; point di to location
        rep stosw        ; color desired number of columns

        mov cx,10        ; number of columns to color
        mov di,438       ; point di to location
        rep stosw        ; color desired number of columns

        mov cx,14        ; number of columns to color
        mov di,504       ; point di to location
        rep stosw        ; color desired number of columns

        mov cx,14        ; number of columns to color
        mov di,534       ; point di to location
        rep stosw        ; color desired number of columns

        mov cx,14        ; number of columns to color
        mov di,564       ; point di to location
        rep stosw        ; color desired number of columns

        mov cx,14        ; number of columns to color
        mov di,594       ; point di to location
        rep stosw        ; color desired number of columns

     call RMsky          ; FUNCTION CALL:  PRINTING REAR VIEW MIRROR SKY

     mov di,3362         ; point di to location
     mov cx,5            ; number of columns to color
     mov ax,0x62f0       ; green on brown attribute character
     rep stosw           ; color desired number of columns
     sub di,168          ; update di accordingly
     mov cx,3            ; number of columns to color
     rep stosw           ; color desired number of columns
     sub di,164          ; update di accordingly          
     mov cx,1            ; number of columns to color
     rep stosw           ; color desired number of columns

     mov di,3372         ; point di to location
     mov cx,5            ; number of columns to color
     rep stosw           ; color desired number of columns
     sub di,168          ; update di accordingly
     mov cx,3            ; number of columns to color
     rep stosw           ; color desired number of columns
     sub di,164          ; update di accordingly
     mov cx,1            ; number of columns to color
     rep stosw           ; color desired number of columns

     mov di,3382         ; point di to location
     mov cx,5            ; number of columns to color
     rep stosw           ; color desired number of columns
     sub di,168          ; update di accordingly
     mov cx,3            ; number of columns to color
     rep stosw           ; color desired number of columns
     sub di,164          ; update di accordingly
     mov cx,1            ; number of columns to color
     rep stosw           ; color desired number of columns

       pop di
       pop cx
       pop ax
       pop es

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    PRINTING BACKGROUND D    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
prntbgD:
       push es
       push ax
       push cx
       push di
       push bx

       mov ax,0xb800
       mov es,ax

       cld               ; auto increment method

       call prntsky      ; FUNCTION CALL:  PRINTING SKY

       xor bx,bx         ; set bx to 0
       mov di, 22        ; point di to location 
       mov cx,14         ; number of columns to color
       mov ax,0x04db     ; red attribute character

build1:    
       rep stosw         ; color desired number of columns
       add cx,14         ; reset cx to 14
       add di,132        ; update di accordingly
       inc bx            ; increment bx
       cmp bx,7          ; check if desired number of rows colored
       jne build1        ; keep coloring if false
 
       xor bx,bx         ; set bx to 0
       mov di,186        ; point di to location
       mov ax,0x00db     ; black attribute character
  
mirbuild1:
       mov [es:di],ax    ; print mirror
       mov [es:di+6],ax  ; print mirror
       mov [es:di+12],ax ; print mirror
       mov [es:di+18],ax ; print mirrorx
       add di,320        ; update di accordingly
       inc bx            ; increment bx
       cmp bx,3          ; check if rows colored
       jne mirbuild1     ; keep coloring if false
 
       mov di,374        ; point di to location 
       mov cx,10         ; number of columns to color
       xor bx,bx         ; set bx to 0
       mov ax,0x10dd     ; blue attribute character

build2:
       rep stosw         ; color desired number of columns
       add cx,10         ; reset cx to 10
       add di,300        ; update di accordingly
       inc bx            ; increment bx
       cmp bx,3          ; check if all rows colored
       jne build2        ; keep coloring if false

       mov di,534        ; point di to location 
       mov cx,10         ; number of columns to color
       xor bx,bx         ; set bx to 0
       mov ax,0x10de     ; blue attribute character

build21:
       rep stosw         ; color desired number of columns
       add cx,10         ; reset cx to 10
       add di,300        ; update di accordingly
       inc bx            ; increment bx
       cmp bx,2          ; check if all rows colored
       jne build21       ; keep coloring if false

       xor bx,bx         ; set bx to 0
       mov di, 414       ; point di to location 
       mov cx,4          ; number of columns to color
       mov ax,0x06db     ; brown attribute character

build3.1.1:
       rep stosw         ; color desired number of columns
       add cx,4          ; reset cx to 4
       add di,152        ; update di accordingly
       inc bx            ; increment bx
       cmp bx,5          ; check if all rows colored
       jne build3.1.1    ; keep coloring if false

       mov di, 558       ; point di to location 
       mov cx,8          ; number of columns to color
       xor bx,bx         ; set bx to 0
       mov ax,0x6fcd     ; brown attribute character

build31:
       rep stosw         ; color desired number of columns
       add cx,8          ; reset cx to 8
       add di,144        ; update di accordingly
       inc bx            ; increment bx
       cmp bx,4          ; check if all rows colored
       jne build31       ; keep coloring if false


       xor bx,bx         ; set bx to 0
       mov di, 582       ; point di to location 
       mov cx,8          ; number of columns to color
       mov ax,0x6fcd     ; brown attribute character
build32:
       rep stosw         ; color desired number of columns
       add cx,8          ; reset cx to 8
       add di,144        ; update di accordingly
       inc bx            ; increment bx
       cmp bx,4          ; check if all rows colored
       jne build32       ; keep coloring if false

       
       xor bx,bx         ; set bx to 0
       mov di, 416       ; point di to location blue mirrors
       mov cx,2          ; number of columns to color
       mov ax,0x63fe     ; cyan attribute character

build33:
       rep stosw          ; color desired number of columns
       add cx,2           ; reset cx to 2
       add di,156         ; update di accordingly
       inc bx             ; increment bx
       cmp bx,5           ; check if all rows colored
       jne build33        ; keep coloring if false


       mov di,1056        ; point di to location
       mov ax,0x63db      ; cyan attribute character
       mov [es:di],ax     ; print character on screen
       mov [es:di+2],ax   ; print character on screen

       mov di,562         ; point di to location
       mov ax, 0x63cd     ; cyan attribute character
       mov [es:di],ax     ; print character on screen
       mov [es:di+2],ax   ; print character on screen
       mov [es:di+28],ax  ; print character on screen
       mov [es:di+30],ax  ; print character on screen 
       mov [es:di+168],ax ; print character on screen
       mov [es:di+170],ax ; print character on screen
       mov [es:di+182],ax ; print character on screen
       mov [es:di+184],ax ; print character on screen
       mov [es:di+320],ax ; print character on screen
       mov [es:di+322],ax ; print character on screen
       mov [es:di+350],ax ; print character on screen
       mov [es:di+352],ax ; print character on screen

       mov di, 602        ; point di to location 
       mov cx,18          ; number of columns to color
       xor bx,bx          ; set bx to 0

build4:    
       mov ax,0x07db      ; magenta background on black foreground
       rep stosw          ; color desired number of columns
       add cx,18          ; reset cx to 18
       add di,124         ; update di accordingly
       inc bx             ; increment bx
       cmp bx,4           ; check if all rows colored
       jne build4         ; keep coloring if false
 
       xor bx,bx          ; set bx to 0
       mov di, 606        ; point di to location 
       mov ax,0x70ba      ; grey and black attribute character

mirbuild4:
   	mov [es:di],ax    ; print attribute
        mov [es:di+2],ax  ; print attribute
        mov [es:di+6],ax  ; print attribute
	mov [es:di+8],ax  ; print attribute
       	mov [es:di+12],ax ; print attribute
        mov [es:di+14],ax ; print attribute
  	mov [es:di+18],ax ; print attribute
        mov [es:di+20],ax ; print attribute
  	mov [es:di+24],ax ; print attribute
        mov [es:di+26],ax ; print attribute
        add di,160        ; update di accordingly
        inc bx            ; increment bx
        cmp bx,4          ; check if all rows colored
        jne mirbuild4     ; keep coloring if false

       call RMsky         ; FUNCTION CALL:  PRINTING REAR VIEW MIRROR SKY

      
      mov ax,0x132D       ; blue attribute with cyan line character
      mov di,3200         ; point di to location
      mov cx,16           ; number of columns to color
      rep stosw           ; color desired number of columns

      mov di,3360         ; point di to location
      mov cx,16           ; number of columns to color
      rep stosw           ; color desired number of columns

      mov ax,0x1edc       ; blue attribute with yellow bar character
      mov di,3206         ; point di to location  
      mov cx,10           ; number of columns to color
      rep stosw           ; color desired number of columns

      mov ax,0x1edf       ; blue attribute with yellow bar character
      mov di,3366         ; point di to location 
      mov cx,10           ; number of columns to color
      rep stosw           ; color desired number of columns

      mov word[es:3210],0x06db ; print tree bark at location
      mov word[es:3048],0x02db ; print tree leaves
      mov word[es:3050],0x02db ; print tree leaves
      mov word[es:3052],0x02db ; print tree leaves

      mov word[es:3220],0x06db ; print tree bark at location
      mov word[es:3058],0x02db ; print tree leaves
      mov word[es:3060],0x02db ; print tree leaves
      mov word[es:3062],0x02db ; print tree leaves

       pop bx
       pop di
       pop cx
       pop ax
       pop es

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PRINTING BACKGROUND CRASHED ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
prntbgCrash:
       push bp
       mov  bp,sp
       sub  bp,2
       push si
       push es
       push ax
       push bx
       push cx
       push dx
       push di

       mov ax,0xb800
       mov es,ax

       cld

       xor di,di
       mov ax,0x0bdb
       mov cx,560
       rep stosw

       mov di,1120
       mov ax,0x02db
       mov cx,800
       rep stosw

   mov bx,0
   mov di,1280
   mov ax,0x08b2

rocks1.1:	
     inc bx
     mov [es:di],ax
     mov [es:di+2],ax
     mov [es:di+4],ax
     mov [es:di+6],ax
     mov [es:di-160],ax
     mov [es:di-158],ax
     mov [es:di-156],ax
     mov [es:di-154],ax
     add di,20
     cmp bx,8
     jne rocks1.1

   mov bx,0
   mov di,1290
   mov ax,0x08b1

rocks1.2:
     inc bx
     mov [es:di],ax
     mov [es:di+2],ax
     mov [es:di+4],ax
     mov [es:di+6],ax
     mov [es:di-160],ax
     mov [es:di-158],ax
     mov [es:di-156],ax
     mov [es:di-154],ax
     add di,20
     cmp bx,8
     jne rocks1.2


   mov bx,0
   mov di,2560
   mov ax,0x08b2

rocks1.3:	
     inc bx
     mov [es:di],ax
     mov [es:di+2],ax
     mov [es:di+4],ax
     mov [es:di+6],ax
     mov [es:di-160],ax
     mov [es:di-158],ax
     mov [es:di-156],ax
     mov [es:di-154],ax
     add di,20
     cmp bx,8
     jne rocks1.3

   mov bx,0
   mov di,2570
   mov ax,0x08b1

rocks1.4:
     inc bx
     mov [es:di],ax
     mov [es:di+2],ax
     mov [es:di+4],ax
     mov [es:di+6],ax
     mov [es:di-160],ax
     mov [es:di-158],ax
     mov [es:di-156],ax
     mov [es:di-154],ax
     add di,20
     cmp bx,8
     jne rocks1.4

       xor bx,bx 
       mov di,820
       mov ax,0x06db

tree1.1:    
       mov cx,2
       add di,156
       rep stosw
       inc bx
       cmp bx,7
       jne tree1.1

       xor bx,bx
       mov di,686

tree2.2:
       mov cx,2 
       add di,156
       rep stosw
       inc bx
       cmp bx,6
       jne tree2.2

       xor bx,bx
       mov di,872

tree3.3:
       mov cx,2
       add di,156
       rep stosw 
       inc bx
       cmp bx,7
       jne tree3.3

       xor bx,bx
       mov di,898

tree4.4:
       mov cx,2
       add di,156
       rep stosw
       inc bx
       cmp bx,7
       jne tree4.4

       xor bx,bx
       mov di,764

tree5.5:
       mov cx,2
       add di,156
       rep stosw
       inc bx
       cmp bx,7
       jne tree5.5

       xor bx,bx
       mov di,950

tree6.6:
       mov cx,2
       add di,156
       rep stosw
       inc bx
       cmp bx,7
       jne tree6.6

       mov di,336
       mov ax,0x02db
       mov[es:di],ax
       mov[es:di+2],ax
       mov[es:di+52],ax
       mov[es:di+54],ax
       mov[es:di+78],ax
       mov[es:di+80],ax

       mov[es:di+130],ax
       mov[es:di+132],ax

       mov di,494
       mov ax,0x02db
       mov cx,4
       rep stosw

       mov di,546
       mov cx,4
       rep stosw

       mov di,572  
       mov cx,4
       rep stosw

       mov di,624
       mov cx,4
       rep stosw

       mov di,650
       mov cx,8 
       rep stosw

       mov di,702
       mov cx,8
       rep stosw

       mov di,728
       mov cx,8
       rep stosw

       mov di,780
       mov cx,8
       rep stosw

       mov di,806
       mov cx,12
       rep stosw

       mov di,858
       mov cx,12
       rep stosw

       mov di,884
       mov cx,12
       rep stosw

       mov di,936
       mov cx,12
       rep stosw

       mov di,202
       mov ax,0x02db
       mov[es:di],ax
       mov[es:di+2],ax

       mov[es:di+78],ax
       mov[es:di+80],ax

       mov di,360
       mov cx,4
       rep stosw

       mov di,438
       mov cx,4  
       rep stosw
  
       mov di,516
       mov cx,8
       rep stosw

       mov di,594
       mov cx,8
       rep stosw

       mov di,672
       mov cx,12
       rep stosw

       mov di,750
       mov cx,8
       rep stosw

       mov word[bp-2],40
       mov si,70
       mov di,2400


     mov di,2116
     mov ax,0x02b2

     mov [es:di-2],ax
     mov [es:di-4],ax
     mov [es:di],ax
     mov [es:di+2],ax
     mov [es:di+4],ax
     mov [es:di+6],ax
     mov [es:di+8],ax
     mov [es:di+10],ax
     mov [es:di-160],ax
     mov [es:di-158],ax
     mov [es:di-156],ax
     mov [es:di-154],ax

     mov di,2000

     mov [es:di-2],ax
     mov [es:di-4],ax     
     mov [es:di],ax
     mov [es:di+2],ax
     mov [es:di+4],ax
     mov [es:di+6],ax
     mov [es:di+8],ax
     mov [es:di+10],ax
     mov [es:di-160],ax
     mov [es:di-158],ax
     mov [es:di-156],ax
     mov [es:di-154],ax

     mov di,2190

     mov [es:di-2],ax
     mov [es:di-4],ax     
     mov [es:di],ax
     mov [es:di+2],ax
     mov [es:di+4],ax
     mov [es:di+6],ax
     mov [es:di+8],ax
     mov [es:di+10],ax
     mov [es:di-160],ax
     mov [es:di-158],ax
     mov [es:di-156],ax
     mov [es:di-154],ax

     mov di,1890

     mov [es:di-2],ax
     mov [es:di-4],ax     
     mov [es:di],ax
     mov [es:di+2],ax
     mov [es:di+4],ax
     mov [es:di+6],ax
     mov [es:di+8],ax
     mov [es:di+10],ax
     mov [es:di-160],ax
     mov [es:di-158],ax
     mov [es:di-156],ax
     mov [es:di-154],ax

       pop di
       pop dx
       pop cx
       pop bx
       pop ax
       pop es
       pop si
       add bp,2                 ; free local variable space
       pop bp

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PRINTING BOUNDARY SKIRTINGS ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
prntbndskrt:
       push bp
       mov  bp,sp
       sub  sp,2           ; create space for local variable
       push es
       push ax
       push bx
       push cx
       push di

       mov ax,0xb800
       mov es,ax

       cld                 ; auto increment method 

       mov di,1120         ; point to bottom of stadium to print skirtings   
       mov word[bp-2],0    ; initialize local variable to zero
       mov cx,80           ; number of columns to color in the row 
       mov ax,0x4faf       ; load red background with '>>' on white foreground

loopPBS:
        push cx            ; store cx column counter
        mov  cx,2          ; number of columns to color for rep instruction
        rep  stosw         ; color desired columns
        mov  ah,0x4f       ; load red background with '>>' on white foreground
        add  word[bp-2],1  ; increment local variable
        mov  bx,word[bp-2] ; copy the count of local variable in bx
        shr  bx,1          ; check if count is odd
        jnc  endPBS        ; if not odd, print red background skirting
        mov  ah,0x1f       ; load blue background with '>>' on white foreground
endPBS: 
        pop cx             ; restore column count
        sub cx,2           ; decrement cx counter of columns
        cmp cx,0           ; check if row is colored entirely
        jnz loopPBS        ; keep coloring if false

       pop di
       pop cx
       pop bx
       pop ax
       pop es
       add sp,2
       pop bp

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       PRINTING  GRASS        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
prntgrs:    
       push bp
       mov  bp,sp
       sub  sp,2                 ; create space for local variable
       push es
       push ax
       push bx
       push cx
       push dx
       push di

       mov ax,0xb800
       mov es,ax

       cld                       ; auto increment method 

       mov cx,24                 ; number of columns to color
       mov di,1280               ; place di to start of grass print position
       mov word[bp-2],0          ; initialize local variable to zero
       mov ax,0x02db             ; green foreground and black background
       mov bx,9                  ; number of rows to print grass on

loopPGrgt:
       push di                   ; store di for next loop iteration
       push cx                   ; store cx for next loop iteration
       rep stosw                 ; color the desired row green
       pop cx                    ; restore cx value of columns to color
       sub cx,2                  ; subtract by 2 for next iterations color
       pop di                    ; restore dx value of starting point in row
       add di,160                ; add 160 to move to next row (below)
       inc word[bp-2]            ; increment local variable count   
       cmp word[bp-2], bx        ; check if desired rows are colored yet or no 
       jnz loopPGrgt             ; keep coloring if false
 
       mov di,1328         ; update di to correct location
       mov word[bp-2],0    ; initialize local variable
       mov cx,9            ; number of rows to color
       mov ax,0x0cdb       ; load light red foreground attribute
       mov bx,0            ; intialize local variable

loopGbdryrt:
        push cx            ; store cx row counter
        mov  cx,2          ; number of columns to color for rep instruction
        rep  stosw         ; color desired columns
        add  di,152        ; update di position
        mov  ah,0x0c       ; load light red foreground attribute
        add  word[bp-2],1  ; increment local variable
        mov  bx,word[bp-2] ; copy the count of local variable in bx
        shr  bx,1          ; check if count is odd
        jnc  endGbdryrt    ; if not odd, print red background skirting
        mov  ah,0x0f       ; load white foreground attribute
 endGbdryrt:
        pop cx             ; restore column count
        sub cx,1           ; decrement cx counter of columns
        cmp cx,0           ; check if row is colored entirely
        jnz loopGbdryrt    ; keep coloring if false
    
       std                       ; auto decrement method 

       mov cx,24                 ; number of columns to color
       mov di,1438               ; place di to start of grass print position
       mov word[bp-2],0          ; initialize local variable to zero
       mov ax,0x02db             ; green color foreground on black background
       mov bx,9                  ; number of rows to print grass on     

loopPGlft:
       push di                   ; store di for next loop iteration
       push cx                   ; store cx for next loop iteration
       rep stosw                 ; color the desired row green
       pop cx                    ; restore cx value of columns to color
       sub cx,2                  ; subtract by 2 for next iterations color
       pop di                    ; restore dx value of starting point in row
       add di,160                ; add 160 to move to next row (below)
       inc word[bp-2]            ; increment local variable count   
       cmp word[bp-2], bx        ; check if desired rows are colored yet or no 
       jnz loopPGlft             ; keep coloring if false

       mov di,1390         ; update di to correct location
       mov word[bp-2],0    ; initialize local variable
       mov cx,9            ; number of rows to color
       mov ax,0x0fdb       ; load white foreground attribute
       mov bx,0            ; intialize local variable

loopGbdrylt:
        push cx            ; store cx row counter
        mov  cx,2          ; number of columns to color for rep instruction
        rep  stosw         ; color desired columns
        add  di,168        ; update di position
        mov  ah,0x0f       ; load white foreground attribute
        add  word[bp-2],1  ; increment local variable
        mov  bx,word[bp-2] ; copy the count of local variable in bx
        shr  bx,1          ; check if count is odd
        jnc  endGbdrylt    ; if not odd, print red background skirting
        mov  ah,0x0c       ; load light red foreground attribute
 endGbdrylt:
        pop cx             ; restore column count
        sub cx,1           ; decrement cx counter of columns
        cmp cx,0           ; check if row is colored entirely
        jnz loopGbdrylt    ; keep coloring if false

       pop di
       pop dx
       pop cx
       pop bx
       pop ax
       pop es
       add sp,2
       pop bp

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;        PRINTING ROAD         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
prntrd:    
       push bp
       mov  bp,sp
       sub  sp,2                 ; create space for local variable
       push es
       push ax
       push bx 
       push cx
       push dx
       push di
       push si

       mov ax,0xb800
       mov es,ax   
      
       cld                       ; auto increment method 
      
       mov cx,28                 ; number of columns to color
       mov di,1332               ; place di to start of grass print position
       mov word[bp-2],0          ; initialize local variable to zero
       mov ax,0x08db             ; dark grey foreground and black background
       mov bx,9                  ; number of rows to print road on
       
loopPR:
       push di                   ; store di for next loop iteration
       push cx                   ; store cx for next loop iteration
       rep stosw                 ; color the desired row grey
       pop cx                    ; restore cx value of columns to color
       add cx,4                  ; addition by 4 for next iterations color
       pop di                    ; restore dx value of starting point in row
       add di,156                ; add 156 to move to next row (below)
       inc word[bp-2]            ; increment local variable count   
       cmp word[bp-2], bx        ; check if desired rows are colored yet or no 
       jnz loopPR                ; keep coloring if false

       mov ax,0x7fdb   
       mov cx,1                  ; number of columns to color
       mov di,1520               ; place di to start of grass print position
       mov word[bp-2],0          ; initialize local variable to zero
       mov bx,6                  ; put 6 in bx to print 6 white dashes
       mov si,0               

loopline:
       push di                   ; store di for next loop iteration
       push cx                   ; store cx for next loop iteration
       rep stosw                 ; color the desired row grey
       pop cx                    ; restore cx value of columns to color
       pop di                    ; restore dx value of starting point in row
       add di,160                ; add 160 to move to next row (below)
       inc word[bp-2]            ; increment local variable count
       mov dx,word[bp-2]         ; copy the counter in dx 
       shr dx,1                  ; shift right to check if odd or even
       jc loopline2              ; if odd, dont increment di again
       add di,160                ; add 160 in di to print space between lines
       mov word[bp-2],0          ; reset the local variable
loopline2: 
       inc si                    ; si to control the executions of loop
       cmp si, bx                ; check if desired rows are colored yet or no 
       jnz loopline              ; keep printing line

       pop si
       pop di
       pop dx
       pop cx
       pop bx
       pop ax
       pop es
       add sp,2
       pop bp

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   PRINTING CHECKERED FLAG   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
chqrdflg:
       push bp
       mov  bp,sp
       sub  bp,2                    ; create local variable space
       push si
       push es
       push ax
       push bx 
       push cx
       push dx
       push di

       mov ax,0xb800
       mov es,ax   
      
       cld                          ; auto increment method 

       mov word[bp-2],28            ; number of columns to color in first  row
       mov si,58                    ; number of columns to color in second row
       mov di,2424                  ; place di to start of flag print position
    
loopCF:   
        mov ax,0x70db               ; load white foreground color
        mov cx,2                    ; number of columns to color
        rep stosw                   ; color desired number of columns
        mov ax,0x7fdb               ; load black foreground color
        mov cx,2                    ; number of columns to color
        rep stosw                   ; color desired number of columns
        sub word[bp-2],2            ; decrement count of columns to color
        sub si,2                    ; decrement si for count of lower row
        cmp word[bp-2],0            ; check if first row is colored
        jnz loopCF                  ; keep coloring row if false
        mov word[bp-2],si           ; load number of columns to color in second row
        mov di,2580                 ; place di to start of flag print position
        cmp word[bp-2],0            ; check if second row is colored
        jnz loopCF                  ; keep coloring row if false
 
       pop di
       pop dx
       pop cx
       pop bx
       pop ax
       pop es
       pop si
       add bp,2                     ; free local variable space
       pop bp

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      PRINTING DASHBOARD     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
prntdbrd:
       push si
       push es
       push ax
       push bx
       push cx
       push dx
       push di

       mov ax,0xb800
       mov es,ax

       cld                    ; auto increment method
    
       mov di, 2720           ; load di with starting location
       mov ax,0x08db          ; grey foreground on black background
       mov cx,640             ; number of columns to color grey
       rep stosw              ; color the desired columns grey

       mov di, 2720           ; load di with starting location
       mov ax,0x04dd          ; red and black stripe attirbute
       mov cx,24              ; number of columns to color in stripes
       rep stosw              ; color the desired columns
       mov di,2832            ; load di with starting location
       mov cx,24              ; number of columns to color in stripes
       rep stosw              ; color the desired columns

       mov di,2864            ; load di with starting location
       mov cx,8               ; number of columns to color
       rep stosw              ; color the desired columns

       mov di, 2766           ; load di with starting location
       mov ax,0x74dc          ; red and grey attribute
       mov cx,36              ; number of columns to color in stripes
       rep stosw              ; color the desired columns grey

       mov di, 2838           ; load di with starting location 
       mov ax,0x02db          ; green foreground on black background
       mov cx,2               ; number of columns to color 
       rep stosw              ; color the desired columns

       mov di,2998            ; load di with starting location 
       mov ax,0x04db          ; red foreground on black background
       mov cx,2               ; number of columns to color
       rep stosw              ; color desired number of columns

       mov ax,0x01db          ; blue foreground on black background
       mov cx,2               ; number of columns to color
       rep stosw              ; color desired number of columns
   
       mov di,3554            ; load di with starting location  
       mov ax,0x74b2          ; red foreground colored Fire Button
       mov cx,4               ; number of columns to color
       rep stosw              ; color desired number of columns
 
       mov di,3718              ; load di with starting location
       mov ax,0x02db            ; green foreground for button
       mov cx,2                 ; number of columns to color
       rep stosw                ; color desired number of columns
       mov word[es:3878],0x4eae ; print left indicator signal
       mov word[es:3880],0x4eae ; print left indicator signal

       mov di,3802
       mov ax,0x40e0
       mov [es:di+6],ax            
       mov [es:di+8],ax
       mov ax,0xe0e3
       mov [es:di+12],ax    
       mov [es:di+14],ax 
       mov ax,0x90e4
       mov [es:di+18],ax
       mov [es:di+20],ax 
       mov ax,0x509c
       mov [es:di+24],ax
       mov [es:di+26],ax
       mov ax,0x30a8
       mov [es:di+30],ax
       mov [es:di+32],ax

    mov  ax,17                ; load x position         
    push ax                   ; push x position
    mov  ax,21                ; load y position
    push ax                   ; push y position
    mov  ax,0x0007f           ; white on grey attribute
    push ax                   ; push attribute
    mov  ax,Fire              ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov  ax,65                ; load x position
    push ax                   ; push x position
    mov  ax,19                ; load y position
    push ax                   ; push y position
    mov  ax,0x0007f           ; white on grey attribute
    push ax                   ; push attribute
    mov  ax,OffButton         ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov  ax,63                ; load x position         
    push ax                   ; push x position
    mov  ax,20                ; load y position
    push ax                   ; push y position
    mov  ax,0x0007f           ; white on grey attribute
    push ax                   ; push attribute
    mov  ax,OnButton          ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov di,3332
    mov ax,0x0fcd
    mov cx,2
    rep stosw
 
    mov  ax,65                ; load x position         
    push ax                   ; push x position
    mov  ax,21                ; load y position
    push ax                   ; push y position
    mov  ax,0x0004f           ; white on red attribute
    push ax                   ; push attribute
    mov  ax,Ignition          ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov  ax,73                ; load x position
    push ax                   ; push x position
    mov  ax,19                ; load y position
    push ax                   ; push y position
    mov  ax,0x0007f           ; white on grey attribute
    push ax                   ; push attribute
    mov  ax,OffButton         ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov  ax,71                ; load x position         
    push ax                   ; push x position
    mov  ax,20                ; load y position
    push ax                   ; push y position
    mov  ax,0x0007f           ; white on grey attribute
    push ax                   ; push attribute
    mov  ax,OnButton          ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov di,3348
    mov ax,0x0fcd             
    mov cx,2 
    rep stosw

    mov  ax,73                ; load x position         
    push ax                   ; push x position
    mov  ax,21                ; load y position
    push ax                   ; push y position
    mov  ax,0x0004f           ; white on red attribute
    push ax                   ; push attribute
    mov  ax,Fuel              ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov  ax,17                ; load x position
    push ax                   ; push x position
    mov  ax,19                ; load y position
    push ax                   ; push y position
    mov  ax,0x0007f           ; white on grey attribute
    push ax                   ; push attribute
    mov  ax,Gear              ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov  ax,43                ; load x position
    push ax                   ; push x position
    mov  ax,21                ; load y position
    push ax                   ; push y position
    mov  ax,0x0007f           ; white on grey attribute
    push ax                   ; push attribute
    mov  ax,Speed             ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov  ax,33                ; load x position
    push ax                   ; push x position
    mov  ax,21                ; load y position
    push ax                   ; push y position
    mov  ax,0x0007f           ; white on grey attribute
    push ax                   ; push attribute
    mov  ax,Rpm               ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

       pop di
       pop dx
       pop cx
       pop bx
       pop ax
       pop es
       pop si

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  PRINTING REAR VIEW MIRROR  ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
rvmirror:
       push si
       push es
       push ax
       push bx
       push cx
       push dx
       push di

    mov ax,0xb800
    mov es,ax   
     
    cld                        ; auto increment method

    mov di,2880                ; point di to starting location
    mov ax,0x04c4              ; red horizontal line on black background
    mov cx,17                  ; number of columns to color
    rep stosw                  ; color desired columns

    mov ax,0x04b3              ; red vertical line on black background
    mov cx,8                   ; number of rows to color
    add di,158                 ; point di to starting location

loopRMbdry:
    mov word[es:di],ax         ; print rearview mirror boundry on screen
    add di,160                 ; update di
    loop loopRMbdry            ; color until cx is zero

    mov di,3040                ; point di to starting location
    mov cx, 6                  ; number of rows to color
    mov ax,0x08db              ; grey color attribute

loopRMrd: 
     push di                   ; store di for later use
     push cx                   ; store cx for later use
     mov cx,16                 ; number of columns to color
     rep stosw                 ; color desired columns
     pop cx                    ; restore cx
     pop di                    ; restore di
     add di,160                ; update di
     dec cx                    ; decrement row count
     cmp cx,0                  ; check if all rows colored
     jnz loopRMrd              ; keep coloring if false

     mov word[es:3544],0x0fdb  ; print white road line
     mov word[es:3864],0x0fdb  ; print white road line

     mov di,3520               ; point di to starting location
     mov ax,0x02db             ; green color attribute
     mov cx,6                  ; number of columns to color
     mov bx,3                  ; number of rows to color

loopRMgrs:
     push di                   ; store di for later use
     push cx                   ; store cx for later use
     rep stosw                 ; color desired columns
     mov word[es:di],0x0fdb    ; print white boundry of grass
     pop cx                    ; restore cx
     pop di                    ; restore di
     add di,160                ; update di
     sub cx,2                  ; decrement columns to color
     sub bx,1                  ; decrement rows counter
     cmp bx,0                  ; check if all rows colored
     jnz loopRMgrs             ; keep coloring if false

       pop di
       pop dx
       pop cx
       pop bx
       pop ax
       pop es
       pop si

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   PRINTING STEERING WHEEL   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
prntstrwhl:
    push bp
    mov  bp,sp
    sub  sp,2                 ; create local variable space
    push si  
    push es
    push ds
    push ax
    push bx
   
    push cx
   
    push di

    mov ax,0xb800
    mov es,ax 
 
    mov ax,0x00db             ; black attribute of steering wheel
    mov word[bp-2],7          ; number of rows to color
    mov di,2930               ; starting point of di

leftline:                
   mov cx,2                   ; number of columns to color 
   rep stosw                  ; color the desired number of columns
   add di,156                 ; mov di to lower row desired position
   dec word[bp-2]             ; decrement rows counter
   cmp word[bp-2],0           ; check if all rows colored
   jnz leftline               ; keep coloring if false

   mov di,2930                ; starting point of di
   mov cx,30                  ; number of columns to color 
   rep stosw                  ; color the desired number of columns(top line)  
   
   mov word[bp-2],7           ; number of rows to color

rightline: 
   mov cx,2                   ; number of columns to color 
   rep stosw                  ; color the desired number of columns
   add di,156                 ; mov di to lower row desired position
   dec word[bp-2]             ; decrement rows counter
   cmp word[bp-2],0           ; check if all rows colored
   jnz rightline              ; keep coloring if false

   std                        ; auto decrement method

   sub di,160                 ; bring di back in video memory (moved out in last loop)
   mov cx,30                  ; number of columns to color 
   rep stosw                  ; color the desired number of columns(top line) 

   cld                        ; auto increment method

   mov di,3580                ; starting point of di
   mov word[bp-2],3           ; number of rows to color
   mov ax,0x0edb              ; load yellow foreground attribute

strwhlCntr: 
   push di                    ; store di value for later use in loop
   mov cx,22                  ; number of columns to color 
   rep stosw                  ; color the desired number of columns(bottom line)           
   pop di                     ; restore previous di value
   add di,160                 ; point towards lower row
   dec word[bp-2]             ; decrement rows counter
   cmp word[bp-2],0           ; check if all rows colored
   jnz strwhlCntr             ; keep coloring if false

    mov word[es:2960],0x8cdc  ; load red dot on steering wheel

    mov  ax,34                ; load x position
    push ax                   ; push x position
    mov  ax,23                ; load y position
    push ax                   ; push y position
    mov  ax,0x000c            ; red on black attribute
    push ax                   ; push attribute
    mov  ax,CarName           ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov di,3718               ; load di with starting location
    mov ax,0x02db             ; green foreground for button
    mov cx,2                  ; number of columns to color
    rep stosw                 ; color desired number of columns
    mov word[es:3878],0x4eae  ; print left indicator signal
    mov word[es:3880],0x4eae  ; print left indicator signal

    mov di,3802               ; load di with starting location
    mov cx,2                  ; number of columns to color
    rep stosw                 ; color desired number of columns
    mov word[es:3962],0x4eaf  ; print right indicator signal 
    mov word[es:3964],0x4eaf  ; print right indicator signal

    mov di,2720               ; load di with starting location
    mov ax,0xfefe             ; block with blinking yellow attribute
    mov cx,8                  ; number of columns to color
    rep stosw                 ; color the desired columns

    mov di,2864               ; load di with starting location
    mov cx,8                  ; number of columns to color
    rep stosw                 ; color the desired columns

    pop di
    pop cx
    pop bx
    pop ax
    pop ds
    pop es
    pop si
    add sp,2                  ; free local variable space
    pop bp

    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   CLEARING STEERING WHEEL   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clrstrwhl:
    push bp
    mov  bp,sp
    sub  sp,2                 ; create local variable space
    push si  
    push es
    push ds
    push ax
    push bx
   
    push cx
   
    push di

    mov ax,0xb800
    mov es,ax 

    cld                       ; auto increment method

    mov ax,0x08db             ; black on black attribute of steering wheel
    mov word[bp-2],7          ; number of rows to color

    mov di,2930               ; starting point of di
    add di,[bp+4]             ; check type of parameter

    push di                   ; store di for later use
    mov cx,32                 ; number of columns to color
    rep stosw                 ; color the desired number of columns
    pop di                    ; restore di value
    add di,160                ; update di accordingly
    mov cx,32                 ; number of columns to color
    rep stosw                 ; color the desired number of columns

    mov di,3250               ; starting point of di
    add di,[bp+4]             ; check type of parameter

    push di                   ; store di for later use
    mov cx,2                  ; number of columns to color
    rep stosw                 ; color the desired number of columns
    pop di                    ; restore di value
    add di,160                ; update di accordingly
    mov cx,2                  ; number of columns to color
    rep stosw                 ; color the desired number of columns

    mov di,3310               ; starting point of di
    add di,[bp+4]             ; check type of parameter        

    push di                   ; store di for later use
    mov cx,2                  ; number of columns to color
    rep stosw                 ; color the desired number of columns
    pop di                    ; restore di value
    add di,160                ; update di accordingly
    mov cx,2                  ; number of columns to color
    rep stosw                 ; color the desired number of columns

    mov di,3570               ; starting point of di
    add di,[bp+4]             ; check type of parameter
    mov word[bp-2],3          ; number of rows to color

clrstrwhlcentr:
   push di                   ; store di for later use
   mov cx,32                 ; number of columns to color
   rep stosw                 ; color the desired number of columns
   pop di                    ; restore di value
   add di,160                ; update di accordingly
   dec word[bp-2]            ; decrement row counter
   cmp word[bp-2],0          ; check if all rows colored
   jnz clrstrwhlcentr        ; keep coloring if false

    pop di
    pop cx
    pop bx
    pop ax
    pop ds
    pop es
    pop si
    add sp,2                  ; free local variable space
    pop bp

    ret 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PRINTING STEERING WHEEL RIGHT;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
strwhlrght:
    push bp
    mov  bp,sp
    sub  sp,2                 ; create local variable space
    push si  
    push es
    push ds
    push ax
    push bx
   
    push cx
   
    push di

    mov ax,0xb800
    mov es,ax 
   
    mov ax,0                  ; parameter of starting point
    push ax                   ; push it on stack
    call clrstrwhl            ; FUNCTION CALL: CLEARING STEERING WHEEL

    mov ax,0x00db             ; black on black attribute of steering wheel
    mov word[bp-2],7          ; number of rows to color
    mov di,2934               ; starting point of di
 
leftline2:                
   mov cx,2                   ; number of columns to color 
   rep stosw                  ; color the desired number of columns
   add di,156                 ; mov di to lower row desired position
   dec word[bp-2]             ; decrement rows counter
   cmp word[bp-2],0           ; check if all rows colored
   jnz leftline2               ; keep coloring if false

   mov di,2934                ; starting point of di
   mov cx,30                  ; number of columns to color 
   rep stosw                  ; color the desired number of columns(top line)  
   
   mov word[bp-2],7           ; number of rows to color

rightline2: 
   mov cx,2                   ; number of columns to color 
   rep stosw                  ; color the desired number of columns
   add di,156                 ; mov di to lower row desired position
   dec word[bp-2]             ; decrement rows counter
   cmp word[bp-2],0           ; check if all rows colored
   jnz rightline2              ; keep coloring if false

   std                        ; auto decrement method

   sub di,160                 ; bring di back in video memory (moved out in last loop)
   mov cx,30                  ; number of columns to color 
   rep stosw                  ; color the desired number of columns(top line) 

   cld                        ; auto increment method
 
   mov di,3584                ; starting point of di
   mov word[bp-2],3           ; number of rows to color
   mov ax,0x0edb              ; load yellow foreground attribute
  
strwhlCntr2: 
   push di                    ; store di value for later use in loop
   mov cx,22                  ; number of columns to color 
   rep stosw                  ; color the desired number of columns(bottom line)           
   pop di                     ; restore previous di value
   add di,160                 ; point towards lower row
   dec word[bp-2]             ; decrement rows counter
   cmp word[bp-2],0           ; check if all rows colored
   jnz strwhlCntr2            ; keep coloring if false

    mov word[es:2964],0x8cdc  ; load red dot on steering wheel

    mov  ax,36                ; load x position
    push ax                   ; push x position
    mov  ax,23                ; load y position
    push ax                   ; push y position
    mov  ax,0x000c            ; red on black attribute
    push ax                   ; push attribute
    mov  ax,CarName           ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING
    
    mov ax,0x0edb             ; yellow attribute character
    mov di,3802               ; load di with starting location
    mov cx,2                  ; number of columns to color
    rep stosw                 ; color desired number of columns
    mov word[es:3962],0xCeaf  ; print BLINKING right indicator signal 
    mov word[es:3964],0xCeaf  ; print BLINKING right indicator signal

    mov di,2720               ; load di with starting location
    mov ax,0x07db             ; block with grey attribute
    mov cx,8                  ; number of columns to color
    rep stosw                 ; color the desired columns

    call movement             ; FUNCTION CALL:  MOVING SCREEN
    call movement             ; FUNCTION CALL:  MOVING SCREEN
    call movement             ; FUNCTION CALL:  MOVING SCREEN
    call movement             ; FUNCTION CALL:  MOVING SCREEN
    call movement             ; FUNCTION CALL:  MOVING SCREEN
    call movement             ; FUNCTION CALL:  MOVING SCREEN
    call movement             ; FUNCTION CALL:  MOVING SCREEN
    call movement             ; FUNCTION CALL:  MOVING SCREEN
    call movement             ; FUNCTION CALL:  MOVING SCREEN
    call movement             ; FUNCTION CALL:  MOVING SCREEN
    call movement             ; FUNCTION CALL:  MOVING SCREEN
    call movement             ; FUNCTION CALL:  MOVING SCREEN

    mov ax,4                  ; parameter of starting point
    push ax                   ; push it on stack
    call clrstrwhl            ; FUNCTION CALL: CLEARING STEERING WHEEL
  
    call prntstrwhl           ; FUNCTION CALL:  PRINTING STEERING WHEEL

    pop di
    pop cx
    pop bx
    pop ax
    pop ds
    pop es
    pop si
    add sp,2                  ; free local variable space
    pop bp

    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PRINTING STEERING WHEEL LEFT ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
strwhllft:
    push bp
    mov  bp,sp
    sub  sp,2                 ; create local variable space
    push si  
    push es
    push ds
    push ax
    push bx
   
    push cx
   
    push di

    mov ax,0xb800
    mov es,ax 
   
    mov ax,0                  ; parameter of starting point
    push ax                   ; push it on stack
    call clrstrwhl            ; FUNCTION CALL: CLEARING STEERING WHEEL

    mov ax,0x00db             ; black on black attribute of steering wheel
    mov word[bp-2],7          ; number of rows to color
    mov di,2926               ; starting point of di
 
leftline3:                
   mov cx,2                   ; number of columns to color 
   rep stosw                  ; color the desired number of columns
   add di,156                 ; mov di to lower row desired position
   dec word[bp-2]             ; decrement rows counter
   cmp word[bp-2],0           ; check if all rows colored
   jnz leftline3               ; keep coloring if false

   mov di,2926                ; starting point of di
   mov cx,30                  ; number of columns to color 
   rep stosw                  ; color the desired number of columns(top line)  
   
   mov word[bp-2],7           ; number of rows to color

rightline3: 
   mov cx,2                   ; number of columns to color 
   rep stosw                  ; color the desired number of columns
   add di,156                 ; mov di to lower row desired position
   dec word[bp-2]             ; decrement rows counter
   cmp word[bp-2],0           ; check if all rows colored
   jnz rightline3              ; keep coloring if false

   std                        ; auto decrement method

   sub di,160                 ; bring di back in video memory (moved out in last loop)
   mov cx,30                  ; number of columns to color 
   rep stosw                  ; color the desired number of columns(top line) 

   cld                        ; auto increment method
 
   mov di,3576                ; starting point of di
   mov word[bp-2],3           ; number of rows to color
   mov ax,0x0edb              ; load yellow foreground attribute
  
strwhlCntr3: 
   push di                    ; store di value for later use in loop
   mov cx,22                  ; number of columns to color 
   rep stosw                  ; color the desired number of columns(bottom line)           
   pop di                     ; restore previous di value
   add di,160                 ; point towards lower row
   dec word[bp-2]             ; decrement rows counter
   cmp word[bp-2],0           ; check if all rows colored
   jnz strwhlCntr3            ; keep coloring if false

   mov word[es:2956],0x8cdc  ; load red dot on steering wheel

    mov  ax,32                ; load x position
    push ax                   ; push x position
    mov  ax,23                ; load y position
    push ax                   ; push y position
    mov  ax,0x000c            ; red on black attribute
    push ax                   ; push attribute
    mov  ax,CarName           ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov ax,0x0edb             ; yellow attribute character
    mov di,3718               ; load di with starting location
    mov cx,2                  ; number of columns to color
    rep stosw                 ; color desired number of columns
    mov word[es:3878],0xCeae  ; print BLINKING left indicator signal
    mov word[es:3880],0xCeae  ; print BLINKING left indicator signal
 
    mov ax,0x07db             ; block with grey attribute
    mov di,2864               ; load di with starting location
    mov cx,8                  ; number of columns to color
    rep stosw                 ; color the desired columns

    call movement             ; FUNCTION CALL:  MOVING SCREEN
    call movement             ; FUNCTION CALL:  MOVING SCREEN
    call movement             ; FUNCTION CALL:  MOVING SCREEN
    call movement             ; FUNCTION CALL:  MOVING SCREEN
    call movement             ; FUNCTION CALL:  MOVING SCREEN
    call movement             ; FUNCTION CALL:  MOVING SCREEN
    call movement             ; FUNCTION CALL:  MOVING SCREEN
    call movement             ; FUNCTION CALL:  MOVING SCREEN
    call movement             ; FUNCTION CALL:  MOVING SCREEN
    call movement             ; FUNCTION CALL:  MOVING SCREEN
    call movement             ; FUNCTION CALL:  MOVING SCREEN
    call movement             ; FUNCTION CALL:  MOVING SCREEN

    mov ax,-4                 ; parameter of starting point
    push ax                   ; push it on stack
    call clrstrwhl            ; FUNCTION CALL: CLEARING STEERING WHEEL
  
    call prntstrwhl           ; FUNCTION CALL:  PRINTING STEERING WHEEL

    pop di
    pop cx
    pop bx
    pop ax
    pop ds
    pop es
    pop si
    add sp,2                  ; free local variable space
    pop bp

    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;        STARTING RACE        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

rcstrt:      
 
    push si
    push es
    push ds
    push ax
    push bx

    push cx

    push di

    mov ax,0xb800
    mov es,ax   

    mov ds,ax

    xor di,di                    ; point di to starting location
    mov ax,0x00db                ; character with black foreground and black background
    mov cx,10                    ; number of columns to color black
    mov bx,6                     ; number of rows to color black

signal:
   push di                       ; store value of di for later use
   rep stosw                     ; color black the desired column
   pop di                        ; restore di value 
   add di,160                    ; point di to lower row
   mov cx,10                     ; restore cx back
   dec bx                        ; one row done, decrement it
   cmp bx,0                      ; check if all desired rows colored black
   jnz signal                    ; keep coloring if false

    mov di,4                     ; point di to desired location
    mov cx,2                     ; number of light blocks to color
    mov ax,0x04db                ; character with red foreground and black background 

redlight: 
    mov [es:di],ax               ; color first  column
    mov [es:di+2],ax             ; color second column
    add di,8                     ; increment di to point to next light block
    loop redlight                ; color two blocks of light

    mov  cx,2
    push cx
    call soundsig1

    call delay
    call delay
    call delay

    mov di,324                   ; point di to desired location
    mov cx,2                     ; number of light blocks to color
    mov ax,0x0edb                ; character with yellow foreground and black background 

yellowlight: 
    mov [es:di],ax               ; color first  column
    mov [es:di+2],ax             ; color second column
    add di,8                     ; increment di to point to next light block
    loop yellowlight             ; color two blocks of light

    mov  cx,2
    push cx
    call soundsig1

    call delay
    call delay
    call delay

    mov di,644                   ; point di to desired location
    mov cx,2                     ; number of light blocks to color
    mov ax,0x02db                ; character with green foreground and black background 

greenlight: 
    mov [es:di],ax               ; color first  column
    mov [es:di+2],ax             ; color second column
    add di,8                     ; increment di to point to next light block
    loop greenlight              ; color two blocks of light

    mov  cx,3
    push cx
    call soundsig1

    call delay                   
    call delay
    call delay

    xor di,di                    ; point di to starting location
    mov ax,0x0bdb                ; character with cyan foreground and black background
    mov cx,10                    ; number of columns to color black
    mov bx,6                     ; number of rows to color black

skyy:                            ; reprinting sky portion to save time
   push di                       ; store value of di for later use
   rep stosw                     ; color black the desired column
   pop di                        ; restore di value 
   add di,160                    ; point di to lower row
   mov cx,10                     ; restore cx back
   dec bx                        ; one row done, decrement it
   cmp bx,0                      ; check if all desired rows colored black
   jnz skyy                      ; keep coloring if false
  
   mov ax,0x08db                 ; dark grey foreground and black background
   mov di,2424                   ; point di to starting location
   mov cx,56                     ; number of columns to color dark grey
   rep stosw                     ; color desired columns grey
  
   call delay
          
    mov cx,7                     ; number of rows to use movs on
    mov di,2480                  ; destination index loaded
    mov si,2320                  ; source index loaded (directly above di)
   
lineMov:
    movsw                        ; execute movs on word data
    sub di,162                   ; update di accordingly to move upwards 
    sub si,162                   ; update si accordingly to move upwards

    call delay 

    dec cx                       ; decrement when movsw executed once
    cmp cx,0                     ; check if all required rows are movsw
    jnz lineMov                  ; keep executing if not false
    
    mov ax,0x08db                ; dark grey foreground and black background
    mov di,2580                  ; point di to starting location
    mov cx,60                    ; number of columns to color dark grey
    rep stosw                    ; color desired columns grey

    mov word[es:1360],0x0fdb     ; color white at top of road
    mov word[es:2640],0x0fdb     ; color white at bottom of road

    pop di
    pop cx
    pop bx
    pop ax
    pop ds
    pop es
    pop si

    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;         SPEED DIALS         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
speeddials:

    push ax

    mov  ax,0x000c            ; load attribute
    push ax                   ; push attribute
    mov  ax,2914              ; load position
    push ax                   ; push position
    push word[cs:GearMeter]   ; push decimal value
    call prntdgt              ; FUNCTION CALL:  PRINTING DIGIT

    mov  ax,0x0003            ; load attribute
    push ax                   ; push attribute
    mov  ax,3288              ; load position
    push ax                   ; push position
    push  word[cs:SpeedMeter] ; push decimal value
    call prntdgt              ; FUNCTION CALL:  PRINTING DIGIT

    mov  ax,0x0003            ; load attribute
    push ax                   ; push attribute
    mov  ax,3266              ; load position
    push ax                   ; push position
    push word[cs:RpmMeter]    ; push decimal value
    call prntdgt              ; FUNCTION CALL:  PRINTING DIGIT

    pop ax

    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;         SAVING MAP          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
savemap:
       push bp
       mov  bp,sp
       push es
       push ax
       push bx
       push cx
       push dx
       push di
       push si
       push ds

       mov ax,0xb800
       mov es,ax

       cld
     
     xor bx,bx
     mov di,160

loopSaveR1:
     mov ax,[es:di+bx]
     mov [cs:SaveMapR1+bx],ax
     add bx,2
     cmp bx,24
     jne loopSaveR1

     xor bx,bx
     add di,160

loopSaveR2:
     mov ax,[es:di+bx]
     mov [cs:SaveMapR2+bx],ax
     add bx,2
     cmp bx,24
     jne loopSaveR2

     xor bx,bx
     add di,160

loopSaveR3:
     mov ax,[es:di+bx]
     mov [cs:SaveMapR3+bx],ax
     add bx,2
     cmp bx,24
     jne loopSaveR3

     xor bx,bx
     add di,160

loopSaveR4:
     mov ax,[es:di+bx]
     mov [cs:SaveMapR4+bx],ax
     add bx,2
     cmp bx,24
     jne loopSaveR4

     xor bx,bx
     add di,160

loopSaveR5:
     mov ax,[es:di+bx]
     mov [cs:SaveMapR5+bx],ax
     add bx,2
     cmp bx,24
     jne loopSaveR5

    pop ds
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop es
    pop bp

    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     PRINTING SAVED MAP      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
prntsavedmap:
       push bp
       mov  bp,sp
       push es
       push ax
       push bx
       push cx
       push dx
       push di
       push si
       push ds

       mov ax,0xb800
       mov es,ax

       cld

     xor bx,bx
     mov di,160

loopprntSaveR1:
     mov ax,[cs:SaveMapR1+bx]
     mov [es:di+bx],ax
     add bx,2
     cmp bx,24
     jne loopprntSaveR1

     xor bx,bx
     add di,160

loopprntSaveR2:
     mov ax,[cs:SaveMapR2+bx]
     mov [es:di+bx],ax
     add bx,2
     cmp bx,24
     jne loopprntSaveR2

     xor bx,bx
     add di,160

loopprntSaveR3:
     mov ax,[cs:SaveMapR3+bx]
     mov [es:di+bx],ax
     add bx,2
     cmp bx,24
     jne loopprntSaveR3

     xor bx,bx
     add di,160

loopprntSaveR4:
     mov ax,[cs:SaveMapR4+bx]
     mov [es:di+bx],ax
     add bx,2
     cmp bx,24
     jne loopprntSaveR4

     xor bx,bx
     add di,160

loopprntSaveR5:
     mov ax,[cs:SaveMapR5+bx]
     mov [es:di+bx],ax
     add bx,2
     cmp bx,24
     jne loopprntSaveR5

    pop ds
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop es
    pop bp

    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;        PRINTING MAP         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
prntmap:
       push es
       push ax
       push cx
       push di
       push bx

      mov ax,0xb800   
      mov es,ax
 
      cld                ; auto increment method

      xor bx,bx          ; set dx to 0
      mov di,160         ; move di to location
      mov ax,0x00db      ; black attribute character
 
loopblck:  
      mov cx,12          ; number of columns to color
      rep stosw          ; color desired number of columns
      add di,136         ; update di accordingly  
      inc bx             ; increment bx
      cmp bx,5           ; check if all rows colored
      jne loopblck       ; keep coloring if false


       mov di,164        ; move di to to location
       mov ax,0x0fcd     ; white attribute character
       mov cx,8          ; number of columns to color
       rep stosw         ; color desired number of columns
 
       xor bx,bx         ; set dx to 0
       mov di,322        ; move di to location
       mov ax,0x0fba     ; white attribute character

loopmapline1:
         mov cx,1         ; number of columns to color
         rep stosw        ; color desired columns
         add di,158       ; update di accordingly
         inc bx           ; increment bx
         cmp bx,3         ; check if all rows colored
         jne loopmapline1 ; keep coloring if false

       mov di,804         ; move di to location
       mov ax,0x0fcd      ; white attribute character
       mov cx,8           ; number of columns to color
       rep stosw          ; color desired columns

       xor bx,bx         ; set dx to 0
       mov di,340        ; move di to location
       mov ax,0x0fba     ; white attribute character

loopmapline2:
         mov cx,1         ; number of columns to color
         rep stosw        ; color desired columns
         add di,158       ; update di accordingly
         inc bx           ; increment bx
         cmp bx,3         ; check if all rows colored
         jne loopmapline2 ; keep coloring if false

    mov di,162            ; move di to location
    mov ax,0x0fc9         ; white attribute character
    mov [es:di],ax        ; print attribute on screen
    mov ax,0x0fbb         ; white attribute character
    mov [es:di+18],ax     ; print attribute on screen
    mov ax,0x0fc8         ; white attribute character
    mov [es:di+640],ax    ; print attribute on screen
    mov ax,0x0fbc         ; white attribute character
    mov [es:di+658],ax    ; print attribute on screen

    mov word[es:176],0x0fcb    ; print attribute on screen
    mov word[es:336],0x0fba    ; print attribute on screen
    mov word[es:496],0x0fba    ; print attribute on screen
    mov word[es:656],0x0fba    ; print attribute on screen
    mov word[es:816],0x0fca    ; print attribute on screen

    mov word[es:642],0x02db ; print starting point of race

       pop bx
       pop di
       pop cx
       pop ax
       pop es

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    PRINTING BACKGROUND S    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
prntbgS:
       push bp
       mov  bp,sp
       sub  sp,2                 ; create space for local variable
       push es
       push ax
       push bx
       push cx
       push dx
       push di
       push si
       push ds

       mov ax,0xb800
       mov es,ax
       mov ds,ax

       cld                       ; auto increment method 

      mov ax,0x0720
      xor di,di
      mov cx,1360
      rep stosw

       mov ax,0x08db             ; dark grey foreground and black background

       mov cx,42                 ; number of columns to color
       mov di,1318               ; place di to start of grass print position
       rep stosw                 ; color desired number of cloumns

       mov cx,46                 ; number of columns to color
       mov di,1474               ; place di to start of grass print position
       rep stosw                 ; color desired number of cloumns

       mov cx,50                 ; number of columns to color
       mov di,1630               ; place di to start of grass print position
       rep stosw                 ; color desired number of cloumns

       mov cx,54                 ; number of columns to color
       mov di,1786               ; place di to start of grass print position
       rep stosw                 ; color desired number of cloumns

       mov cx,58                 ; number of columns to color
       mov di,1942               ; place di to start of grass print position
       rep stosw                 ; color desired number of cloumns

       mov cx,62                 ; number of columns to color
       mov di,2098               ; place di to start of grass print position
       rep stosw                 ; color desired number of cloumns

       mov cx,66                 ; number of columns to color
       mov di,2254               ; place di to start of grass print position
       rep stosw                 ; color desired number of cloumns

       mov cx,70                 ; number of columns to color
       mov di,2410               ; place di to start of grass print position
       rep stosw                 ; color desired number of cloumns

       mov cx,74                 ; number of columns to color
       mov di,2566               ; place di to start of grass print position
       rep stosw                 ; color desired number of cloumns

       mov ax,0x7fdb
       mov cx,1                  ; number of columns to color
       mov di,1520               ; place di to start of grass print position
       mov word[bp-2],0          ; initialize local variable to zero
       mov bx,6                  ; put 6 in bx to print 6 white dashes
       mov si,0

looplineT1:
       push di                   ; store di for next loop iteration
       push cx                   ; store cx for next loop iteration
       rep stosw                 ; color the desired row grey
       pop cx                    ; restore cx value of columns to color
       pop di                    ; restore dx value of starting point in row
       add di,160                ; add 160 to move to next row (below)
       inc word[bp-2]            ; increment local variable count
       mov dx,word[bp-2]         ; copy the counter in dx 
       shr dx,1                  ; shift right to check if odd or even
       jc looplineT2             ; if odd, dont increment di again
       add di,160                ; add 160 in di to print space between lines
       mov word[bp-2],0          ; reset the local variable
looplineT2: 
       inc si                    ; si to control the executions of loop
       cmp si, bx                ; check if desired rows are colored yet or no 
       jnz looplineT1            ; keep printing line

       mov bx,0
       mov di,1314
ysl:
       add bx,1 
       mov ax,0x0edb
       mov [es:di],ax
       mov [es:di+2],ax
       add di,156
       cmp bx,9
       jne ysl

       mov bx,0
       mov di,1402
ysl2:
       add bx,1 
       mov ax,0x0edb
       mov [es:di],ax
       mov [es:di+2],ax
       add di,164
       cmp bx,9
       jne ysl2

    mov di,3040                ; point di to starting location
    mov cx, 6                  ; number of rows to color
    mov ax,0x08db              ; grey color attribute

loopRMrdT1: 
     push di                   ; store di for later use
     push cx                   ; store cx for later use
     mov cx,16                 ; number of columns to color
     rep stosw                 ; color desired columns
     pop cx                    ; restore cx
     pop di                    ; restore di
     add di,160                ; update di
     dec cx                    ; decrement row count
     cmp cx,0                  ; check if all rows colored
     jnz loopRMrdT1            ; keep coloring if false

     mov word[es:3544],0x0fdb  ; print white road line
     mov word[es:3864],0x0fdb  ; print white road line

     mov di,3520               ; point di to starting location
     mov ax,0x00db             ; green color attribute
     mov cx,6                  ; number of columns to color
     mov bx,3                  ; number of rows to color

loopRMT2:
     push di                   ; store di for later use
     push cx                   ; store cx for later use
     rep stosw                 ; color desired columns
     mov word[es:di],0x0edb    ; print white boundry of grass
     pop cx                    ; restore cx
     pop di                    ; restore di
     add di,160                ; update di
     sub cx,2                  ; decrement columns to color
     sub bx,1                  ; decrement rows counter
     cmp bx,0                  ; check if all rows colored
     jnz loopRMT2              ; keep coloring if false

    mov di,3040                ; point di to starting location
    mov cx,16                  ; number of rows to color
    mov ax,0x00db              ; grey color attribute
    rep stosw                  ; color desired columns

    mov di,3200                ; point di to starting location
    mov cx,16                  ; number of rows to color
    mov ax,0x00db              ; grey color attribute
    rep stosw                  ; color desired columns

    mov di,3360                ; point di to starting location
    mov cx,16                  ; number of rows to color
    mov ax,0x00db              ; grey color attribute
    rep stosw                  ; color desired columns

    mov di,3044                ; point di to starting location
    mov cx,14                  ; number of rows to color
    mov ax,0x0fc4              ; grey color attribute
    rep stosw                  ; color desired columns

    mov di,3372                ; point di to starting location
    mov cx,10                  ; number of rows to color
    mov ax,0x0fc4              ; grey color attribute
    rep stosw                  ; color desired columns

    mov di,3372
    mov ax,0x0fda
    mov [es:di],ax
    mov di,3044
    mov ax,0x0fda
    mov [es:di],ax

    mov bx,0
    mov di,3204

trl2:
     add bx,1
     mov ax,0x0fb3
     mov [es:di],ax
     add di,160
     cmp bx,4
     jne trl2

       pop ds
       pop si
       pop di
       pop dx
       pop cx
       pop bx
       pop ax
       pop es
       add sp,2
       pop bp

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    CLEARING SCREEN TUNNEL   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
clrscrnTunnel:
       push es
       push ax
       push cx
       push di
       push bx

       mov ax,0xb800
       mov es,ax

       cld              ; auto increment method

       xor di,di        ; load di to point to top left of screen
       mov ax,0x0720    ; load space character on black background
       mov cx,640       ; number of columns to color
       rep stosw        ; repeat until  cx turns zero

      mov cx,16  
      mov di,1280 
      rep stosw         ; repeat until  cx turns zero

      mov cx,14
      mov di,1440
      rep stosw

      mov cx,12
      mov di,1600
      rep stosw

      mov cx,10
      mov di,1760
      rep stosw
     
      mov cx,8
      mov di,1920
      rep stosw

      mov cx,6
      mov di,2080
      rep stosw

      mov cx,4
      mov di,2240
      rep stosw

      mov cx,3
      mov di,2400
      rep stosw

      mov cx,16  
      mov di, 1406
      rep stosw
  
      mov cx,14
      mov di,1570
      rep stosw

      mov cx,12
      mov di,1734
      rep stosw

      mov cx,10
      mov di,1898
      rep stosw

      mov cx,8
      mov di,2062
      rep stosw

      mov cx,6
      mov di,2226
      rep stosw

      mov cx,4
      mov di,2390
      rep stosw

      mov cx,3
      mov di,2554
      rep stosw

      mov cx,8
      mov di,3214
      rep stosw
  
    mov bx,0
    mov di,3206

 ctrl3:
       add bx,1
       mov ax,0x0720
       mov [es:di],ax
       add di,160
       cmp bx,4
       jne ctrl3

     mov bx,0
     ;mov di,3208
     mov di,3368

ctrl4:
       add bx,1
       mov ax,0x0720
       mov [es:di],ax
       add di,160
       cmp bx,2
       jne ctrl4

     mov bx,0
     ;mov di,3208
     mov di,3370

ctrl5:
       add bx,1
       mov ax,0x0720
       mov [es:di],ax
       add di,160
       cmp bx,2
       jne ctrl5

       pop bx
       pop di
       pop cx
       pop ax
       pop es

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     MOVEMENT ROAD TUNNEL    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
movrdTunnel:    
       push bp
       mov  bp,sp
       sub  sp,2                 ; create space for local variable
       push es
       push ax
       push bx
       push cx
       push dx
       push di
       push si
       push ds

       mov ax,0xb800
       mov es,ax
       mov ds,ax

       cld                       ; auto increment method 

    mov cx,7                     ; number of rows to use movs on
    mov di,2480                  ; destination index loaded
    mov si,2320                  ; source index loaded (directly above di)
    mov ax,[es:di]               ; store the memory location in ax

TunnelroadMov:
    movsw                        ; execute movs on word data
    sub di,162                   ; update di accordingly to move upwards 
    sub si,162                   ; update si accordingly to move upwards
    dec cx                       ; decrement when movsw executed once
    cmp cx,0                     ; check if all required rows are movsw
    jnz TunnelroadMov            ; keep executing if not false
    mov [es:di],ax               ; replace the stored memory location

    mov di,3864                  ; destination index loaded
    mov si,3704                  ; source index loaded (directly above di)
    mov ax,[es:di]               ; store the memory location in ax
    mov cx,2                     ; number of rows to use movs on

TunnelrearmirMov:
    movsw                        ; execute movs on word data
    sub di,162                   ; update di accordingly to move upwards 
    sub si,162                   ; update si accordingly to move upwards
    dec cx                       ; decrement when movsw executed once
    cmp cx,0                     ; check if all required rows are movsw
    jnz TunnelrearmirMov         ; keep executing if not false
    mov [es:di],ax               ; replace the stored memory location

       pop ds
       pop si
       pop di
       pop dx
       pop cx
       pop bx
       pop ax
       pop es
       add sp,2
       pop bp

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PRINTING ROAD TUNNEL TYPE I ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
prntrdTunnel1:    
       push bp
       mov  bp,sp
       sub  sp,2                 ; create space for local variable
       push es
       push ax
       push bx
       push cx
       push dx
       push di
       push si

       mov ax,0xb800
       mov es,ax

       cld                       ; auto increment method 
      
       mov ax,0x0fc4             ; white on black background
       mov cx,42                 ; number of columns to color
       mov di,998                ; place di to start of grass print position
       rep stosw                 ; color desired number of cloumns

       mov ax,0x0fb3
       mov [es:di+76],ax      
       mov [es:di+158],ax  
     
      mov di,998 
      mov ax,0x0fda
      mov [es:di],ax
      mov di,1080 
      mov ax,0x0fbf
      mov [es:di],ax
      
       mov ax,0x0fc4             ; dark grey foreground and black background
       mov cx,50                 ; number of columns to color
       mov di,830                ; place di to start of grass print position
       rep stosw                 ; color desired number of cloumns

      mov bx,0

 tl2:
       add bx,1
       mov ax,0x0fb3
       mov [es:di+60],ax
       mov [es:di+158],ax
       add di,160
       cmp bx,3
       jne tl2

     mov di,830 
     mov ax,0x0fda
     mov [es:di],ax
     mov di,928 
     mov ax,0x0fbf
     mov [es:di],ax
      
      mov ax,0x0fc4             ; dark grey foreground and black background
      mov cx,66                 ; number of columns to color
      mov di,494                ; place di to start of grass print position
      rep stosw                 ; color desired number of cloumns

     mov bx,0

 tl4:
     add bx,1
     mov ax,0x0fb3
     mov [es:di+28],ax
     mov [es:di+158],ax
     add di,160
     cmp bx,9
     jne tl4

      mov di,494 
      mov ax,0x0fda
      mov [es:di],ax
      mov di,624 
      mov ax,0x0fbf
      mov [es:di],ax

      mov ax,0x0fc4             ; dark grey foreground and black background
      mov cx,74                 ; number of columns to color
      mov di,326                ; place di to start of grass print position
      rep stosw                 ; color desired number of cloumns

      mov bx,0
 tl5:
       add bx,1
       mov ax,0x0fb3
       mov [es:di+12],ax
       mov [es:di+158],ax
       add di,160
       cmp bx,12
       jne tl5

      mov di,326 
      mov ax,0x0fda
      mov [es:di],ax
      mov di,472 
      mov ax,0x0fbf
      mov [es:di],ax

       mov ax,0x0fb2            ; dark grey foreground and black background
       mov cx,8                 ; number of columns to color
       mov di,712               ; place di to start of grass print position
       rep stosw

       mov ax,0x0fdc            ; dark grey foreground and black background
       mov cx,4                 ; number of columns to color
       mov di,3214              ; place di to start of grass print position
       rep stosw

   mov bx,0
   mov di,3206

 trl3:
       add bx,1
       mov ax,0x0fb3
       mov [es:di],ax
       add di,160
       cmp bx,4
       jne trl3

       pop si
       pop di
       pop dx
       pop cx
       pop bx
       pop ax
       pop es
       add sp,2
       pop bp

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; PRINTING ROAD TUNNEL TYPE II;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
prntrdTunnel2:    
       push bp
       mov  bp,sp
       sub  sp,2                 ; create space for local variable
       push es
       push ax
       push bx
       push cx
       push dx
       push di
       push si

       mov ax,0xb800
       mov es,ax

       cld                       ; auto increment method 

       mov ax,0x0fc4             ; dark grey foreground and black background
       mov cx,42                 ; number of columns to color
       mov di,998                ; place di to start of grass print position
       rep stosw                 ; color desired number of cloumns

       mov ax,0x0fb3
       mov [es:di+76],ax
       mov [es:di+158],ax

      mov di,998
      mov ax,0x0fda
      mov [es:di],ax
      mov di,1080
      mov ax,0x0fbf
      mov [es:di],ax

       mov ax,0x0fc4             ; dark grey foreground and black background
       mov cx,58                 ; number of columns to color
       mov di,662                ; place di to start of grass print position
       rep stosw                 ; color desired number of cloumns

       mov bx,0

 tl32:
      add bx,1
      mov ax,0x0fb3
      mov [es:di+44],ax
      mov [es:di+158],ax
      add di,160
      cmp bx,6
      jne tl32

     mov di,662 
     mov ax,0x0fda
     mov [es:di],ax
     mov di,776 
     mov ax,0x0fbf
     mov [es:di],ax

       mov ax,0x0fc4             ; dark grey foreground and black background
       mov cx,74                 ; number of columns to color
       mov di,326                ; place di to start of grass print position
       rep stosw                 ; color desired number of cloumns

      mov bx,0

 tl52:
      add bx,1
      mov ax,0x0fb3
      mov [es:di+12],ax
      mov [es:di+158],ax
      add di,160
      cmp bx,12
      jne tl52

     mov di,326 
     mov ax,0x0fda
     mov [es:di],ax
     mov di,472 
     mov ax,0x0fbf
     mov [es:di],ax

       mov ax,0x0fb2            ; dark grey foreground and black background
       mov cx,8                 ; number of columns to color
       mov di,874               ; place di to start of grass print position
       rep stosw

       mov ax,0x0fb2            ; dark grey foreground and black background
       mov cx,8                 ; number of columns to color
       mov di,548               ; place di to start of grass print position
       rep stosw

       mov ax,0x0fdf            ; dark grey foreground and black background
       mov cx,4                 ; number of columns to color
       mov di,3222              ; place di to start of grass print position
       rep stosw  

     mov bx,0
     ;mov di,3208
     mov di,3368 
trl4:
       add bx,1
       mov ax,0x0fb3
       mov [es:di],ax
       add di,160
       cmp bx,2
       jne trl4

       pop si
       pop di
       pop dx
       pop cx
       pop bx
       pop ax
       pop es
       add sp,2
       pop bp

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;PRINTING ROAD TUNNEL TYPE III;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
prntrdTunnel3:    
       push bp
       mov  bp,sp
       sub  sp,2                 ; create space for local variable
       push es
       push ax
       push bx
       push cx
       push dx
       push di
       push si

       mov ax,0xb800
       mov es,ax

       cld                       ; auto increment method 

       mov ax,0x0fc4             ; dark grey foreground and black background
       mov cx,50                 ; number of columns to color
       mov di,830                ; place di to start of grass print position
       rep stosw                 ; color desired number of cloumns

      mov bx,0

 tl23:
      add bx,1
      mov ax,0x0fb3
      mov [es:di+60],ax
      mov [es:di+158],ax
      add di,160
      cmp bx,3
      jne tl23

     mov di,830
     mov ax,0x0fda
     mov [es:di],ax
     mov di,928
     mov ax,0x0fbf
     mov [es:di],ax

       mov ax,0x0fc4             ; dark grey foreground and black background
       mov cx,58                 ; number of columns to color
       mov di,662                ; place di to start of grass print position
       rep stosw                 ; color desired number of cloumns

     mov bx,0

 tl33:
     add bx,1
     mov ax,0x0fb3
     mov [es:di+44],ax
     mov [es:di+158],ax
     add di,160
     cmp bx,6
     jne tl33

     mov di,662 
     mov ax,0x0fda
     mov [es:di],ax
     mov di,776 
     mov ax,0x0fbf
     mov [es:di],ax

       mov ax,0x0fc4             ; dark grey foreground and black background
       mov cx,66                 ; number of columns to color
       mov di,494                ; place di to start of grass print position
       rep stosw                 ; color desired number of cloumns

     mov bx,0

 tl34:
      add bx,1
      mov ax,0x0fb3
      mov [es:di+28],ax
      mov [es:di+158],ax
      add di,160
      cmp bx,9
      jne tl34

     mov di,494 
     mov ax,0x0fda
     mov [es:di],ax
     mov di,624 
     mov ax,0x0fbf
     mov [es:di],ax

       mov ax,0x0fc4             ; dark grey foreground and black background
       mov cx,77                 ; number of columns to color
       mov di,164                ; place di to start of grass print position
       rep stosw                 ; color desired number of cloumns

     mov bx,0
 tl36:
     add bx,1
     mov ax,0x0fb3
     mov [es:di+6],ax
     mov [es:di+158],ax
     add di,160
     cmp bx,14
     jne tl36

     mov di,164 
     mov ax,0x0fda
     mov [es:di],ax
     mov di,316 
     mov ax,0x0fbf
     mov [es:di],ax

       mov ax,0x0fb2             ; dark grey foreground and black background
       mov cx,8                  ; number of columns to color
       mov di,1038               ; place di to start of grass print position
       rep stosw

       mov ax,0x0fb2             ; dark grey foreground and black background
       mov cx,8                  ; number of columns to color
       mov di,388                ; place di to start of grass print position
       rep stosw

     mov bx,0
     ;mov di,3208
     mov di,3370

trl5:
       add bx,1
       mov ax,0x0fb3
       mov [es:di],ax
       add di,160
       cmp bx,2
       jne trl5

       pop si
       pop di
       pop dx
       pop cx
       pop bx
       pop ax
       pop es
       add sp,2
       pop bp

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    MOVING TUNNEL SCREEN     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
movTunnel:
       push bp
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
       mov ds,ax

       cld

    inc word[cs:SpeedMeter]
    call speeddials

     call clrscrnTunnel
     call prntrdTunnel1
     call movrdTunnel
     call prntsavedmap

     mov  cx,0xffff             ; load cx with highest count
loopx0: loop loopx0               ; loop instruction until cx is zero
     mov  cx,0xffff             ; load cx with highest count
loopx1: loop loopx1               ; loop instruction until cx is zero
     mov  cx,0xffff             ; load cx with highest count
loopx2: loop loopx2               ; loop instruction until cx is zero
     mov  cx,0xffff             ; load cx with highest count
loopx3: loop loopx3               ; loop instruction until cx is zero


    call clrscrnTunnel
    call prntrdTunnel2
    call movrdTunnel
    call prntsavedmap

     mov  cx,0xffff             ; load cx with highest count
loopy0: loop loopy0               ; loop instruction until cx is zero
     mov  cx,0xffff             ; load cx with highest count
loopy1: loop loopy1               ; loop instruction until cx is zero
     mov  cx,0xffff             ; load cx with highest count
loopy2: loop loopy2               ; loop instruction until cx is zero
     mov  cx,0xffff             ; load cx with highest count
loopy3: loop loopy3               ; loop instruction until cx is zero


    call clrscrnTunnel  
    call prntrdTunnel3
    call movrdTunnel
    call prntsavedmap

     mov  cx,0xffff             ; load cx with highest count
loopzz0: loop loopzz0             ; loop instruction until cx is zero
     mov  cx,0xffff             ; load cx with highest count
loopzz1: loop loopzz1             ; loop instruction until cx is zero
     mov  cx,0xffff             ; load cx with highest count
loopzz2: loop loopzz2             ; loop instruction until cx is zero
     mov  cx,0xffff             ; load cx with highest count
loopzz3: loop loopzz3             ; loop instruction until cx is zero

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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;        MOVING SCREEN        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
movement:
       push bp
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
       mov ds,ax

    cmp byte[cs:isRouteS],1
    jne movnormal
       call movTunnel
    jmp exitmovement

movnormal:

       mov bx,1                 ; number of cycles to complete

loopMovs:

    inc word[cs:SpeedMeter]
    call speeddials

    cld                          ; auto increment method

    mov cx,7                     ; number of rows to use movs on
    mov di,2480                  ; destination index loaded
    mov si,2320                  ; source index loaded (directly above di)
    mov ax,[es:di]               ; store the memory location in ax

roadMov:
    movsw                        ; execute movs on word data
    sub di,162                   ; update di accordingly to move upwards 
    sub si,162                   ; update si accordingly to move upwards
    dec cx                       ; decrement when movsw executed once
    cmp cx,0                     ; check if all required rows are movsw
    jnz roadMov                  ; keep executing if not false
    mov [es:di],ax               ; replace the stored memory location

    mov di,3864                  ; destination index loaded
    mov si,3704                  ; source index loaded (directly above di)
    mov ax,[es:di]               ; store the memory location in ax               
    mov cx,2                     ; number of rows to use movs on

rearmirMov:
    movsw                        ; execute movs on word data
    sub di,162                   ; update di accordingly to move upwards 
    sub si,162                   ; update si accordingly to move upwards
    dec cx                       ; decrement when movsw executed once
    cmp cx,0                     ; check if all required rows are movsw
    jnz rearmirMov               ; keep executing if not false
    mov [es:di],ax               ; replace the stored memory location

    mov di,2576                  ; destination index loaded
    mov si, 2420                 ; source index loaded (directly above di)
    mov ax,[es:di]               ; store the memory location in ax
    mov cx,8                     ; number of rows to use movs on

bdryrhtMov:
    movsw                        ; execute movs on word data
    movsw                        ; execute movs on word data
    sub di,160                   ; update di accordingly to move upwards 
    sub si,160                   ; update si accordingly to move upwards
    dec cx                       ; decrement when movsw executed once
    cmp cx,0                     ; check if all required rows are movsw
    jnz bdryrhtMov               ; keep executing if not false
    mov [es:di],ax               ; replace the stored memory location
    mov [es:di+2],ax             ; replace the stored memory location

    std                          ; auto decrement method
    mov di,2702                  ; destination index loaded
    mov si, 2538                 ; source index loaded (directly above di)
    mov ax,[es:di]               ; store the memory location in ax
    mov cx,8                     ; number of rows to use movs on
 
bdrylftMov:
    movsw                        ; execute movs on word data
    movsw                        ; execute movs on word data
    sub di,160                   ; update di accordingly to move upwards 
    sub si,160                   ; update si accordingly to move upwards
    dec cx                       ; decrement when movsw executed once
    cmp cx,0                     ; check if all required rows are movsw
    jnz bdrylftMov               ; keep executing if not false
    mov [es:di],ax               ; replace the stored memory location
    mov [es:di-2],ax             ; replace the stored memory location

    call delay

    dec bx                       ; decrement when movement executed once
    cmp bx,0                     ; check number of movs executed
    jnz loopMovs                 ; keep repeating if false

exitmovement:
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      RACE END ANIMATION     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
endanimation:
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
       mov ds,ax

  mov ax,0x0cdb
  mov [es:1388],ax
  mov [es:1390],ax

  mov word[bp-2],1332
  mov word[bp-4],28
  mov bx,8

loopCFE:
   cld
   mov di,word[bp-2] 
   mov cx, word[bp-4]

   push di
   push cx

prntline1:
    mov ax,0x70db
    mov [es:di],ax
    mov [es:di+2],ax
    add di,4
    mov ax,0x7fdb 
    mov [es:di],ax
    mov [es:di+2],ax
    add di,4
    sub cx,4
    cmp cx,0
    jnz prntline1

   pop cx
   pop di

   add di,156
   add cx,4

prntline2:
    mov ax,0x70db
    mov [es:di],ax
    mov [es:di+2],ax
    add di,4
    mov ax,0x7fdb 
    mov [es:di],ax
    mov [es:di+2],ax
    add di,4
    sub cx,4
    cmp cx,0
    jnz prntline2

   add word[bp-2],156 
   add word[bp-4],4

   call delay

    mov cx,0xffff
 loopa: loop loopa
    mov cx,0xffff
 loopb: loop loopb

    call prntrd

    mov di,3864                  ; destination index loaded
    mov si,3704                  ; source index loaded (directly above di)
    mov ax,[es:di]               ; store the memory location in ax               
    mov cx,2                     ; number of rows to use movs on

rearmirMov2:
    movsw                        ; execute movs on word data
    sub di,162                   ; update di accordingly to move upwards 
    sub si,162                   ; update si accordingly to move upwards
    dec cx                       ; decrement when movsw executed once
    cmp cx,0                     ; check if all required rows are movsw
    jnz rearmirMov2              ; keep executing if not false
    mov [es:di],ax               ; replace the stored memory location

    mov di,2576                  ; destination index loaded
    mov si, 2420                 ; source index loaded (directly above di)
    mov ax,[es:di]               ; store the memory location in ax
    mov cx,8                     ; number of rows to use movs on
 
bdryrhtMov2:
    movsw                        ; execute movs on word data
    movsw                        ; execute movs on word data
    sub di,160                   ; update di accordingly to move upwards 
    sub si,160                   ; update si accordingly to move upwards
    dec cx                       ; decrement when movsw executed once
    cmp cx,0                     ; check if all required rows are movsw
    jnz bdryrhtMov2              ; keep executing if not false
    mov [es:di],ax               ; replace the stored memory location
    mov [es:di+2],ax             ; replace the stored memory location

    std                          ; auto decrement method
    mov di,2702                  ; destination index loaded
    mov si, 2538                 ; source index loaded (directly above di)
    mov ax,[es:di]               ; store the memory location in ax
    mov cx,8                     ; number of rows to use movs on
 
bdrylftMov2:
    movsw                        ; execute movs on word data
    movsw                        ; execute movs on word data
    sub di,160                   ; update di accordingly to move upwards 
    sub si,160                   ; update si accordingly to move upwards
    dec cx                       ; decrement when movsw executed once
    cmp cx,0                     ; check if all required rows are movsw
    jnz bdrylftMov2              ; keep executing if not false
    mov [es:di],ax               ; replace the stored memory location
    mov [es:di-2],ax             ; replace the stored memory location

      dec bx
      cmp bx,0
      jnz loopCFE

       pop ds
       pop di
       pop dx
       pop cx
       pop bx
       pop ax
       pop es
       pop si
       add bp,4                  ; free local variable space
       pop bp

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;            DELAY            ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
;    PRINTING BACKGROUNDS     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;   THIS SUBROUTINE IS NOW NULL AND VOID
;   THIS SUBROUTINE WAS DESIGNED SPECIFICALLY FOR PHASE II
;   IT HAS NO FURTHER USE IN PROJECT FROM PHASE III ONWARDS

prntBG:
         push bp
         mov bp,sp
	 push es
	 push ax
	 push bx
	 push cx
	 push dx
	 push di

	 mov ax, 0xb800
	 mov es, ax
         
         cmp word[bp+4],50      
         je bgB
         cmp word[bp+4],100
         je bgC
         cmp word[bp+4],150
         je bgD
         cmp word[bp+4],200
         je bgA
         jmp exitprntBG

bgA:
         mov word[cs:TickCount],0  ; reset TickCount to 0
         call strwhlrght
         call prntbgA              ; FUNCTION CALL:  PRINTING BACKGROUND A
         jmp exitprntBG

bgB:     
         call strwhlrght
         call prntbgB              ; FUNCTION CALL:  PRINTING BACKGROUND B
         jmp exitprntBG

bgC:     
         call strwhlrght
         call prntbgC              ; FUNCTION CALL:  PRINTING BACKGROUND C
         jmp exitprntBG

bgD:     
         call strwhlrght
         call prntbgD              ; FUNCTION CALL:  PRINTING BACKGROUND D
         jmp exitprntBG

exitprntBG:

         call movement             ; FUNCTION CALL:  MOVING SCREEN

         pop di
	 pop dx
         pop cx
	 pop bx
	 pop ax
	 pop es
	 pop bp

	 ret 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;         CAR CRASHED         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
carCrashed:
       push bp
       mov  bp,sp
       push es
       push ax
       push bx
       push cx
       push dx
       push di
       push si
       push ds

       mov ax,0xb800
       mov es,ax
 
       cld

    mov di,2720               ; load di with starting location
    mov ax,0x74fe             ; block with red attribute
    mov cx,8                  ; number of columns to color
    rep stosw                 ; color the desired columns

    mov di,2864               ; load di with starting location
    mov cx,8                  ; number of columns to color
    rep stosw                 ; color the desired columns

    call soundsig2
    call prntbgCrash

    mov  ax,20                ; load x position
    push ax                   ; push x position
    mov  ax,8                 ; load y position
    push ax                   ; push y position
    mov  ax,0x007e            ; yellow on grey attribute
    push ax                   ; push attribute
    mov  ax,CarCrashed        ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    call delay
    call delay
    call delay
    call delay
    call delay
    call delay
    call delay
    call delay
    call delay
    call delay
    call delay
    call delay
    call delay
    call delay
    call delay
    call delay
    call delay
    call delay
    call delay

    mov ax,0xb800
    mov es,ax

    mov di,2720               ; load di with starting location
    mov ax,0xfefe             ; block with blinking yellow attribute
    mov cx,8                  ; number of columns to color
    rep stosw                 ; color the desired columns

    mov di,2864               ; load di with starting location
    mov cx,8                  ; number of columns to color
    rep stosw                 ; color the desired columns

    mov word[cs:CarPosMapRA],642
    mov word[cs:CarPosMapRB],162
    mov word[cs:CarPosMapRC],340
    mov word[cs:CarPosMapRD],820
    mov word[cs:CarPosMapRSf],176
    mov word[cs:CarPosMapRSr],656

    call prntbndskrt          ; FUNCTION CALL:  PRINTING BOUNDARY SKIRTINGS
    call prntgrs              ; FUNCTION CALL:  PRINTING GRASS
    call prntrd               ; FUNCTION CALL:  PRINTING ROAD

     
    mov word[cs:SpeedMeter],0 ; car crasehd, so Speed is zero
    mov word[cs:GearMeter],0  ; speed is zero, so Gear is zero
    call speeddials           ; update speed dials

    xor dx,dx
    mov dl,byte[cs:noOfLaps]

    cmp byte[cs:isRouteA],1
    jne cmpRouteBCrash
        mov byte[cs:isRouteA],0
        mov byte[cs:isRouteB],1
        call prntbgB
        mov word[cs:CarPosMapRB],160
    jmp exitCarCrash

cmpRouteBCrash:
    cmp byte[cs:isRouteB],1
    jne cmpRouteCCrash
        mov byte[cs:isRouteB],0
        mov byte[cs:isRouteC],1
        call prntbgC
        mov word[cs:CarPosMapRC],180
    jmp exitCarCrash

cmpRouteCCrash:
    cmp byte[cs:isRouteC],1
    jne cmpRouteDCrash
        mov byte[cs:isRouteC],0
        mov byte[cs:isRouteD],1
        call prntbgD
        mov word[cs:CarPosMapRD],822
    jmp exitCarCrash

cmpRouteDCrash:
    cmp byte[cs:isRouteD],1
    jne cmpRouteSCrash
        mov byte[cs:isRouteD],0
        mov byte[cs:isRouteA],1
        call prntbgA
        mov word[cs:CarPosMapRA],802
        inc word[cs:RpmMeter]
    jmp exitCarCrash

cmpRouteSCrash:
    cmp byte[cs:isRouteS],1
    jne near exitCarCrash

    cmp byte[cs:isForwardRS],1
    jne cmpRouteSCrash2
        mov byte[cs:isRouteD],1
        mov byte[cs:isRouteS],0
        mov byte[cs:isForwardRS],0
        mov byte[cs:lencvrdS],0
        mov byte[cs:isMultiple],1
        mov byte[cs:lencvrdBD],7
        call prntbndskrt          ; FUNCTION CALL:  PRINTING BOUNDARY SKIRTINGS
        call prntgrs              ; FUNCTION CALL:  PRINTING GRASS
        call prntrd               ; FUNCTION CALL:  PRINTING ROAD
        call rvmirror             ; FUNCTION CALL:  PRINTING REAR VIEW MIRROR
        call prntbgD
        mov word[cs:CarPosMapRD],818
    jmp exitCarCrash

cmpRouteSCrash2:
    cmp byte[cs:isReverseRS],1
    jne cmpRouteSCrash2
        mov byte[cs:isRouteB],1
        mov byte[cs:isRouteS],0
        mov byte[cs:isReverseRS],0
        mov byte[cs:lencvrdS],0
        mov byte[cs:isMultiple],1
        mov byte[cs:lencvrdBD],22
        call prntbndskrt          ; FUNCTION CALL:  PRINTING BOUNDARY SKIRTINGS
        call prntgrs              ; FUNCTION CALL:  PRINTING GRASS
        call prntrd               ; FUNCTION CALL:  PRINTING ROAD
        call rvmirror             ; FUNCTION CALL:  PRINTING REAR VIEW MIRROR
        call prntbgB
        mov word[cs:CarPosMapRB],174
    jmp exitCarCrash

exitCarCrash:
       cmp word[cs:RpmMeter],dx
       jne exitCarCrash2
       mov byte[cs:RaceFinised],1

exitCarCrash2:
       mov byte[cs:isCrashed],0
       call updateCarPos
       add byte[cs:Seconds],10

        pop ds
        pop si
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        pop es
        pop bp

        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    UPDATING CAR POSITION    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
updateCarPos:
       push bp
       mov  bp,sp
       push es
       push ax
       push bx
       push cx
       push dx
       push di
       push si
       push ds

       mov ax,0xb800
       mov es,ax

       call prntmap
       mov ax,0x84db

       cmp byte[cs:isRouteA],1
       jne cmpRouteB
       sub word[cs:CarPosMapRA],160
       mov di,[cs:CarPosMapRA]
       mov [es:di],ax
       jmp exitCarPos

cmpRouteB:
       cmp byte[cs:isRouteB],1
       jne cmpRouteC
       add word[cs:CarPosMapRB],2
       mov di,[cs:CarPosMapRB]
       mov [es:di],ax
       jmp exitCarPos

cmpRouteC:
       cmp byte[cs:isRouteC],1
       jne cmpRouteD
       add word[cs:CarPosMapRC],160
       mov di,[cs:CarPosMapRC]
       mov [es:di],ax
       jmp exitCarPos

cmpRouteD:
       cmp byte[cs:isRouteD],1
       jne cmpRouteS
       sub word[cs:CarPosMapRD],2
       mov di,[cs:CarPosMapRD]
       mov [es:di],ax
       jmp exitCarPos

cmpRouteS:
       cmp byte[cs:isRouteS],1
       jne exitCarPos
      
       cmp byte[cs:isForwardRS],1
       jne cmpRSrev
         add word[cs:CarPosMapRSf],160
         mov di,[cs:CarPosMapRSf]
         mov [es:di],ax
         call savemap
       jmp exitCarPos
cmpRSrev:
       cmp byte[cs:isReverseRS],1
       jne exitCarPos
         sub word[cs:CarPosMapRSr],160
         mov di,[cs:CarPosMapRSr]
         mov [es:di],ax
         call savemap
       jmp exitCarPos

exitCarPos:
        pop ds
        pop si
        pop di
        pop dx
        pop cx
        pop bx
        pop ax
        pop es
        pop bp

        ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    MOVING DOWNWARDS KEY     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
moveDOWN:
       push bp
       mov  bp,sp
       push es
       push ax
       push bx
       push cx
       push dx
       push di
       push si
       push ds

       mov ax,0xb800
       mov es,ax

    cld

    mov word[cs:SpeedMeter],0 ; car stopped, so Speed is zero
    mov word[cs:GearMeter],0  ; speed is zero, so Gear is zero
    call speeddials           ; update speed dials

    mov di,2720               ; load di with starting location
    mov ax,0x74fe             ; block with red attribute
    mov cx,8                  ; number of columns to color
    rep stosw                 ; color the desired columns

    mov di,2864               ; load di with starting location
    mov cx,8                  ; number of columns to color
    rep stosw                 ; color the desired columns

    call delay
    call delay
    call delay
    call delay
    call delay

    mov di,2720               ; load di with starting location
    mov ax,0xfefe             ; block with blinking yellow attribute
    mov cx,8                  ; number of columns to color
    rep stosw                 ; color the desired columns

    mov di,2864               ; load di with starting location
    mov cx,8                  ; number of columns to color
    rep stosw                 ; color the desired columns

    pop ds
    pop si
    pop di
    pop dx
    pop cx
    pop bx
    pop ax
    pop es
    pop bp

    ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;      MOVING UPWARDS KEY     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
moveUP:
       push bp
       mov  bp,sp
       push es
       push ax
       push bx
       push cx
       push dx
       push di
       push si
       push ds

       mov ax,0xb800
       mov es,ax

    xor ax,ax
    xor bx,bx
    xor cx,cx

    mov al,byte[cs:lengthAC]
    mov ah,byte[cs:lengthBD]
    mov bl,byte[cs:multipleAC]
    mov bh,byte[cs:multipleBD]
    mov cl,byte[cs:lengthS]
    mov ch,byte[cs:multipleS]

     cmp byte[cs:isRouteA],1
     je  updateRouteAC
     cmp byte[cs:isRouteC],1
     jne chckRouteBD

updateRouteAC:
         inc byte[cs:lencvrdAC]
         inc byte[cs:isMultiple]

         cmp byte[cs:lencvrdAC],al 
         jbe cmpMultiple1
           mov byte[cs:lencvrdAC],0
           mov byte[cs:isMultiple],0
           mov byte[cs:isCrashed],1
           call carCrashed
           jmp exitMoveUp

    cmpMultiple1:
         cmp byte[cs:isMultiple],bl
         jne near exitMoveUp
         mov byte[cs:isMultiple],0
         call updateCarPos
         jmp exitMoveUp

chckRouteBD:
     cmp byte[cs:isRouteB],1
     je  updateRouteBD
     cmp byte[cs:isRouteD],1
     jne chckRouteS

updateRouteBD:
         inc byte[cs:lencvrdBD]
         inc byte[cs:isMultiple]

         cmp byte[cs:lencvrdBD],ah
         jbe cmpMultiple2
           mov byte[cs:lencvrdBD],0
           mov byte[cs:isMultiple],0
           mov byte[cs:isCrashed],1
           call carCrashed
           jmp exitMoveUp

    cmpMultiple2:
         cmp byte[cs:isMultiple],bh
         jne exitMoveUp
         mov byte[cs:isMultiple],0
         call updateCarPos
         jmp exitMoveUp

chckRouteS:
         inc byte[cs:lencvrdS]
         inc byte[cs:isMultiple]

         cmp byte[cs:lencvrdS],cl
         jbe cmpMultiple3
           mov byte[cs:lencvrdS],0
           mov byte[cs:isMultiple],0
           mov byte[cs:isCrashed],1
           call carCrashed
           jmp exitMoveUp

    cmpMultiple3:
         cmp byte[cs:isMultiple],ch
         jne exitMoveUp
         mov byte[cs:isMultiple],0
         call updateCarPos
         jmp exitMoveUp

exitMoveUp:
          pop ds
          pop si
          pop di
          pop dx
          pop cx
          pop bx
          pop ax
          pop es
          pop bp

          ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       MOVING RIGHT KEY      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
moveRIGHT:
       push bp
       mov  bp,sp
       push es
       push ax
       push bx
       push cx
       push dx
       push di
       push si
       push ds

       mov ax,0xb800
       mov es,ax

    xor ax,ax
    xor bx,bx
    xor dx,dx

    mov al,byte[cs:lengthAC]
    mov ah,byte[cs:lengthBD]
    mov bl,byte[cs:lengthBS]
    mov bh,byte[cs:lengthDS]
    mov cl,byte[cs:lengthS] 
    mov dl,byte[cs:noOfLaps]

    call strwhlrght

    cmp byte[cs:lencvrdBD],bl
    jne chckRouteRSD
    cmp byte[cs:isRouteB],1
    jne near exitMoveRightSound
         mov byte[cs:isRouteB],0
         mov byte[cs:isRouteS],1
         mov byte[cs:isForwardRS],1
         mov byte[cs:lencvrdBD],0
         mov byte[cs:isMultiple],0
         call prntbgS
         call prntmap
         mov di,[cs:CarPosMapRSf]
         mov word[es:di],0x84db
         mov word[cs:CarPosMapRB],162
         call savemap
         inc word[cs:GearMeter]
    jmp exitMoveRight

chckRouteRSD:
    cmp byte[cs:lencvrdBD],bh
    jne cmpRouteAC
    cmp byte[cs:isRouteD],1
    jne near exitMoveRightSound
         mov byte[cs:isRouteD],0
         mov byte[cs:isRouteS],1
         mov byte[cs:isReverseRS],1
         mov byte[cs:lencvrdBD],0
         mov byte[cs:isMultiple],0
         call prntbgS
         call prntmap
         mov di,[cs:CarPosMapRSr]
         mov word[es:di],0x84db
         mov word[cs:CarPosMapRD],820
         call savemap
         inc word[cs:GearMeter]
    jmp exitMoveRight

cmpRouteAC:
    cmp byte[cs:lencvrdAC],al
    jne near cmpRouteBD

    cmp byte[cs:isRouteA],1
    jne chckRouteC
       mov byte[cs:isRouteA],0
       mov byte[cs:isRouteB],1
       mov byte[cs:lencvrdAC],0
       mov byte[cs:isMultiple],0
       call prntbgB
       call prntmap
       mov di,[cs:CarPosMapRB]
       mov word[es:di],0x84db
       mov word[cs:CarPosMapRA],642
       inc word[cs:GearMeter]
    jmp exitMoveRight

chckRouteC:
    cmp byte[cs:isRouteC],1
    jne cmpRouteBD
       mov byte[cs:isRouteC],0
       mov byte[cs:isRouteD],1
       mov byte[cs:lencvrdAC],0
       mov byte[cs:isMultiple],0
       call prntbgD
       call prntmap
       mov di,[cs:CarPosMapRD]
       mov word[es:di],0x84db
       mov word[cs:CarPosMapRC],340
       inc word[cs:GearMeter]
    jmp exitMoveRight

cmpRouteBD:
    cmp byte[cs:lencvrdBD],ah
    jne near checkRouteS

    cmp byte[cs:isRouteB],1
    jne chckRouteD
       mov byte[cs:isRouteB],0
       mov byte[cs:isRouteC],1
       mov byte[cs:lencvrdBD],0
       mov byte[cs:isMultiple],0
       call prntbgC
       call prntmap
       mov di,[cs:CarPosMapRC]
       mov word[es:di],0x84db
       mov word[cs:CarPosMapRB],162
       inc word[cs:GearMeter]
    jmp exitMoveRight
chckRouteD:
    cmp byte[cs:isRouteD],1
    jne checkRouteS
       mov byte[cs:isRouteD],0
       mov byte[cs:isRouteA],1
       mov byte[cs:lencvrdBD],0
       mov byte[cs:isMultiple],0
       inc word[cs:RpmMeter]
       call prntbgA
       call prntmap
       mov di,[cs:CarPosMapRA]
       mov word[es:di],0x84db
       mov word[cs:CarPosMapRD],820
       inc word[cs:GearMeter]
    jmp exitMoveRight

checkRouteS:
     cmp byte[cs:isRouteS],1
     jne near exitMoveRightSound

     cmp byte[cs:lencvrdS],cl
     jne near exitMoveRightSound

     cmp byte[cs:isForwardRS],1
     jne checkisReverse
       mov byte[cs:isRouteD],1
       mov byte[cs:isRouteS],0
       mov byte[cs:isForwardRS],0
       mov byte[cs:lencvrdS],0
       mov byte[cs:isMultiple],1
       inc word[cs:GearMeter]
       mov byte[cs:lencvrdBD],7
       call prntbndskrt          ; FUNCTION CALL:  PRINTING BOUNDARY SKIRTINGS
       call prntgrs              ; FUNCTION CALL:  PRINTING GRASS
       call prntrd               ; FUNCTION CALL:  PRINTING ROAD
       call rvmirror             ; FUNCTION CALL:  PRINTING REAR VIEW MIRROR
       call prntbgD
       call prntmap
       mov word[cs:CarPosMapRD],816
       mov di,[cs:CarPosMapRD]
       mov word[es:di],0x84db
       mov word[cs:CarPosMapRSf],176
       inc word[cs:GearMeter]
     jmp exitMoveRight

checkisReverse:
     cmp byte[cs:isReverseRS],1
     jne exitMoveRightSound
       mov byte[cs:isRouteB],1
       mov byte[cs:isRouteS],0
       mov byte[cs:isReverseRS],0
       mov byte[cs:lencvrdS],0
       mov byte[cs:isMultiple],1
       inc word[cs:GearMeter]
       mov byte[cs:lencvrdBD],22
       call prntbndskrt          ; FUNCTION CALL:  PRINTING BOUNDARY SKIRTINGS
       call prntgrs              ; FUNCTION CALL:  PRINTING GRASS
       call prntrd               ; FUNCTION CALL:  PRINTING ROAD
       call rvmirror             ; FUNCTION CALL:  PRINTING REAR VIEW MIRROR
       call prntbgB
       call prntmap
       mov word[cs:CarPosMapRB],176
       mov di,[cs:CarPosMapRB]
       mov word[es:di],0x84db
       mov word[cs:CarPosMapRSr],656
       inc word[cs:GearMeter]
     jmp exitMoveRight

exitMoveRightSound:

         call soundsig2
         call movement

exitMoveRight:
         cmp word[cs:RpmMeter],dx
         jne exitMoveRight2
         mov byte[cs:RaceFinised],1
exitMoveRight2:
         call speeddials
          pop ds
          pop si
          pop di
          pop dx
          pop cx
          pop bx
          pop ax
          pop es
          pop bp

          ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  ISR: SOUND EFFECT SIGNAL 1 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
soundsig1:
     push bp
     mov  bp,sp
     push ax
     push cx

     mov cx,[bp+4]   ; load number of times to delay sound

     mov al, 0x0b6
     out 0x43, al

     mov ax, 0x1fb4
     out 0x42, al
     mov al, ah
     out 0x42, al

     in al, 0x61
     mov ah,al
     or al, 0x03
     out 0x61, al

loopsndsig1:
     call delay
     loop loopsndsig1

     mov al, ah
     out 0x61, al

     pop cx
     pop ax
     pop bp

     ret 2
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;  ISR: SOUND EFFECT SIGNAL 2 ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
soundsig2:
     push bp
     mov  bp,sp
     push ax
     push cx

     mov cx, 5

loopsndsig2: 
    
     mov al, 0b6h
     out 43h, al

     mov ax, 1fb4h
     out 42h, al
     mov al, ah
     out 42h, al

     in al, 61h
     mov ah,al
     or al, 3h
     out 61h, al
     call delay
     mov al, ah
     out 61h, al

     push cx
     mov cx,0xffff
loopS.1: loop loopS.1
     pop cx

    mov ax, 152fh
    out 42h, al
    mov al, ah
    out 42h, al

    in al, 61h
    mov ah,al
    or al, 3h
    out 61h, al

     push cx
     mov cx,0xffff
loopS.2: loop loopS.2
     pop cx

    mov al, ah
    out 61h, al

     push cx
     mov cx,0xffff
loopS.3: loop loopS.3
     pop cx

    mov ax, 0A97h
    out 42h, al
    mov al, ah
    out 42h, al

    in al, 61h
    mov ah,al
    or al, 3h
    out 61h, al

     push cx
     mov cx,0xffff
loopS.4: loop loopS.4
     pop cx

    mov al, ah
    out 61h, al
 
    loop loopsndsig2

     pop cx
     pop ax
     pop bp
 
     ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;        ISR: KEYBOARD        ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
kbisr:
     push ax
     push es

     mov ax,0xb800
     mov es,ax

    in al,0x60

    cmp byte[cs:RaceFinised],1
    je  nokeymatch

    cmp al,0x48               ; SCAN CODE UpArrow
    jne cmpnxtkey1

    call moveUP

    call movement
    call movement
    add byte[cs:Seconds],1
    jmp keymatched

cmpnxtkey1:
    cmp al,0x50               ; SCAN CODE DownArrow
    jne cmpnxtkey2
    call moveDOWN
    add byte[cs:Seconds],1
    jmp keymatched

cmpnxtkey2:
    cmp al,0x4B               ; SCAN CODE LeftArrow
    jne cmpnxtkey3

    call strwhllft
    call movement
    call soundsig2
    call movement
    add byte[cs:Seconds],2
    jmp keymatched

cmpnxtkey3:
    cmp al,0x4D               ; SCAN CODE RightArrow
    jne nokeymatch

    call moveRIGHT
    add byte[cs:Seconds],2
    jmp keymatched

nokeymatch:
      pop es
      pop ax
      jmp far [cs:OldKbISR]   ; call back the original ISR

keymatched:
    mov al,0x20
    out 0x20,al               ; send EOI to PIC

    pop es
    pop ax

    iret                       ; return from interrupt

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;         ISR: TIMER          ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
     
     cmp word[cs:SpeedMeter],0
     je exitTimer
   
     call movement
     call movement
     sub word[cs:SpeedMeter],2

exitTimer:
     mov al, 0x20
     out 0x20, al

     pop ax

     iret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;        PRINTING CLOCK       ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;    LOADING RESULT SCREEN    ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;   QUALIFYING RESULT SHEET   ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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

      cmp byte[cs:Seconds],60
      jb prntQRSNormal

      sub byte[cs:Seconds],60
      inc byte[cs:Minutes]

prntQRSNormal:
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     LOADING GAME SCREEN     ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
loadinggame:
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

       xor di,di
       mov word[bp-2],80

loopTopR1:
      mov ax,0x0fdb
      mov cx,2
      rep stosw
      mov ax,0x00db
      mov cx,2
      rep stosw
      sub word[bp-2],4
      cmp word[bp-2],0
      jne loopTopR1

       mov word[bp-2],80

loopTopR2:
      mov ax,0x00db
      mov cx,2
      rep stosw
      mov ax,0x0fdb
      mov cx,2
      rep stosw
      sub word[bp-2],4
      cmp word[bp-2],0
      jne loopTopR2

       mov word[bp-2],80

loopTopR3:
      mov ax,0x0fdb
      mov cx,2
      rep stosw
      mov ax,0x00db
      mov cx,2
      rep stosw
      sub word[bp-2],4
      cmp word[bp-2],0
      jne loopTopR3

       mov word[bp-2],80

loopTopR4:
      mov ax,0x00db
      mov cx,2
      rep stosw
      mov ax,0x0fdb
      mov cx,2
      rep stosw
      sub word[bp-2],4
      cmp word[bp-2],0
      jne loopTopR4

    mov  ax,26                ; load x position
    push ax                   ; push x position
    mov  ax,6                 ; load y position
    push ax                   ; push y position
    mov  ax,0x0004            ; red on black attribute
    push ax                   ; push attribute
    mov  ax,StartRace         ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov  ax,32                ; load x position
    push ax                   ; push x position
    mov  ax,9                 ; load y position
    push ax                   ; push y position
    mov  ax,0x000a            ; red on black attribute
    push ax                   ; push attribute
    mov  ax,LoadTrack         ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov ax,0x0720
    mov di,1534
    xor bx,bx

loopLT:
    push di
    mov cx,4
    rep stosw
    pop di
    call delay
    call delay
    mov word[es:di],0x0a2e
    call delay
    call delay
    mov word[es:di+2],0x0a2e
    call delay
    call delay
    mov word[es:di+4],0x0a2e
    call delay
    call delay
    inc bx
    cmp bx,4
    jne loopLT

    mov  ax,29                ; load x position
    push ax                   ; push x position
    mov  ax,12                ; load y position
    push ax                   ; push y position
    mov  ax,0x0006            ; red on black attribute
    push ax                   ; push attribute
    mov  ax,SetCar            ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov ax,0x0720
    mov di,2022
    xor bx,bx

loopSC:
    push di
    mov cx,4
    rep stosw
    pop di
    call delay
    call delay
    mov word[es:di],0x062e
    call delay
    call delay
    mov word[es:di+2],0x062e
    call delay
    call delay
    mov word[es:di+4],0x062e
    call delay
    call delay
    inc bx
    cmp bx,4
    jne loopSC

    mov  ax,34                ; load x position
    push ax                   ; push x position
    mov  ax,22                ; load y position
    push ax                   ; push y position
    mov  ax,0x0087            ; red on black attribute
    push ax                   ; push attribute
    mov  ax,GetReady          ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov  ax,32                ; load x position
    push ax                   ; push x position
    mov  ax,15                ; load y position
    push ax                   ; push y position
    mov  ax,0x000f            ; red on black attribute
    push ax                   ; push attribute
    mov  ax,Refueling         ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov ax,0x0720
    mov di,2494
    xor bx,bx

loopRF:
    push di
    mov cx,4
    rep stosw
    pop di
    call delay
    call delay
    mov word[es:di],0x0f2e
    call delay
    call delay
    mov word[es:di+2],0x0f2e
    call delay
    call delay
    mov word[es:di+4],0x0f2e
    call delay
    call delay
    inc bx
    cmp bx,3
    jne loopRF

    mov  ax,34                ; load x position
    push ax                   ; push x position
    mov  ax,22                ; load y position
    push ax                   ; push y position
    mov  ax,0x008e            ; red on black attribute
    push ax                   ; push attribute
    mov  ax,GetReady          ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov  ax,31                ; load x position
    push ax                   ; push x position
    mov  ax,18                ; load y position
    push ax                   ; push y position
    mov  ax,0x0009            ; red on black attribute
    push ax                   ; push attribute
    mov  ax,IgnSwtch          ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov ax,0x0720
    mov di,2976
    xor bx,bx

    call delay
    call delay
    mov word[es:di],0x092e
    call delay
    call delay
    call delay
    mov word[es:di+2],0x092e
    call delay
    call delay
    call delay
    mov word[es:di+4],0x092e
    call delay
    call delay
    call delay
    call delay
    call delay

    mov  ax,51                ; load x position
    push ax                   ; push x position
    mov  ax,18                ; load y position
    push ax                   ; push y position
    mov  ax,0x0009            ; red on black attribute
    push ax                   ; push attribute
    mov  ax,swtchOn           ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    mov  ax,34                ; load x position
    push ax                   ; push x position
    mov  ax,22                ; load y position
    push ax                   ; push y position
    mov  ax,0x0002            ; red on black attribute
    push ax                   ; push attribute
    mov  ax,GetReady          ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

    call delay
    call delay
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;     PRINTING GAME NAME      ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
prntname:
       push bp
       mov  bp,sp
       sub  sp,2                 ; create space for local variable
       push es
       push ax
       push bx
       push cx
       push dx
       push di
       push si

       mov ax,0xb800
       mov es,ax

       cld              ; auto increment method 

       mov ax,0x04b1
       mov di,172
       mov cx,6
       rep stosw
       mov di,172
       mov [es:di+160],ax
       mov [es:di+162],ax
       mov [es:di+320],ax
       mov [es:di+322],ax
       mov [es:di+480],ax
       mov [es:di+482],ax
       mov [es:di+640],ax
       mov [es:di+642],ax
       add di,640
       mov cx,6
       rep stosw
       sub di,4
       mov [es:di-160],ax
       mov [es:di-158],ax
       mov [es:di-320],ax
       mov [es:di-318],ax
       mov [es:di-322],ax

    mov ax,0x01b0
    mov di,188
    mov cx,6
    rep stosw
    mov di,188
    mov [es:di+160],ax
    mov [es:di+162],ax
    mov [es:di+320],ax
    mov [es:di+322],ax
    mov [es:di+480],ax
    mov [es:di+482],ax
    mov [es:di+640],ax
    mov [es:di+642],ax
    add di,320
    mov cx,6
    rep stosw
    mov [es:di-164],ax
    mov [es:di-162],ax
    sub di,6
    mov [es:di+160],ax
    mov [es:di+162],ax
    mov [es:di+320],ax
    mov [es:di+322],ax
    mov [es:di+324],ax

       mov ax,0x04b1
       mov di,204
       mov cx,6
       rep stosw
       mov [es:di+156],ax
       mov [es:di+158],ax
       mov [es:di+316],ax
       mov [es:di+318],ax
       mov [es:di+476],ax
       mov [es:di+478],ax
       mov [es:di+636],ax
       mov [es:di+638],ax
       sub di,12
       mov [es:di+160],ax
       mov [es:di+162],ax
       mov [es:di+320],ax
       mov [es:di+322],ax
       mov [es:di+480],ax
       mov [es:di+482],ax
       mov [es:di+640],ax
       mov [es:di+642],ax
       add di,320
       mov cx,4
       rep stosw

    mov ax,0x01b0
    mov di,220
    mov cx,2
    rep stosw
    mov di,220
    mov [es:di+160],ax
    mov [es:di+162],ax
    mov [es:di+320],ax
    mov [es:di+322],ax
    mov [es:di+480],ax
    mov [es:di+482],ax
    mov [es:di+640],ax
    mov [es:di+642],ax
    mov di,230
    mov cx,2
    rep stosw
    mov di,230
    mov [es:di+160],ax
    mov [es:di+162],ax
    mov [es:di+320],ax
    mov [es:di+322],ax
    mov [es:di+480],ax
    mov [es:di+482],ax
    mov [es:di+640],ax
    mov [es:di+642],ax
    mov di,220
    mov [es:di+164],ax
    mov [es:di+326],ax
    mov [es:di+488],ax

      mov ax,0x04b1
      mov di,238
      mov cx,5
      rep stosw
      mov di,238
      mov [es:di+160],ax
      mov [es:di+162],ax
      mov [es:di+320],ax
      mov [es:di+322],ax
      mov [es:di+480],ax
      mov [es:di+482],ax
      mov [es:di+640],ax
      mov [es:di+642],ax
      add di,640
      mov cx,5
      rep stosw
      mov [es:di-162],ax
      mov [es:di-322],ax
      mov [es:di-482],ax

     mov ax,0x0fdb

    mov di,256
    mov cx,6
    rep stosw
    mov di,256
    mov [es:di+160],ax
    mov [es:di+162],ax
    mov [es:di+320],ax
    mov [es:di+322],ax
    mov [es:di+480],ax
    mov [es:di+482],ax
    mov [es:di+640],ax
    mov [es:di+642],ax
    add di,320
    mov cx,6
    rep stosw
    mov [es:di-164],ax
    mov [es:di-162],ax

       mov ax,0x0fdb
       mov di,270
       mov cx,6
       rep stosw
       mov di,270
       mov [es:di+160],ax
       mov [es:di+162],ax
       mov [es:di+320],ax
       mov [es:di+322],ax
       mov [es:di+480],ax
       mov [es:di+482],ax
       mov [es:di+640],ax
       mov [es:di+642],ax
       add di,320
       mov cx,6
       rep stosw
       mov [es:di-164],ax
       mov [es:di-162],ax
       sub di,6
       mov [es:di+160],ax
       mov [es:di+162],ax
       mov [es:di+320],ax
       mov [es:di+322],ax
       mov [es:di+324],ax

    mov di,286
    mov cx,6
    rep stosw
    mov di,286
    mov [es:di+164],ax
    mov [es:di+166],ax
    mov [es:di+324],ax
    mov [es:di+326],ax
    mov [es:di+484],ax
    mov [es:di+486],ax
    mov [es:di+644],ax
    mov [es:di+646],ax
    add di,640
    mov cx,6
    rep stosw

       mov di,300
       mov [es:di],ax
       mov [es:di+162],ax
       mov [es:di+324],ax
       mov [es:di+486],ax
       mov [es:di+648],ax
       add di,8
       mov [es:di],ax
       mov [es:di+158],ax
       mov [es:di+316],ax
       mov [es:di+474],ax
       mov [es:di+632],ax

       pop si
       pop di
       pop dx
       pop cx
       pop bx
       pop ax
       pop es
       add sp,2
       pop bp

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;        INTRO SCREEN         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
intro:
       push bp
       mov  bp,sp
       sub  sp,2                 ; create space for local variable
       push es
       push ax
       push bx
       push cx
       push dx
       push di
       push si

      mov ax,0xb800
      mov es,ax

      cld                ; auto increment method

       xor di,di           ; load di to point to top left of screen
       mov ax,0x08db       ; load space character on black background
       mov cx,2000         ; number of columns to color
       rep stosw           ; repeat until  cx turns zero

        mov bx,0
        mov di, 0          ; point di to location 
        mov cx,4           ; number of columns to color

ler:
    add bx,1
    mov ax,0x04db          ; magenta background on black foreground
    rep stosw              ; color desired number of columns
    mov cx,4
    add di,312
    cmp bx,13
    jne ler

        mov bx,0
        mov di, 160       ; point di to location 
        mov cx,4          ; number of columns to color

lew:
      add bx,1
      mov ax,0x0fdb      ; magenta background on black foreground
      rep stosw          ; color desired number of columns
      mov cx,4
      add di,312
      cmp bx,12
      jne lew

        mov bx,0
        mov di, 152      ; point di to location 
        mov cx,4         ; number of columns to color

rer:
     add bx,1
     mov ax,0x04db      ; magenta background on black foreground
     rep stosw          ; color desired number of columns
     mov cx,4
     add di,312
     cmp bx,13
     jne rer

        mov bx,0
        mov di, 312      ; point di to location 
        mov cx,4         ; number of columns to color

rew:
    add bx,1
    mov ax,0x0fdb        ; magenta background on black foreground
    rep stosw            ; color desired number of columns
    mov cx,4
    add di,312
    cmp bx,12
    jne rew      

     mov bx,0
     mov di, 1328       ; point di to location 
     mov cx,2           ; number of columns to color

rs1:
     add bx,1
     mov ax,0x0fdb      ; magenta background on black foreground
     rep stosw          ; color desired number of columns
     mov cx,2
     add di,636
     cmp bx,5
     jne rs1

      mov bx,0
      mov di, 1648      ; point di to location 
      mov cx,2          ; number of columns to color

rs1w:
    add bx,1
    mov ax,0x0edb       ; magenta background on black foreground
    rep stosw           ; color desired number of columns
    mov cx,2
    add di,636
    cmp bx,4
    jne rs1w

       mov bx,0
       mov di, 1384     ; point di to location 
       mov cx,2         ; number of columns to color

rs2:
     add bx,1
     mov ax,0x0fdb      ; magenta background on black foreground
     rep stosw          ; color desired number of columns
     mov cx,2
     add di,636
     cmp bx,5
     jne rs2

     mov bx,0
     mov di, 1704      ; point di to location 
     mov cx,2          ; number of columns to color

rs2w:
     add bx,1
     mov ax,0x0edb     ; magenta background on black foreground
     rep stosw         ; color desired number of columns
     mov cx,2
     add di,636
     cmp bx,4
     jne rs2w

       mov di,1510      ; load di to point to top left of screen
       mov ax,0x10cd    ; load space character on black background
       mov cx,8         ; number of columns to color
       rep stosw        ; repeat until  cx turns zero

  mov di, 1676          ; point di to location 
  mov ax,0x10ba         ; magenta background on black foreground
  mov[es:di],ax
  mov [es:di+2],ax
  mov[es:di+160],ax
  mov [es:di+162],ax
 
 mov ax,0x01db  
 mov[es:di+320],ax
 mov [es:di+322],ax

 mov ax,0x11de
 mov [es:di+318],ax

 mov ax,0x11de
 mov[es:di+324],ax

    mov di,2150          ; point di to location 
    mov cx,8             ; number of columns to color
    mov bx,0

cl11:
       add bx,1
       mov ax,0x01db     ; magenta background on black foreground
       rep stosw         ; color desired number of columns
       add cx,8
       add di,784
       cmp bx,2
       jne cl11

    mov di,2308          ; point di to location 
    mov cx,10            ; number of columns to color
    mov bx,0

cl1:
       add bx,1
       mov ax,0x01db     ; magenta background on black foreground
       rep stosw         ; color desired number of columns
       add cx,10
       add di,140
       cmp bx,4
       jne cl1

  mov ax,0x0bdb
  mov di,2316
  mov[es:di],ax
  mov[es:di+2],ax

    mov ax,0x01db
    mov di,3112         ; point di to location 
    mov cx,6            ; number of columns to color
    mov bx,0
    mov ax,0x01cd       ; magenta background on black foreground

cl111:
       add bx,1
       rep stosw         ; color desired number of columns
       add cx,8
       add di,146
       mov ax,0x10f0     ; magenta background on black foreground
       cmp bx,2
       jne cl111

    mov di,3106
    mov ax,0x00db
    mov [es:di],ax
    mov [es:di-2],ax
    mov [es:di+22],ax
    mov [es:di+24],ax
    mov [es:di+160],ax
    mov [es:di+158],ax
    mov [es:di+182],ax
    mov [es:di+184],ax

    mov di,1826
    mov ax,0x00db
    mov [es:di],ax
    mov [es:di-2],ax
    mov [es:di+22],ax 
    mov [es:di+24],ax   
    mov [es:di+160],ax
    mov [es:di+158],ax 
    mov [es:di+182],ax
    mov [es:di+184],ax

  mov ax,0x08dc
  mov [es:di+162],ax
  mov [es:di+164],ax
  mov [es:di+166],ax
  mov [es:di+176],ax
  mov [es:di+178],ax
  mov [es:di+180],ax

  mov di,3268
  mov [es:di],ax
  mov [es:di+18],ax

     mov di,1780        ; load di to point to top left of screen
     mov ax,0x40cd      ; load space character on black background
     mov cx,8           ; number of columns to color
     rep stosw          ; repeat until  cx turns zero

    mov di, 1946        ; point di to location 
    mov ax,0x40ba       ; magenta background on black foreground
    mov[es:di],ax
    mov [es:di+2],ax
    mov[es:di+160],ax
    mov [es:di+162],ax

    mov ax,0x04db  
    mov[es:di+320],ax
    mov [es:di+322],ax

    mov ax,0x44de
    mov [es:di+318],ax

  mov ax,0x44de
  mov[es:di+324],ax

     mov di,2420        ; point di to location 
     mov cx,8           ; number of columns to color
     mov bx,0

c211:
       add bx,1
       mov ax,0x04db     ; magenta background on black foreground
       rep stosw         ; color desired number of columns
       add cx,8
       add di,784
       cmp bx,2
       jne c211

      mov di,2578        ; point di to location 
      mov cx,10          ; number of columns to color
      mov bx,0

c2l1:
       add bx,1
       mov ax,0x04db     ; magenta background on black foreground
       rep stosw         ; color desired number of columns
       add cx,10
       add di,140
       cmp bx,4
       jne c2l1

  mov ax,0x0bdb
  mov di,2586
  mov[es:di],ax
  mov[es:di+2],ax

   mov di,3382           ; point di to location 
   mov cx,6              ; number of columns to color
   mov bx,0
   mov ax,0x04cd         ; magenta background on black foreground

c2111:
       add bx,1
       rep stosw         ; color desired number of columns
       add cx,8
       add di,146
       mov ax,0x40f0     ; magenta background on black foreground
       cmp bx,2
       jne c2111

    mov di,3376
    mov ax,0x00db
    mov [es:di],ax
    mov [es:di-2],ax
    mov [es:di+22],ax 
    mov [es:di+24],ax   
    mov [es:di+160],ax
    mov [es:di+158],ax 
    mov [es:di+182],ax
    mov [es:di+184],ax

    mov di,2096
    mov ax,0x00db
    mov [es:di],ax
    mov [es:di-2],ax
    mov [es:di+22],ax
    mov [es:di+24],ax
    mov [es:di+160],ax
    mov [es:di+158],ax
    mov [es:di+182],ax
    mov [es:di+184],ax

    mov ax,0x08dc
    mov [es:di+162],ax
    mov [es:di+164],ax
    mov [es:di+166],ax
    mov [es:di+176],ax
    mov [es:di+178],ax
    mov [es:di+180],ax

    mov di,3538
    mov [es:di],ax
    mov [es:di+18],ax

   mov di,2042           ; load di to point to top left of screen
   mov ax,0x20cd         ; load space character on black background
   mov cx,8              ; number of columns to color
   rep stosw             ; repeat until  cx turns zero

   mov di, 2208          ; point di to location 
   mov ax,0x20ba         ; magenta background on black foreground
   mov[es:di],ax
   mov [es:di+2],ax
   mov[es:di+160],ax
   mov [es:di+162],ax

   mov ax,0x02db
   mov[es:di+320],ax
   mov [es:di+322],ax

   mov ax,0x22de
   mov [es:di+318],ax

   mov ax,0x22de
   mov[es:di+324],ax

     mov di,2682          ; point di to location 
     mov cx,8             ; number of columns to color
     mov bx,0

c311:   
       add bx,1
       mov ax,0x02db      ; magenta background on black foreground
       rep stosw          ; color desired number of columns
       add cx,8
       add di,784
       cmp bx,2
       jne c311

     mov di,2840          ; point di to location 
     mov cx,10            ; number of columns to color
     mov bx,0

c33l1:    
       add bx,1
       mov ax,0x02db      ; magenta background on black foreground
       rep stosw          ; color desired number of columns
       add cx,10
       add di,140
       cmp bx,4
       jne c33l1

  mov ax,0x0bdb
  mov di,2848
  mov[es:di],ax
  mov[es:di+2],ax

    mov di,3644           ; point di to location 
    mov cx,6              ; number of columns to color
    mov bx,0              ; intialize bx to 0
    mov ax,0x02cd         ; magenta background on black foreground

c3111:    
       add bx,1
       rep stosw          ; color desired number of columns
       add cx,8
       add di,146
       mov ax,0x20f0      ; magenta background on black foreground
       cmp bx,2
       jne c3111

    mov di,3638
    mov ax,0x00db
    mov [es:di],ax
    mov [es:di-2],ax
    mov [es:di+22],ax 
    mov [es:di+24],ax   
    mov [es:di+160],ax
    mov [es:di+158],ax 
    mov [es:di+182],ax
    mov [es:di+184],ax

    mov di,2358
    mov ax,0x00db
    mov [es:di],ax
    mov [es:di-2],ax
    mov [es:di+22],ax 
    mov [es:di+24],ax   
    mov [es:di+160],ax
    mov [es:di+158],ax 
    mov [es:di+182],ax
    mov [es:di+184],ax

  mov ax,0x08dc
  mov [es:di+162],ax
  mov [es:di+164],ax
  mov [es:di+166],ax
  mov [es:di+176],ax
  mov [es:di+178],ax
  mov [es:di+180],ax

   mov di,3800
   mov [es:di],ax
   mov [es:di+18],ax

call prntname

    mov  ax,27                ; load x position
    push ax                   ; push x position
    mov  ax,24                ; load y position
    push ax                   ; push y position
    mov  ax,0x008f            ; white on black attribute
    push ax                   ; push attribute
    mov  ax,EnterToStart      ; load string address
    push ax                   ; push string address
    call prntstr              ; FUNCTION CALL:  PRINTING STRING

loopEntKey2:
    mov ah,0
    int 0x16
    cmp al,0x0D               ; ASCII of enter Key (NOT Scan Code)
    jne loopEntKey2

    call clrscrn

       pop si
       pop di
       pop dx
       pop cx
       pop bx
       pop ax
       pop es
       add sp,2
       pop bp

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;       MAIN FUNCTION         ;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
start:
      mov  [cs:DataSegment],ds

      call clrscrn              ; FUNCTION CALL:  CLEARING SCREEN

      call intro                ; FUNCTION CALL:  LOADING INTRO SCREEN

      call loadinggame          ; FUNCTION CALL:  LOADING GAME SCREEN

      call clrscrn              ; FUNCTION CALL:  CLEARING SCREEN

      call prntbndskrt          ; FUNCTION CALL:  PRINTING BOUNDARY SKIRTINGS
      call prntgrs              ; FUNCTION CALL:  PRINTING GRASS
      call prntrd               ; FUNCTION CALL:  PRINTING ROAD
      call chqrdflg             ; FUNCTION CALL:  PRINTING CHECKERED FLAG 
      call prntdbrd             ; FUNCTION CALL:  PRINTING DASHBOARD
      call rvmirror             ; FUNCTION CALL:  PRINTING REAR VIEW MIRROR
      call prntbgA              ; FUNCTION CALL:  PRINTING BACKGROUND A
      call prntstrwhl           ; FUNCTION CALL:  PRINTING STEERING WHEEL
      call speeddials           ; FUNCTION CALL:  CAR SPEEDING DIALS
      call rcstrt               ; FUNCTION CALL:  STARTING RACE
      call prntmap              ; FUNCTION CALL:  PRINTING MAP
      call movement             ; FUNCTION CALL:  MOVING SCREEN

      xor ax, ax
      mov es, ax

      mov ax,[es:9*4]          ; get  offset  of oldKbISR
      mov [cs:OldKbISR],ax     ; save offset  of oldKbISR
      mov ax,[es:9*4+2]        ; get  segment of oldKbISR
      mov [cs:OldKbISR+2],ax   ; save segment of oldKbISR

      mov ax,[es:8*4]
      mov [cs:oldTimerISR],ax
      mov ax,[es:8*4+2]
      mov [cs:oldTimerISR+2],ax

      cli
      mov word[es:9*4],kbisr   ; store offset at n*4
      mov [es:9*4+2],cs        ; store segment at n*4+2
      mov word [es:8*4],timer  ; store offset at n*4
      mov [es:8*4+2],cs        ; store segment at n*4+2
      sti                      ; enable interrupts

loopesckey:
      mov ah,0                 ; service 0 - get keystroke
      int 0x16                 ; call BIOS keyboard services
      cmp al,27                ; is the ESC key pressed
      je  exitQualifyRound
      cmp byte[cs:RaceFinised],1
      je  exitQualifyRound
      jne loopesckey

exitQualifyRound:

      mov ax,[cs:OldKbISR]     ; read old offset in ax
      mov bx,[cs:OldKbISR+2]   ; read old segment in bx

      cli                      ; disable interrupts
      mov [es:9*4],ax          ; store offset at n*4
      mov [es:9*4+2],bx        ; store segment at n*4+2
      sti                      ; enable interrupts

    xor ax, ax
    mov es, ax

      mov ax,[cs:oldTimerISR]
      mov bx,[cs:oldTimerISR+2]

      cli
      mov [es:8*4],ax
      mov [es:8*4+2],bx
      sti

    cmp byte[cs:RaceFinised],1
    jne exitProgram

    call endanimation

    call delay
    call delay
    call delay
    call delay
    call delay

    call loadingresult
    call qualifyresultsheet

exitProgram:
     call clrscrn
mov ax, 0x4c00
int 0x21