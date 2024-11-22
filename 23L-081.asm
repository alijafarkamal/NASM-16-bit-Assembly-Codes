;New! Keyboard shortcuts … Drive keyboard shortcuts have been updated to give you first-letters navigation
; Flag Register with unsigned subtraction

[org 0x0100]
	
;	Q1---------> finding maximum and minimum of an array <------------



;	jmp start ; unconditionally jump over data
;num1: dw 2,4,2,8,2
;max_un: dw 0
;start:
;	mov bx,num1		;pointer
;	mov ax,0
;	mov cx,0
;unsigned_max:
;	cmp ax,[bx]
;	jb value_get
;counter:
;	add bx,2
;	add cx,1
;	cmp cx,5
;	jz out
;	jmp unsigned_max
;value_get:
;	mov ax,[bx]
;	jmp counter
;out:
;	mov [max_un],ax
	
;unsigned_min
;	jmp start ; unconditionally jump over data
;num1: dw 2,4,1,8,2
;min_un: dw 0
;start:
;	mov bx,num1		;pointer
;	mov ax,[bx]
;	add bx,2
;	mov cx,0
;unsigned_min:
;	cmp ax,[bx]
;	ja value_get
;counter:
;	add bx,2
;	add cx,1
;	cmp cx,4
;	jz out
;	jmp unsigned_min
;value_get:
;	mov ax,[bx]
;	jmp counter
;out:
;	mov [min_un],ax

;	jmp start ; unconditionally jump over data
;num1: dw -1,-2,1,-8,0
;min_s: dw 0
;start:
;	mov bx,num1		;pointer
;	mov ax,[bx]
;	add bx,2
;	mov cx,0
;signed_min:
;	cmp ax,[bx]
;	jg value_get
;counter:
;	add bx,2
;	add cx,1
;	cmp cx,4
;	jz out
;	jmp signed_min
;value_get:
;	mov ax,[bx]
;	jmp counter
;out:
;	mov [min_s],ax
	
	
	
		jmp start ; unconditionally jump over data
num1: dw -1,-2,1,-8,0
max_s: dw 0
start:
	mov bx,num1		;pointer
	mov ax,[bx]
	add bx,2
	mov cx,0
signed_max:
	cmp ax,[bx]
	jl value_get
counter:
	add bx,2
	add cx,1
	cmp cx,4
	jz out
	jmp signed_max
value_get:
	mov ax,[bx]
	jmp counter
out:
	mov [max_s],ax
	
	
	
;	Q2---------> finding Union of two arrays <------------


			jmp start
Set1: dw 1,4,6,0
Set2: dw 1,3,5,8,0
Union: dw 0,0,0,0,0,0,0,0,0,0

start:	
	mov bx,0
	mov si,0
	mov ax,6
	mov cx,8
Loop:
	mov dx,[Set1+bx]
	mov [Union+si],dx
	add bx,2
	add si,2
	cmp bx,ax
	jb Loop
mov bx,0
loop1:
	mov dx,[Set2+bx]
	mov [Union+si],dx
	add bx,2
	add si,2
	cmp bx,cx
	jb loop1
	
mov dx,0
mov bx,0
mov cx,0
mov si,0

OuterLoop:
	mov dx,[Union+bx]
	add bx,2
	mov si,bx
	cmp bx,12
	jz outer
	
InnerLoop:
		mov cx,[Union+si]
		cmp dx,cx
		jz zero
		
counter:
		add si,2
		cmp si,14
		jz OuterLoop
		jmp InnerLoop
zero:
		mov word[Union+si],0x00
		jmp counter
outer:


	mov si, 0
outerloop:
	mov di, si
	add di, 2
innerloop:
		mov ax, [Union+si]
		cmp ax, [Union+di]
		jb noswap
		mov dx, [Union+di]
		mov [Union+si], dx
		mov [Union+di], ax
		
noswap:
	add di, 2
	cmp di, 14
	jb innerloop
	add si,2
	cmp si, 12
	jb outerloop
	
mov si,0
mov bp,0
LOOP:


;	Q3---------> finding intersection of two arrays <------------


	jmp start 		;unconditionally jump over data
	
Set1: dw 1,4,6,0
Set2: dw 1,3,6,8,0
Intersection: dw 0,0,0,0,0

start:
	mov bx,0	;bx to zero
	mov bp,0	;bp to zero
	mov si,0	;si to zero
	
OuterLoop:
	cmp bx,6	;comparison
	ja out
	mov bp,0
	mov ax,[Set1+bx]	
	add bx,2
	
InnerLoop:
	cmp ax,[Set2+bp]
	jz matching
	
counter:
	add bp,2
	cmp bp,8
	ja OuterLoop
	jmp InnerLoop

matching:
	mov [Intersection+si],ax
	add si,2
	jmp counter
out:



;	Q4---------> finding starting index <------------



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








