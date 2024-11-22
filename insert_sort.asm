;insertion sort
[org 0x0100]
 		jmp start
arr: dw 5, 3, 8, 6, 2, 7, 4, 10, 1, 9 ; Array to be sorted
size: dw 10 ; Size of the array

start:
	mov bx,0			;counter
	mov bp,2			;pointer to first number[1]
	mov ax,[size]
	add ax,[size]
	sub ax,2			;size getter
	mov si,bp
sort:
	mov dx,[arr+bp]		;takes number in dx to be compared
	cmp [arr+bx],dx		;compares number
	ja swap
	cmp bx,0			;condition for insertion sort
	jnz condition
	jmp check			;if not swap is necessary, just go on net value
swap:
	mov cx,[arr+bx]		;makes temp
	mov [arr+bx],dx		;swap
	mov [arr+bp],cx		;finally swaps
condition:
	cmp bx,0			;if it is at 0th index
	jz check
	sub bx,2			;backward iteration
	sub bp,2
	jmp sort
check:
	mov bp,si
	cmp bp,ax			
	jz out				;comes out of loop
	add bp,2
	mov bx,bp			;moves to next index less than iterator index
	mov si,bp
	sub bx,2			;finally it does
	jmp sort
out:

	mov ax, 0x4c00		;terminate the program
INT		0x21
