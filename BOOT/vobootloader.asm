
; voiled_os bootloader - prints a welcome message

[BITS 16]
[ORG 0x7C00]  ; BIOS loads bootloader here

start:
    ; Clear the screen
    mov ah, 0x00
    mov al, 0x03        ; video mode 3 (text mode)
    int 0x10

    ; Print the message pointed by SI
    mov si, message

.print:
    lodsb               ; load byte at [SI] into AL, SI++
    cmp al, 0
    je .halt            ; if zero terminator, end printing
    mov ah, 0x0E        ; teletype output function
    int 0x10
    jmp .print

.halt:
    cli                 ; disable interrupts
.hang:
    hlt                 ; halt CPU
    jmp .hang

message db "Welcome to Voiled OS.", 0

times 510 - ($ - $$) db 0   ; fill the rest of boot sector with zeros
dw 0xAA55                   ; boot signature
