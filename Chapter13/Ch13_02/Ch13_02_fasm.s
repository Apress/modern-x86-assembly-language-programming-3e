;------------------------------------------------------------------------------
; Ch13_02_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"
        %include "cmpequ_int.inc"

;------------------------------------------------------------------------------
; void MaskOpI64a_avx512(ZmmVal c[5], uint8_t mask, const ZmmVal* a,
;   const ZmmVal* b);
;------------------------------------------------------------------------------

        section .text

        global MaskOpI64a_avx512
MaskOpI64a_avx512:

        vmovdqa64 zmm0,[rdx]                ;load a values
        vmovdqa64 zmm1,[rcx]                ;load b values

        kmovb k1,esi                        ;k1 = opmask

        vpaddq zmm2{k1}{z},zmm0,zmm1        ;masked qword addition
        vmovdqa64 [rdi],zmm2                ;save result

        vpsubq zmm2{k1}{z},zmm0,zmm1        ;masked qword subtraction
        vmovdqa64 [rdi+64],zmm2             ;save result

        vpmullq zmm2{k1}{z},zmm0,zmm1       ;masked qword multiplication
        vmovdqa64 [rdi+128],zmm2            ;save products (low 64-bits)

        vpsllvq zmm2{k1}{z},zmm0,zmm1       ;masked qword shift left
        vmovdqa64 [rdi+192],zmm2            ;save result

        vpsravq zmm2{k1}{z},zmm0,zmm1       ;masked qword shift right
        vmovdqa64 [rdi+256],zmm2            ;save result

        vzeroupper
        ret

;------------------------------------------------------------------------------
; void MaskOpI64b_avx512(ZmmVal c[5], uint8_t mask, const ZmmVal* a,
;   const ZmmVal* b1, const ZmmVal* b2);
;------------------------------------------------------------------------------

        global MaskOpI64b_avx512
MaskOpI64b_avx512:

        vmovdqa64 zmm0,[rdx]                ;load a values
        vmovdqa64 zmm1,[rcx]                ;load b1 values
        vmovdqa64 zmm2,[r8]                 ;load b2 values

        kmovb k1,esi                        ;k1 = opmask

        vpaddq zmm0{k1},zmm1,zmm2           ;masked qword addition
        vmovdqa64 [rdi],zmm0                ;save result

        vpsubq zmm0{k1},zmm1,zmm2           ;masked qword subtraction
        vmovdqa64 [rdi+64],zmm0             ;save result

        vpmullq zmm0{k1},zmm1,zmm2          ;masked qword multiplication
        vmovdqa64 [rdi+128],zmm0            ;save products (low 64-bits)

        vpsllvq zmm0{k1},zmm1,zmm2          ;masked qword shift left
        vmovdqa64 [rdi+192],zmm0            ;save result

        vpsravq zmm0{k1},zmm1,zmm2          ;masked qword shift right
        vmovdqa64 [rdi+256],zmm0            ;save result

        vzeroupper
        ret

;------------------------------------------------------------------------------
; void MaskOpI64c_avx512(ZmmVal* c, const ZmmVal* a, int64_t x1, int64_t x2);
;------------------------------------------------------------------------------

        global MaskOpI64c_avx512
MaskOpI64c_avx512:

        vmovdqa64 zmm0,[rsi]                ;load a values
        vpbroadcastq zmm1,rdx               ;broadcast x1 to zmm1
        vpbroadcastq zmm2,rcx               ;broadcast x2 to zmm2

; c[i] = (a[i] >= x1) ? a[i] + x2 : a[i]
        vpcmpq k1,zmm0,zmm1,CMP_GE          ;k1 = a[i] >= x1 mask
        vpaddq zmm0{k1},zmm0,zmm2           ;masked qword addition
        vmovdqa64 [rdi],zmm0                ;save result

        vzeroupper
        ret
