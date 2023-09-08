;------------------------------------------------------------------------------
; Ch08_01_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; void AddI16_avx(XmmVal* c1, XmmVal* c2, const XmmVal* a, const XmmVal* b);
;------------------------------------------------------------------------------

        section .text

        global AddI16_avx
AddI16_avx:

        vmovdqa xmm0,[rdx]                  ;xmm0 = a
        vmovdqa xmm1,[rcx]                  ;xmm1 = b

        vpaddw xmm2,xmm0,xmm1               ;packed add - wraparound
        vpaddsw xmm3,xmm0,xmm1              ;packed add - saturated

        vmovdqa [rdi],xmm2                  ;save c1
        vmovdqa [rsi],xmm3                  ;save c2
        ret

;------------------------------------------------------------------------------
; void SubI16_avx(XmmVal* c1, XmmVal* c2, const XmmVal* a, const XmmVal* b);
;------------------------------------------------------------------------------

        global SubI16_avx
SubI16_avx:

        vmovdqa xmm0,[rdx]                  ;xmm0 = a
        vmovdqa xmm1,[rcx]                  ;xmm1 = b

        vpsubw xmm2,xmm0,xmm1               ;packed sub - wraparound
        vpsubsw xmm3,xmm0,xmm1              ;packed sub - saturated

        vmovdqa [rdi],xmm2                  ;save c1
        vmovdqa [rsi],xmm3                  ;save c2
        ret
