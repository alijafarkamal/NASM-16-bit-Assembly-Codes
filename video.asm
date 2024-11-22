[org 0x0100]
				jmp start
arr:  dw 0x10, 0x20, 0x30, 0x40, 0x50, 0x60, 0x70, 0x80, 0x90, 0xA0;, 0xB0, 0xC0, 0xD0, 0xE0, 0xF0, 0x100

;arr: dw 11111010, 10110001, 10101011, 01110010, 11000101, 10011100, 01010100, 01010000, 10001011
result: dw 0
;string: db 'DRAWER'
;length: dw 6

;bxgnal: dw 0
;num: db '1011100110011001'

;yes: db 'Yes'
;no: db 'No'
clrsr:
	mov ax,0xB800
	mov es,ax
	mov di,0
	mov cx,2000
	iteration:
	mov word[es:di],0x720
	add di,2
	loop iteration
	ret
;subr:
;	push bp
;	mov bp,sp
;	push ax
;	push bx
;	mov ax,[bp+4]
;	mov bx,[bp+6]
;	mul bx
;	mov [result],ax
;	pop bx
;	pop ax
;	pop bp
;	ret 4
;triangle:
;    push bp
;    mov bp, sp
;    pusha
;    xor dx, dx         ; Clear dx to avoid dividxon errors
;	mov dx,2
;    mov ax, [bp+4]     ; Load the first argument into ax
;    mov bx, [bp+6]     ; Load the second argument into bx
;    mul bx             ; Multiply ax by bx, result in dx:ax
;    mov bx, 2          ; Load 2 into bx for dividxon
;    div bx             ; Divide dx:ax by bx
;    mov [result], ax   ; Store result`	
;    popa
;    pop bp
;    ret 4
;draw:
;	push bp
;	mov bp,sp
;	pusha
;
;	mov dx,[result]
;	mov ax,0xB800
;	mov es,ax
;	mov di,0
;
;	mov ah,0x4F
;	mov al,'*'
;	mov bx,0
;	mov cx,0
;	mov byte[es:di],al
;	mov di,160
;
;st_loop:
;	add cx,1
;nd_loop:
;	mov byte[es:di],al
;	add di,2
;	add bx,1
;	loop nd_loop
;
;	mov cx,bx
;	mov bx,0
;	add di,160
;	sub di,cx
;	sub di,cx
;
;	sub dx,1
;	jnz st_loop
;
;	popa
;	pop bp
;	ret
;
;print: 
;	push bp
;	mov bp,sp
;
;	mov cx,[bp+4]
;	mov di,cx
;	sub di,1
;	shr cx,1
;	mov bx,[bp+6]
;	mov bx,0
;
;loop1:
;	mov al,byte[bx+bx]
;	mov ah,byte[bx+di]
;	mov byte[bx+bx],ah
;	mov byte[bx+di],al
;	sub di,1
;	add bx,1
;	loop loop1
;
;
;	pop bp
;ret 4
;
;
;drawer:
;	push bp
;	mov bp,sp
;	mov ax,0xB800
;	mov es,ax
;
;	mov cx,80
;	mov ax,[bp+6]
;	mul cx
;	mov cx,[length]
;	add ax,[bp+4]
;	shl ax,1
;	mov di,ax
;	mov bx,0
;
;
;	drawing:
;
;	mov al,byte[string+bx]
;	mov ah,0x8C
;	mov word[es:di],ax
;	add di,2
;	add bx,1
;	loop drawing
;
;
;	pop bp
;	ret 4
;
;
;palindrome:
;	push bp
;	mov bp,sp
;	mov cx,16
;	shr cx,1
;	mov di,15
;	mov bx,0
;	mov bx,[bp+4]
;
;	mov ax,0xB800
;	mov es,ax
;
;check: 
;	mov dl,byte[bx+di]
;	cmp byte[bx+bx],dl
;	jne ouf_of_loop
;	sub di,1
;	add bx,1
;loop check
;
;
;	mov bx,0
;	mov di,0
;	mov cx,3
;	mov bx,yes
;
;yes_iter:
;	mov al,[bx+bx]
;	mov ah,0x8C
;	mov [es:di],ax
;	add di,2
;	add bx,1
;	loop yes_iter
;	jmp end_of
;
;
;ouf_of_loop: 
;	mov bx,0
;	mov di,0
;	mov cx,2
;	mov bx,no
;no_iter:
;	mov al,[bx+bx]
;	mov ah,0x8C
;	mov [es:di],ax
;	add di,2
;	add bx,1
;	loop no_iter
;end_of:
;
;	pop bp
;	ret 2




help:
	push bp
	mov bp,sp
	mov ax,0xB800
	mov es,ax
	mov ah,0x8C
	mov al,byte[bp+2]
	mov [es:di],ax
	pop bp
	ret 2





command:
	push cx
	push bx
	push dx
	push ax
	mov cx,0
	mov bx,10
next:
	xor dx,dx
	div bx
	add dl,0x30
	push dx
	inc cx
	cmp ax,0
	jne next
mext:
	pop dx
	mov dh,0x4C
	mov [es:di],dx
	add di,2
	loop mext

	pop ax
	pop dx
	pop bx
	pop cx
	ret

multiplication_table:

	push bp
	mov bp,sp
	pusha
	mov ax,0xB800
	mov es,ax
	mov di,0
	mov bx,0
	mov si,1
first_loop:

	cmp bx,5
	je end
	add bx,1
	mov cx,5
	mov ax,0
	mov si,1

second_loop:

	mov ax,si
	mul bx
	cmp ax,10
	jae divv
	add ax,0x30

	mov ah,0x4C
	mov [es:di],ax
labelar:
	add si,1
	add di,4
	loop second_loop

	mov ax,160
	mov di,bx
	mul di
	mov di,ax

	jmp first_loop
divv: 
call command
jmp labelar
end:
	popa
	pop bp
	ret

plus:
	push bp
	mov bp,sp
	pusha
	mov ax,0xB800
	mov es,ax
	mov di,20
	mov cx,[bp+6]
	mov ah,0x0A
	mov al,'*'
vertical:
	mov [es:di],ax
	add di,160
loop vertical
	mov bx,9
	mov ax,160
	mul bx
	mov di,ax
	mov cx,[bp+4]
	mov ah,0x0A
	mov al,'*'
horizontal:
	mov [es:di],ax
	add di,2
	loop horizontal
	popa
	pop bp
	ret 4



	
poly:
	push bp
	mov bp,sp
	pusha
	add si,[bp+12]
	mov cx,[bp+4]
	
	mov di,10
	mov dx,0



evaluate:
	
	mov bx,[bp+6]
	mov ax,dx
ander:
	cmp dx,0
	je baher
	shl bx,1
	dec dx
	jmp ander
baher:
	mov dx,ax
	mov ax,[bp+di]
	mul bx
	add si,ax
	sub di,2
	inc dx
loop evaluate
	mov [result],si
	popa
	pop bp
	ret 10
checkOccurences:
	push bp
	mov bp,sp
	pusha
	mov ax,0xB800
	mov es,ax
	mov cx,2000
	mov di,0
highlighter:
	cmp byte[es:di],'A'
	je go
	cmp byte[es:di],'a'
	je go
	jmp outsider
go:
	mov al,byte[es:di]
	mov ah,0xCA
	mov [es:di],ax
outsider:
	add di,2
loop highlighter
	popa
	pop bp
	ret





fibonacci:
	cmp cx,1
	je skip1
	sub cx,1
	mov dx,bx
	add bx,ax
	mov ax,dx
	call fibonacci
skip1:
	mov [result],bx
	ret
factorial:
	push bp
	mov bp,sp
	mov word[bp+4],7
	mov word[bp+6],8
	pop bp
	ret 4


	;sub cx,1
	;cmp cx,0
	;je skipa
	;add ax,cx
	;call factorial
	;skipa:
	;mov [result],ax
	;ret




binary_search:
	cmp bx,ax
	jb skipa
	mov di,bx
	sub di,ax
	shr di,1
	add di,ax
	test di,1
	jnz skip
label:
	cmp word[arr+di],si
	je skipa
	ja delta
	mov ax,di
	add ax,1
	call binary_search
delta:	
	mov bx,di
	sub bx,1
	call binary_search
skip:
	sub di,1
	jmp label
skipa:
	shr di,1
	add di,1
	mov [result],di
	ret


hexagon:
	push bp
	mov bp,sp
	pusha
	mov ax,0xB800
	mov es,ax
	mov cx,[bp+8]
	mov di,160
	mov ax,[bp+12]
	mul di
	mov di,[bp+10]
	shl di,1
	add ax,di
	mov di,ax
	mov ah,[bp+4]
	mov al,[bp+6]

straight:
	mov [es:di],ax
	add di,2
loop straight
	mov cx,[bp+8]
	add di,160

front_diagonal:
	mov [es:di],ax
	add di,162
loop front_diagonal
	mov cx,[bp+8]
	sub di,4

back_diagonal:
	mov [es:di],ax
	add di,158
loop back_diagonal
	mov cx,[bp+8]
	sub cx,1
	sub di,160

bottom:
	mov [es:di],ax
	sub di,2
loop bottom
	mov cx,[bp+8]
	sub di,160
back_back_diagonal:
	mov [es:di],ax
	sub di,162
loop back_back_diagonal
	mov cx,[bp+8]
	sub cx,1
	add di,4

back_front_diagonal:
	mov [es:di],ax
	sub di,158
loop back_front_diagonal
	popa
	pop bp
	ret 10

start:

	call clrsr
	call ganji
	push 7
	push 10
	push 5
	push '*'
	push 0x02
	call hexagon

	push 5
	push 28
	push 3
	push '+'
	push 0x01
	call hexagon

	push 7
	push 40
	push 7
	push '#'
	push 0x05
	call hexagon


	;mov ax,0
	;mov bx,18
	;mov si,0x70
	;call binary_search

	;mov cx,5
	;mov ax,cx
	;push 5
	;push 6
	;mov cx,8
	;mov ax,0
	;mov bx,1
	;mov si,0
	;call fibonacci

	
	;mov ax,[arr]

	;call checkOccurences
	;call clrsr
	;push 3
	;push 4
	;push 5
	;push 2
	;push 2
	;call poly




	;call plus
	;call multiplication_table
	;mov ax,num
	;push ax
	;call palindrome
	;push string
	;push word[length]
	;call print
	;push 2
	;push 5
	;call drawer
	;call clrsr
	;push 2
	;push 5
	;call triangle
	;call draw

	;call subr
	;mov word[0x0500],0xB
	;mov word[0x0600],0xF
	;mov ax,[0x0500]
	;mov bx,[0x0600]
	;mov cx,ax
	;mov ax,bx
	;mov bx,cx
	;mov word[0x0500],bx
	;mov word[0x0600],ax
enda:
mov ax,0x4c00
int 0x21