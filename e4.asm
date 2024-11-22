;               COAL PROJECT - GRAND PRIX CIRCUIT GAME IMPLEMENTATION
; MEMBERS:  SYED MUHAMMAD ANAS NAUMAN    21L-5230 
;           SAAD ASIF                    21L-7532  
; SECTION:  3-B
[org 0x0100]
jmp start
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
;;;;;;;;;;;;;;;;;;;;;;;;;;;
chqrdflg:
       push bp
       mov  bp,sp
       sub  bp,6                    ; create local variable space
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
jmp n
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
           ;;;;;;;;;;;;;;;;;;;;;;;
;mov ax,0x9efe
;mov di,1332
;mov cx,28
;rep stosw
;mov di,1488
;mov cx,32
;rep stosw

n:



       pop di
       pop dx
       pop cx
       pop bx
       pop ax
       pop es
       pop si
       add bp,6                    ; free local variable space
       pop bp

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
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
   call delay
   call delay
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
       add bp,4                     ; free local variable space
       pop bp

       ret
;;;;;;;;;;;;;;;;;;;;;;;;;;;;
start:
call clrscrn
call prntgrs 
call prntrd             
call chqrdflg    
call endanimation

mov ax, 0x4c00
int 0x21

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
loopMovs:

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