.intel_syntax noprefix
.global _start

.extern print_z
.extern print_system
.extern print_uptime
.extern print_memory
.extern print_cpu
.extern print_disk
.extern cyan
.extern newline

.section .rodata
logo:       .asciz " /\\   /\\  PicoFetch\n"
logo_2:     .asciz "/  \\ /  \\ ━━━━━━━━━━━━\n"

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

    lea rsi, [rip + newline]
    call print_z

    call print_cpu
    call print_memory
    call print_disk

    mov eax, 60
    xor edi, edi
    syscall
