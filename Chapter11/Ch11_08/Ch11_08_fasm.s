;------------------------------------------------------------------------------
; Ch11_08_fasm.s
;------------------------------------------------------------------------------

        %include "ModX86Asm3eNASM.inc"

;------------------------------------------------------------------------------
; void CalcCovMatF64_avx2(double* cov_mat, double* var_means,
;   const double* x, size_t n_vars, size_t n_obvs);
;------------------------------------------------------------------------------

NSE     equ 4                                   ;num_simd_elements
SF      equ 8                                   ;scale factor for F64 elements

        section .text

        global CalcCovMatF64_avx2
CalcCovMatF64_avx2:
        push rbx
        push r12
        push r13

; Re-order register arguments
        mov r10,r8                              ;r10 = n_obvs
        mov r9,rcx                              ;r9 = n_vars
        mov r8,rdx                              ;r8 = x
        mov rdx,rsi                             ;rdx = var_means
        mov rcx,rdi                             ;rcx = cov_mat

; Initialize
        vcvtsi2sd xmm5,xmm5,r10                 ;convert n_obvs to F64
        mov rax,r10
        sub rax,1                               ;rax = n_obvs - 1
        vcvtsi2sd xmm6,xmm6,rax                 ;convert n_obvs - 1 to F64

        xor eax,eax                             ;i = 0
        jmp L1                                  ;begin execution of Loop1

;----------------------------------------------------------------------
; General-purpose register use for var_means[i] calculation:
;   rax     i                       r10     n_obvs 
;   rbx     j                       r11     scratch register
;   rcx     cov_mat                 r12     -----                 
;   rdx     var_means               r13     -----
;   r8      x                       rsi     i * n_obvs
;   r9      n_vars                  rdi     -----
;----------------------------------------------------------------------

; Calculate var_means[i] (mean of row i in matrix x)
Loop1:  mov rsi,rax                             ;rsi = i
        imul rsi,r10                            ;rsi = i * n_obvs

        xor ebx,ebx                             ;j = 0
        vxorpd ymm0,ymm0,ymm0                   ;sums[0:NSE-1] = 0
        jmp L2                                  ;begin execution of Loop2

; Sum elements in row x[i] using SIMD addition
        align 16
Loop2:  lea r11,[rsi+rbx]                       ;r11 = i * n_obvs + j
        vaddpd ymm0,ymm0,[r8+r11*SF]            ;sums[0:NSE-1] += x[i][j:j+NSE-1]

        add rbx,NSE                             ;j += NSE
L2:     mov r11,rbx                             ;r11 = j
        add r11,NSE                             ;r11 = j + NSE
        cmp r11,r10                             ;j + NSE <= n_obvs?
        jbe Loop2                               ;jump if yes

; Reduce packed sums to scalar
        vextractf128 xmm1,ymm0,1                ;extract high-order F64 values (2)
        vaddpd xmm0,xmm1,xmm0
        vhaddpd xmm0,xmm0,xmm0                  ;scalar sum in xmm0[63:0]
        jmp L3                                  ;begin execution of Loop3

; Sum remaining elements in current row using scalar arithmetic
Loop3:  lea r11,[rsi+rbx]                       ;r11 = i * n_obvs + j
        vaddsd xmm0,xmm0,[r8+r11*SF]            ;sum += x[i][j]

        add rbx,1                               ;j += 1
L3:     cmp rbx,r10                             ;j < n_obvs?
        jb Loop3                                ;jump if yes

; Calculate var_means[i]
        vdivsd xmm1,xmm0,xmm5                   ;var_means[i] = sum / n_obvs
        vmovsd [rdx+rax*SF],xmm1                ;save var_means[i]

        add rax,1                               ;i += 1
L1:     cmp rax,r9                              ;i < n_vars?
        jb Loop1                                ;jump if yes

;----------------------------------------------------------------------
; General-purpose register use for cov_mat[i][j] calculation:
;   rax     i                       r10     n_obvs 
;   rbx     j                       r11     scratch register
;   rcx     cov_mat                 r12     i * n_vars
;   rdx     var_means               r13     k
;   r8      x                       rsi     i * n_obvs
;   r9      n_vars                  rdi     j * n_obvs
;----------------------------------------------------------------------

; Calculate covariance matrix
        xor eax,eax                             ;i = 0
        jmp L4

