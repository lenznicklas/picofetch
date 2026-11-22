
.intel_syntax noprefix
.global print_disk

.extern print_z
.extern print_number
.extern print_progress

.extern magenta
.extern reset
.extern newline

.section .rodata
disk_path:  .asciz "/"
disk_label: .asciz "  Disk    "
slash:      .asciz " / "
unit:       .asciz " GiB"
dot:        .asciz "."

.section .bss
disk_info: .skip 120

.section .text

print_disk:
    push r12
    push r13
    push r14

    # -------------------------
    # statfs("/")
    # -------------------------

    mov eax, 137
    lea rdi, [rip + disk_path]
    lea rsi, [rip + disk_info]
    syscall

    test rax, rax
    js disk_done

    # -------------------------
    # Prozent berechnen
    # Wie df: used / (used + avail)
    # -------------------------

    # Used Blocks
    mov rax, [rip + disk_info + 16]
    sub rax, [rip + disk_info + 24]

    # Used + Available
    mov rcx, rax
    add rcx, [rip + disk_info + 32]

    test rcx, rcx
    jz disk_done

    # Used * 100
    mov r8d, 100
    mul r8

    # Durch Used + Available teilen
    div rcx

    # Aufrunden wie df
    test rdx, rdx
    jz percent_ready
    inc rax

percent_ready:
    mov r14, rax

    # -------------------------
    # Blockgröße bestimmen
    # -------------------------

    mov rcx, [rip + disk_info + 72]
    test rcx, rcx
    jnz size_ready

    mov rcx, [rip + disk_info + 8]

size_ready:
    # -------------------------
    # Used MiB berechnen
    # -------------------------

    mov rax, [rip + disk_info + 16]
    sub rax, [rip + disk_info + 24]

    # Blocks * Blockgröße
    mul rcx

    # Bytes -> MiB
    mov rcx, 1048576
    div rcx

    mov r12, rax

    # -------------------------
    # Total MiB berechnen
    # -------------------------

    mov rcx, [rip + disk_info + 72]
    test rcx, rcx
    jnz size_ready2

    mov rcx, [rip + disk_info + 8]

size_ready2:
    mov rax, [rip + disk_info + 16]
    mul rcx

    mov rcx, 1048576
    div rcx

    mov r13, rax

    # -------------------------
    # Ausgabe
    # -------------------------

    lea rsi, [rip + magenta]
    call print_z

    lea rsi, [rip + disk_label]
    call print_z

    lea rsi, [rip + reset]
    call print_z

    # Used GiB
    mov rax, r12
    call print_gib

    lea rsi, [rip + unit]
    call print_z

    # Separator
    lea rsi, [rip + slash]
    call print_z

    # Total GiB
    mov rax, r13
    call print_gib

    lea rsi, [rip + unit]
    call print_z

    # -------------------------
    # Progress Bar
    # -------------------------

    mov rax, r14
    call print_progress

    lea rsi, [rip + newline]
    call print_z

disk_done:
    pop r14
    pop r13
    pop r12
    ret


# -------------------------
# print_gib
# Input: RAX = MiB
# Ausgabe: X.Y
# -------------------------

print_gib:
    # Auf Zehntel GiB umrechnen
    imul rax, rax, 10
    add rax, 512

    xor edx, edx
    mov ecx, 1024
    div rcx

    # Ganze GiB und Nachkommastelle
    xor edx, edx
    mov ecx, 10
    div rcx

    # Nachkommastelle sichern
    push rdx

    # Ganze GiB ausgeben
    call print_number

    # Dezimalpunkt
    lea rsi, [rip + dot]
    call print_z

    # Nachkommastelle
    pop rax
    call print_number

    ret
