.intel_syntax noprefix
.global print_system
.extern print_z
.extern blue
.extern reset
.extern newline

.section .rodata
os_label:   .asciz "  OS      "
host_label: .asciz "  Host    "
kern_label: .asciz "  Kernel  "

.section .bss
sys_info:   .skip 390

.section .text
print_system:
    mov eax, 63
    lea rdi, [rip + sys_info]
    syscall

    test rax, rax
    js system_done

    lea rsi, [rip + blue]
    call print_z
    lea rsi, [rip + os_label]
    call print_z
    lea rsi, [rip + reset]
    call print_z
    lea rsi, [rip + sys_info]
    call print_z
    lea rsi, [rip + newline]
    call print_z

    lea rsi, [rip + blue]
    call print_z
    lea rsi, [rip + host_label]
    call print_z
    lea rsi, [rip + reset]
    call print_z
    lea rsi, [rip + sys_info + 65]
    call print_z
    lea rsi, [rip + newline]
    call print_z

    lea rsi, [rip + blue]
    call print_z
    lea rsi, [rip + kern_label]
    call print_z
    lea rsi, [rip + reset]
    call print_z
    lea rsi, [rip + sys_info + 130]
    call print_z
    lea rsi, [rip + newline]
    call print_z

system_done:
    ret
