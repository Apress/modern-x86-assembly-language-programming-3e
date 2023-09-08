;------------------------------------------------------------------------------
; Ch12_01_fasm.asm
;------------------------------------------------------------------------------

        include <MacrosX86-64-AVX.asmh>

ConstVals       segment readonly align(32) 'const'
Mat4x4I         real4 1.0, 0.0, 0.0, 0.0
                real4 0.0, 1.0, 0.0, 0.0
                real4 0.0, 0.0, 1.0, 0.0
                real4 0.0, 0.0, 0.0, 1.0

F32_SignBitMask dd 4 dup (80000000h)
F32_AbsMask     dd 4 dup (7fffffffh)

F32_1p0         real4  1.0
F32_N1p0        real4 -1.0
F32_N0p5        real4 -0.5
F32_N0p333      real4 -0.33333333333333
F32_N0p25       real4 -0.25

;------------------------------------------------------------------------------
; Mat4x4TraceF32_M macro
;
; Description:  This macro emits instructions that calculate the trace of a
;               4x4 F32 matrix.
;
; Registers:    rcx     pointer to matrix
;               xmm0    calculated trace value
;               xmm1    scratch register
;------------------------------------------------------------------------------

Mat4x4TraceF32_M macro
        vmovss xmm0,real4 ptr [rcx]             ;xmm0 = m[0][0]
        vmovss xmm1,real4 ptr [rcx+20]          ;xmm1 = m[1][1]
        vaddss xmm0,xmm0,real4 ptr [rcx+40]     ;xmm0 = m[0][0] + m[2][2]
        vaddss xmm1,xmm1,real4 ptr [rcx+60]     ;xmm1 = m[1][1] + m[3][3]
        vaddss xmm0,xmm0,xmm1                   ;xmm0 = trace(m)
        endm

;------------------------------------------------------------------------------
; Mat4x4MulCalcRowF32_M macro
;
; Description:  This macro emits instructions that calculates one row of a
;               4x4 F32 matrix multiplication (c = a * b).
;
; Parameters:   disp            displacement for row a[i][], c[i][]
;
; Registers:    rcx             matrix c pointer
;               rdx             matrix a pointer
;               xmm0            row b[0][]
;               xmm1            row b[1][]
;               xmm2            row b[2][]
;               xmm3            row b[3][]
;               xmm4, xmm5      scratch registers
;------------------------------------------------------------------------------

Mat4x4MulCalcRowF32_M macro disp
        vbroadcastss xmm5,real4 ptr [rdx+disp]      ;broadcast a[i][0]
        vmulps xmm4,xmm5,xmm0                       ;xmm4  = a[i][0] * b[0][]

        vbroadcastss xmm5,real4 ptr [rdx+disp+4]    ;broadcast a[i][1]
        vfmadd231ps xmm4,xmm5,xmm1                  ;xmm4 += a[i][1] * b[1][]

        vbroadcastss xmm5,real4 ptr [rdx+disp+8]    ;broadcast a[i][2]
        vfmadd231ps xmm4,xmm5,xmm2                  ;xmm4 += a[i][2] * b[2][]

        vbroadcastss xmm5,real4 ptr [rdx+disp+12]   ;broadcast a[i][3]
        vfmadd231ps xmm4,xmm5,xmm3                  ;xmm4 += a[i][3] * b[3][]

        vmovaps [rcx+disp],xmm4                     ;save row c[i][]
        endm

;------------------------------------------------------------------------------
; void Mat4x4MulF32_avx2(float* c, const float* a, const float* b)
;------------------------------------------------------------------------------

        .code
Mat4x4MulF32_avx2 proc
        vmovaps xmm0,[r8]                   ;xmm0 = b[0][]
        vmovaps xmm1,[r8+16]                ;xmm1 = b[1][]
        vmovaps xmm2,[r8+32]                ;xmm2 = b[2][]
        vmovaps xmm3,[r8+48]                ;xmm3 = b[3][]

        Mat4x4MulCalcRowF32_M 0             ;calculate c[0][]
        Mat4x4MulCalcRowF32_M 16            ;calculate c[1][]
        Mat4x4MulCalcRowF32_M 32            ;calculate c[2][]
        Mat4x4MulCalcRowF32_M 48            ;calculate c[3][]
        ret
