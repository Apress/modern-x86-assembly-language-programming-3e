;------------------------------------------------------------------------------
; Ch05_02_fasm.asm
;------------------------------------------------------------------------------

            .const
F32_3p0     real4 3.0

            extern g_F32_PI:real4

;------------------------------------------------------------------------------
; void CalcConeVolSA_avx(float* vol, float* sa, float r, float h);
;------------------------------------------------------------------------------

        .code
CalcConeVolSA_avx proc

; Calculate vol = pi * r * r * h / 3.0f;
        vmulss xmm0,xmm2,xmm2           ;xmm0 = r * r;
        vmulss xmm1,xmm0,[g_F32_PI]     ;xmm1 = r * r * pi
        vmulss xmm4,xmm1,xmm3           ;xmm4 = r * r * pi * h
        vdivss xmm5,xmm4,[F32_3p0]      ;xmm5 = r * r * pi * h / 3.0
        vmovss real4 ptr [rcx],xmm5     ;save volume

; Calculate sa = pi * r * (r + sqrt(r * r + h * h));
        vmulss xmm3,xmm3,xmm3           ;xmm3 = h * h
        vaddss xmm0,xmm0,xmm3           ;xmm0 = r * r + h * h
        vsqrtss xmm1,xmm0,xmm0          ;xmm1 = sqrt(r * r + h * h)
        vaddss xmm4,xmm1,xmm2           ;xmm4 = sqrt(r * r + h * h) + r
        vmulss xmm5,xmm2,[g_F32_PI]     ;xmm5 = r * pi
        vmulss xmm5,xmm5,xmm4           ;xmm5 = r * pi * (sqrt(r * r + h * h) + r)
        vmovss real4 ptr [rdx],xmm5     ;save surface area
        ret

CalcConeVolSA_avx endp
        end
