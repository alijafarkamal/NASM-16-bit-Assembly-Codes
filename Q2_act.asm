;New! Keyboard shortcuts … Drive keyboard shortcuts have been updated to give you first-letters navigation
; Flag Register with unsigned subtraction

[org 0x0100]
		jmp start
Set: dw 1,2,4,1,1,2,3,1,2,5
Subset: dw 1,2,3
Index: dw 0
start:
	mov ax,1	;counter for subset
	mov bx,Set	;pointer for set
	mov bp,Subset	;pointer for subset
	mov cx,0
	mov si,3
loop:
	cmp cx,10	;compares full array iteration
	jz out		
	add cx,1	
	mov dx,[bx]	;value get
	cmp dx,[bp]
	jz check
	cmp word[bx],1
	jnz look	;jump not zero 
	sub bp,2	;backward coming ;cmp dx,[bp-2]
	sub ax,1	
	jmp check
look:
	add bx,2
	mov bp,Subset	;keeping bp at first index
	mov ax,1	;remaining at 0th index
	jmp loop
check:
	cmp ax,3
	jz result
	add ax,1	;matching counter
	add bp,2
	add bx,2
	jmp loop
result:
	sub cx,si
	mov [Index],cx
out:
	
	mov ax, 0x4c00		;terminate the program
	int 0x21
	

