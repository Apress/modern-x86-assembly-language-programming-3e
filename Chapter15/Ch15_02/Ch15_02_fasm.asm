;------------------------------------------------------------------------------
; Ch15_02_fasm.asm
;------------------------------------------------------------------------------

            include <MacrosX86-64-AVX.asmh>

;------------------------------------------------------------------------------
; bool Convolve1D_F64_avx512(float* y, const float* x, const float* kernel,
;   int64_t num_pts, int64_t kernel_size);
;------------------------------------------------------------------------------

NSE     equ 8                               ;num_simd_elements
NSE2    equ 4                               ;num_simd_elements2
NSE3    equ 2                               ;num_simd_elements3
SF      equ 8                               ;scale factor for F64 elements

        .code
Convolve1D_F64_avx512 proc frame
        CreateFrame_M CV_,0,0,rbx,rsi,rdi,r12,r13
        EndProlog_M

; Validate arguments
        mov r10,[rbp+CV_OffsetStackArgs]        ;r10 = kernel_size (ks)
        cmp r10,3
        jl BadArg                               ;jump if ks < 3
        test r10,1
        jz BadArg                               ;jump if ks is even
        cmp r9,r10
        jl BadArg                               ;jump if num_pts < ks

; Initialize
        mov r11,r10                             ;r11 = ks
        shr r11,1                               ;r11 = ks2
        mov rsi,r9                              ;rsi = num_pts
        sub rsi,r11                             ;rsi = num_pts - ks2
        mov rdi,r11
        neg rdi                                 ;rdi = -ks2
        mov rax,r11                             ;i = ks2

        jmp F1                                  ;begin execution of Loop1a

;------------------------------------------------------------------------------
; General-purpose registers used in code below:
;   rax     i                   r8      kernel
;   rbx     k                   r9      num_pts
;   rcx     y array             r10     kernel_size
;   rdx     x array             r11     ks2
;   rsi     num_pts - ks2       r12     scratch
;   rdi     -ks2                r13     scratch
;------------------------------------------------------------------------------

; Calculate y[i:i+NSE-1]
Loop1a: mov rbx,rdi                             ;k = -ks2
        vxorpd zmm0,zmm0,zmm0                   ;y[i:i+NSE-1] = 0

        align 16
Loop1b: mov r12,rax                             ;r12 = i
        sub r12,rbx                             ;r12 = i - k
        lea r13,[rbx+r11]                       ;r13 = k + ks2

        vbroadcastsd zmm2,real8 ptr [r8+r13*SF] ;zmm2 = kernel[k+ks2]
        vfmadd231pd zmm0,zmm2,[rdx+r12*SF]      ;update y[i:i+NSE-1]

        add rbx,1                               ;k += 1
        cmp rbx,r11
        jle Loop1b                              ;jump if k <= ks2

        vmovupd [rcx+rax*SF],zmm0               ;save y[i:i+NSE-1]
        add rax,NSE                             ;i += NSE

F1:     lea r12,[rax+NSE]                       ;r12 = i + NSE
        cmp r12,rsi
        jle Loop1a                              ;jump if i + NSE <= num_pts - ks2

        jmp F2                                  ;begin execution of Loop2a

; Calculate y[i:i+NSE2-1]
Loop2a: mov rbx,rdi                             ;k = -ks2
        vxorpd ymm0,ymm0,ymm0                   ;y[i:i+NSE2-1] = 0

        align 16
Loop2b: mov r12,rax                             ;r12 = i
        sub r12,rbx                             ;r12 = i - k
        lea r13,[rbx+r11]                       ;r13 = k + ks2

        vbroadcastsd ymm2,real8 ptr [r8+r13*SF] ;ymm2 = kernel[k+ks2]
        vfmadd231pd ymm0,ymm2,[rdx+r12*SF]      ;update y[i:i+NSE2-1]

        add rbx,1                               ;k += 1
        cmp rbx,r11
        jle Loop2b                              ;jump if k <= ks2

        vmovupd [rcx+rax*SF],ymm0               ;save y[i:i+NSE2-1]
        add rax,NSE2                            ;i += NSE2

F2:     lea r12,[rax+NSE2]                      ;r12 = i + NSE2
        cmp r12,rsi
        jle Loop2a                              ;jump if i + NSE2 <= num_pts - ks2

        jmp F3                                  ;begin execution of Loop3a

; Calculate y[i:i+NSE3-1]
Loop3a: mov rbx,rdi                             ;k = -ks2
        vxorpd xmm0,xmm0,xmm0                   ;y[i:i+NSE3-1] = 0

        align 16
Loop3b: mov r12,rax                             ;r12 = i
        sub r12,rbx                             ;r12 = i - k
        lea r13,[rbx+r11]                       ;r13 = k + ks2

        vmovddup xmm2,real8 ptr [r8+r13*SF]     ;xmm2 = kernel[k+ks2]
        vfmadd231pd xmm0,xmm2,[rdx+r12*SF]      ;update y[i:i+NSE3-1]

        add rbx,1                               ;k += 1
        cmp rbx,r11
        jle Loop3b                              ;jump if k <= ks2

        vmovupd [rcx+rax*SF],xmm0               ;save y[i:i+NSE3-1]
        add rax,NSE3                            ;i += NSE3

F3:     lea r12,[rax+NSE3]                      ;r12 = i + NSE3
        cmp r12,rsi
        jle Loop3a                              ;jump if i + NSE3 <= num_pts - ks2

        jmp F4                                  ;begin execution of Loop4a

; Calculate y[i]
Loop4a: mov rbx,rdi                             ;k = -ks2
        vxorpd xmm0,xmm0,xmm0                   ;y[i] = 0

        align 16
Loop4b: mov r12,rax                             ;r12 = i
        sub r12,rbx                             ;r12 = i - k
        lea r13,[rbx+r11]                       ;r13 = k + ks2

        vmovsd xmm2,real8 ptr [r8+r13*SF]       ;xmm2 = kernel[k+ks2]
        vfmadd231sd xmm0,xmm2,[rdx+r12*SF]      ;update y[i]

        add rbx,1                               ;k += 1
        cmp rbx,r11
        jle Loop4b                              ;jump if k <= ks2

        vmovsd real8 ptr [rcx+rax*SF],xmm0      ;save y[i]
        add rax,1                               ;i += 1

F4:     cmp rax,rsi
        jl Loop4a                               ;jump if i < num_pts - ks2

        mov eax,1                               ;set success return code

Done:   vzeroupper
        DeleteFrame_M rbx,rsi,rdi,r12,r13
        ret

BadArg: xor eax,eax                             ;set error return code
        jmp Done

Convolve1D_F64_avx512 endp
        end
