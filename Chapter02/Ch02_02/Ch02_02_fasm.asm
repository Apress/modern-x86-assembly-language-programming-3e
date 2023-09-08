;------------------------------------------------------------------------------
; Ch02_02_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; unsigned int BitOpsU32_a(unsigned int a, unsigned int b, unsigned int c,
;   unsigned int d);
;------------------------------------------------------------------------------

        .code
BitOpsU32_a proc

; Calculate ~(((a & b) | c ) ^ d)
        and ecx,edx                         ;ecx = a & b
        or ecx,r8d                          ;ecx = (a & b) | c
        xor ecx,r9d                         ;ecx = ((a & b) | c) ^ d
        not ecx                             ;ecx = ~(((a & b) | c ) ^ d)

        mov eax,ecx                         ;eax = final result
        ret                                 ;return to caller

BitOpsU32_a endp
        end
