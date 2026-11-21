.intel_syntax noprefix
.global print_disk

.extern print_z
.extern print_number

.extern magenta
.extern reset
.extern newline

.section .rodata
disk_path:  .asciz "/"
disk_label: .asciz "  Disk    "
slash:      .asciz " / "
unit:       .asciz " GiB"
percent_l:  .asciz " ("
percent_r:  .asciz "%)"
dot:        .asciz "."

.section .bss
disk_info: .skip 120

.section .text

print_disk:
    push r12
    push r13
    push r14

    # statfs
    mov eax, 137
    lea rdi, [rip + disk_path]
    lea rsi, [rip + disk_info]
    syscall

    test rax, rax
    js disk_done

    mov rax, [rip + disk_info + 16]
    sub rax, [rip + disk_info + 24]

    mov rcx, rax
    add rcx, [rip + disk_info + 32]

    test rcx, rcx
    jz disk_done

    mov r8, 100
    mul r8

    div rcx
    test rdx, rdx
    jz percent_ready
    inc rax

percent_ready:
    mov r14, rax

    mov rax, [rip + disk_info + 16]
    sub rax, [rip + disk_info + 24]

    mov rcx, [rip + disk_info + 8]
    mul rcx

    mov rcx, 1048576
    div rcx

    mov r12, rax

    mov rax, [rip + disk_info + 16]

    mov rcx, [rip + disk_info + 8]
    mul rcx

    mov rcx, 1048576
    div rcx

    mov r13, rax

    lea rsi, [rip + magenta]
    call print_z
    lea rsi, [rip + disk_label]
    call print_z
    lea rsi, [rip + reset]
    call print_z

    mov rax, r12
    call print_gib

    lea rsi, [rip + unit]
    call print_z

    lea rsi, [rip + slash]
    call print_z

    mov rax, r13
    call print_gib

    lea rsi, [rip + unit]
    call print_z

    lea rsi, [rip + percent_l]
    call print_z

    mov rax, r14
    call print_number

    lea rsi, [rip + percent_r]
    call print_z

    lea rsi, [rip + newline]
    call print_z

disk_done:
    pop r14
    pop r13
    pop r12
    ret

print_gib:
    imul rax, rax, 10
    add rax, 512

    xor edx, edx
    mov rcx, 1024
    div rcx

    xor edx, edx
    mov rcx, 10
    div rcx

    push rdx

    call print_number

    lea rsi, [rip + dot]
    call print_z

    pop rax
    call print_number

    ret
