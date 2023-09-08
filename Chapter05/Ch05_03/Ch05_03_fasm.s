;------------------------------------------------------------------------------
; Ch05_03_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

        section .rdata
F64_3p0 dq 3.0
F64_4p0 dq 4.0

;------------------------------------------------------------------------------
; void CalcSphereVolSA_avx(double* vol, double* sa, double r);
;------------------------------------------------------------------------------

        section .text
        extern g_F64_PI

        global CalcSphereVolSA_avx
CalcSphereVolSA_avx:

; Calculate surface area = 4 * PI * r * r
        vmulsd xmm1,xmm0,xmm0               ;xmm1 = r * r
        vmulsd xmm3,xmm1,[g_F64_PI]         ;xmm3 = r * r * PI
        vmulsd xmm4,xmm3,[F64_4p0]          ;xmm4 = r * r * PI * 4
        vmovsd [rsi],xmm4                   ;save surface area

; Calculate volume = sa * r / 3
        vmulsd xmm5,xmm4,xmm0               ;xmm4 = r * r * r * PI * 4
        vdivsd xmm5,xmm5,[F64_3p0]          ;xmm5 = r * r * r * PI * 4 / 3
        vmovsd [rdi],xmm5                   ;save volume
        ret
