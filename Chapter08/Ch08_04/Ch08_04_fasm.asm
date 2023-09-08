;------------------------------------------------------------------------------
; Ch08_04_fasm.asm
;------------------------------------------------------------------------------

;------------------------------------------------------------------------------
; void SllU16_avx(XmmVal* c, const XmmVal* a, uint32_t count);
;------------------------------------------------------------------------------

        .code
SllU16_avx proc
        vmovdqa xmm0,xmmword ptr [rdx]      ;xmm0 = a
        vmovd xmm1,r8d                      ;xmm1[31:0] = count

        vpsllw xmm2,xmm0,xmm1               ;left shift word elements of a

        vmovdqa xmmword ptr [rcx],xmm2      ;save result
        ret
SllU16_avx endp

;------------------------------------------------------------------------------
; void SrlU16_Aavx(XmmVal* c, const XmmVal* a, uint32_t count);
;------------------------------------------------------------------------------

SrlU16_avx proc
        vmovdqa xmm0,xmmword ptr [rdx]      ;xmm0 = a
        vmovd xmm1,r8d                      ;xmm1[31:0] = count

        vpsrlw xmm2,xmm0,xmm1               ;right shift word elements of a

        vmovdqa xmmword ptr [rcx],xmm2      ;save result
        ret
SrlU16_avx endp

;------------------------------------------------------------------------------
; void SraU16_Aavx(XmmVal* c, const XmmVal* a, uint32_t count);
;------------------------------------------------------------------------------

SraU16_avx proc
        vmovdqa xmm0,xmmword ptr [rdx]      ;xmm0 = a
        vmovd xmm1,r8d                      ;xmm1[31:0] = count

        vpsraw xmm2,xmm0,xmm1               ;right shift word elements of a

        vmovdqa xmmword ptr [rcx],xmm2      ;save result
        ret
SraU16_avx endp
        end
