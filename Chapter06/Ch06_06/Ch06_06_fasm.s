;------------------------------------------------------------------------------
; Ch06_06_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; int64_t AddIntegers_a(int8_t a, int16_t b, int32_t c, int64_t d,
;   int8_t e, int16_t f, int32_t g, int64_t h);
;------------------------------------------------------------------------------

; RBP offsets for temp variables on stack
TEMP_A      equ -8
TEMP_B      equ -16
TEMP_C      equ -24
TEMP_D      equ -32

STK_LOCAL   equ 32      ;storage space allocated on stack for temp variables

; RBP offsets for stack arguments
ARG_G   equ 32
ARG_H   equ 40

        section .text

        global AddIntegers_a
AddIntegers_a:

; Function prologue
        push rbp                            ;save callers RBP
        push r14                            ;r14, r15 pushes for demo only
        push r15
        mov rbp,rsp
        sub rsp,STK_LOCAL                   ;allocate STK_LOCAL bytes on stack

; Sign-extend and save a, b, c, and d on stack
        movsx rdi,dil                       ;rdi = a
        mov [rbp+TEMP_A],rdi                ;save sign-extended a
        movsx rsi,si                        ;rsi = b
        mov [rbp+TEMP_B],rsi                ;save sign-extended b
        movsxd rdx,edx                      ;rdx = c;
        mov [rbp+TEMP_C],rdx                ;save sign-extended c
        mov [rbp+TEMP_D],rcx                ;save d

; Sign-extend e, f, and g
        movsx rcx,r8b                       ;rcx = e
        movsx rdx,r9w                       ;rdx = f
        movsxd r8,[rbp+ARG_G]               ;r8 = g
        mov r9,[rbp+ARG_H]                  ;r9 = h

; Calculate a + b + c + d + e + f + g + h
        add rcx,[rbp+TEMP_A]                ;rcx = e + a
        add rdx,[rbp+TEMP_B]                ;rdx = f + b
        add r8,[rbp+TEMP_C]                 ;rdx = g + c
        add r9,[rbp+TEMP_D]                 ;rdx = h + d
        add rcx,rdx                         ;rcx = e + a + f + b
        add r8,r9                           ;r8 = g + c + h + d
        add rcx,r8                          ;rcx = e + a + f + b + g + c + h + d
        mov rax,rcx                         ;rax = final product

; Function epilogue
        mov rsp,rbp                         ;release local storage
        pop r15
        pop r14
        pop rbp                             ;restore non-volatile GPRs
        ret
