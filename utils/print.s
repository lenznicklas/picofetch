.intel_syntax noprefix

.global print_z

.section .text
print_z:
    xor edx, edx

count_chars:
    cmp byte ptr [rsi + rdx], 0
    je write_text
    inc rdx
    jmp count_chars

write_text:
    mov eax, 1
    mov edi, 1
    syscall
    ret
