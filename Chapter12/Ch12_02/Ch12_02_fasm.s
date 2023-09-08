;------------------------------------------------------------------------------
; Ch12_02_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

                section .rdata align=32
Mat4x4I         dq 1.0, 0.0, 0.0, 0.0
                dq 0.0, 1.0, 0.0, 0.0
                dq 0.0, 0.0, 1.0, 0.0
                dq 0.0, 0.0, 0.0, 1.0

F64_SignBitMask dq 2 dup (8000000000000000h)
F64_AbsMask     dq 2 dup (7fffffffffffffffh)

F64_1p0         dq  1.0
F64_N1p0        dq -1.0
F64_N0p5        dq -0.5
F64_N0p333      dq -0.33333333333333
F64_N0p25       dq -0.25

;------------------------------------------------------------------------------
; Mat4x4TraceF64_M macro
;
; Description:  This macro emits instructions that calculate the trace of a
;               4x4 F64 matrix.
;
; Registers:    rdi     pointer to matrix
;               xmm0    calculated trace value
;               xmm1    scratch register
;------------------------------------------------------------------------------

%macro  Mat4x4TraceF64_M 0
        vmovsd xmm0,[rdi]                   ;xmm0 = m[0][0]
        vmovsd xmm1,[rdi+40]                ;xmm1 = m[1][1]
        vaddsd xmm0,xmm0,[rdi+80]           ;xmm0 = m[0][0] + m[2][2]
        vaddsd xmm1,xmm1,[rdi+120]          ;xmm1 = m[1][1] + m[3][3]
        vaddsd xmm0,xmm0,xmm1               ;xmm0 = trace(m)
%endmacro

;------------------------------------------------------------------------------
; Mat4x4MulCalcRowF64_M macro
;
; Description:  This macro emits instructions that calculates one row of a
;               4x4 F64 matrix multiplication (c = a * b).
;
; Parameters:   %1             displacement for row a[i][], c[i][]
;
; Registers:    rdi             matrix c pointer
;               rsi             matrix a pointer
;               ymm0            row b[0][]
;               ymm1            row b[1][]
;               ymm2            row b[2][]
;               ymm3            row b[3][]
;               ymm4, ymm5      scratch registers
;------------------------------------------------------------------------------

%macro  Mat4x4MulCalcRowF64_M 1
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
; void Mat4x4MulF64_avx2(double* c, const double* a, const double* b)
;------------------------------------------------------------------------------

        section .text

        global Mat4x4MulF64_avx2
Mat4x4MulF64_avx2:

        vmovapd ymm0,[rdx]                  ;ymm0 = b[0][]
        vmovapd ymm1,[rdx+32]               ;ymm1 = b[1][]
        vmovapd ymm2,[rdx+64]               ;ymm2 = b[2][]
        vmovapd ymm3,[rdx+96]               ;ymm3 = b[3][]

        Mat4x4MulCalcRowF64_M 0             ;calculate c[0][]
        Mat4x4MulCalcRowF64_M 32            ;calculate c[1][]
        Mat4x4MulCalcRowF64_M 64            ;calculate c[2][]
        Mat4x4MulCalcRowF64_M 96            ;calculate c[3][]
        vzeroupper
        ret

;------------------------------------------------------------------------------
; bool Mat4x4InvF64_avx2(double* m_inv, const double* m, double epsilon)
;
; Returns   true    matrix m_inv calculated
;           false   matrix m_inv not calculated (m is singular)
;------------------------------------------------------------------------------

; Stack storage offsets relative to rsp (see figure in text)
OffsetM2        equ  0          ;offset of m2
OffsetM3        equ  128        ;offset of m3
OffsetM4        equ  256        ;offset of m4
Offset_m_inv    equ  384        ;offset for m_inv ptr
Offset_m        equ  392        ;offset for m ptr
Offset_epsilon  equ  400        ;offset for epsilon
OffsetExtra     equ  408        ;extra qword for StkSizeLocal % 32 == 0
StkSizeLocal    equ  416        ;stack space (bytes) for temp matrices, local vars

        global Mat4x4InvF64_avx2
Mat4x4InvF64_avx2:
        push rbp                            ;save caller's rbp
        mov rbp,rsp                         ;save caller's rsp
        and rsp,0ffffffffffffffe0h          ;align rsp to 32b boundary
        sub rsp,StkSizeLocal                ;allocate local storage space

; Save args on stack for later use
        mov [rsp+Offset_m_inv],rdi          ;save m_inv ptr
        mov [rsp+Offset_m],rsi              ;save m ptr
        vmovsd [rsp+Offset_epsilon],xmm0    ;save epsilon

; Calculate m2
        lea rdi,[rsp+OffsetM2]              ;rdi = m2 ptr
        mov rdx,rsi                         ;rdx = rsi = m ptr
        call Mat4x4MulF64_avx2              ;calculate and save m2

; Calculate m3
        lea rdi,[rsp+OffsetM3]              ;rdi = m3 ptr
        lea rsi,[rsp+OffsetM2]              ;rsi = m2 ptr
        mov rdx,[rsp+Offset_m]              ;rdx = m ptr
        call Mat4x4MulF64_avx2              ;calculate and save m3

; Calculate m4
        lea rdi,[rsp+OffsetM4]              ;rdi = m4 ptr
        lea rsi,[rsp+OffsetM3]              ;rsi = m3 ptr
        mov rdx,[rsp+Offset_m]              ;rdx = m ptr
        call Mat4x4MulF64_avx2              ;calculate and save m4

