[org 0x0100]

jmp start

tickcount dw 0
counter dw 0
countera dw 0
flag_for db 'f'
flag db 'p'
clear:
	mov ax,0xb800
	mov es,ax
	mov cx,2000
	mov di,0
	mov ax,0x0720
	rep stosw
	ret
star_moving_forward:

			push di
			
			mov bx,di
			mov bh,0x07
			mov di,word[cs:counter]
			mov word[cs:countera],di
			mov word[es:di-2],0x0720
			mov word[es:di],0x072A
			
			cmp di,158
			jne out10					
			mov byte[cs:flag_for],'d'
			jmp out1
			out10:
			
			cmp di, 3998
			jne out11
			mov byte[cs:flag_for],'b'
						jmp out1
			out11:
			
			cmp di,3840
			jne out12
			mov byte[cs:flag_for],'u'
						jmp out1
			out12:
					
			cmp di,160
			jne out13
			mov di,0
			
			mov byte[cs:flag_for],'f'
						jmp out1
			out13:
out1:		
			cmp byte[cs:flag_for],'d'
			jne out6
			add di,158
						jmp out
			out6:


			cmp byte[cs:flag_for],'b'
			jne out7
			sub di,4
						jmp out
			out7:

			cmp byte[cs:flag_for],'f'
			jne out5
			add di,2
			jmp out
			out5:
	
				
			cmp byte[cs:flag_for],'u'
			jne out8
			sub di,162
						jmp out
			out8:
out:		
			add di,2
			mov word[cs:counter],di
			
			pop di
	ret
	
clr:
		
			push di
			mov di,[cs:countera]
			mov word[es:di-2],0x0720
			pop di
			ret
timer:		
			push ax
			call clear
			inc word [cs:tickcount]; increment tick count
			cmp word[cs:tickcount],18
			je check
			jmp end
check:
			; CMP byte[cs:flag],'p'
			jne checker
			call star_moving_forward
			cmp word[cs:counter],156
			jne outera
			mov word[cs:counter],318
			mov byte[cs:flag_for],'d'
			outera:
			call delay
			call delay
			call delay
			; mov byte[cs:flag],'f'
checker:
			mov word[cs:tickcount],0
end:
			mov al, 0x20
			out 0x20, al 
			pop ax
			iret 
delay:
	mov cx,0xffff
loopa:
	loop loopa
	ret
kbisr:
			push ax
			push es
			mov ax,0xB800
			mov es,ax
			in al,0x60
			
			cmp al,0x2a
			jne stop
			mov byte[cs:flag],'p'
			jmp outa
stop:
			cmp al,0x36
			jne outa
			mov byte[cs:flag],'f'
outa:
			mov al,0x20
			out 0x20,al
			pop es
			pop ax
			
			iret
			
start:		
			call clear
			mov di,0
			xor ax, ax
			mov es, ax ; point es to IVT base

			cli ; disable in
			mov word [es:8*4], timer; store offset at n*4
			mov [es:8*4+2], cs ; store segment at n*4+2
			sti ; enable interrupts
			mov dx, start ; end of resident portion
			add dx, 15 ; round up to next para
			mov cl, 4
			shr dx, cl ; number of paras

			mov ax, 0x3100 ; terminate and stay resident
			int 0x21 

