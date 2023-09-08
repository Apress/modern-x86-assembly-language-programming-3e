;------------------------------------------------------------------------------
; Ch03_02_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; int64_t CalcResultI64_a(int8_t a, int16_t b, int32_t c, int64_t d,
;   int8_t e, int16_t f, int32_t g, int64_t h);
;------------------------------------------------------------------------------

        section .text

        global CalcResultI64_a
CalcResultI64_a:

; Calculate a * b * c * d
        movsx rax,dil                       ;rax = a
        movsx r10,si                        ;r10 = b
        imul rax,r10                        ;rax = a * b
        movsxd r10,edx                      ;r10 = c
        imul r10,rcx                        ;r10 = c * d
        imul rax,r10                        ;rax = a * b * c * d

; Calculate e * f * g * h
        movsx r10,r8b                       ;r10 = e
        movsx r11,r9w                       ;r11 = f
        imul r10,r11                        ;r10 = e * f
        movsxd r11,dword [rsp+8]            ;r11 = g
        imul r11,[rsp+16]                   ;r11 = g * h
        imul r10,r11                        ;r10 = e * f * g * h

; Calculate (a * b * c * d) + (e * f * g * h)
        add rax,r10                         ;rax = final result
        ret

;------------------------------------------------------------------------------
; void CalcResultU64_a(uint8_t a, uint16_t b, uint32_t c, uint64_t d,
;   uint8_t e, uint16_t f, uint32_t g, uint64_t h, uint64_t* quo, uint64_t* rem);
;------------------------------------------------------------------------------

        global CalcResultU64_a
CalcResultU64_a:

; Calculate a + b + c + d
        movzx rax,dil                       ;rax = a
        movzx r10,si                        ;r10 = b
        add rax,r10                         ;rax = a + b
        mov r11d,edx                        ;r11 = c
        add r11,rcx                         ;r11 = c + d
        add rax,r11                         ;rax = a + b + c + d

; Calculate e + f + g + h
        movzx r10,r8b                       ;r10 = e
        movzx r11,r9w                       ;r11 = f
        add r10,r11                         ;r10 = e + f
        mov r11d,[rsp+8]                    ;r11 = g
        add r11,[rsp+16]                    ;r11 = g + h;
        add r10,r11                         ;r10 = e + f + g + h

; Calculate (a + b + c + d) / (e + f + g + h)
; (no check for division by zero)
        xor edx,edx                         ;rdx:rax = a + b + c + d
        div r10                             ;rdx:rax = rdx:rax / r10

; Save results
        mov rcx,[rsp+24]
        mov [rcx],rax                       ;save quotient
        mov rcx,[rsp+32]
        mov [rcx],rdx                       ;save remainder

        ret
