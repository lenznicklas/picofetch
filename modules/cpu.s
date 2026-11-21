.intel_syntax noprefix
.global print_cpu

.extern print_z
.extern magenta
.extern reset
.extern newline

.section .rodata
cpu_path:  .asciz "/proc/cpuinfo"
cpu_label: .asciz "  CPU     "
cpu_key:   .asciz "model name"

.section .bss
cpu_buffer: .skip 8208

.section .text
print_cpu:
    push r12

    mov eax, 2
    lea rdi, [rip + cpu_path]
    xor esi, esi
    xor edx, edx
    syscall

    test rax, rax
    js cpu_done

    mov r12, rax

    mov eax, 0
    mov rdi, r12
    lea rsi, [rip + cpu_buffer]
    mov edx, 8191
    syscall

    mov r8, rax

    mov eax, 3
    mov rdi, r12
    syscall

    test r8, r8
    jle cpu_done

    lea rsi, [rip + cpu_buffer]
    mov byte ptr [rsi + r8], 0

find_cpu:
    cmp byte ptr [rsi], 0
    je cpu_done

    cmp byte ptr [rsi], 'm'
    jne cpu_next

    cmp byte ptr [rsi + 1], 'o'
    jne cpu_next

    cmp byte ptr [rsi + 2], 'd'
    jne cpu_next

    cmp byte ptr [rsi + 3], 'e'
    jne cpu_next

    cmp byte ptr [rsi + 4], 'l'
    jne cpu_next

    cmp byte ptr [rsi + 5], ' '
    jne cpu_next

    cmp byte ptr [rsi + 6], 'n'
    jne cpu_next

    cmp byte ptr [rsi + 7], 'a'
    jne cpu_next

    cmp byte ptr [rsi + 8], 'm'
    jne cpu_next

    cmp byte ptr [rsi + 9], 'e'
    jne cpu_next

find_colon:
    cmp byte ptr [rsi], 0
    je cpu_done

    cmp byte ptr [rsi], ':'
    je cpu_found

    inc rsi
    jmp find_colon

cpu_next:
    inc rsi
    jmp find_cpu

cpu_found:
    inc rsi

skip_spaces:
    cmp byte ptr [rsi], ' '
    jne cpu_start

    inc rsi
    jmp skip_spaces

cpu_start:
    mov r12, rsi

find_end:
    cmp byte ptr [rsi], 0
    je cpu_print

    cmp byte ptr [rsi], 10
    je cpu_terminate

    inc rsi
    jmp find_end

cpu_terminate:
    mov byte ptr [rsi], 0

cpu_print:
    lea rsi, [rip + magenta]
    call print_z

    lea rsi, [rip + cpu_label]
    call print_z

    lea rsi, [rip + reset]
    call print_z

    mov rsi, r12
    call print_z

    lea rsi, [rip + newline]
    call print_z

cpu_done:
    pop r12
    ret
