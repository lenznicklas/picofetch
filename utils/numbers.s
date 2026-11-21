.intel_syntax noprefix
.global print_number
.extern print_z

.section .bss
num_buf: .skip 32

.section .text
print_number:
    lea rsi, [rip + num_buf + 31]
    mov byte ptr [rsi], 0

    mov rcx, 10

convert_loop:
    xor edx, edx
    div rcx

    add dl, '0'
    dec rsi
    mov [rsi], dl

    text rax, rax
    jnz convert_loop

    call print_z
    ret
