;------------------------------------------------------------------------------
; Ch08_04.fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; void SllU16_avx(XmmVal* c, const XmmVal* a, uint32_t count);
;------------------------------------------------------------------------------

        section .text

        global SllU16_avx
SllU16_avx:
        vmovdqa xmm0,[rsi]                  ;xmm0 = a
        vmovd xmm1,edx                      ;xmm1[31:0] = count

        vpsllw xmm2,xmm0,xmm1               ;left shift word elements of a

        vmovdqa [rdi],xmm2                  ;save result
        ret

;------------------------------------------------------------------------------
; void SrlU16_Aavx(XmmVal* c, const XmmVal* a, uint32_t count);
;------------------------------------------------------------------------------

        global SrlU16_avx
SrlU16_avx:
        vmovdqa xmm0,[rsi]                  ;xmm0 = a
        vmovd xmm1,edx                      ;xmm1[31:0] = count

        vpsrlw xmm2,xmm0,xmm1               ;right shift word elements of a

        vmovdqa [rdi],xmm2                  ;save result
        ret

;------------------------------------------------------------------------------
; void SraU16_Aavx(XmmVal* c, const XmmVal* a, uint32_t count);
;------------------------------------------------------------------------------

        global SraU16_avx
SraU16_avx:
        vmovdqa xmm0,[rsi]                  ;xmm0 = a
        vmovd xmm1,edx                      ;xmm1[31:0] = count

        vpsraw xmm2,xmm0,xmm1               ;right shift word elements of a

        vmovdqa [rdi],xmm2                  ;save result
        ret
