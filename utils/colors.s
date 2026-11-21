.intel_syntax noprefix

.global red
.global green
.global yellow
.global blue
.global magenta
.global cyan
.global white
.global reset
.global newline

.section .rodata
red:       .asciz "\033[31m"
green:     .asciz "\033[32m"
yellow:    .asciz "\033[33m"
blue:      .asciz "\033[34m"
magenta:   .asciz "\033[35m"
cyan:      .asciz "\033[36m"
white:     .asciz "\033[37m"
reset:     .asciz "\033[0m"
newline:   .asciz "\n"
