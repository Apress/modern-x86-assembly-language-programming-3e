;------------------------------------------------------------------------------
; Ch08_03_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; void AndU16_avx(XmmVal* c, const XmmVal* a, const XmmVal* b);
;------------------------------------------------------------------------------

        .code
AndU16_avx proc
        vmovdqa xmm0,xmmword ptr [rdx]      ;xmm0 = a
        vpand xmm1,xmm0,[r8]                ;xmm1 = a & b
        vmovdqa xmmword ptr [rcx],xmm1      ;save result
        ret
AndU16_avx endp

;------------------------------------------------------------------------------
; void OrU16_avx(XmmVal* c, const XmmVal* a, const XmmVal* b);
;------------------------------------------------------------------------------

OrU16_avx proc
        vmovdqa xmm0,xmmword ptr [rdx]      ;xmm0 = a
        vpor xmm1,xmm0,[r8]                 ;xmm1 = a | b
        vmovdqa xmmword ptr [rcx],xmm1      ;save result
        ret
OrU16_avx endp

;------------------------------------------------------------------------------
; void XorU16_avx(XmmVal* c, const XmmVal* a, const XmmVal* b);
;------------------------------------------------------------------------------

XorU16_avx proc
        vmovdqa xmm0,xmmword ptr [rdx]      ;xmm0 = a
        vpxor xmm1,xmm0,[r8]                ;xmm1 = a ^ b
        vmovdqa xmmword ptr [rcx],xmm1      ;save result
        ret
XorU16_avx endp
        end
