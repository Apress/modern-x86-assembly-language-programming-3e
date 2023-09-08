;------------------------------------------------------------------------------
; Ch14_01_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

            section .rdata
F64_AbsMask  dq     07fffffffffffffffh
F32_AbsMask  dd     07fffffffh

;------------------------------------------------------------------------------
; void PackedMathF32_avx512(ZmmVal* c], const ZmmVal* a, const ZmmVal* b);
;------------------------------------------------------------------------------

        section .text

        global PackedMathF32_avx512
PackedMathF32_avx512:

        vmovaps zmm0,[rsi]                  ;zmm0 = a
        vmovaps zmm1,[rdx]                  ;zmm1 = b

        vaddps zmm2,zmm0,zmm1               ;F32 addition
        vmovaps [rdi],zmm2

        vaddps zmm2,zmm0,zmm1,{rd-sae}      ;F32 addition (round down toward -inf)
        vmovaps [rdi+64],zmm2

        vsubps zmm2,zmm0,zmm1               ;F32 subtraction
        vmovaps [rdi+128],zmm2

        vmulps zmm2,zmm0,zmm1               ;F32 multiplication
        vmovaps [rdi+192],zmm2

        vdivps zmm2,zmm0,zmm1               ;F32 division
        vmovaps [rdi+256],zmm2

        vminps zmm2,zmm0,zmm1               ;F32 min
        vmovaps [rdi+320],zmm2
        
        vmaxps zmm2,zmm0,zmm1               ;F32 max
        vmovaps [rdi+384],zmm2

        vsqrtps zmm2,zmm0                   ;F32 sqrt(a)
        vmovaps [rdi+448],zmm2

        vandps zmm2,zmm1,[F32_AbsMask] {1to16}  ;F32 abs(b)
        vmovaps [rdi+512],zmm2

        vzeroupper
        ret

;------------------------------------------------------------------------------
; void PackedMathF64_avx512(ZmmVal* c, const ZmmVal* a, const ZmmVal* b);
;------------------------------------------------------------------------------

        global PackedMathF64_avx512
PackedMathF64_avx512:

        vmovapd zmm0,[rsi]                  ;zmm0 = a
        vmovapd zmm1,[rdx]                  ;zmm1 = b

        vaddpd zmm2,zmm0,zmm1               ;F64 addition
        vmovapd [rdi],zmm2

        vsubpd zmm2,zmm0,zmm1               ;F64 subtraction
        vmovapd [rdi+64],zmm2

        vmulpd zmm2,zmm0,zmm1               ;F64 multiplication
        vmovapd [rdi+128],zmm2

        vdivpd zmm2,zmm0,zmm1               ;F64 division
        vmovapd [rdi+192],zmm2

        vdivpd zmm2,zmm0,zmm1,{ru-sae}       ;F64 division (round up toward +inf)
        vmovapd [rdi+256],zmm2

        vminpd zmm2,zmm0,zmm1               ;F64 min
        vmovapd [rdi+320],zmm2
        
        vmaxpd zmm2,zmm0,zmm1               ;F64 max
        vmovapd [rdi+384],zmm2

        vsqrtpd zmm2,zmm0                   ;F64 sqrt(a)
        vmovapd [rdi+448],zmm2

        vandpd zmm2,zmm1,[F64_AbsMask] {1to8}   ;F64 abs(b)
        vmovapd [rdi+512],zmm2

        vzeroupper
        ret
