[org 0x0100]

; main:
    jmp start
promptName: db 'Enter your name: $'
promptRollNo: db 'Enter your roll number: $'
promptCourse: db 'Enter your course name: $'
promptSection: db 'Enter your section: $'
maxInput: dw 80
inputName: times 81 db 0
inputRollNo: times 81 db 0
inputCourse: times 81 db 0
inputSection: times 81 db 0

newline1 db 0Dh, 0Ah, "$"          ; Newline sequence for DOS interrupt 21h
msg_prompt db "Your Entered Data:$"
label_name db "Name: $"
label_roll db "Roll Number: $"
label_course db "Course: $"
label_section db "Section: $"

section .text
start:
    ; Ask for and store the name
    mov dx, msg_name
    call print_string            ; Print "Enter your name:"
    lea dx, [name]
    call read_string             ; Read user input into 'name'
    mov byte [name+1], 13        ; Append Enter (CR) to input
    mov byte [name+2], '$'       ; Null-terminate input
    call newline                 ; Move to the next line

    ; Ask for and store the roll number
    mov dx, msg_roll
    call print_string            ; Print "Enter your roll number:"
    lea dx, [roll]
    call read_string             ; Read user input into 'roll'
    mov byte [roll+1], 13        ; Append Enter (CR) to input
    mov byte [roll+2], '$'       ; Null-terminate input
    call newline                 ; Move to the next line

    ; Ask for and store the course name
    mov dx, msg_course
    call print_string            ; Print "Enter your course name:"
    lea dx, [course]
    call read_string             ; Read user input into 'course'
    mov byte [course+1], 13      ; Append Enter (CR) to input
    mov byte [course+2], '$'     ; Null-terminate input
    call newline                 ; Move to the next line

    ; Ask for and store the section
    mov dx, msg_section
    call print_string            ; Print "Enter your section:"
    lea dx, [section_name]
    call read_string             ; Read user input into 'section_name'
    mov byte [section_name+1], 13; Append Enter (CR) to input
    mov byte [section_name+2], '$'; Null-terminate input
    call newline                 ; Move to the next line

    ; Clear the screen
    call clrscr

    ; Display data in the middle of the screen (12th row, 30th column)
    mov ah, 0x02                ; BIOS interrupt to set cursor position
    mov bh, 0                   ; Page number
    mov dh, 12                  ; Row (12th)
    mov dl, 30                  ; Column (30th)
    int 0x10
    popa
    ; Display a prompt
    mov dx, msg_prompt
    call print_string
    call newline

    ; Display the entered data
    call display_data

    ; Program end
    mov ax, 0x4C00              ; DOS terminate program
    int 0x21

; Subroutine to display entered data
display_data:
    ; Display Name
    mov dx, label_name
    call print_string
    lea dx, [name+2]
    call print_string
    call newline

    ; Display Roll Number
    mov dx, label_roll
    call print_string
    lea dx, [roll+2]
    call print_string
    call newline

    ; Display Course
    mov dx, label_course
    call print_string
    lea dx, [course+2]
    call print_string
    call newline

    ; Display Section
    mov dx, label_section
    call print_string
    lea dx, [section_name+2]
    call print_string
    call newline

    ret

; Subroutine to clear the screen
clrscr:
    pusha
    push es
    mov ax, 0xb800             ; Load video base in ax
    mov es, ax                 ; Point es to video base
    mov di, 0                  ; Point di to top left column (0xB800:0000)

nextchar:
    mov word [es:di], 0x0720   ; Clear next char on screen with space (0x20) and white attribute (0x07)
    add di, 2                  ; Move to next screen position (2 bytes per character)
    cmp di, 4000               ; Check if the whole screen is cleared (4000 bytes for 80x25 text mode)
    jne nextchar               ; If not, clear the next character
    pop es
    popa
    ret

print_string:
    mov ah, 0x09               ; DOS function 09h: print string
    int 0x21                   ; Print the string at DS:DX
    ret

; Subroutine to read a string (uses DOS interrupt 21h, function 0Ah)
read_string:
    mov ah, 0x0A               ; DOS function 0Ah: buffered input
    int 0x21                   ; Read user input into buffer at DS:DX
    ret

; Subroutine to move to the next line
newline:
    mov dx, newline1
    call print_string
    ret