;------------------------------------------------------------------------------
; Ch06_05_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; int64_t MulIntegers_a(int8_t a, int16_t b, int32_t c, int64_t d,
;   int8_t e, int16_t f, int32_t g, int64_t h);
;------------------------------------------------------------------------------

; Offsets for red zone variables (simulated using home area)
RZ_A    equ 8
RZ_B    equ 16
RZ_C    equ 24
RZ_D    equ 32

; Offsets for stack arguments
ARG_E   equ 40
ARG_F   equ 48
ARG_G   equ 56
ARG_H   equ 64

        .code
MulIntegers_a proc

; Sign-extend and save a, b, c, and d to red zone
        movsx rcx,cl                        ;rcx = a
        mov [rsp+RZ_A],rcx                  ;save sign-extended a
        movsx rdx,dx                        ;rdx = b
        mov [rsp+RZ_B],rdx                  ;save sign-extended b
        movsxd r8,r8d                       ;r8 = c;
        mov [rsp+RZ_C],r8                   ;save sign-extended c
        mov [rsp+RZ_D],r9                   ;save d

; Calculate a * b * c * d * e * f * g * h
        movsx rcx,byte ptr [rsp+ARG_E]      ;rcx = e
        movsx rdx,word ptr [rsp+ARG_F]      ;rdx = f
        movsxd r8,dword ptr [rsp+ARG_G]     ;r8 = g
        mov r9,[rsp+ARG_H]                  ;r9 = h

        imul rcx,[rsp+RZ_A]                 ;rcx = e * a
        imul rdx,[rsp+RZ_B]                 ;rdx = f * b
        imul r8,[rsp+RZ_C]                  ;rdx = g * c
        imul r9,[rsp+RZ_D]                  ;rdx = h * d

        imul rcx,rdx                        ;rcx = e * a * f * b
        imul r8,r9                          ;r8 = g * c * h * d
        imul rcx,r8                         ;rcx = e * a * f * b * g * c * h * d
        mov rax,rcx                         ;rax = final product
        ret

MulIntegers_a endp
        end
