[org 0x0100]
jmp start

video_segment equ 0xB800
screen_width   equ 80
screen_height  equ 25
bytes_per_char equ 2

scrollup:
    pusha
    mov ax, video_segment
    mov es, ax
    mov ds, ax
    mov cx, screen_width * 3 * bytes_per_char
    xor si, si
    add si, cx
    xor di, di
    mov cx, (screen_height - 3) * screen_width
    shl cx, 1
    cld
    rep movsw
    mov ax, 0x0720
    mov cx, screen_width * 3
    shl cx, 1
    mov di, (screen_height - 3) * screen_width * bytes_per_char
    rep stosw
    popa
    ret

scrolldown:
    pusha
    mov ax, video_segment
    mov es, ax
    mov ds, ax
    mov cx, screen_width * 3 * bytes_per_char
    mov si, (screen_height - 6) * screen_width * bytes_per_char
    mov di, (screen_height - 3) * screen_width * bytes_per_char
    std
    rep movsw
    cld
    mov ax, 0x0720
    mov cx, screen_width * 3
    shl cx, 1
    xor di, di
    rep stosw
    popa
    ret

start:
main_loop:
    call scrollup
    call scrolldown
    jmp main_loop

mov ax, 0x4C00
int 0x21
