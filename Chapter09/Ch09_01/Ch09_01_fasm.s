;------------------------------------------------------------------------------
; Ch09_01 fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

        section .rdata
F64_AbsMask  dq 07fffffffffffffffh
F32_AbsMask  dd 07fffffffh

;------------------------------------------------------------------------------
; void PackedMathF32_avx(YmmVal* c, const YmmVal* a, const YmmVal* b);
;------------------------------------------------------------------------------

        section .text

        global PackedMathF32_avx
PackedMathF32_avx:

        vmovaps ymm0,[rsi]                  ;ymm0 = a
        vmovaps ymm1,[rdx]                  ;ymm1 = b

        vaddps ymm2,ymm0,ymm1               ;SPFP addition
        vmovaps [rdi],ymm2

        vsubps ymm2,ymm0,ymm1               ;SPFP subtraction
        vmovaps [rdi+32],ymm2

        vmulps ymm2,ymm0,ymm1               ;SPFP multiplication
        vmovaps [rdi+64],ymm2

        vdivps ymm2,ymm0,ymm1               ;SPFP division
        vmovaps [rdi+96],ymm2

        vminps ymm2,ymm0,ymm1               ;SPFP min
        vmovaps [rdi+128],ymm2
        
        vmaxps ymm2,ymm0,ymm1               ;SPFP max
        vmovaps [rdi+160],ymm2

        vsqrtps ymm2,ymm0                   ;SPFP sqrt(a)
        vmovaps [rdi+192],ymm2

        vbroadcastss ymm3,[F32_AbsMask]     ;load abs mask
        vandps ymm2,ymm3,ymm1               ;SPFP abs(b)
        vmovaps [rdi+224],ymm2

        vzeroupper                          ;clear upper YMM/ZMM bits
        ret

;------------------------------------------------------------------------------
; void PackedMathF64_avx(YmmVal c[8], const YmmVal* a, const YmmVal* b);
;------------------------------------------------------------------------------

        global PackedMathF64_avx
PackedMathF64_avx:

        vmovapd ymm0,[rsi]                  ;ymm0 = a
        vmovapd ymm1,[rdx]                  ;ymm1 = b

        vaddpd ymm2,ymm0,ymm1               ;DPFP addition
        vmovapd [rdi],ymm2

        vsubpd ymm2,ymm0,ymm1               ;DPFP subtraction
        vmovapd [rdi+32],ymm2

        vmulpd ymm2,ymm0,ymm1               ;DPFP multiplication
        vmovapd [rdi+64],ymm2

        vdivpd ymm2,ymm0,ymm1               ;DPFP division
        vmovapd [rdi+96],ymm2

        vminpd ymm2,ymm0,ymm1               ;DPFP min
        vmovapd [rdi+128],ymm2
        
        vmaxpd ymm2,ymm0,ymm1               ;DPFP max
        vmovapd [rdi+160],ymm2

        vsqrtpd ymm2,ymm0                   ;DPFP sqrt(a)
        vmovapd [rdi+192],ymm2

        vbroadcastsd ymm3,[F64_AbsMask]     ;load abs mask
        vandpd ymm2,ymm3,ymm1               ;DPFP abs(b)
        vmovapd [rdi+224],ymm2

        vzeroupper                          ;clear upper YMM/ZMM bits
        ret
