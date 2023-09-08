;------------------------------------------------------------------------------
; Ch12_01_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

        section .rdata align = 32
Mat4x4I         dd 1.0, 0.0, 0.0, 0.0
                dd 0.0, 1.0, 0.0, 0.0
                dd 0.0, 0.0, 1.0, 0.0
                dd 0.0, 0.0, 0.0, 1.0

F32_SignBitMask dd 4 dup (80000000h)
F32_AbsMask     dd 4 dup (7fffffffh)

F32_1p0         dd  1.0
F32_N1p0        dd -1.0
F32_N0p5        dd -0.5
F32_N0p333      dd -0.33333333333333
F32_N0p25       dd -0.25

;------------------------------------------------------------------------------
; Mat4x4TraceF32_M macro
;
; Description:  This macro emits instructions that calculate the trace of a
;               4x4 F32 matrix.
;
; Registers:    rdi     pointer to matrix
;               xmm0    calculated trace value
;               xmm1    scratch register
;------------------------------------------------------------------------------

%macro  Mat4x4TraceF32_M 0
        vmovss xmm0,[rdi]                   ;xmm0 = m[0][0]
        vmovss xmm1,[rdi+20]                ;xmm1 = m[1][1]
        vaddss xmm0,xmm0,[rdi+40]           ;xmm0 = m[0][0] + m[2][2]
        vaddss xmm1,xmm1,[rdi+60]           ;xmm1 = m[1][1] + m[3][3]
        vaddss xmm0,xmm0,xmm1               ;xmm0 = trace(m)
%endmacro

;------------------------------------------------------------------------------
; Mat4x4MulCalcRowF32_M macro
;
; Description:  This macro emits instructions that calculates one row of a
;               4x4 F32 matrix multiplication (c = a * b).
;
; Parameters:   %1              displacement for row a[i][], c[i][]
;
; Registers:    rdi             matrix c pointer
;               rsi             matrix a pointer
;               xmm0            row b[0][]
;               xmm1            row b[1][]
;               xmm2            row b[2][]
;               xmm3            row b[3][]
;               xmm4, xmm5      scratch registers
;------------------------------------------------------------------------------

%macro  Mat4x4MulCalcRowF32_M 1
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
; void Mat4x4MulF32_avx2(float* c, const float* a, const float* b)
;------------------------------------------------------------------------------

        section .text

        global Mat4x4MulF32_avx2
Mat4x4MulF32_avx2:
        vmovaps xmm0,[rdx]                  ;xmm0 = b[0][]
        vmovaps xmm1,[rdx+16]               ;xmm1 = b[1][]
        vmovaps xmm2,[rdx+32]               ;xmm2 = b[2][]
        vmovaps xmm3,[rdx+48]               ;xmm3 = b[3][]

        Mat4x4MulCalcRowF32_M 0             ;calculate c[0][]
        Mat4x4MulCalcRowF32_M 16            ;calculate c[1][]
        Mat4x4MulCalcRowF32_M 32            ;calculate c[2][]
        Mat4x4MulCalcRowF32_M 48            ;calculate c[3][]
        ret

;------------------------------------------------------------------------------
; bool Mat4x4InvF32_avx2(float* m_inv, const float* m, float epsilon)
;
; Returns   true    matrix m_inv calculated
;           false   matrix m_inv not calculated (m is singular)
;------------------------------------------------------------------------------

; Stack storage offsets relative to rsp (see figure in text)
OffsetM2        equ  0          ;offset of m2
OffsetM3        equ  64         ;offset of m3
OffsetM4        equ  128        ;offset of m4
Offset_m_inv    equ  192        ;offset for m_inv ptr
Offset_m        equ  200        ;offset for m ptr
Offset_epsilon  equ  208        ;offset for epsilon
OffsetExtra     equ  216        ;extra qword for StkSizeLocal % 32 == 0
StkSizeLocal    equ  224        ;stack space (bytes) for temp matrices, local vars

        global Mat4x4InvF32_avx2
Mat4x4InvF32_avx2:
        push rbp                            ;save caller's rbp
        mov rbp,rsp                         ;save caller's rsp
        and rsp,0ffffffffffffffe0h          ;align rsp to 32b boundary
        sub rsp,StkSizeLocal                ;allocate local storage space

; Save args on stack for later use
        mov [rsp+Offset_m_inv],rdi          ;save m_inv ptr
        mov [rsp+Offset_m],rsi              ;save m ptr
        vmovss [rsp+Offset_epsilon],xmm0    ;save epsilon

; Calculate m2
        lea rdi,[rsp+OffsetM2]              ;rdi = m2 ptr
        mov rdx,rsi                         ;rdx = rsi = m ptr
        call Mat4x4MulF32_avx2              ;calculate and save m2

; Calculate m3
        lea rdi,[rsp+OffsetM3]              ;rdi = m3 ptr
        lea rsi,[rsp+OffsetM2]              ;rsi = m2 ptr
        mov rdx,[rsp+Offset_m]              ;rdx = m ptr
        call Mat4x4MulF32_avx2              ;calculate and save m3

; Calculate m4
        lea rdi,[rsp+OffsetM4]              ;rdi = m4 ptr
        lea rsi,[rsp+OffsetM3]              ;rsi = m3 ptr
        mov rdx,[rsp+Offset_m]              ;rdx = m ptr
        call Mat4x4MulF32_avx2              ;calculate and save m4

