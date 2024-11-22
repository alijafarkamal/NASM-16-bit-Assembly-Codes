[org 0x100]
;**NOTE**: Carefully observe the top value of stack throughout debugging and when returning from the function  
jmp main ;jump to main


fun2:;nested function

	push bp      ; Save base pointer
	mov bp, sp   ; Set base pointer to stack pointer
	sub sp, 2  ;create another local variable for nested fun2
	
	mov word [bp-2], 4 ;placing 4 in local variable as we have to add 4 to parameter
	
	
	mov ax,[bp+4] ; it contains the number which is passed
	add  [bp-2],ax ; add that number to 4(stored in result i.e.[bp-2])
	mov ax,[bp-2] ;mov result to ax
	 
	mov [bp+4],ax ;now we can move result to [bp+4] which is the local variable of fun1
	
	mov sp, bp
    pop bp
    ret  ;we didnt pass the parameter but when we return from fun2 the local variable of fun1 has to popped so that we get the correct returning address for fun1 

fun1:
    push bp      ; Save base pointer
    mov bp, sp   ; Set base pointer to stack pointer
    sub sp, 2    ; Allocate 2 bytes for local variable (result) (if you guys want to create lets say 5 variables you can subtract (5*2=10 bytes) from sp for reseving space for variables )

    mov word [bp-2], 5 ; Initialize result to 5 (as we want to add 5 to given number)

    mov ax,[bp+4] ; it contains the number which is passed
	add  [bp-2],ax ; add that number to 5(stored in result i.e.[bp-2])
	mov ax,[bp-2] ;mov result to ax
	
    ;local variable will be used as parameter for fun2 so we dont need to push ax for fun2
	call fun2 ;call second function which will adds 4 to the result of fun1
	
	
    mov ax,[bp-2] ;
	
    mov [bp+6],ax
    mov sp, bp
    pop bp
    ret 2 ; as we had one parameter of 2 bytes

; Main program
main:
    push 1     ; Push the number in which you want to add 5
    call fun1
    pop bx       ; Pop the result into BX

    [org 0x100]


    mov ah, 4ch  ; Exit program
    int 21h