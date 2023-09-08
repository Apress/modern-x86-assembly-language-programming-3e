;------------------------------------------------------------------------------
; Ch02_01_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; int AddSubI32_a(int a, int b, int c, int d);
;------------------------------------------------------------------------------

        section .text

        global AddSubI32_a
AddSubI32_a:

; Calculate (a + b) - (c + d) + 7
        add edi,esi                         ;edi = a + b
        add edx,ecx                         ;edx = c + d
        sub edi,edx                         ;edi = (a + b) - (c + d)
        add edi,7                           ;edi = (a + b) - (c + d) + 7

        mov eax,edi                         ;eax = final result

        ret                                 ;return to caller
