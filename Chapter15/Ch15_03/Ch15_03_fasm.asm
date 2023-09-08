;------------------------------------------------------------------------------
; Ch15_03_fasm.asm
;------------------------------------------------------------------------------

            include <MacrosX86-64-AVX.asmh>

;------------------------------------------------------------------------------
; bool Convolve1D_Ks5_F32_avx512(float* y, const float* x, const float* kernel,
;    int64_t num_pts);
;------------------------------------------------------------------------------

NSE     equ     16                          ;num_simd_elements
NSE2    equ     8                           ;num_simd_elements2
NSE3    equ     4                           ;num_simd_elements3
KS      equ     5                           ;kernel_size
KS2     equ     2                           ;floor(kernel_size / 2)
SF      equ     4                           ;scale factor for F32 elements

        .code
Convolve1D_Ks5_F32_avx512 proc frame
        CreateFrame_M CV5_,0,0,rsi
        EndProlog_M

; Validate arguments
        cmp r9,KS
        jl BadArg                               ;jump if num_pts < KS

; Initialize
        mov rax,KS2                             ;i = ks2
        mov r10,r9                              ;r10 = num_pts
        sub r10,KS2                             ;r10 = num_pts - KS2

        vbroadcastss zmm0,real4 ptr [r8]        ;zmm0 = packed kernel[0]
        vbroadcastss zmm1,real4 ptr [r8+4]      ;zmm1 = packed kernel[1]
        vbroadcastss zmm2,real4 ptr [r8+8]      ;zmm2 = packed kernel[2]
        vbroadcastss zmm3,real4 ptr [r8+12]     ;zmm3 = packed kernel[3]
        vbroadcastss zmm4,real4 ptr [r8+16]     ;zmm4 = packed kernel[4]

        jmp F1                                  ;begin execution of Loop1

;------------------------------------------------------------------------------
; General-purpose registers used in code below:
;   rax     i                   r8      kernel
;   rcx     y array             r9      num_pts
;   rdx     x array             r10     num_pts - KS2
;   rsi     scratch             r11     k
;------------------------------------------------------------------------------

; Calculate y[i:i+NSE-1]
        align 16
Loop1:  lea r11,[rax+KS2]                       ;k = i + KS2

        vmulps zmm5,zmm0,[rdx+r11*SF]           ;kernel[0] * x[k:k+NSE-1]
        vfmadd231ps zmm5,zmm1,[rdx+r11*SF-4]    ;kernel[1] * x[k-1:k-1+NSE-1]
        vfmadd231ps zmm5,zmm2,[rdx+r11*SF-8]    ;kernel[2] * x[k-2:k-2+NSE-1]
        vfmadd231ps zmm5,zmm3,[rdx+r11*SF-12]   ;kernel[3] * x[k-3:k-3+NSE-1]
        vfmadd231ps zmm5,zmm4,[rdx+r11*SF-16]   ;kernel[4] * x[k-4:k-4+NSE-1]

        vmovups [rcx+rax*SF],zmm5               ;save y[i:i+NSE-1]
        add rax,NSE                             ;i += NSE

F1:     lea rsi,[rax+NSE]                       ;rsi = i + NSE
        cmp rsi,r10                             ;i + NSE <= num_pts - ks2?
        jle Loop1                               ;jump if yes

        jmp F2                                  ;begin execution of Loop2

; Calculate y[i:i+NSE2-1]
Loop2:  lea r11,[rax+KS2]                       ;k = i + KS2

        vmulps ymm5,ymm0,[rdx+r11*SF]           ;kernel[0] * x[k:k+NSE2-1]
        vfmadd231ps ymm5,ymm1,[rdx+r11*SF-4]    ;kernel[1] * x[k-1:k-1+NSE2-1]
        vfmadd231ps ymm5,ymm2,[rdx+r11*SF-8]    ;kernel[2] * x[k-2:k-2+NSE2-1]
        vfmadd231ps ymm5,ymm3,[rdx+r11*SF-12]   ;kernel[3] * x[k-3:k-3+NSE2-1]
        vfmadd231ps ymm5,ymm4,[rdx+r11*SF-16]   ;kernel[4] * x[k-4:k-4+NSE2-1]

        vmovups [rcx+rax*SF],ymm5               ;save y[i:i+NSE2-1]
        add rax,NSE2                            ;i += NSE2

F2:     lea rsi,[rax+NSE2]                      ;rsi = i + NSE2
        cmp rsi,r10                             ;i + NSE2 <= num_pts - KS2?
        jle Loop2                               ;jump if yes

        jmp F3                                  ;begin execution of Loop3

; Calculate y[i:i+NSE3-1]
Loop3:  lea r11,[rax+KS2]                       ;k = i + KS2

        vmulps xmm5,xmm0,[rdx+r11*SF]           ;kernel[0] * x[k:k+NSE3-1]
        vfmadd231ps xmm5,xmm1,[rdx+r11*SF-4]    ;kernel[1] * x[k-1:k-1+NSE3-1]
        vfmadd231ps xmm5,xmm2,[rdx+r11*SF-8]    ;kernel[2] * x[k-2:k-2+NSE3-1]
        vfmadd231ps xmm5,xmm3,[rdx+r11*SF-12]   ;kernel[3] * x[k-3:k-3+NSE3-1]
        vfmadd231ps xmm5,xmm4,[rdx+r11*SF-16]   ;kernel[4] * x[k-4:k-4+NSE3-1]

        vmovups [rcx+rax*SF],xmm5               ;save y[i:i+NSE3-1]
        add rax,NSE3                            ;i += NSE3

F3:     lea rsi,[rax+NSE3]                      ;rsi = i + NSE3
        cmp rsi,r10                             ;i + NSE3 <= num_pts - KS2?
        jle Loop3                               ;jump if yes

        jmp F4                                  ;begin execution of Loop4

; Calculate y[i]
Loop4:  lea r11,[rax+KS2]                       ;k = i + KS2

        vmulss xmm5,xmm0,real4 ptr [rdx+r11*SF] ;kernel[0] * x[k]
        vfmadd231ss xmm5,xmm1,[rdx+r11*SF-4]    ;kernel[1] * x[k-1]
        vfmadd231ss xmm5,xmm2,[rdx+r11*SF-8]    ;kernel[2] * x[k-2]
        vfmadd231ss xmm5,xmm3,[rdx+r11*SF-12]   ;kernel[3] * x[k-3]
        vfmadd231ss xmm5,xmm4,[rdx+r11*SF-16]   ;kernel[4] * x[k-4]
     
        vmovss real4 ptr [rcx+rax*SF],xmm5      ;save y[i]
        add rax,1                               ;i += 1

F4:     cmp rax,r10                             ;i < num_pts - KS2?
        jl Loop4                                ;jump if yes

        mov eax,1                               ;set success return code
        
Done:   vzeroupper
        DeleteFrame_M rsi
        ret

BadArg: xor eax,eax                             ;set error return code
        jmp Done

Convolve1D_Ks5_F32_avx512 endp
        end
