;------------------------------------------------------------------------------
; Ch02_01_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
;int AddSubI32_a(int a, int b, int c, int d);
;------------------------------------------------------------------------------

        .code
AddSubI32_a proc

; Calculate (a + b) - (c + d) + 7
        add ecx,edx                         ;ecx = a + b
        add r8d,r9d                         ;r8d = c + d
        sub ecx,r8d                         ;ecx = (a + b) - (c + d)
        add ecx,7                           ;ecx = (a + b) - (c + d) + 7

        mov eax,ecx                         ;eax = final result

        ret                                 ;return to caller

AddSubI32_a endp
        end
