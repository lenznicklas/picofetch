.intel_syntax noprefix
.global _start

.extern print_z
.extern print_system
.extern print_uptime
.extern print_memory
.extern print_cpu

.section .rodata
logo:       .asciz " /\\   /\\  PicoFetch\n"
logo_2:     .asciz "/  \\ /  \\ ---------\n"
cyan:       .asciz "\033[36m"
reset:      .asciz "\033[0m"
newline:    .asciz "\n"

.section .text
_start:
    lea rsi, [rip + cyan]
    call print_z

    lea rsi, [rip + logo]
    call print_z
    lea rsi, [rip + logo_2]
    call print_z

    lea rsi, [rip + reset]
    call print_z

    lea rsi, [rip + newline]
    call print_z

    call print_system
    call print_uptime
    call print_memory
    call print_cpu

    mov eax, 60
    xor edi, edi
    syscall
