;------------------------------------------------------------------------------
; Ch02_04_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; long long AddSubI64a_a(long long a, long long b, long long c, long long d);
;------------------------------------------------------------------------------

        .code
AddSubI64a_a proc

; Calculate (a + b) - (c + d) + 7
        add rcx,rdx                         ;rcx = a + b
        add r8,r9                           ;r8 = c + d
        sub rcx,r8                          ;rcx = (a + b) - (c + d)
        add rcx,7                           ;rcx = (a + b) - (c + d) + 7

        mov rax,rcx                         ;rax = final result

        ret                                 ;return to caller
AddSubI64a_a endp

;------------------------------------------------------------------------------
; long long AddSubI64b_a(long long a, long long b, long long c, long long d);
;------------------------------------------------------------------------------

AddSubI64b_a proc

; Calculate (a + b) - (c + d) + 12345678900
        add rcx,rdx                         ;rcx = a + b
        add r8,r9                           ;r8 = c + d
        sub rcx,r8                          ;rcx = (a + b) - (c + d)

        mov rax,12345678900                 ;rax = 12345678900
        add rax,rcx                         ;rax = (a + b) - (c + d) + 12345678900

        ret                                 ;return to caller
AddSubI64b_a endp
        end
