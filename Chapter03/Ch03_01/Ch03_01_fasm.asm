;------------------------------------------------------------------------------
; Ch03_01_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; int32_t SumValsI32_a(int32_t a, int32_t b, int32_t c, int32_t d, int32_t e,
;   int32_t f, int32_t g, int32_t h);
;------------------------------------------------------------------------------

        .code
SumValsI32_a proc

; Calculate a + b + c + d
        add ecx,edx                         ;ecx = a + b
        add r8d,r9d                         ;r8d = c + d
        add ecx,r8d                         ;ecx = a + b + c + d

; Calculate e + f + g + h
        mov eax,[rsp+40]                    ;eax = e
        add eax,[rsp+48]                    ;eax = e + f
        add eax,[rsp+56]                    ;eax = e + f + g
        add eax,[rsp+64]                    ;eax = e + f + g + h

;Calculate a + b + c + d + e + f + g + h
        add eax,ecx                         ;eax = final sum
        ret
SumValsI32_a endp

;------------------------------------------------------------------------------
; uint64_t MulValsU64_a(uint64_t a, uint64_t b, uint64_t c, uint64_t d,
;   int64_t e, uint64_t f, uint64_t g, uint64_t h);
;------------------------------------------------------------------------------

MulValsU64_a proc

; Calculate a * b * c * d * e * f * g * h
        mov rax,rcx                         ;rax = a
        mul rdx                             ;rax = a * b
        mul r8                              ;rax = a * b * c
        mul r9                              ;rax = a * b * c * d

        mul qword ptr [rsp+40]              ;rax = a * b * c * d * e
        mul qword ptr [rsp+48]              ;rax = a * b * c * d * e * f
        mul qword ptr [rsp+56]              ;rax = a * b * c * d * e * f * g
        mul qword ptr [rsp+64]              ;rax = final product

        ret
MulValsU64_a endp
        end
