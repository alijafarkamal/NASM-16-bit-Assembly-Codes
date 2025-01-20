


; cmp word [bp+6], 40
; jb checkx2
; cmp word [bp+6], 65
; ja checkx2
; jmp checkY
; checkx2:
; ; check 2, pipeX < 40
; cmp word [bp+6], 40
; ja get_out
; jmp checkY
; checkY:
; ; check Y, pipeY < birdY && pipeY + 55 > birdY
; mov dx, [bp+4]
; mov bx, [birdy]
; cmp dx, bx
; ja collided
; add dx, 55
; add bx, 15
; cmp dx, bx
; jae get_out

; jmp get_out
 ; mov ax,[bird_top_corner]
; mov word[a_keeper],ax
 ; mov dx,0
 ; mov cx,320
 ; div cx
 ; cmp dx,[pipesX]
; ; mov ax,0x0035
; ; mov [es:31100],ax
 ; jb get_out
; ; ja get_out
; ; mov ax,0xCC00
; ; mov [es:31100],ax
; mov cx,[intBottomPipeStart]
; sub cx,56
; mov ax,320
; checker:
; add ax,320
; loop checker
; add ax,40
; add ax,dx
; cmp word[bird_top_corner],ax
; jb collided
; ; cmp word[bird_pos],ax
; ; jb collided

; sub ax,40
; mov word[a_keeper],ax
; mov cx,53
; mov ax,320
; checker1:

; add ax,320
; loop checker1
; add ax,[a_keeper]
; cmp word[bird_bottom_corner_end],ax
; jae collided
; cmp word[bird_bottom_corner],ax
; jae collided
; jmp get_out
; mov dx,[a_keeper]
; cmp dx,word[pipesX+2]
; jb next_check2

; next_check2:
; add ax,40
; cmp word[bird_bottom_corner_end],ax
; jbe collided
; jmp get_out
; next_check3:
; add ax,40
; cmp word[bird_bottom_corner],ax
; jbe collided
; jmp get_out
; ; ; pop dx
 ; ; cmp dx,[rect_pos1]
 ; ; jne next_check3
; ; je exit_game
 ; ; mov word[collision_detected],1
 ; ; jmp get_out
; ; next_check3:
 ; ; cmp dx,[rect_pos2]
 ; ; jne next_check4

 ; ; mov word[collision_detected],1
 ; ; jmp get_out
; ; next_check4:
 ; ; mov si,dx
 ; ; mov ax,[rect_pos_down]
 ; ; mov cx,320
 ; ; mov dx,0
 ; ; div cx
 ; ; cmp si,dx
 ; ; jne next_check5

 ; ; mov word[collision_detected],1
 ; ; jmp get_out
; ; next_check5:
 ; ; mov ax,[rect_pos_down1]
 ; ; mov cx,320
 ; ; mov dx,0
 ; ; div cx
 ; ; cmp si,dx
 ; ; jne next_check6
 ; ; mov word[collision_detected],1
 ; ; jmp get_out
; ; next_check6:
 ; ; mov ax,[rect_pos_down2]
 ; ; mov cx,320
 ; ; mov dx,0
 ; ; div cx
 ; ; cmp si,dx
 ; ; jne get_out
 ; ; mov word[collision_detected],1
 ; jmp get_out
; collided:
; mov word[collision_detected],1