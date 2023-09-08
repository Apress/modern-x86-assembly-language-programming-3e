;------------------------------------------------------------------------------
; Ch06_06_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; int64_t AddIntegers_a(int8_t a, int16_t b, int32_t c, int64_t d,
;   int8_t e, int16_t f, int32_t g, int64_t h);
;------------------------------------------------------------------------------

; RBP offsets for temp variables on stack
TEMP_A  equ -8
TEMP_B  equ -16
TEMP_C  equ -24
TEMP_D  equ -32

STK_LOCAL   equ 32      ;storage space allocated on stack for temp variables

; RBP offsets for stack arguments
ARG_E   equ 64
ARG_F   equ 72
ARG_G   equ 80
ARG_H   equ 88

        .code
AddIntegers_a proc

; Function prologue (POC code - stack frame directives not included)
        push rbp
        push r14                            ;r14, r15 pushes for demo only
        push r15
        mov rbp,rsp
        sub rsp,STK_LOCAL

; Sign-extend and save a, b, c, and d on local stack
        movsx rcx,cl                        ;rcx = a
        mov [rbp+TEMP_A],rcx                ;save sign-extended a
        movsx rdx,dx                        ;rdx = b
        mov [rbp+TEMP_B],rdx                ;save sign-extended b
        movsxd r8,r8d                       ;r8 = c;
        mov [rbp+TEMP_C],r8                 ;save sign-extended c
        mov [rbp+TEMP_D],r9                 ;save d

; Sign-extend e, f, and g
        movsx rcx,byte ptr [rbp+ARG_E]      ;rcx = e
        movsx rdx,word ptr [rbp+ARG_F]      ;rdx = f
        movsxd r8,dword ptr [rbp+ARG_G]     ;r8 = g
        mov r9,qword ptr [rbp+ARG_H]        ;r9 = h

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

AddIntegers_a endp
        end
