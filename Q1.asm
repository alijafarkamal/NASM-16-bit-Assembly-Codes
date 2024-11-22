;New! Keyboard shortcuts … Drive keyboard shortcuts have been updated to give you first-letters navigation
; Flag Register with unsigned subtraction

[org 0x0100]
		jmp start
wor: dw 0xB189;1011 0001 1000 1001
start:
	mov bx,[wor]
	mov cx,0
	mov dx,0
	mov ax,16
first_loop:
	shr bx,1
	jc inc
check:
	cmp dx,ax
	je out
	add dx,1
	jmp first_loop
inc:
	add cx,1
	jmp first_loop
out:
	mov bx,[wor]
	xor bx,0x007F
	
	
	
	mov ax, 0x4c00		;terminate the program
	int 0x21
	
;	mov ax,1	;counter for subset
;	mov bx,Set	;pointer for set
;	mov bp,Subset	;pointer for subset
;	mov cx,0
;	mov si,3
;loop:
;	cmp cx,10	;compares full array iteration
;	jz out		
;	add cx,1	
;	mov dx,[bx]	;value get
;	cmp dx,[bp]
;	jz check
;	cmp word[bx],1
;	jnz look	;jump not zero 
;	sub bp,2	;backward coming ;cmp dx,[bp-2]
;	sub ax,1	
;	jmp check
;look:
;	add bx,2
;	mov bp,Subset	;keeping bp at first index
;	mov ax,1	;remaining at 0th index
;	jmp loop
;check:
;	cmp ax,3
;	jz result
;	add ax,1	;matching counter
;	add bp,2
;	add bx,2
;	jmp loop
;result:
;	sub cx,si
;	mov [Index],cx
