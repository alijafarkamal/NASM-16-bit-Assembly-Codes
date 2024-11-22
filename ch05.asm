; local variables
[ORG 0x0100]
jmp start

;------------------------------------------------------
FindMin:		cmp ax, bx
				ja bIsSmaller 		; b < a
				cmp ax, cx			; either a or c is min
				ja cIsSmallest		; a>c
				mov dx, ax
				jmp return
bIsSmaller:		cmp ax, bx
				ja bIsSmallest		; b < c		
				mov dx, cx			; c is smallest	
				jmp return	
bIsSmallest:	mov dx, bx
				jmp return
cIsSmallest:	mov dx, cx			;dl = c	

return:			mov [bp-2], dx		;***** What is this space???? Local Var no 1
;------------------------------------------------------
FindMax:		cmp ax, bx
				jb bIsGreater 		; b > a
				cmp ax, cx			; either a or c is max
				jb cIsGreatest		; c > a
				mov dx, ax
				jmp returnFindMax
bIsGreater:		cmp cx, bx
				jb bIsGreatest		; b < c		
				mov dx, cx			; c is greatest	
				jmp returnFindMax	
bIsGreatest:	mov dx, bx
				jmp returnFindMax
cIsGreatest:	mov dx, cx			;dl = c	
returnFindMax:	mov [bp-4], dx		;**** What is this space???? Local Var no 2
				jmp retFromFindMax	
;-------------------------------------------------------
someFunc:			mov bp, sp

					sub sp, 8		;***create space for local vars on stack min,max, total,avg
									; Can dummy push work here???
									; what if we do not subtract 8 from sp and use bp-i???

					mov cx, [bp+2]	;Reading Parameter C
					mov bx, [bp+4]	;Parameter B 
					mov ax, [bp+6]	;Parameter A
		
					;-----------------------------------------
					jmp FindMin
					;--------------Find Total Below-----------

retFromFindMax:		mov dx, 0
					add dx, ax
					add dx, bx
					add dx, cx

					mov [bp-6], dx					
		
					mov al, [bp-6]
					mov cl, 3
					div cl				;al = al/cl
					mov [bp-8], al

					cmp byte[bp-8], 0xC
					jae AvgIsGreater
					mov dl, [bp-2]
					jmp ReturnFunc

AvgIsGreater:		mov dl, [bp-4]
ReturnFunc:			mov dh,0
					mov [bp+8], dx		;Copying answer on stack
		
					add sp, 8			; ***local variable space removed min, max, total, avg
										; ***why are we doing it before ret???
										; What if we skip this statement????
					ret 6				; Pop return address and increment sp by 6 Callee clearing the stack

;----------------------------------------------------------------------------------
start:		mov ax, 0xCCCC		; ***Creating space for Return Values on stack
			push ax				; dummy push

			mov ax, 0xA			; ***Parameters
			push ax				; see 2-126 of 88 manual
			mov ax, 0xB
			push ax
			mov ax, 0xC
			push ax
			call someFunc		; ***what if we do not pop return value from stack?
			pop dx				; ans is in dx

			MOV  AX, 0x4C00     ; Terminate Program 
			INT  0x21   