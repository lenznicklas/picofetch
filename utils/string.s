.intel_syntax noprefix

.global find_string

.section .text

find_string:
    mov r8, rsi

search_loop:
    cmp byte ptr [r8], 0
    je not_found

    mov r9, r8
    mov r10, rdi

compare_loop:
    cmp byte ptr [r10], 0
    je found

    cmp byte ptr [r9], 0
    je not_found

    mov al, [r9]
    cmp al, [r10]
    jne next_position

    inc r9
    inc r10
    jmp compare_loop

next_position:
    inc r8
    jmp search_loop

found:
    mov rax, r8
    ret

not_found:
    xor eax, eax
    ret
