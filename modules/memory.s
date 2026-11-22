
.intel_syntax noprefix
.global print_memory

.extern print_z
.extern print_number
.extern print_progress

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
    push r12
    push r13
    push r14

    # sysinfo()
    mov eax, 99
    lea rdi, [rip + mem_info]
    syscall

    test rax, rax
    js memory_done

    # -------------------------
    # Belegten RAM berechnen
    # -------------------------

    # Total - Free
    mov rax, [rip + mem_info + 32]
    sub rax, [rip + mem_info + 40]

    # mem_unit berücksichtigen
    mov ecx, [rip + mem_info + 104]
    imul rax, rcx

    # Bytes -> MiB
    xor edx, edx
    mov ecx, 1048576
    div rcx

    # Used MiB
    mov r12, rax

    # -------------------------
    # Gesamten RAM berechnen
    # -------------------------

    mov rax, [rip + mem_info + 32]

    mov ecx, [rip + mem_info + 104]
    imul rax, rcx

    xor edx, edx
    mov ecx, 1048576
    div rcx

    # Total MiB
    mov r13, rax

    # -------------------------
    # Prozent berechnen
    # -------------------------

    test r13, r13
    jz memory_done

    # Used * 100 / Total
    imul rax, r12, 100

    xor edx, edx
    div r13

    # Prozent sichern
    mov r14, rax

    # -------------------------
    # Ausgabe
    # -------------------------

    lea rsi, [rip + magenta]
    call print_z

    lea rsi, [rip + mem_label]
    call print_z

    lea rsi, [rip + reset]
    call print_z

    # Used
    mov rax, r12
    call print_number

    lea rsi, [rip + unit]
    call print_z

    # Separator
    lea rsi, [rip + slash]
    call print_z

    # Total
    mov rax, r13
    call print_number

    lea rsi, [rip + unit]
    call print_z

    # -------------------------
    # Progress Bar
    # -------------------------

    mov rax, r14
    call print_progress

    lea rsi, [rip + newline]
    call print_z

memory_done:
    pop r14
    pop r13
    pop r12
    ret