; Calculate trace of m, m2, m3, and m4
        mov rdi,[rsp+Offset_m]
        Mat4x4TraceF32_M
        vmovss xmm8,xmm0,xmm0               ;xmm8 = t1

        lea rdi,[rsp+OffsetM2]
        Mat4x4TraceF32_M
        vmovss xmm9,xmm0,xmm0               ;xmm9 = t2
        
        lea rdi,[rsp+OffsetM3]
        Mat4x4TraceF32_M
        vmovss xmm10,xmm0,xmm0              ;xmm10 = t3

        lea rdi,[rsp+OffsetM4]
        Mat4x4TraceF32_M
        vmovss xmm11,xmm0,xmm0              ;xmm11 = t4

;------------------------------------------------------------------------------
; Calculate the required coefficients
; c1 = -t1;
; c2 = -1.0f / 2.0f * (c1 * t1 + t2);
; c3 = -1.0f / 3.0f * (c2 * t1 + c1 * t2 + t3);
; c4 = -1.0f / 4.0f * (c3 * t1 + c2 * t2 + c1 * t3 + t4);
;
; Registers used:
;   t1 - t4 = xmm8 - xmm11
;   c1 - c4 = xmm12 - xmm15
;------------------------------------------------------------------------------

        vxorps xmm12,xmm8,[F32_SignBitMask] ;c1 = -t1

        vmulss xmm13,xmm12,xmm8             ;c1 * t1
        vaddss xmm13,xmm13,xmm9             ;c1 * t1 + t2
        vmulss xmm13,xmm13,[F32_N0p5]       ;c2

        vmulss xmm14,xmm13,xmm8             ;c2 * t1
        vmulss xmm0,xmm12,xmm9              ;c1 * t2
        vaddss xmm14,xmm14,xmm0             ;c2 * t1 + c1 * t2
        vaddss xmm14,xmm14,xmm10            ;c2 * t1 + c1 * t2 + t3
        vmulss xmm14,xmm14,[F32_N0p333]     ;c3

        vmulss xmm15,xmm14,xmm8             ;c3 * t1
        vmulss xmm0,xmm13,xmm9              ;c2 * t2
        vmulss xmm1,xmm12,xmm10             ;c1 * t3
        vaddss xmm2,xmm0,xmm1               ;c2 * t2 + c1 * t3
        vaddss xmm15,xmm15,xmm2             ;c3 * t1 + c2 * t2 + c1 * t3
        vaddss xmm15,xmm15,xmm11            ;c3 * t1 + c2 * t2 + c1 * t3 + t4
        vmulss xmm15,xmm15,[F32_N0p25]      ;c4

; Make sure matrix is not singular
        vandps xmm0,xmm15,[F32_AbsMask]     ;compute fabs(c4)
        vcomiss xmm0,[rsp+Offset_epsilon]   ;compare against epsilon
        setp al                             ;set al if unordered
        setb ah                             ;set ah if fabs(c4) < epsilon
        or al,ah                            ;is input matrix is_singular?
        jnz IsSing                          ;jump if yes

; Calculate m_inv = -1.0 / c4 * (m3 + c1 * m2 + c2 * m + c3 * I)
        vbroadcastss xmm14,xmm14            ;xmm14 = packed c3
        lea rdi,[Mat4x4I]                   ;rdi = I ptr
        vmulps xmm0,xmm14,[rdi]
        vmulps xmm1,xmm14,[rdi+16]
        vmulps xmm2,xmm14,[rdi+32]
        vmulps xmm3,xmm14,[rdi+48]          ;c3 * I

        vbroadcastss xmm13,xmm13            ;xmm13 = packed c2
        mov rdi,[rsp+Offset_m]              ;rdi = m ptr
        vfmadd231ps xmm0,xmm13,[rdi]
        vfmadd231ps xmm1,xmm13,[rdi+16]
        vfmadd231ps xmm2,xmm13,[rdi+32]
        vfmadd231ps xmm3,xmm13,[rdi+48]     ;c2 * m + c3 * I

        vbroadcastss xmm12,xmm12            ;xmm12 = packed c1
        lea rdi,[rsp+OffsetM2]              ;rdi = m2 ptr
        vfmadd231ps xmm0,xmm12,[rdi]
        vfmadd231ps xmm1,xmm12,[rdi+16]
        vfmadd231ps xmm2,xmm12,[rdi+32]
        vfmadd231ps xmm3,xmm12,[rdi+48]     ;c1 * m2 + c2 * m + c3 * I

        lea rdi,[rsp+OffsetM3]              ;rdi = m3 ptr
        vaddps xmm0,xmm0,[rdi]
        vaddps xmm1,xmm1,[rdi+16]
        vaddps xmm2,xmm2,[rdi+32]
        vaddps xmm3,xmm3,[rdi+48]           ;m3 + c1 * m2 + c2 * m + c3 * I

        vmovss xmm4,[F32_N1p0]
        vdivss xmm4,xmm4,xmm15              ;xmm4 = -1.0 / c4
        vbroadcastss xmm4,xmm4
        vmulps xmm0,xmm0,xmm4
        vmulps xmm1,xmm1,xmm4
        vmulps xmm2,xmm2,xmm4
        vmulps xmm3,xmm3,xmm4               ;xmm0:xmm3 = m_inv

; Save m_inv
        mov rdi,[rsp+Offset_m_inv]
        vmovaps [rdi],xmm0                  ;save m_inv[0][]
        vmovaps [rdi+16],xmm1               ;save m_inv[1][]
        vmovaps [rdi+32],xmm2               ;save m_inv[2][]
        vmovaps [rdi+48],xmm3               ;save m_inv[3][]

        mov eax,1                           ;set non-singular return code

Done:   mov rsp,rbp
        pop rbp
        ret

IsSing: xor eax,eax                         ;set singular return code
        jmp Done
