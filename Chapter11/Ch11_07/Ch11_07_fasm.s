;------------------------------------------------------------------------------
; Ch11_07_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; Mat4x4TransposeF64_M macro
;
; Description:  This macro transposes a 4x4 matrix of double-precision
;               floating-point values.
;
;  Input Matrix                    Output Matrix
;  ---------------------------------------------------
;  ymm0    a3 a2 a1 a0             ymm0    d0 c0 b0 a0
;  ymm1    b3 b2 b1 b0             ymm1    d1 c1 b1 a1
;  ymm2    c3 c2 c1 c0             ymm2    d2 c2 b2 a2
;  ymm3    d3 d2 d1 d0             ymm3    d3 c3 b3 a3
;
; Scratch registers: ymm4, ymm5, ymm6, ymm7
;------------------------------------------------------------------------------

%macro Mat4x4TransposeF64_M 0
        vunpcklpd ymm4,ymm0,ymm1            ;ymm4 = b2 a2 b0 a0
        vunpckhpd ymm5,ymm0,ymm1            ;ymm5 = b3 a3 b1 a1
        vunpcklpd ymm6,ymm2,ymm3            ;ymm6 = d2 c2 d0 c0
        vunpckhpd ymm7,ymm2,ymm3            ;ymm7 = d3 c3 d1 c1

        vperm2f128 ymm0,ymm4,ymm6,20h       ;ymm0 = d0 c0 b0 a0
        vperm2f128 ymm1,ymm5,ymm7,20h       ;ymm1 = d1 c1 b1 a1
        vperm2f128 ymm2,ymm4,ymm6,31h       ;ymm2 = d2 c2 b2 a2
        vperm2f128 ymm3,ymm5,ymm7,31h       ;ymm3 = d3 c3 b3 a3
%endmacro

;------------------------------------------------------------------------------
; void MatVecMulF64_avx2(Vec4x1_F64* vec_b, const float* m,
;   const Vec4x1_F64* vec_a, size_t num_vec);
;------------------------------------------------------------------------------

        section .text

        global MatVecMulF64_avx2
MatVecMulF64_avx2:

; Validate arguments
        test rcx,rcx
        jz Done                             ;jump if num_vec == 0

        test rdi,1fh
        jnz Done                            ;jump if vec_b not 32b aligned

        test rsi,1fh
        jnz Done                            ;jump if m not 32b aligned

        test rdx,1fh
        jnz Done                            ;jump if vec_a 32b aligned

; Initialize
        mov rax,-32                         ;array offset
        vmovapd ymm0,[rsi]                  ;ymm0 = m row 0
        vmovapd ymm1,[rsi+32]               ;ymm1 = m row 1
        vmovapd ymm2,[rsi+64]               ;ymm2 = m row 2
        vmovapd ymm3,[rsi+96]               ;ymm3 = m row 3

; Transpose m
        Mat4x4TransposeF64_M

; Calculate matrix-vector products
        align 16
Loop1:  add rax,32

        vbroadcastsd ymm5,[rdx+rax]             ;ymm5 = vec_a[i].W
        vmulpd ymm4,ymm0,ymm5                   ;ymm4  = m_T row 0 * W vals

        vbroadcastsd ymm5,[rdx+rax+8]           ;ymm5 = vec_a[i].X
        vfmadd231pd ymm4,ymm1,ymm5              ;ymm4 += m_T row 1 * X vals

        vbroadcastsd ymm5,[rdx+rax+16]          ;ymm5 = vec_a[i].Y
        vfmadd231pd ymm4,ymm2,ymm5              ;ymm4 += m_T row 2 * Y vals

        vbroadcastsd ymm5,[rdx+rax+24]          ;ymm5 = vec_a[i].Z
        vfmadd231pd ymm4,ymm3,ymm5              ;ymm4 += m_T row 3 * Z vals

        vmovapd [rdi+rax],ymm4                  ;save vec_b[i]

        sub rcx,1                               ;num_vec -= 1
        jnz Loop1                               ;repeat until done

Done:   vzeroupper
        ret
