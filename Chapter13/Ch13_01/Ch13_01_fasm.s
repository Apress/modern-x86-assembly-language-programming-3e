;------------------------------------------------------------------------------
; Ch13_01_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; void MathI16_Aavx512(ZmmVal* c, const ZmmVal* a, const ZmmVal* b);
;------------------------------------------------------------------------------

        section .text

        global MathI16_avx512
MathI16_avx512:

        vmovdqa64 zmm0,[rsi]                ;load a values
        vmovdqa64 zmm1,[rdx]                ;load b values

        vpaddw zmm2,zmm0,zmm1               ;packed addition - wraparound
        vmovdqa64 [rdi],zmm2                ;save result

        vpaddsw zmm2,zmm0,zmm1              ;packed addition - saturated
        vmovdqa64 [rdi+64],zmm2             ;save result

        vpsubw zmm2,zmm0,zmm1               ;packed subtraction - wraparound
        vmovdqa64 [rdi+128],zmm2            ;save result

        vpsubsw zmm2,zmm0,zmm1              ;packed subtraction - saturated
        vmovdqa64 [rdi++192],zmm2           ;save result

        vpminsw zmm2,zmm0,zmm1              ;packed min values
        vmovdqa64 [rdi+256],zmm2            ;save result

        vpmaxsw zmm2,zmm0,zmm1              ;packed max values
        vmovdqa64 [rdi+320],zmm2            ;save result

        vzeroupper                          ;clear upper YMM/ZMM bits
        ret

;------------------------------------------------------------------------------
; void MathI64_avx512(ZmmVal* c, const ZmmVal* a, const ZmmVal* b);
;------------------------------------------------------------------------------

        global MathI64_avx512
MathI64_avx512:

        vmovdqa64 zmm16,[rsi]               ;load a values
        vmovdqa64 zmm17,[rdx]               ;load b values

        vpaddq zmm18,zmm16,zmm17            ;packed qword addition
        vmovdqa64 [rdi],zmm18               ;save result

        vpsubq zmm18,zmm16,zmm17            ;packed qword subtraction
        vmovdqa64 [rdi+64],zmm18            ;save result

        vpmullq zmm18,zmm16,zmm17           ;packed qword multiplication
        vmovdqa64 [rdi+128],zmm18           ;save products (low 64-bits)

        vpsllvq zmm18,zmm16,zmm17           ;packed qword shift left
        vmovdqa64 [rdi+192],zmm18           ;save result

        vpsravq zmm18,zmm16,zmm17           ;packed qword shift right
        vmovdqa64 [rdi+256],zmm18           ;save result

        vpabsq zmm18,zmm16                  ;packed qword abs (a values)
        vmovdqa64 [rdi+320],zmm18           ;save result

        ret                                 ;vzeroupper not needed