Mat4x4MulF32_avx2 endp

;------------------------------------------------------------------------------
; bool Mat4x4InvF32_avx2(float* m_inv, const float* m, float epsilon)
;
; Returns   true    matrix m_inv calculated
;           false   matrix m_inv not calculated (m is singular)
;------------------------------------------------------------------------------

; Stack offsets and sizes (see figure in text)
OffsetM2        equ 32          ;offset of m2 relative to rsp
OffsetM3        equ 96          ;offset of m3 relative to rsp
OffsetM4        equ 160         ;offset of m4 relative to rsp
StkSizeLocal    equ 192         ;stack space (bytes) for temp matrices

Mat4x4InvF32_avx2 proc frame
        CreateFrame_M MI_,0,160
        SaveXmmRegs_M xmm6,xmm7,xmm8,xmm9,xmm10,xmm11,xmm12,xmm13,xmm14,xmm15
        EndProlog_M

; Save args to home area for later use
        mov [rbp+MI_OffsetHomeRCX],rcx              ;save m_inv ptr
        mov [rbp+MI_OffsetHomeRDX],rdx              ;save m ptr
        vmovss real4 ptr [rbp+MI_OffsetHomeR8],xmm2 ;save epsilon

; Allocate stack space for temp matrices + 32 bytes for function calls
        and rsp,0ffffffffffffffe0h          ;align rsp to 32-byte boundary
        sub rsp,StkSizeLocal+32             ;alloc stack space

; Calculate m2
        lea rcx,[rsp+OffsetM2]              ;rcx = m2 ptr
        mov r8,rdx                          ;r8 = rdx = m ptr
        call Mat4x4MulF32_avx2              ;calculate and save m2

; Calculate m3
        lea rcx,[rsp+OffsetM3]              ;rcx = m3 ptr
        lea rdx,[rsp+OffsetM2]              ;rdx = m2 ptr
        mov r8,[rbp+MI_OffsetHomeRDX]       ;r8 = m
        call Mat4x4MulF32_avx2              ;calculate and save m3

; Calculate m4
        lea rcx,[rsp+OffsetM4]              ;rcx = m4 ptr
        lea rdx,[rsp+OffsetM3]              ;rdx = m3 ptr
        mov r8,[rbp+MI_OffsetHomeRDX]       ;r8 = m ptr
        call Mat4x4MulF32_avx2              ;calculate and save m4

; Calculate trace of m, m2, m3, and m4
        mov rcx,[rbp+MI_OffsetHomeRDX]
        Mat4x4TraceF32_M
        vmovss xmm8,xmm0,xmm0               ;xmm8 = t1

        lea rcx,[rsp+OffsetM2]
        Mat4x4TraceF32_M
        vmovss xmm9,xmm0,xmm0               ;xmm9 = t2
        
        lea rcx,[rsp+OffsetM3]
        Mat4x4TraceF32_M
        vmovss xmm10,xmm0,xmm0              ;xmm10 = t3

        lea rcx,[rsp+OffsetM4]
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

        vxorps xmm12,xmm8,[F32_SignBitMask]    ;c1 = -t1

        vmulss xmm13,xmm12,xmm8         ;c1 * t1
        vaddss xmm13,xmm13,xmm9         ;c1 * t1 + t2
        vmulss xmm13,xmm13,[F32_N0p5]   ;c2

        vmulss xmm14,xmm13,xmm8         ;c2 * t1
        vmulss xmm0,xmm12,xmm9          ;c1 * t2
        vaddss xmm14,xmm14,xmm0         ;c2 * t1 + c1 * t2
        vaddss xmm14,xmm14,xmm10        ;c2 * t1 + c1 * t2 + t3
        vmulss xmm14,xmm14,[F32_N0p333] ;c3

        vmulss xmm15,xmm14,xmm8         ;c3 * t1
        vmulss xmm0,xmm13,xmm9          ;c2 * t2
        vmulss xmm1,xmm12,xmm10         ;c1 * t3
        vaddss xmm2,xmm0,xmm1           ;c2 * t2 + c1 * t3
        vaddss xmm15,xmm15,xmm2         ;c3 * t1 + c2 * t2 + c1 * t3
        vaddss xmm15,xmm15,xmm11        ;c3 * t1 + c2 * t2 + c1 * t3 + t4
        vmulss xmm15,xmm15,[F32_N0p25]  ;c4

