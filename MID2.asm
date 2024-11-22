[org 0x0100]
; Set the program's starting offset in memory.

push 8 ; Push row number onto stack.
push 2 ; Push column number onto stack.
call CompressData ; Call the subroutine.
mov ax, 0x4c00
int 21h ; Terminate the program using DOS interrupt.
CompressData Subroutine
assembly
Copy code
CompressData:
push bp
mov bp, sp
; Standard prologue, set up base pointer for stack frame.

push ax ; Save all used registers.
push bx
push cx
push dx
push si
push di
push es
push ds
; Saving segment registers and general-purpose registers.
Set Up Video Memory Segment
assembly
Copy code
push 0xb800
pop es
; Set extra segment to point to video memory segment address.
Calculate Position in Video Memory
assembly
Copy code
mov al, 80
mov bl, [bp+6] ; Load row number from stack into bl.
mul bl ; Multiply row number by 80 (width of the screen in text mode).
add ax, [bp+4] ; Add column number to result.
shl ax, 1 ; Multiply by 2 to convert column to its byte offset (each cell is 2 bytes).
mov di, ax ; Store result in di, which will be used as the index for operations.
push di ; Save original index position of the character.
Remove Consecutive Characters
assembly
Copy code
mov cx, 80
sub cx, [bp+4] ; Calculate remaining columns in the row from the given position.
mov ax, [es:di] ; Load the character and attribute from video memory.
repe scasw
; Repeat comparing words from ES:DI until character changes, using CX as counter.
sub di, 2 ; Adjust DI because repe scasw stops one position ahead after a mismatch.
mov si, di ; Move new starting position for copying back to SI.
pop di ; Restore original DI position.
add cx, 1 ; Adjust count for moving remaining characters.
Shift Remaining Characters Left
assembly
Copy code
mov bx, cx ; Save value of CX for later use.
push 0xb800
pop ds ; Ensure DS points to video memory as well.
rep movsw ; Move words from SI to DI, effectively shifting characters left.
Fill End with Spaces
assembly
Copy code
mov cx, bx ; Restore count of elements to move.
mov ax, 0x0720 ; Load space character and attribute (usually gray on black).
rep stosw ; Store AX into ES:DI CX times, filling remaining space with spaces.
Cleanup and Return
assembly
Copy code
pop ds ; Restore registers and stack.
pop es
pop di
pop si
pop dx
pop cx
pop bx
pop ax
pop bp
ret 4 ; Return from subroutine and adjust stack for parameters.

; Assume AX, BX, CX, DX are used for general purposes
; Stack is used to pass parameters

; Main Procedure Call
push yB
push xB
push yA
push xA
call DrawRectangle
add sp, 8  ; Cleanup stack (4 words pushed)
mov ax, 0x4c00
int 0x21  ; Terminate program

; DrawRectangle Subroutine
DrawRectangle:
push bp
mov bp, sp
push ax
push bx
push cx
push dx
push es
push ds

; Load parameters from stack
mov ax, [bp+6]  ; xA
mov bx, [bp+8]  ; yA
mov cx, [bp+10] ; xB
mov dx, [bp+12] ; yB

; Validate coordinates
cmp ax, cx
jge InvalidInput
cmp bx, dx
jge InvalidInput

; Clear screen to white
call ClearScreen

; Setting up video memory access for colors and characters
mov ax, 0xb800
mov es, ax

; Drawing rectangle
mov si, bx ; Start row
Label_RowLoop:
  mov di, ax ; Start column
  Label_ColLoop:
    cmp si, bx
    je DrawBorder
    cmp si, dx
    je DrawBorder
    cmp di, ax
    je DrawBorder
    cmp di, cx
    je DrawBorder
    jmp DrawInside

    DrawBorder:
      mov ah, 0x1B  ; Attribute for blue background
      mov al, '$'
      jmp PrintChar

    DrawInside:
      mov ah, 0x4C  ; Attribute for red background
      mov al, ' '   ; Empty space, colored background

    PrintChar:
      ; Calculate position in video memory (assuming 80 columns)
      mov bx, si
      shl bx, 6
      mov tmp, si
      shr tmp, 1
      add bx, tmp
      add bx, di
      shl bx, 1
      mov [es:bx], ax
      inc di
      cmp di, cx
      jle Label_ColLoop
  inc si
  cmp si, dx
  jle Label_RowLoop

jmp Done

InvalidInput:
  ; Handle invalid input
  mov ax, 0
  mov [es:0], ax  ; Just a placeholder to do nothing

Done:
pop ds
pop es
pop dx
pop cx
pop bx
pop ax
pop bp
ret

; ClearScreen Subroutine
ClearScreen:
; Set entire screen to white background
