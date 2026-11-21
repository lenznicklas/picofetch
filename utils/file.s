.intel_syntax noprefix
.global read_file

.section .text

read_file:
    push r12
    push r13
    push r14

    mov r12, rsi
    mov r13, rdx

    test r13, r13
    jz file_invalid

    mov eax, 2
    xor esi, esi
    xor edx, edx
    syscall

    test rax, rax
    js file_done

    mov r14, rax

    mov eax, 0
    mov rdi, r14
    mov rsi, r12
    mov rdx, r13
    dec rdx
    syscall

    mov r13, rax

    mov eax, 3
    mov rdi, r14
    syscall

    mov rax, r13

    test rax, rax
    js file_done

    mov byte ptr [r12 + rax], 0
    jmp file_done

file_invalid:
    mov rax, -22

file_done:
    pop r14
    pop r13
    pop r12
    ret
