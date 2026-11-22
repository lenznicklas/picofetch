.intel_syntax noprefix
.global print_progress

.extern print_z
.extern print_number
.extern magenta
.extern reset

.section .rodata
progress_space: .asciz "  "
progress_dot:   .asciz "●"
progress_dim:   .asciz "\033[90m"
progress_end:   .asciz " "
progress_pct:   .asciz "%"

.section .text

print_progress:
    push r12
    push r13
    push r14

    mov r12, rax

    cmp r12, 100
    jbe percent_ok
    mov r12, 100

percent_ok:
    imul rax, r12, 20

    xor edx, edx
    mov ecx, 100
    div rcx

    mov r13, rax

    lea rsi, [rip + progress_space]
    call print_z

    lea rsi, [rip + magenta]
    call print_z

    xor r14d, r14d

filled_loop:
    cmp r14, r13
    jae switch_dim

    lea rsi, [rip + progress_dot]
    call print_z

    inc r14
    jmp filled_loop

switch_dim:
    lea rsi, [rip + progress_dim]
    call print_z

empty_loop:
    cmp r14, 20
    jae progress_finish

    lea rsi, [rip + progress_dot]
    call print_z

    inc r14
    jmp empty_loop

progress_finish:
    lea rsi, [rip + reset]
    call print_z

    lea rsi, [rip + progress_end]
    call print_z

    mov rax, r12
    call print_number

    lea rsi, [rip + progress_pct]
    call print_z

    pop r14
    pop r13
    pop r12
    ret
