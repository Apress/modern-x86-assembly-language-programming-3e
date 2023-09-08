;------------------------------------------------------------------------------
; Ch02_04_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; long long AddSubI64a_a(long long a, long long b, long long c, long long d);
;------------------------------------------------------------------------------

        section .text

        global AddSubI64a_a
AddSubI64a_a:

; Calculate (a + b) - (c + d) + 7
        add rdi,rsi                         ;rdi = a + b
        add rdx,rcx                         ;rdx = c + d
        sub rdi,rdx                         ;rdi = (a + b) - (c + d)
        add rdi,7                           ;rdi = (a + b) - (c + d) + 7

        mov rax,rdi                         ;rax = final result

        ret                                 ;return to caller

;------------------------------------------------------------------------------
; long long AddSubI64b_a(long long a, long long b, long long c, long long d);
;------------------------------------------------------------------------------

        global AddSubI64b_a
AddSubI64b_a:

; Calculate (a + b) - (c + d) + 12345678900
        add rdi,rsi                         ;rdi = a + b
        add rdx,rcx                         ;rdx = c + d
        sub rdi,rdx                         ;rdi = (a + b) - (c + d)

        mov rax,12345678900                 ;rax = 12345678900
        add rax,rdi                         ;rax = (a + b) - (c + d) + 12345678900

        ret                                 ;return to caller
