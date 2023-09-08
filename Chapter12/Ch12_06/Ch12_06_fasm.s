;------------------------------------------------------------------------------
; Ch12_06_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; bool Convolve1D_Ks5_F64_avx2(double* y, const double* x, const double* kernel,
;    int64_t num_pts);
;------------------------------------------------------------------------------

NSE     equ     4                           ;num_simd_elements
NSE2    equ     2                           ;num_simd_elements2
KS      equ     5                           ;kernel_size
KS2     equ     2                           ;floor(kernel_size / 2)
SF      equ     8                           ;scale factor for F64 elements

        section .text

        global Convolve1D_Ks5_F64_avx2
Convolve1D_Ks5_F64_avx2:

; Re-order arguments
        mov r9,rcx                          ;r9 = num_pts
        mov r8,rdx                          ;r8 = kernel
        mov rdx,rsi                         ;rdx = x
        mov rcx,rdi                         ;rcx = y

; Validate arguments
        cmp r9,KS
        jl BadArg                           ;jump if num_pts < KS

; Initialize
        mov rax,KS2                         ;i = ks2
        mov r10,r9                          ;r10 = num_pts
        sub r10,KS2                         ;r10 = num_pts - KS2

        vbroadcastsd ymm0,[r8]              ;ymm0 = packed kernel[0]
        vbroadcastsd ymm1,[r8+8]            ;ymm1 = packed kernel[1]
        vbroadcastsd ymm2,[r8+16]           ;ymm2 = packed kernel[2]
        vbroadcastsd ymm3,[r8+24]           ;ymm3 = packed kernel[3]
        vbroadcastsd ymm4,[r8+32]           ;ymm4 = packed kernel[4]

        jmp F1                              ;begin execution of Loop1

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

        vmulpd ymm5,ymm0,[rdx+r11*SF]           ;kernel[0] * x[k:k+NSE-1]
        vfmadd231pd ymm5,ymm1,[rdx+r11*SF-8]    ;kernel[1] * x[k-1:k-1+NSE-1]
        vfmadd231pd ymm5,ymm2,[rdx+r11*SF-16]   ;kernel[2] * x[k-2:k-2+NSE-1]
        vfmadd231pd ymm5,ymm3,[rdx+r11*SF-24]   ;kernel[3] * x[k-3:k-3+NSE-1]
        vfmadd231pd ymm5,ymm4,[rdx+r11*SF-32]   ;kernel[4] * x[k-4:k-4+NSE-1]

        vmovupd [rcx+rax*SF],ymm5               ;save y[i:i+NSE-1]
        add rax,NSE                             ;i += NSE

F1:     lea rsi,[rax+NSE]                       ;rsi = i + NSE
        cmp rsi,r10                             ;i + NSE <= num_pts - KS2?
        jle Loop1                               ;jump if yes

        jmp F2                                  ;begin execution of Loop2

; Calculate y[i:i+NSE2-1]
Loop2:  lea r11,[rax+KS2]                       ;k = i + KS2

        vmulpd xmm5,xmm0,[rdx+r11*SF]           ;kernel[0] * x[k:k+NSE2-1]          
        vfmadd231pd xmm5,xmm1,[rdx+r11*SF-8]    ;kernel[1] * x[k-1:k-1+NSE2-1]
        vfmadd231pd xmm5,xmm2,[rdx+r11*SF-16]   ;kernel[2] * x[k-2:k-2+NSE2-1]
        vfmadd231pd xmm5,xmm3,[rdx+r11*SF-24]   ;kernel[3] * x[k-3:k-3+NSE2-1]
        vfmadd231pd xmm5,xmm4,[rdx+r11*SF-32]   ;kernel[4] * x[k-4:k-4+NSE2-1]

        vmovupd [rcx+rax*SF],xmm5               ;save y[i:i+NSE2-1]
        add rax,NSE2                            ;i += NSE2

F2:     lea rsi,[rax+NSE2]                      ;rsi = i + NSE2
        cmp rsi,r10                             ;i + NSE2 <= num_pts - KS2?
        jle Loop2                               ;jump if yes 

        jmp F3                                  ;begin execution of Loop3

; Calculate y[i]
Loop3:  lea r11,[rax+KS2]                       ;k = i + KS2

        vmulsd xmm5,xmm0,[rdx+r11*SF]           ;kernel[0] * x[k]
        vfmadd231sd xmm5,xmm1,[rdx+r11*SF-8]    ;kernel[1] * x[k-1]
        vfmadd231sd xmm5,xmm2,[rdx+r11*SF-16]   ;kernel[2] * x[k-2]
        vfmadd231sd xmm5,xmm3,[rdx+r11*SF-24]   ;kernel[3] * x[k-3]
        vfmadd231sd xmm5,xmm4,[rdx+r11*SF-32]   ;kernel[4] * x[k-4]
     
        vmovsd [rcx+rax*SF],xmm5                ;save y[i]
        add rax,1                                ;i += 1

F3:     cmp rax,r10                             ;i < num_pts - KS2?
        jl Loop3                                ;jump if yes

        mov eax,1                               ;set success return code
        
Done:   vzeroupper
        ret

BadArg: xor eax,eax                             ;set error return code
        jmp Done
