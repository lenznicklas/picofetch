.intel_syntax noprefix
.global print_memory

.extern print_z
.extern print_number
.extern magenta
.extern reset
.extern newline

.section .rodata
mem_label: .asciz "  Memory  "
slash:     .asciz " / "
unit:      .asciz " MiB"

.section .bss
mem_info: .skip 112

.section .text
print_memory:
    mov eax, 99
    lea rdi, [rip + mem_info]
    syscall

    test rax, rax
    js memory_done

    # load ram
    mov rax, [rip + mem_info + 32]

    # load free ram
    sub rax, [rip + mem_info + 40]

    # mem_unit
    mov ecx, [rip + mem_info + 104]
    imul rax, rcx

    # to MiB
    xor edx, edx
    mov rcx, 1048576
    div rcx

    # save used ram
    push rax

    # load ram
    mov rax, [rip + mem_info + 32]

    mov ecx, [rip + mem_info + 104]
    imul rax, rcx

    xor edx, edx
    mov rcx, 1048576
    div rcx

    # save ram
    push rax

    # effective print
    lea rsi, [rip + magenta]
    call print_z
    lea rsi, [rip + mem_label]
    call print_z
    lea rsi, [rip + reset]
    call print_z

    pop rax
    mov r8, rax

    pop rax
    push r8
    call print_number

    lea rsi, [rip + slash]
    call print_z

    pop rax
    call print_number

    lea rsi, [rip + unit]
    call print_z
    lea rsi, [rip + newline]
    call print_z

memory_done:
    ret
