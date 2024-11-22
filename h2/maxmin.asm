;unsigned_max
[org 0x0100]
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
	
mov ax, 0x4c00 ; terminate program
int 0x21
