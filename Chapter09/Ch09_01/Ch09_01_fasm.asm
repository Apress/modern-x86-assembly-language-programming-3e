;------------------------------------------------------------------------------
; Ch09_01_fasm.asm
;------------------------------------------------------------------------------

            .const
F64_AbsMask  dq 07fffffffffffffffh
F32_AbsMask  dd 07fffffffh

;------------------------------------------------------------------------------
; void PackedMathF32_avx(YmmVal* c, const YmmVal* a, const YmmVal* b);
;------------------------------------------------------------------------------

        .code
PackedMathF32_avx proc
        vmovaps ymm0,ymmword ptr [rdx]      ;ymm0 = a
        vmovaps ymm1,ymmword ptr [r8]       ;ymm1 = b

        vaddps ymm2,ymm0,ymm1               ;SPFP addition
        vmovaps ymmword ptr[rcx],ymm2

        vsubps ymm2,ymm0,ymm1               ;SPFP subtraction
        vmovaps ymmword ptr[rcx+32],ymm2

        vmulps ymm2,ymm0,ymm1               ;SPFP multiplication
        vmovaps ymmword ptr[rcx+64],ymm2

        vdivps ymm2,ymm0,ymm1               ;SPFP division
        vmovaps ymmword ptr[rcx+96],ymm2

        vminps ymm2,ymm0,ymm1               ;SPFP min
        vmovaps ymmword ptr[rcx+128],ymm2
        
        vmaxps ymm2,ymm0,ymm1               ;SPFP max
        vmovaps ymmword ptr[rcx+160],ymm2

        vsqrtps ymm2,ymm0                   ;SPFP sqrt(a)
        vmovaps ymmword ptr[rcx+192],ymm2

        vbroadcastss ymm3,real4 ptr [F32_AbsMask] ;load abs mask
        vandps ymm2,ymm3,ymm1                     ;SPFP abs(b)
        vmovaps ymmword ptr[rcx+224],ymm2

        vzeroupper                          ;clear upper YMM/ZMM bits
        ret
PackedMathF32_avx endp

;------------------------------------------------------------------------------
; void PackedMathF64_avx(YmmVal* c, const YmmVal* a, const YmmVal* b);
;------------------------------------------------------------------------------

PackedMathF64_avx proc
        vmovapd ymm0,ymmword ptr [rdx]      ;ymm0 = a
        vmovapd ymm1,ymmword ptr [r8]       ;ymm1 = b

        vaddpd ymm2,ymm0,ymm1               ;DPFP addition
        vmovapd ymmword ptr[rcx],ymm2

        vsubpd ymm2,ymm0,ymm1               ;DPFP subtraction
        vmovapd ymmword ptr[rcx+32],ymm2

        vmulpd ymm2,ymm0,ymm1               ;DPFP multiplication
        vmovapd ymmword ptr[rcx+64],ymm2

        vdivpd ymm2,ymm0,ymm1               ;DPFP division
        vmovapd ymmword ptr[rcx+96],ymm2

        vminpd ymm2,ymm0,ymm1               ;DPFP min
        vmovapd ymmword ptr[rcx+128],ymm2
        
        vmaxpd ymm2,ymm0,ymm1               ;DPFP max
        vmovapd ymmword ptr[rcx+160],ymm2

        vsqrtpd ymm2,ymm0                   ;DPFP sqrt(a)
        vmovapd ymmword ptr[rcx+192],ymm2

        vbroadcastsd ymm3,real8 ptr [F64_AbsMask] ;load abs mask
        vandpd ymm2,ymm3,ymm1                     ;DPFP abs(b)
        vmovapd ymmword ptr[rcx+224],ymm2

        vzeroupper                          ;clear upper YMM/ZMM bits
        ret
PackedMathF64_avx endp
        end
