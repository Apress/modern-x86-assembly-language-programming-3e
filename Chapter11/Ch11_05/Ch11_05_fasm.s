;------------------------------------------------------------------------------
; Ch11_05_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; Mat4x4MulCalcRowF64a_M macro
;
; Description:  This macro is used to compute one row of a 4x4 matrix
;               multiply using packed FMA instructions.
;
; Parameters:   %1 = displacement for row a[i][], c[i][]
;
; Registers:    ymm0 = row b[0][]
;               ymm1 = row b[1][]
;               ymm2 = row b[2][]
;               ymm3 = row b[3][]
;               rdi = matrix c pointer
;               rsi = matrix a pointer
;               ymm4, ymm5 = scratch registers
;------------------------------------------------------------------------------

%macro Mat4x4MulCalcRowF64a_M 1
        vbroadcastsd ymm5,[rsi+%1]          ;broadcast a[i][0]
        vmulpd ymm4,ymm5,ymm0               ;ymm4  = a[i][0] * b[0][]

        vbroadcastsd ymm5,[rsi+%1+8]        ;broadcast a[i][1]
        vfmadd231pd ymm4,ymm5,ymm1          ;ymm4 += a[i][1] * b[1][]

        vbroadcastsd ymm5,[rsi+%1+16]       ;broadcast a[i][2]
        vfmadd231pd ymm4,ymm5,ymm2          ;ymm4 += a[i][2] * b[2][]

        vbroadcastsd ymm5,[rsi+%1+24]       ;broadcast a[i][3]
        vfmadd231pd ymm4,ymm5,ymm3          ;ymm4 += a[i][3] * b[3][]

        vmovapd [rdi+%1],ymm4               ;save row c[i][]
%endmacro

;------------------------------------------------------------------------------
; Mat4x4MulCalcRowF64b_M macro
;
; Description:  This macro is used to compute one row of a 4x4 matrix
;               multiply using packed multiply and add instructions.
;
; Parameters:   %1 = displacement for row a[i][], c[i][]
;
; Registers:    ymm0 = row b[0][]
;               ymm1 = row b[1][]
;               ymm2 = row b[2][]
;               ymm3 = row b[3][]
;               rsi = matrix c pointer
;               rdi = matrix a pointer
;               ymm4, ymm5 = scratch registers
;------------------------------------------------------------------------------

%macro Mat4x4MulCalcRowF64b_M 1
        vbroadcastsd ymm5,[rsi+%1]          ;broadcast a[i][0]
        vmulpd ymm4,ymm5,ymm0               ;ymm5  = a[i][0] * b[0][]

        vbroadcastsd ymm5,[rsi+%1+8]        ;broadcast a[i][1]
        vmulpd ymm5,ymm5,ymm1               ;ymm5  = a[i][1] * b[1][]
        vaddpd ymm4,ymm5,ymm4               ;ymm4 += a[i][1] * b[1][]

        vbroadcastsd ymm5,[rsi+%1+16]       ;broadcast a[i][2]
        vmulpd ymm5,ymm5,ymm2               ;ymm5  = a[i][2] * b[2][]
        vaddpd ymm4,ymm5,ymm4               ;ymm4 += a[i][2] * b[2][]

        vbroadcastsd ymm5,[rsi+%1+24]       ;broadcast a[i][3]
        vmulpd ymm5,ymm5,ymm3               ;ymm5  = a[i][3] * b[3][]
        vaddpd ymm4,ymm5,ymm4               ;ymm4 += a[i][3] * b[3][]

        vmovapd [rdi+%1],ymm4               ;save row c[i][]
%endmacro

;------------------------------------------------------------------------------
; void MatrixMul4x4F64a_avx2(double* c, const double* a, const double* b);
;------------------------------------------------------------------------------

        section .text

        global MatrixMul4x4F64a_avx2
MatrixMul4x4F64a_avx2:

; Load matrix b into ymm0 - ymm3
        vmovapd ymm0,[rdx]                  ;ymm0 = row b[0][]
        vmovapd ymm1,[rdx+32]               ;ymm1 = row b[1][]
        vmovapd ymm2,[rdx+64]               ;ymm2 = row b[2][]
        vmovapd ymm3,[rdx+96]               ;ymm3 = row b[3][]

; Calculate matrix product c = a * b
        Mat4x4MulCalcRowF64a_M 0            ;calculate row c[0][]
        Mat4x4MulCalcRowF64a_M 32           ;calculate row c[1][]
        Mat4x4MulCalcRowF64a_M 64           ;calculate row c[2][]
        Mat4x4MulCalcRowF64a_M 96           ;calculate row c[3][]

        vzeroupper
        ret

;------------------------------------------------------------------------------
; void MatrixMul4x4F64b_avx2(double* c, const double* a, const double* b);
;------------------------------------------------------------------------------

        global MatrixMul4x4F64b_avx2
MatrixMul4x4F64b_avx2:

; Load matrix b into ymm0 - ymm3
        vmovapd ymm0,[rdx]                  ;ymm0 = row b[0][]
        vmovapd ymm1,[rdx+32]               ;ymm1 = row b[1][]
        vmovapd ymm2,[rdx+64]               ;ymm2 = row b[2][]
        vmovapd ymm3,[rdx+96]               ;ymm3 = row b[3][]

; Calculate matrix product c = a * b
        Mat4x4MulCalcRowF64b_M 0            ;calculate row c[0][]
        Mat4x4MulCalcRowF64b_M 32           ;calculate row c[1][]
        Mat4x4MulCalcRowF64b_M 64           ;calculate row c[2][]
        Mat4x4MulCalcRowF64b_M 96           ;calculate row c[3][]

        vzeroupper
        ret
