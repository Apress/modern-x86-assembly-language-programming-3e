;------------------------------------------------------------------------------
; Ch05_03_fasm.asm
;------------------------------------------------------------------------------

        .const
F64_3p0 real8 3.0
F64_4p0 real8 4.0    

            extern g_F64_PI:real8

;------------------------------------------------------------------------------
; void CalcSphereVolSA_avx(double* vol, double* sa, double r);
;------------------------------------------------------------------------------

        .code
CalcSphereVolSA_avx proc

; Calculate surface area = 4 * PI * r * r
        vmulsd xmm1,xmm2,xmm2               ;xmm1 = r * r
        vmulsd xmm3,xmm1,[g_F64_PI]         ;xmm3 = r * r * PI
        vmulsd xmm4,xmm3,[F64_4p0]          ;xmm4 = r * r * PI * 4
        vmovsd real8 ptr [rdx],xmm4         ;save surface area

; Calculate volume = sa * r / 3
        vmulsd xmm5,xmm4,xmm2               ;xmm4 = r * r * r * PI * 4
        vdivsd xmm5,xmm5,[F64_3p0]          ;xmm5 = r * r * r * PI * 4 / 3
        vmovsd real8 ptr [rcx],xmm5         ;save volume
        ret

CalcSphereVolSA_avx endp
        end