; Calculate trace of m, m2, m3, and m4
        mov rdi,[rsp+Offset_m]
        Mat4x4TraceF64_M
        vmovsd xmm8,xmm0,xmm0               ;xmm8 = t1

        lea rdi,[rsp+OffsetM2]
        Mat4x4TraceF64_M
        vmovsd xmm9,xmm0,xmm0               ;xmm9 = t2
        
        lea rdi,[rsp+OffsetM3]
        Mat4x4TraceF64_M
        vmovsd xmm10,xmm0,xmm0              ;xmm10 = t3

        lea rdi,[rsp+OffsetM4]
        Mat4x4TraceF64_M
        vmovsd xmm11,xmm0,xmm0              ;xmm11 = t4

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

        vxorpd xmm12,xmm8,[F64_SignBitMask] ;c1 = -t1

        vmulsd xmm13,xmm12,xmm8             ;c1 * t1
        vaddsd xmm13,xmm13,xmm9             ;c1 * t1 + t2
        vmulsd xmm13,xmm13,[F64_N0p5]       ;c2

        vmulsd xmm14,xmm13,xmm8             ;c2 * t1
        vmulsd xmm0,xmm12,xmm9              ;c1 * t2
        vaddsd xmm14,xmm14,xmm0             ;c2 * t1 + c1 * t2
        vaddsd xmm14,xmm14,xmm10            ;c2 * t1 + c1 * t2 + t3
        vmulsd xmm14,xmm14,[F64_N0p333]     ;c3

        vmulsd xmm15,xmm14,xmm8             ;c3 * t1
        vmulsd xmm0,xmm13,xmm9              ;c2 * t2
        vmulsd xmm1,xmm12,xmm10             ;c1 * t3
        vaddsd xmm2,xmm0,xmm1               ;c2 * t2 + c1 * t3
        vaddsd xmm15,xmm15,xmm2             ;c3 * t1 + c2 * t2 + c1 * t3
        vaddsd xmm15,xmm15,xmm11            ;c3 * t1 + c2 * t2 + c1 * t3 + t4
        vmulsd xmm15,xmm15,[F64_N0p25]      ;c4

; Make sure matrix is not singular
        vandpd xmm0,xmm15,[F64_AbsMask]     ;compute fabs(c4)
        vcomisd xmm0,[rsp+Offset_epsilon]   ;compare against epsilon
        setp al                             ;set al if unordered
        setb ah                             ;set ah if fabs(c4) < epsilon
        or al,ah                            ;is mat m singular?
        jnz IsSing                          ;jump if yes

; Calculate m_inv = -1.0 / c4 * (m3 + c1 * m2 + c2 * m + c3 * I)
        vbroadcastsd ymm14,xmm14            ;ymm14 = packed c3
        lea rdi,[Mat4x4I]                   ;rcx = I ptr
        vmulpd ymm0,ymm14,[rdi]
        vmulpd ymm1,ymm14,[rdi+32]
        vmulpd ymm2,ymm14,[rdi+64]
        vmulpd ymm3,ymm14,[rdi+96]          ;c3 * I

        vbroadcastsd ymm13,xmm13            ;ymm13 = packed c2
        mov rdi,[rsp+Offset_m]              ;rcx = m ptr
        vfmadd231pd ymm0,ymm13,[rdi]
        vfmadd231pd ymm1,ymm13,[rdi+32]
        vfmadd231pd ymm2,ymm13,[rdi+64]
        vfmadd231pd ymm3,ymm13,[rdi+96]     ;c2 * m + c3 * I

        vbroadcastsd ymm12,xmm12            ;xmm12 = packed c1
        lea rdi,[rsp+OffsetM2]              ;rcx = m2 ptr
        vfmadd231pd ymm0,ymm12,[rdi]
        vfmadd231pd ymm1,ymm12,[rdi+32]
        vfmadd231pd ymm2,ymm12,[rdi+64]
        vfmadd231pd ymm3,ymm12,[rdi+96]     ;c1 * m2 + c2 * m + c3 * I

        lea rdi,[rsp+OffsetM3]              ;rcx = m3 ptr
        vaddpd ymm0,ymm0,[rdi]
        vaddpd ymm1,ymm1,[rdi+32]
        vaddpd ymm2,ymm2,[rdi+64]
        vaddpd ymm3,ymm3,[rdi+96]           ;m3 + c1 * m2 + c2 * m + c3 * I

        vmovsd xmm4,[F64_N1p0]
        vdivsd xmm4,xmm4,xmm15              ;xmm4 = -1.0 / c4
        vbroadcastsd ymm4,xmm4
        vmulpd ymm0,ymm0,ymm4
        vmulpd ymm1,ymm1,ymm4
        vmulpd ymm2,ymm2,ymm4
        vmulpd ymm3,ymm3,ymm4               ;ymm0:ymm3 = m_inv

; Save m_inv
        mov rdi,[rsp+Offset_m_inv]
        vmovapd [rdi],ymm0                  ;save m_inv[0][]
        vmovapd [rdi+32],ymm1               ;save m_inv[1][]
        vmovapd [rdi+64],ymm2               ;save m_inv[2][]
        vmovapd [rdi+96],ymm3               ;save m_inv[3][]

        mov eax,1                           ;set non-singular return code

Done:   vzeroupper
        mov rsp,rbp
        pop rbp
        ret

IsSing: xor eax,eax                         ;set singular return code
        jmp Done
