.intel_syntax noprefix
.global print_cpu

.extern print_z
.extern find_string
.extern read_file

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

    lea rdi, [rip + cpu_path]
    lea rsi, [rip + cpu_buffer]
    mov edx, 8191
    call read_file

    test rax, rax
    jle cpu_done

    lea rsi, [rip + cpu_buffer]
    lea rdi, [rip + cpu_key]
    call find_string

    test rax, rax
    jz cpu_done

    lea rsi, [rax + 10]

find_colon:
    cmp byte ptr [rsi], 0
    je cpu_done

    cmp byte ptr [rsi], 10
    je cpu_done

    cmp byte ptr [rsi], ':'
    je cpu_found

    inc rsi
    jmp find_colon

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

    # write cpu name
    mov rsi, r12
    call print_z

    lea rsi, [rip + newline]
    call print_z

cpu_done:
    pop r12
    ret
