;------------------------------------------------------------------------------
; Ch10_01_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; void MathI16_avx2(YmmVal c[6], const YmmVal* a, const YmmVal* b);
;------------------------------------------------------------------------------

        section .text

        global MathI16_avx2
MathI16_avx2:

        vmovdqa ymm0,[rsi]                  ;ymm0 = a
        vmovdqa ymm1,[rdx]                  ;ymm1 = b

        vpaddw ymm2,ymm0,ymm1               ;packed addition - wraparound
        vmovdqa [rdi],ymm2

        vpaddsw ymm2,ymm0,ymm1              ;packed addition - saturated
        vmovdqa [rdi+32],ymm2

        vpsubw ymm2,ymm0,ymm1               ;packed subtraction - wraparound
        vmovdqa [rdi+64],ymm2

        vpsubsw ymm2,ymm0,ymm1              ;packed subtraction - saturated
        vmovdqa [rdi+96],ymm2

        vpminsw ymm2,ymm0,ymm1              ;packed minimum
        vmovdqa [rdi+128],ymm2

        vpmaxsw ymm2,ymm0,ymm1              ;packed maximum
        vmovdqa [rdi+160],ymm2

        vzeroupper
        ret

;------------------------------------------------------------------------------
; void MathI32_avx2(YmmVal c[6], const YmmVal* a, const YmmVal* b);
;------------------------------------------------------------------------------

        global MathI32_avx2
MathI32_avx2:
        vmovdqa ymm0,[rsi]                  ;ymm0 = a
        vmovdqa ymm1,[rdx]                  ;ymm1 = b

        vpaddd ymm2,ymm0,ymm1               ;packed addition
        vmovdqa [rdi],ymm2

        vpsubd ymm2,ymm0,ymm1               ;packed subtraction
        vmovdqa [rdi+32],ymm2

        vpmulld ymm2,ymm0,ymm1              ;packed multiplication (low result)
        vmovdqa [rdi+64],ymm2

        vpsllvd ymm2,ymm0,ymm1              ;packed shift left logical
        vmovdqa [rdi+96],ymm2

        vpsravd ymm2,ymm0,ymm1              ;packed shift right arithmetic
        vmovdqa [rdi+128],ymm2

        vpabsd ymm2,ymm0                    ;packed absolute value
        vmovdqa [rdi+160],ymm2

        vzeroupper
        ret
