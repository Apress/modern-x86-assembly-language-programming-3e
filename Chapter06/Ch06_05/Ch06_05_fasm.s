;------------------------------------------------------------------------------
; Ch06_05_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; int64_t MulIntegers_a(int8_t a, int16_t b, int32_t c, int64_t d,
;   int8_t e, int16_t f, int32_t g, int64_t h);
;------------------------------------------------------------------------------

; Offsets for red zone variables
RZ_A    equ -8
RZ_B    equ -16
RZ_C    equ -120
RZ_D    equ -128

; Offsets for stack arguments
ARG_G   equ 8
ARG_H   equ 16

        section .text

        global MulIntegers_a
MulIntegers_a:

; Sign-extend and save a, b, c, and d to red zone
        movsx rdi,dil                       ;rdi = a
        mov [rsp+RZ_A],rdi                  ;save sign-extended a
        movsx rsi,si                        ;rsi = b
        mov [rsp+RZ_B],rsi                  ;save sign-extended b
        movsxd rdx,edx                      ;rdx = c;
        mov [rsp+RZ_C],rdx                  ;save sign-extended c
        mov [rsp+RZ_D],rcx                  ;save d

; Calculate a * b * c * d * e * f * g * h
        movsx r8,r8b                        ;r8 = e
        movsx r9,r9w                        ;r9 = f
        movsxd r10,[rsp+ARG_G]              ;r10 = g
        mov r11,[rsp+ARG_H]                 ;r11 = h

        imul r8,[rsp+RZ_A]                  ;r8 = e * a
        imul r9,[rsp+RZ_B]                  ;r9 = f * b
        imul r10,[rsp+RZ_C]                 ;r10 = g * c
        imul r11,[rsp+RZ_D]                 ;r11 = h * d
        imul r8,r9                          ;r8 = e * a * f * b
        imul r10,r11                        ;r10 = g * c * h * d
        imul r8,r10                         ;r8 = e * a * f * b * g * c * h * d

        mov rax,r8                          ;rax = final product
        ret
