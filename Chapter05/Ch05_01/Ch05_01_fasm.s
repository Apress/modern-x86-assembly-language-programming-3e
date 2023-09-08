;------------------------------------------------------------------------------
; Ch05_01_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

                section .rdata
F32_ScaleFtoC   dd 0.55555556                ;5 / 9
F32_ScaleCtoF   dd 1.8                       ;9 / 5
F32_32p0        dd 32.0

;------------------------------------------------------------------------------
; float ConvertFtoC_avx(float deg_f);
;------------------------------------------------------------------------------

        section .text

        global ConvertFtoC_avx
ConvertFtoC_avx:
        vmovss xmm1,[F32_32p0]              ;xmm1 = 32
        vsubss xmm2,xmm0,xmm1               ;xmm2 = f - 32

        vmovss xmm1,[F32_ScaleFtoC]         ;xmm1 = 5 / 9
        vmulss xmm0,xmm2,xmm1               ;xmm0 = (f - 32) * 5 / 9
        ret

;------------------------------------------------------------------------------
; float ConvertCtoF_avx(float deg_c);
;------------------------------------------------------------------------------

        global ConvertCtoF_avx
ConvertCtoF_avx:
        vmulss xmm0,xmm0,[F32_ScaleCtoF]     ;xmm0 = c * 9 / 5
        vaddss xmm0,xmm0,[F32_32p0]          ;xmm0 = c * 9 / 5 + 32
        ret