; Make sure matrix is not singular
        vandps xmm0,xmm15,real4 ptr [F32_AbsMask]   ;compute fabs(c4)
        vcomiss xmm0,real4 ptr [rbp+MI_OffsetHomeR8];compare against epsilon
        setp al                                     ;set al if unordered
        setb ah                                     ;set ah if fabs(c4) < epsilon
        or al,ah                                    ;is input matrix is_singular?
        jnz IsSing                                  ;jump if yes

; Calculate m_inv = -1.0 / c4 * (m3 + c1 * m2 + c2 * m + c3 * I)
        vbroadcastss xmm14,xmm14                    ;xmm14 = packed c3
        lea rcx,[Mat4x4I]                           ;rcx = I ptr
        vmulps xmm0,xmm14,[rcx]
        vmulps xmm1,xmm14,[rcx+16]
        vmulps xmm2,xmm14,[rcx+32]
        vmulps xmm3,xmm14,[rcx+48]                  ;c3 * I

        vbroadcastss xmm13,xmm13                    ;xmm13 = packed c2
        mov rcx,[rbp+MI_OffsetHomeRDX]              ;rcx = m ptr
        vfmadd231ps xmm0,xmm13,[rcx]
        vfmadd231ps xmm1,xmm13,[rcx+16]
        vfmadd231ps xmm2,xmm13,[rcx+32]
        vfmadd231ps xmm3,xmm13,[rcx+48]             ;c2 * m + c3 * I

        vbroadcastss xmm12,xmm12                    ;xmm12 = packed c1
        lea rcx,[rsp+OffsetM2]                      ;rcx = m2 ptr
        vfmadd231ps xmm0,xmm12,[rcx]
        vfmadd231ps xmm1,xmm12,[rcx+16]
        vfmadd231ps xmm2,xmm12,[rcx+32]
        vfmadd231ps xmm3,xmm12,[rcx+48]             ;c1 * m2 + c2 * m + c3 * I

        lea rcx,[rsp+OffsetM3]                      ;rcx = m3 ptr
        vaddps xmm0,xmm0,[rcx]
        vaddps xmm1,xmm1,[rcx+16]
        vaddps xmm2,xmm2,[rcx+32]
        vaddps xmm3,xmm3,[rcx+48]                   ;m3 + c1 * m2 + c2 * m + c3 * I

        vmovss xmm4,[F32_N1p0]
        vdivss xmm4,xmm4,xmm15                      ;xmm4 = -1.0 / c4
        vbroadcastss xmm4,xmm4
        vmulps xmm0,xmm0,xmm4
        vmulps xmm1,xmm1,xmm4
        vmulps xmm2,xmm2,xmm4
        vmulps xmm3,xmm3,xmm4                       ;xmm0:xmm3 = m_inv

; Save m_inv
        mov rcx,[rbp+MI_OffsetHomeRCX]
        vmovaps [rcx],xmm0                          ;save m_inv[0][]
        vmovaps [rcx+16],xmm1                       ;save m_inv[1][]
        vmovaps [rcx+32],xmm2                       ;save m_inv[2][]
        vmovaps [rcx+48],xmm3                       ;save m_inv[3][]

        mov eax,1                                   ;set non-singular return code

Done:   RestoreXmmRegs_M xmm6,xmm7,xmm8,xmm9,xmm10,xmm11,xmm12,xmm13,xmm14,xmm15
        DeleteFrame_M
        ret

IsSing: xor eax,eax                                 ;set singular return code
        jmp Done

Mat4x4InvF32_avx2 endp
        end
