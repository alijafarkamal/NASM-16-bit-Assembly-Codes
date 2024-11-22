; org 0x100                 ; COM file starts at 0x100 in memory

; section .data
; name times 29 db       ; Buffer for name (29 max characters, +2 for control)
; roll times 9 db    ; Buffer for roll number (9 max characters, +2 for control)
; course times 29 db ; Buffer for course name (29 max characters, +2 for control)
; section_name times 9 db ; Buffer for section (9 max characters, +2 for control)

; msg_name db "Enter your surname: $"
; msg_roll db "Enter your roll number: $"
; msg_course db "Enter your course name: $"
; msg_section db "Enter your section: $"
; newline1 db 0Dh, 0Ah, "$"         ; Newline sequence for DOS interrupt 21h

; section .text
; start:
    ; mov dx, msg_name
    ; call print_string            ; Print "Enter your name:"
    ; lea dx, [name]
    ; call read_string             ; Read user input into 'name'
    ; call newline                 ; Move to the next line


    ; mov dx, msg_roll
    ; call print_string            ; Print "Enter your roll number:"
    ; lea dx, [roll]
    ; call read_string             ; Read user input into 'roll'
    ; call newline                 ; Move to the next line

    ; ; Ask for and store the course name
    ; mov dx, msg_course
    ; call print_string            ; Print "Enter your course name:"
    ; lea dx, [course]
    ; call read_string             ; Read user input into 'course'
    ; call newline                 ; Move to the next line

    ; ; Ask for and store the section
    ; mov dx, msg_section
    ; call print_string            ; Print "Enter your section:"
	
    ; lea dx, [section_name]
    ; call read_string             ; Read user input into 'section_name'
    ; call newline                 ; Move to the next line

    ; ; Program end
    ; mov ax, 0x4C00              ; DOS terminate program
    ; int 0x21
; ; Subroutine to print a string (uses DOS interrupt 21h, function 09h)
; print_string:
    ; mov ah, 0x09                ; DOS function 09h: print string
    ; int 0x21                    ; Print the string at DS:DX
    ; ret
; read_string:
    ; mov ah, 0x0A                  ;DOS function 0Ah: buffered input
    ; int 0x21                    		;Read user input into buffer at DS:DX
    ; ret

; newline:
    ; mov dx, newline1
    ; call print_string
    ; ret
org 0x100                 ; COM file starts at 0x100 in memory

section .data
name times 29 db       ; Buffer for name (29 max characters, +2 for control)
roll times 9 db        ; Buffer for roll number (9 max characters, +2 for control)
course times 29 db     ; Buffer for course name (29 max characters, +2 for control)
section_name times 9 db; Buffer for section (9 max characters, +2 for control)

msg_name db "Enter your surname: $"
msg_roll db "Enter your roll number: $"
msg_course db "Enter your course name: $"
msg_section db "Enter your section: $"
newline1 db 0Dh, 0Ah, "$"         ; Newline sequence for DOS interrupt 21h
msg_prompt db "Your entered data: $"
label_name db "Name: $"
label_roll db "Roll Number: $"
label_course db "Course: $"
label_section db "Section: $"

section .text
start:
    ; Ask for and read the name
	pusha 
    mov dx, msg_name
    call print_string            ; Print "Enter your name:"
	mov dx,0
    lea dx, [name]
    call read_string             ; Read user input into 'name'
    call newline                 ; Move to the next line
popa
pusha
    ; Ask for and read the roll number
    mov dx, msg_roll
    call print_string            ; Print "Enter your roll number:"
	mov dx,0
    lea dx, [roll]
    call read_string             ; Read user input into 'roll'
    call newline                 ; Move to the next line
popa
    ; Ask for and read the course name
pusha
    mov dx, msg_course
    call print_string            ; Print "Enter your course name:"
	mov dx,0
    lea dx, [course]
    call read_string             ; Read user input into 'course'
    call newline                 ; Move to the next line
popa
pusha
    ; Ask for and read the section name
    mov dx, msg_section
    call print_string            ; Print "Enter your section:"
	mov dx,0
    lea dx, [section_name]
    call read_string             ; Read user input into 'section_name'
    call newline                 ; Move to the next line
popa
    ; Output all the entered data

    ; Display the label and name
    mov dx, label_name
    call print_string            ; Print "Name: "
    lea dx, [name]             ; Skip the first 2 bytes (for input buffer size and length)
    call print_string            ; Print the name entered by user
    call newline                 ; Move to the next line

    ; Display the label and roll number
    mov dx, label_roll
    call print_string            ; Print "Roll Number: "
    lea dx, [roll]             ; Skip the first 2 bytes (for input buffer size and length)
    call print_string            ; Print the roll number entered by user
    call newline                 ; Move to the next line

    ; Display the label and course
    mov dx, label_course
    call print_string            ; Print "Course: "
    lea dx, [course]           ; Skip the first 2 bytes (for input buffer size and length)
    call print_string            ; Print the course entered by user
    call newline                 ; Move to the next line

    ; Display the label and section
    mov dx, label_section
    call print_string            ; Print "Section: "
    lea dx, [section_name]     ; Skip the first 2 bytes (for input buffer size and length)
    call print_string            ; Print the section entered by user
    call newline                 ; Move to the next line

    ; Program end
    mov ax, 0x4C00              ; DOS terminate program
    int 0x21

; Subroutine to print a string (uses DOS interrupt 21h, function 09h)
print_string:
	pusha
    mov ah, 0x09                ; DOS function 09h: print string
    int 0x21                    ; Print the string at DS:DX
	popa
    ret

; Subroutine to read a string (uses DOS interrupt 21h, function 0Ah)
read_string:
	pusha
    mov ah, 0x0A                  ; DOS function 0Ah: buffered input
    int 0x21                      ; Read user input into buffer at DS:DX
	popa
    ret

; Subroutine to move to the next line
newline:
	pusha
    mov dx, newline1
    call print_string
	popa
    ret
