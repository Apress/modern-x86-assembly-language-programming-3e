;------------------------------------------------------------------------------
; Ch08_03.fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; void AndU16_avx(XmmVal* c, const XmmVal* a, const XmmVal* b);
;------------------------------------------------------------------------------

        section .text

        global AndU16_avx
AndU16_avx:

        vmovdqa xmm0,[rsi]                  ;xmm0 = a
        vpand xmm1,xmm0,[rdx]               ;xmm1 = a & b
        vmovdqa [rdi],xmm1                  ;save result
        ret

;------------------------------------------------------------------------------
; void OrU16_avx(XmmVal* c, const XmmVal* a, const XmmVal* b);
;------------------------------------------------------------------------------

        global OrU16_avx
OrU16_avx:

        vmovdqa xmm0,[rsi]                  ;xmm0 = a
        vpor xmm1,xmm0,[rdx]                ;xmm1 = a | b
        vmovdqa [rdi],xmm1                  ;save result
        ret

;------------------------------------------------------------------------------
; void XorU16_avx(XmmVal* c, const XmmVal* a, const XmmVal* b);
;------------------------------------------------------------------------------

        global XorU16_avx
XorU16_avx:

        vmovdqa xmm0,[rsi]                  ;xmm0 = a
        vpxor xmm1,xmm0,[rdx]               ;xmm1 = a ^ b
        vmovdqa [rdi],xmm1                  ;save result
        ret
