;------------------------------------------------------------------------------
; Ch11_04_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; Mat4x4MulCalcRowF32a_M macro
;
; Description:  This macro is used to compute one row of a 4x4 matrix
;               multiply using packed FMA instructions.
;
; Parameters:   %1 = displacement for row a[i][], c[i][]

; Registers:    xmm0 = row b[0][]
;               xmm1 = row b[1][]
;               xmm2 = row b[2][]
;               xmm3 = row b[3][]
;               rdi = matrix c pointer
;               rsi = matrix a pointer
;               xmm4, xmm5 = scratch registers
;------------------------------------------------------------------------------

%macro Mat4x4MulCalcRowF32a_M 1
        vbroadcastss xmm5,[rsi+%1]          ;broadcast a[i][0]
        vmulps xmm4,xmm5,xmm0               ;xmm4  = a[i][0] * b[0][]

        vbroadcastss xmm5,[rsi+%1+4]        ;broadcast a[i][1]
        vfmadd231ps xmm4,xmm5,xmm1          ;xmm4 += a[i][1] * b[1][]

        vbroadcastss xmm5,[rsi+%1+8]        ;broadcast a[i][2]
        vfmadd231ps xmm4,xmm5,xmm2          ;xmm4 += a[i][2] * b[2][]

        vbroadcastss xmm5,[rsi+%1+12]       ;broadcast a[i][3]
        vfmadd231ps xmm4,xmm5,xmm3          ;xmm4 += a[i][3] * b[3][]

        vmovaps [rdi+%1],xmm4               ;save row c[i][]
%endmacro

;------------------------------------------------------------------------------
; Mat4x4MulCalcRowF32b_M macro
;
; Description:  This macro is used to compute one row of a 4x4 matrix
;               multiply using packed multiply and add instructions.
;
; Parameters:   %1 = displacement for row a[i][], c[i][]
;
; Registers:    xmm0 = row b[0][]
;               xmm1 = row b[1][]
;               xmm2 = row b[2][]
;               xmm3 = row b[3][]
;               rdi = matrix c pointer
;               rsi = matrix a pointer
;               xmm4, xmm5 = scratch registers
;------------------------------------------------------------------------------

%macro  Mat4x4MulCalcRowF32b_M 1
        vbroadcastss xmm5,[rsi+%1]          ;broadcast a[i][0]
        vmulps xmm4,xmm5,xmm0               ;xmm5  = a[i][0] * b[0][]

        vbroadcastss xmm5,[rsi+%1+4]        ;broadcast a[i][1]
        vmulps xmm5,xmm5,xmm1               ;xmm5  = a[i][1] * b[1][]
        vaddps xmm4,xmm5,xmm4               ;xmm4 += a[i][1] * b[1][]

        vbroadcastss xmm5,[rsi+%1+8]        ;broadcast a[i][2]
        vmulps xmm5,xmm5,xmm2               ;xmm5  = a[i][2] * b[2][]
        vaddps xmm4,xmm5,xmm4               ;xmm4 += a[i][2] * b[2][]

        vbroadcastss xmm5,[rsi+%1+12]       ;broadcast a[i][3]
        vmulps xmm5,xmm5,xmm3               ;xmm5  = a[i][3] * b[3][]
        vaddps xmm4,xmm5,xmm4               ;xmm4 += a[i][3] * b[3][]

        vmovaps [rdi+%1],xmm4               ;save row c[i][]
%endmacro

;------------------------------------------------------------------------------
; void MatrixMul4x4F32a_avx2(float* c, const float* a, const float* b);
;------------------------------------------------------------------------------

        section .text

        global MatrixMul4x4F32a_avx2
MatrixMul4x4F32a_avx2:

; Load matrix b into xmm0 - xmm3
        vmovaps ymm0,[rdx]                  ;xmm0 = row b[0][]
        vextractf128 xmm1,ymm0,1            ;xmm1 = row b[1][]
        vmovaps ymm2,[rdx+32]               ;xmm2 = row b[2][]
        vextractf128 xmm3,ymm2,1            ;xmm3 = row b[3][]

; Calculate matrix product c = a * b
        Mat4x4MulCalcRowF32a_M 0            ;calculate row c[0][]
        Mat4x4MulCalcRowF32a_M 16           ;calculate row c[1][]
        Mat4x4MulCalcRowF32a_M 32           ;calculate row c[2][]
        Mat4x4MulCalcRowF32a_M 48           ;calculate row c[3][]

        vzeroupper
        ret

;------------------------------------------------------------------------------
; void MatrixMul4x4F32b_avx2(float* c, const float* a, const float* b);
;------------------------------------------------------------------------------

        global MatrixMul4x4F32b_avx2
MatrixMul4x4F32b_avx2:

; Load matrix b into xmm0 - xmm3
        vmovaps ymm0,[rdx]                  ;xmm0 = row b[0][]
        vextractf128 xmm1,ymm0,1            ;xmm1 = row b[1][]
        vmovaps ymm2,[rdx+32]               ;xmm2 = row b[2][]
        vextractf128 xmm3,ymm2,1            ;xmm3 = row b[3][]

; Calculate matrix product c = a * b
        Mat4x4MulCalcRowF32b_M 0            ;calculate row c[0][]
        Mat4x4MulCalcRowF32b_M 16           ;calculate row c[1][]
        Mat4x4MulCalcRowF32b_M 32           ;calculate row c[2][]
        Mat4x4MulCalcRowF32b_M 48           ;calculate row c[3][]

        vzeroupper
        ret