Loop4:  mov r12,rax                             ;r12 = i
        imul r12,r9                             ;r12 = i * n_vars
        mov rsi,rax                             ;rsi = i
        imul rsi,r10                            ;rsi = i * n_obvs
        xor ebx,ebx                             ;j = 0
        jmp L5                                  ;begin execution of Loop5

Loop5:  cmp rax,rbx                             ;i > j?
        ja NoCalc                               ;jump if yes

        mov rdi,rbx                             ;rdi = j
        imul rdi,r10                            ;rdi = j * n_obvs
        xor r13,r13                             ;k = 0

        vxorpd ymm0,ymm0,ymm0                   ;cov_mat[i][j] product sums = 0
        vbroadcastsd ymm7,[rdx+rax*SF]          ;ymm7 = var_means[i]
        jmp L6                                  ;begin execution of Loop6

; Calculate product sums for cov_mat[i][j] using SIMD arithmetic
        align 16
Loop6:  vbroadcastsd ymm8,[rdx+rbx*SF]          ;ymm8 = var_means[j]
        lea r11,[rsi+r13]                       ;r11 = i * n_obvs + k
        vmovupd ymm1,[r8+r11*SF]                ;load x[i][k:k+NSE-1]
        lea r11,[rdi+r13]                       ;r11 = j * n_obvs + k
        vmovupd ymm2,[r8+r11*SF]                ;load x[j][k:k+NSE-1]
        vsubpd ymm3,ymm1,ymm7                   ;x[i][k:k+NSE-1] - var_means[i]
        vsubpd ymm4,ymm2,ymm8                   ;x[j][k:k+NSE-1] - var_means[j]
        vfmadd231pd ymm0,ymm3,ymm4              ;update cov_mat[i][j] product sums

        add r13,NSE                             ;k += NSE
L6:     lea r11,[r13+NSE]                       ;r11 = k + NSE
        cmp r11,r10                             ;k + NSE <= n_obvs?
        jbe Loop6                               ;jump if yes

; Reduce packed product sums for cov_mat[i][j] to scalar value
        vextractf128 xmm1,ymm0,1                ;extract high-order F64 values (2)
        vaddpd xmm0,xmm1,xmm0
        vhaddpd xmm0,xmm0,xmm0                  ;scalar product sum in xmm0[63:0]
        jmp L7                                  ;begin execution of Loop7

; Complete calculation of product sums for cov_mat[i][j] using scalar arithmetic
Loop7:  lea r11,[rsi+r13]                       ;r11 = i * n_obvs + k
        vmovsd xmm1,[r8+r11*SF]                 ;load x[i][k]
        lea r11,[rdi+r13]                       ;r11 = j * n_obvs + k
        vmovsd xmm2,[r8+r11*SF]                 ;load x[j][k]
        vsubsd xmm3,xmm1,xmm7                   ;x[i][j] - var_means[i]
        vsubsd xmm4,xmm2,xmm8                   ;x[j][i] - var_means[j]
        vfmadd231sd xmm0,xmm3,xmm4              ;update cov_mat[i][j] product sums

        add r13,1                               ;k += 1
L7:     cmp r13,r10                             ;k < n_obvs?
        jb Loop7                                ;jump if yes

; Calculate and save cov_mat[i][j]
        vdivsd xmm1,xmm0,xmm6                   ;calc cov_mat[i][j]
        lea r11,[r12+rbx]                       ;r11 = i * n_vars + j
        vmovsd [rcx+r11*SF],xmm1                ;save cov_mat[i][j]
        jmp F1

; No calculation needed, set cov_mat[i][j] = cov_mat[j][i]
NoCalc: mov r11,rbx                             ;r11 = j
        imul r11,r9                             ;r11 = j * n_vars
        add r11,rax                             ;r11 = j * n_vars + i
        vmovsd xmm0,[rcx+r11*SF]                ;load cov_mat[j][i]
        lea r11,[r12+rbx]                       ;r11 = i * n_vars + j
        vmovsd [rcx+r11*SF],xmm0                ;save cov_mat[i][j]

F1:     add rbx,1                               ;j += 1
L5:     cmp rbx,r9                              ;j < n_vars?
        jb Loop5                                ;jump if yes

        add rax,1                               ;i += 1
L4:     cmp rax,r9                              ;i < n_vars?
        jb Loop4                                ;jump if yes

Done:   vzeroupper
        pop r13
        pop r12
        pop rbx
        ret
