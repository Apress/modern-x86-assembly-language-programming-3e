;------------------------------------------------------------------------------
; Ch14_01_fasm.asm
;------------------------------------------------------------------------------

            .const
F64_AbsMask  dq  07fffffffffffffffh
F32_AbsMask  dd  07fffffffh

;------------------------------------------------------------------------------
; void PackedMathF32_avx512(ZmmVal* c, const ZmmVal* a, const ZmmVal* b);
;------------------------------------------------------------------------------

        .code
PackedMathF32_avx512 proc
        vmovaps zmm0,zmmword ptr [rdx]      ;zmm0 = a
        vmovaps zmm1,zmmword ptr [r8]       ;zmm1 = b

        vaddps zmm2,zmm0,zmm1               ;F32 addition
        vmovaps zmmword ptr [rcx],zmm2

        vaddps zmm2,zmm0,zmm1{rd-sae}       ;F32 addition (round down toward -inf)
        vmovaps zmmword ptr [rcx+64],zmm2

        vsubps zmm2,zmm0,zmm1               ;F32 subtraction
        vmovaps zmmword ptr [rcx+128],zmm2

        vmulps zmm2,zmm0,zmm1               ;F32 multiplication
        vmovaps zmmword ptr [rcx+192],zmm2

        vdivps zmm2,zmm0,zmm1               ;F32 division
        vmovaps zmmword ptr [rcx+256],zmm2

        vminps zmm2,zmm0,zmm1               ;F32 min
        vmovaps zmmword ptr [rcx+320],zmm2
        
        vmaxps zmm2,zmm0,zmm1               ;F32 max
        vmovaps zmmword ptr [rcx+384],zmm2

        vsqrtps zmm2,zmm0                   ;F32 sqrt(a)
        vmovaps zmmword ptr [rcx+448],zmm2

        vandps zmm2,zmm1,real4 bcst [F32_AbsMask]   ;F32 abs(b)
        vmovaps zmmword ptr [rcx+512],zmm2

        vzeroupper
        ret
PackedMathF32_avx512 endp

;------------------------------------------------------------------------------
; void PackedMathF64_avx512(ZmmVal* c, const ZmmVal* a, const ZmmVal* b);
;------------------------------------------------------------------------------

PackedMathF64_avx512 proc
        vmovapd zmm0,zmmword ptr [rdx]      ;zmm0 = a
        vmovapd zmm1,zmmword ptr [r8]       ;zmm1 = b

        vaddpd zmm2,zmm0,zmm1               ;F64 addition
        vmovapd zmmword ptr [rcx],zmm2

        vsubpd zmm2,zmm0,zmm1               ;F64 subtraction
        vmovapd zmmword ptr [rcx+64],zmm2

        vmulpd zmm2,zmm0,zmm1               ;F64 multiplication
        vmovapd zmmword ptr [rcx+128],zmm2

        vdivpd zmm2,zmm0,zmm1               ;F64 division
        vmovapd zmmword ptr [rcx+192],zmm2

        vdivpd zmm2,zmm0,zmm1{ru-sae}       ;F64 division (round up toward +inf)
        vmovapd zmmword ptr [rcx+256],zmm2

        vminpd zmm2,zmm0,zmm1               ;F64 min
        vmovapd zmmword ptr [rcx+320],zmm2
        
        vmaxpd zmm2,zmm0,zmm1               ;F64 max
        vmovapd zmmword ptr [rcx+384],zmm2

        vsqrtpd zmm2,zmm0                   ;F64 sqrt(a)
        vmovapd zmmword ptr [rcx+448],zmm2

        vandpd zmm2,zmm1,real8 bcst [F64_AbsMask]   ;F64 abs(b)
        vmovapd zmmword ptr [rcx+512],zmm2

        vzeroupper
        ret
PackedMathF64_avx512 endp
        end
