.intel_syntax noprefix
.global print_uptime

.extern print_z
.extern print_number
.extern blue
.extern reset
.extern newline

.section .rodata
uptime_label: .asciz "  Uptime  "
hour_suffix: .asciz "h "
min_suffix:  .asciz "min"

.section .bss
up_info: .skip 112

.section .text
print_uptime:
    mov eax, 99
    lea rdi, [rip + up_info]
    syscall

    test rax, rax
    js uptime_done

    # load seconds
    mov rax, [rip + up_info]

    # s => min
    xor edx, edx
    mov rcx, 60
    div rcx

    # min => h
    xor edx, edx
    div rcx

    # save results
    push rdx
    push rax

    # label
    lea rsi, [rip + blue]
    call print_z
    lea rsi, [rip + uptime_label]
    call print_z
    lea rsi, [rip + reset]
    call print_z

    pop rax
    call print_number

    lea rsi, [rip + hour_suffix]
    call print_z

    pop rax
    call print_number

    lea rsi, [rip + min_suffix]
    call print_z

    lea rsi, [rip + newline]
    call print_z

uptime_done:
    ret
