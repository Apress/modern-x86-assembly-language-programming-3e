;------------------------------------------------------------------------------
; Ch03_01_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; int32_t SumValsI32_a(int32_t a, int32_t b, int32_t c, int32_t d,
;   int32_t e, int32_t f, int32_t g, int32_t h);
;------------------------------------------------------------------------------

        section .text

        global SumValsI32_a
SumValsI32_a:

; Calculate a + b + c + d
        add edi,esi                         ;edi = a + b
        add edx,ecx                         ;edx = c + d
        add edi,edx                         ;edi = a + b + c + d

; Calculate e + f + g + h
        add r8d,r9d                         ;r8d = e + f
        mov eax,[rsp+8]                     ;eax = g
        add eax,[rsp+16]                    ;eax = g + h
        add eax,r8d                         ;eax = e + f + g + h

;Calculate a + b + c + d + e + f + g + h
        add eax,edi                         ;eax = final sum
        ret

;------------------------------------------------------------------------------
; uint64_t MulValsU64_a(uint64_t a, uint64_t b, uint64_t c, uint64_t d,
;   uint64_t e, uint64_t f, uint64_t g, uint64_t h);
;------------------------------------------------------------------------------

        global MulValsU64_a
MulValsU64_a:

; Calculate a * b * c * d * e * f * g * h
        mov r10,rdx                         ;save copy of c
        mov rax,rdi                         ;rax = a
        mul rsi                             ;rax = a * b
        mul r10                             ;rax = a * b * c
        mul rcx                             ;rax = a * b * c * d
        mul r8                              ;rax = a * b * c * d * e
        mul r9                              ;rax = a * b * c * d * e * f

        mul qword [rsp+8]                   ;rax = a * b * c * d * e * f * g
        mul qword [rsp+16]                  ;rax = final product

        ret
